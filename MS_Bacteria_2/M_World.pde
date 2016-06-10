//STEM Phagescape API v(see above)

ArrayList updates = new ArrayList<PVector>();

int[][] gU; //Grid unit - contains all blocks being drawn to the screen
boolean[][] gUHUD;
int[][] gM; //Grid Mini - stores information regarding the position of block boundries and verticies for wave generation
int[][] wU; //World Unit - contains all blocks in the world


int[][] wUDamage;
boolean[][] wUText; //
int[][] wUUpdate; //
ArrayList<Entity>[][] wUEntities; //new ArrayList()[][];
float gScale; //the width and height of blocks being drawn to the screen in pixels

PGraphics gridBuffer;
PImage gridBufferImage;
PVector gridBufferPos = new PVector(0,0);
int[][] gUShade;
int[][] nmapShade;
ArrayList rectL = new ArrayList<RectObj>();
ArrayList damageL = new ArrayList<DamageObj>();
ArrayList textL = new ArrayList<TextObj>();

//searching around for entities
ArrayList eSearchResults;
int aSearchPointer;
int aSearchPointer2;
int aSearchX;
int aSearchY;
int aSearchR;


class RectObj {
  int x, y, w, h, col;
  RectObj(int tx, int ty, int tw, int th, int tcol) {
    x = tx; y = ty; w = tw; h = th; col = tcol;
  }
  void display(float offx, float offy) {
    fill(col);
    rect(offx+x,offy+y,w,h);
  }
}

class DamageObj {
  int x, y, d, posx, posy;
  float maxstage;
  DamageObj(int tx, int ty, int td, int tposx, int tposy) {
    x = tx; y = ty; d = td; posx = tposx; posy = tposy;
    maxstage = aGS1D(gBStrength,aGS(wU,posx,posy))-.01;
  }
  void display(float offx, float offy) {
    arc(offx+x,offy+y,d,d,HALF_PI,HALF_PI+TWO_PI*(float(aGS(wUDamage,posx,posy))/maxstage));
  }
}

class TextObj {
  int x, y, w, h, col;
  TextObj(int tx, int ty, int tw, int th, int tcol) {
    x = tx; y = ty; w = tw; h = th; col = tcol;
  }
  void display(float offx, float offy) {
    fill(col);
    rect(offx+x,offy+y,w,h);
  }
}

void setupWorld(){
  gScale = float(width)/(gSize-1);
  gridBuffer = createGraphics(width+ceil(gScale*2),height+ceil(gScale*2));
  gridBufferImage = createImage(width+ceil(gScale*2),height+ceil(gScale*2),RGB);
  wU = new int[wSize][wSize];
  wUText = new boolean[wSize][wSize];
  wUDamage = new int[wSize][wSize];
  gU = new int[ceil(gSize)][ceil(gSize)];
  gUHUD = new boolean[ceil(gSize)][ceil(gSize)];
  wUUpdate = new int[wSize][wSize];
  wUEntities = new ArrayList[wSize][wSize];
  miniMap = new int[wSize][wSize];
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUEntities[i][j] = new ArrayList(0);
    }
  }
}

void refreshWorld(){
  
  refreshHUD();
  gUShade = new int[floor(gSize)][floor(gSize)];
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      gU[i][j] = aGS(wU,i+wView.x,j+wView.y);
      gUShade[i][j] = aGS(nmapShade,i+wView.x,j+wView.y);
      if(i+wView.x < 0 || j+wView.y < 0 || i+wView.x >= wSize || j+wView.y  >= wSize){
        gUShade[i][j] = 0;
      }
    }
  }
  waveGrid();

  rectL.clear();
  damageL.clear();
  
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      //gridBuffer.noStroke();
      
      int thisBlock = gU[i][j];
      
      int tempColor = aGS1D(gBColor,thisBlock);
      
      float tempShade = float(gUShade[i][j])/5;
      
      PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
      
      
      if(tempShade > 1){
        tempShade = 1;
      }
      
      if(aGS1DB(gBIsSolid,thisBlock)){
        if(aGS1D(gBStrength,thisBlock) > -1){
          if(aGS(gUShade,i,j) > 0){
            if(aGS1D(gBStrength,thisBlock) > -1){
              damageL.add(new DamageObj(floor(tempV.x)+ceil(gScale*1.5),floor(tempV.y)+ceil(gScale*1.5),ceil(gScale*2/3),int(i+wView.x),int(j+wView.y)));
            }
          }
        }
      }
      //gridBuffer.fill(red(tempColor)*tempShade,green(tempColor)*tempShade,blue(tempColor)*tempShade);
      
      if(tempShade > 0){
        if(loadMiniMap){
          aSS(miniMap,i+wView.x,j+wView.y,tempColor);
        }
      }
      
      
      //gridBufferImage = toughRect(gridBufferImage, floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),ceil(gScale),ceil(gScale), color(red(tempColor)*tempShade,green(tempColor)*tempShade,blue(tempColor)*tempShade));
      //gridBufferImage.set(floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),airMonster.Img);
      if(tempColor != gBColor[0] || tempShade != 1){
        rectL.add(new RectObj(floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),ceil(gScale+.1),ceil(gScale+.1), color(red(tempColor)*tempShade,green(tempColor)*tempShade,blue(tempColor)*tempShade)));
      }
      //gridBuffer.rect(floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),ceil(gScale),ceil(gScale)); //-pV.x*gScale
      
      /*
      if(sBHasImage[thisBlock]){
        float tScale;
        if(sBImageDrawType[thisBlock] == 0){
          //gridBuffer.image(sBImage[thisBlock],floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale));
        } else if(sBImageDrawType[thisBlock] == 1) {
          //gridBuffer.image(sBImage[thisBlock],floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale));
        } else {
          tScale = width/sBImage[thisBlock].width;
          //gridBuffer.image(sBImage[thisBlock].get(floor(tempV.x),floor(tempV.y),ceil(gScale),ceil(gScale)),floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale));
        }
      }*/
    }
  }
  
  if(gSize < 30){
    for (Wave w : (ArrayList<Wave>) wL) {
      w.display();
    }
  }
  
  gridBufferPos = new PVector(wViewCenter.x,wViewCenter.y);
  
  updateSpecialBlocks();
  
}

void moveToAnimate(PVector tV, float tTime){
  if(millis() > moveToAnimateTime.y){
    moveToAnimateStart = new PVector(wViewCenter.x,wViewCenter.y,wViewCenter.z);
    moveToAnimateEnd = new PVector(tV.x-wViewCenter.x,tV.y-wViewCenter.y);
    moveToAnimateTime = new PVector(millis(), millis()+tTime);
  }
}

void animate(){
  if(millis() <= moveToAnimateTime.y){
    float temp1 = (millis()-moveToAnimateTime.x)/(moveToAnimateTime.y-moveToAnimateTime.x);
    float temp2 = sin(temp1*PI);
    float temp3 = (-cos(temp1*PI)+1)/2;
    centerView(moveToAnimateStart.x+temp3*moveToAnimateEnd.x,moveToAnimateStart.y+temp3*moveToAnimateEnd.y);
    scaleView(moveToAnimateStart.z+temp2*10);
  }
}

void scaleView(float tGSize){
  gSize = tGSize;
  gScale = float(width)/(gSize-1);
  gU = new int[ceil(gSize)][ceil(gSize)];
  gUHUD = new boolean[ceil(gSize)][ceil(gSize)];
  refreshWorld();
}

void addGeneralBlock(int tIndex, color tColor, boolean tIsSolid, int tStrength){
  gBColor[tIndex] = tColor;
  gBIsSolid[tIndex] = tIsSolid;
  gBStrength[tIndex] = tStrength;
}

void addGeneralBlockBreak(int tIndex, int tBreakType, String tBreakCommand){
  gBBreakType[tIndex] = tBreakType;
  if(tBreakCommand != ""){
    gBBreakCommand[tIndex] = tBreakCommand;
  }
}

/*
void addImageSpecialBlock(int tIndex, PImage tImage, int tImageDrawType){
  sBHasImage[tIndex] = true;
  if(tImageDrawType == 0){
    tImage.resize(ceil(gScale), ceil(gScale));
  } else if(tImageDrawType == 1){
    tImage.resize(ceil(gScale), ceil(gScale));
  } else {
    tImage.resize(width+ceil(gScale*2), height+ceil(gScale*2));
  }
  sBImage[tIndex] = tImage;
  sBImageDrawType[tIndex] = tImageDrawType;
}
*/

/*
void addTextSpecialBlock(int tIndex, String tText, int tTextDrawType){
  sBHasText[tIndex] = true;
  sBText[tIndex] = tText;
  sBTextDrawType[tIndex] = tTextDrawType;
}
*/

void addActionSpecialBlock(int tIndex, int tAction){
  sBHasAction[tIndex] = true;
  sBAction[tIndex] = tAction;
}

void centerView(float ta, float tb){
  wViewCenter = new PVector(ta,tb,gSize);
  wView = new PVector(ta-(gSize-1)/2,tb-(gSize-1)/2);
  if(floor(wViewLast.x) != floor(wView.x) || floor(wViewLast.y) != floor(wView.y)){
    refreshWorld();
    wPhase -= PI;
    debugLog(color(0,255,255));
  }
  wViewLast = new PVector(wView.x,wView.y);
}

void updateWorld(){
  if(updates.size() > 0) {
    int removedUpdates = 0;
    while(updates.size()-removedUpdates > 0){
      PVector update;
      for (int i = updates.size() - 1; i >= 0; i--) {
        update = (PVector) updates.get(i);
        if(update.z == 20){
          if(updateBlock(int(update.x),int(update.y))){
            update.z = -1;
          } else {
            update.z = 0;
          }
        }
        if(update.z == 21){
          update.z = 20;
        }
      }
      for (int i = updates.size() - 1; i >= 0; i--) {
        update = (PVector) updates.get(i);
        if(update.z == -1){
          if(!updateExists(update.x+1,update.y)){updates.add(new PVector(update.x+1,update.y,21));}
          if(!updateExists(update.x-1,update.y)){updates.add(new PVector(update.x-1,update.y,21));}
          if(!updateExists(update.x,update.y+1)){updates.add(new PVector(update.x,update.y+1,21));}
          if(!updateExists(update.x,update.y-1)){updates.add(new PVector(update.x,update.y-1,21));}
        }
        if(update.z == 0 || update.z == -1){update.z = -2; removedUpdates++; /*segments.add(new Segment("="+str(int(update.x))+";"+str(int(update.y))+";"+str(aGS(wU,update.x,update.y))+"&", 2));*/}
      }
    }
    refreshWorld();
    updates.clear();
  }
}

boolean updateBlock(int x, int y){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    int tempBT = aGS(wU,x,y);
    if(aGS1DB(sBHasAction,tempBT)){
      int tAction = sBAction[tempBT];
      if(tAction == 0){
        //if(aGS(wUP,x+xs,y+ys) == aGS(wU,x,y))
        //aSS(wUC,x,y,aGS1D(gBBreakType,tempBT)); //what is action 0 again? - needs updated to new system of update list
      }
      if(tAction == 46){
        //if(aGS(wUP,x,y) == tempBT){
          hitBlock(x,y,10000,false);
          return true;
        //}
      }
    }
  }
  return false;
}

void updateSpecialBlocks(){
  boolean updateAgain = true;
  
  int updateDist = 10;
  int capX = min(max(floor(player.x)+updateDist,0),wSize-1);
  int capY = min(max(floor(player.y)+updateDist,0),wSize-1);
  
  while(updateAgain){
    updateAgain = false;
    for(int i = min(max(floor(player.x)-updateDist,0),wSize-1); i <= capX; i++){
      for(int j = min(max(floor(player.y)-updateDist,0),wSize-1); j <= capY; j++){
        if(aGS1DB(sBHasAction,aGS(wU,i,j))){
          int thisBlock = aGS(wU,i,j);
          int tAction = sBAction[thisBlock];
          
          if(tAction >= 1 && tAction <= 10){
            if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<tAction){
              hitBlock(i,j,10000,false);
              updateAgain = true;
            }
          }
          if(tAction >= 11 && tAction <= 20){
            if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<tAction-10){
              if(genTestPathExists(player.x,player.y,i,j)){
                hitBlock(i,j,10000,false);
                updateAgain = true;
              }
            }
          }
          if(tAction >= 21 && tAction < 30){
            if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<=tAction-20){
              if(genTestPathExists(player.x,player.y,i,j)){
                if(rayCast(i,j,(int)player.x,(int)player.y,true)){
                  hitBlock(i,j,10000,false);
                  updateAgain = true;
                }
              }
            }
          }
        }
      }
    }
  }
}

/*
void updateBlockLight(int x, int y){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    wUCovers[x][y] = wU[x][y];
    int tempBT = aGS(wU,x,y);
    if(aGS1DB(sBHasAction,tempBT)){
      int tAction = sBAction[tempBT];
      if(tAction == 51){
        
        int[] array1 = new int[8];
        int tempCounter = 0;
        if(aGS(wU,x+1,y) != tempBT && gBIsSolid[aGS(wU,x+1,y)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x+1,y); tempCounter++;}
        if(aGS(wU,x+1,y+1) != tempBT && gBIsSolid[aGS(wU,x+1,y+1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x+1,y+1); tempCounter++;}
        if(aGS(wU,x,y+1) != tempBT && gBIsSolid[aGS(wU,x,y+1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x,y+1); tempCounter++;}
        if(aGS(wU,x-1,y+1) != tempBT && gBIsSolid[aGS(wU,x-1,y+1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x-1,y+1); tempCounter++;}
        if(aGS(wU,x-1,y) != tempBT && gBIsSolid[aGS(wU,x-1,y)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x-1,y); tempCounter++;}
        if(aGS(wU,x-1,y-1) != tempBT && gBIsSolid[aGS(wU,x-1,y-1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x-1,y-1); tempCounter++;}
        if(aGS(wU,x,y-1) != tempBT && gBIsSolid[aGS(wU,x,y-1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x,y-1); tempCounter++;}
        if(aGS(wU,x+1,y-1) != tempBT && gBIsSolid[aGS(wU,x+1,y-1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x+1,y-1); tempCounter++;}
        int[] array2 = new int[tempCounter];
        arrayCopy(array1,array2,tempCounter);
        int newCover = tempBT;
        if(tempCounter > 0){
          newCover = mode(array2);
        }
        wUCovers[x][y] = newCover;
        
      }
    }
  }
}
*/

void updateSpawners(){
  int spawnDist = 5;
  int capX = min(max(floor(player.x)+spawnDist,0),wSize-1);
  int capY = min(max(floor(player.y)+spawnDist,0),wSize-1);
  for(int i = min(max(floor(player.x)-spawnDist,0),wSize-1); i <= capX; i++){
    for(int j = min(max(floor(player.y)-spawnDist,0),wSize-1); j <= capY; j++){
      if(aGS1DB(sBHasAction,wU[i][j])){
        int tempBlock = wU[i][j];
        int tempAction = aGS1D(sBAction,tempBlock);
        if(tempAction >= 31 && tempAction <= 45){
          if(nmapShade[i][j] > 0){
            particleEffect(i-.25,j-.25,1.5,1.5,3,aGS1DC(gBColor,aGS(wU,i,j)),color(255),0.03);
            
            if(tempAction < 45){
              if(random(100) < 25){
                tempAction++;
              }
            }
            
            if(tempAction == 45){
            //try to spawn
            
              float tempX;
              float tempY;
              for(int k = 0; k < 5; k++){
                tempX = random(5)-2.5;
                tempY = random(5)-2.5;
                if(aGS(nmapShade,i+tempX+.5,j+tempY+.5) > 0){
                  if(boxHitsBlocks(i+tempX+.5,j+tempY+.5,.6,.6) == false){ //add enemy size
                    //addEntity(new Entity(i+tempX+.5,j+tempY+.5, EC_AIR_MONSTER,random(TWO_PI)));
                    aSS1D(sBAction,tempBlock,31+floor(random(10)));
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void drawWorld(){
  if(alpha(gBColor[0]) == 255){
    background(gBColor[0]);
  }
  
  noStroke();
  int baseDrawX = int((gridBufferPos.x-wViewCenter.x)*gScale-gScale);
  int baseDrawY = int((gridBufferPos.y-wViewCenter.y)*gScale-gScale);
  for(RectObj tempObj : (ArrayList<RectObj>) rectL) {
    tempObj.display(baseDrawX,baseDrawY);
  }
  noFill();
  stroke(strokeColor);
  strokeWeight(gScale/15);
  for(DamageObj tempObj : (ArrayList<DamageObj>) damageL) {
    tempObj.display(baseDrawX,baseDrawY);
  }
  for(TextObj tempObj : (ArrayList<TextObj>) textL) {
    tempObj.display(baseDrawX,baseDrawY);
  }
  /*
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      int thisBlock = gU[i][j];
      if(sBHasText[thisBlock]){
        PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
        if(sBTextDrawType[thisBlock] == 0){
          drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock],255);
        } else if(sBTextDrawType[thisBlock] <= 10) {
          if(pointDistance(new PVector(width/2-gScale/2,height/2-gScale/2),tempV) < sBTextDrawType[thisBlock]*gScale){
            drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock],255);
          }
        } else if(sBTextDrawType[thisBlock] <= 20) {
          PVector tempV2 = grid2Pos(new PVector(i,j));
          if(pointDistance(new PVector(width/2-gScale/2,height/2-gScale/2),tempV) < (sBTextDrawType[thisBlock]-10)*gScale){
            if(aGS2DB(wUText,tempV2.x,tempV2.y) == false){
              cL.add(new Chat(sBText[thisBlock]));
              aSS2DB(wUText,tempV2.x,tempV2.y,true);
            }
          } else {
            aSS2DB(wUText,tempV2.x,tempV2.y,false);
          }
        }
      }
    }
  }
  */
}

PVector screen2Pos(PVector tA){tA.div(gScale);tA.add(wView); return tA;}

PVector pos2Screen(PVector tA){tA.sub(wView); tA.mult(gScale); return tA;}

PVector grid2Pos(PVector tA){tA.add(new PVector(floor(wView.x),floor(wView.y))); return tA;}

//PVector pos2Grid(PVector tA){tA.sub(new PVector(floor(wView.x),floor(wView.y))); return tA;}

void moveInWorld(PVector tV, PVector tS, float tw, float th){
  if(tS.x > 0){
    if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y+th/2)) || aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y-th/2))){
      tS = new PVector(0,tS.y);
      
      tV.x = floor(tV.x+tw/2+tS.x)+.999-tw/2;
    }
  } else if(tS.x < 0) {
    if(aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2+tS.x,tV.y+th/2)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2+tS.x,tV.y-th/2))){
      tS = new PVector(0,tS.y);
      tV.x = floor(tV.x-tw/2+tS.x)+tw/2;
    }
  }
  tV.x += tS.x;
  
  if(tS.y > 0){
    if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2,tV.y+th/2+tS.y)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2,tV.y+th/2+tS.y))){
      tS = new PVector(tS.x,0);
      tV.y = floor(tV.y+th/2+tS.y)+.999-th/2;
    }
  } else if(tS.y < 0){
    if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2,tV.y-th/2+tS.y)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2,tV.y-th/2+tS.y))){
      tS = new PVector(tS.x,0);
      tV.y = floor(tV.y-th/2+tS.y)+th/2;
    }
  }
  tV.y += tS.y;
}

boolean[] getSolidAround(PVector pos, int dir, boolean clockwise){ //array get safe
  //dir = posMod(dir);
  boolean[] tempBool = new boolean[8];
  if(clockwise == false){
    tempBool[(int)posMod(0-dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y-1)];
    tempBool[(int)posMod(1-dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y-1)];
    tempBool[(int)posMod(2-dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y)];
    tempBool[(int)posMod(3-dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y+1)];
    tempBool[(int)posMod(4-dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y+1)];
    tempBool[(int)posMod(5-dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y+1)];
    tempBool[(int)posMod(6-dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y)];
    tempBool[(int)posMod(7-dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y-1)];
  } else {
    tempBool[(int)posMod(0+dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y-1)];
    tempBool[(int)posMod(7+dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y-1)];
    tempBool[(int)posMod(6+dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y)];
    tempBool[(int)posMod(5+dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y+1)];
    tempBool[(int)posMod(4+dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y+1)];
    tempBool[(int)posMod(3+dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y+1)];
    tempBool[(int)posMod(2+dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y)];
    tempBool[(int)posMod(1+dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y-1)];
  }
  return tempBool;
}

PVector blockNear(PVector eV,int tBlock, float tChance){
  float minDis = wSize*wSize;
  PVector tRV = new PVector(random(wSize),random(wSize));
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == tBlock){
        if(random(100)<tChance){
          if(pointDistance(eV, new PVector(i,j)) < minDis){
            tRV = new PVector(i,j);
            minDis = pointDistance(eV,tRV);
          }
        }
      }
    }
  }
  return tRV;
}

PVector blockNearCasting(PVector eV,int tBlock){
  float minDis = 25;
  PVector tRV = new PVector(eV.x,eV.y);
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == tBlock){
        if(pointDistance(eV, new PVector(i,j)) < minDis){
          if(rayCast(i,j,(int) eV.x,(int) eV.y,true)){
            tRV = new PVector(i,j);
            minDis = mDis(eV.x,eV.y, i,j);
          }
        }
      }
    }
  }
  return tRV;
}

boolean rayCast(float x0, float y0, float x1, float y1, boolean ignoreEnds){
  boolean tClear = true;
  int itts = ceil(mDis(x0,y0,x1,y1)*5);
  float tempDispX = (x1-x0)/itts;
  float tempDispY = (y1-y0)/itts;
  
  PVector res = pos2Screen(new PVector(x0,y0));
  PVector res1 = pos2Screen(new PVector(x1,y1));
  
  
  for(int i = 0; i < itts; i++){
    if(ignoreEnds == false || ((floor(x0+tempDispX*i) != floor(x0) || floor(y0+tempDispY*i) != floor(y0)) && (floor(x0+tempDispX*i) != floor(x1) || floor(y0+tempDispY*i) != floor(y1)))){
      if(gBIsSolid[aGS(wU,floor(x0+tempDispX*i),floor(y0+tempDispY*i))]){
        stroke(255,0,0);
        line(res.x,res.y,res1.x,res1.y);
        return false;
      }
    }
  }
  stroke(0,255,0);
  line(res.x,res.y,res1.x,res1.y);
  return true;
}

int rayCastPath(ArrayList a, int x1, int y1){
  PVector tempPV;
  for(int i = a.size()-1; i >= 0; i--){
    tempPV = (PVector)a.get(i);
    if(rayCast((int)tempPV.x, (int)tempPV.y, x1, y1,true)){
      return i;
    }
  }
  return -1;
}

void hitBlock(float x, float y, int hardness, boolean sent){
  if(aGS1D(gBStrength,aGS(wU,x,y)) >= 0 || hardness >= 999){
    aSS(wUDamage,x,y,aGS(wUDamage,x,y)+hardness);
    if(sent == false){segments.add(new Segment("HB,"+str(int(x))+","+str(int(y))+","+str(aGS(wU,x,y))+","+str(hardness), 5));}
    
    if(aGS(wUDamage,x,y) > aGS1D(gBStrength,aGS(wU,x,y))){
      
      if(!updateExists(int(x),int(y))){
        updates.add(new PVector(int(x),int(y),-1));
      }
      if(aGS1DS(gBBreakCommand,aGS(wU,x,y)) != null){
        tryCommand(StringReplaceAll(StringReplaceAll(aGS1DS(gBBreakCommand,aGS(wU,x,y)),"_x_",str(int(x))),"_y_",str(int(y))),"");//aGS1DS(gBBreakCommand,wUP[i][j])
      }
      color tempC = aGS1DC(gBColor,aGS(wU,x,y));
      aSS(wU,x,y,aGS1D(gBBreakType,aGS(wU,x,y)));
      particleEffect(x,y,1,1,15,tempC,aGS1DC(gBColor,aGS(wU,x,y)),.01);
        
        
      
      aSS(wUDamage,x,y,0);
    } else if(aGS(wUDamage,x,y) < 0){
      aSS(wUDamage,x,y,0);
    }
  }
}

boolean updateExists(float x, float y){
  for (PVector update : (ArrayList<PVector>) updates) {
    if(update.x == x && update.y == y){
      return true;
    }
  }
  return false;
}

PVector findBreakableNear(float x, float y, int searchR){
  int tX = (int) x;
  int tY = (int) y;
  int iN, iX, iY, i = 0, tB;
  PVector myReturn = new PVector(-1,-1);
  boolean looping = true;
  while(looping){
    iN = max(i*4,1);
    for(int j = 0; j < iN; j++){
      iX = tX+min(j,i)-min(2*i,max(0,(j-i)))+max(0,(j-i*3));
      iY = tY-i+min(2*i,j)-max(0,(j-2*i));
      if(iX >= 0 && iY >= 0 && iX < wSize && iY < wSize){
        tB = wU[iX][iY];
        if(tB != 0){
          if(gBIsSolid[tB]){
            if(gBStrength[tB] >= 0){
              myReturn = new PVector(iX,iY);
              looping = false;
              if(j != 0 && j != i && j != i*2 & j != i*3){
                break;
              }
            }
          }
        }
      }
    }
    i++;
    if(i > searchR){
      looping = false;
    }
  }
  return myReturn;
}

void resetSearches(float x, float y, int r){
  aSearchPointer = 0;
  aSearchPointer2 = 0;
  
  aSearchX = (int) x;
  aSearchY = (int) y;
  aSearchR = r;
}

ArrayList findEntityGrid(){
  int iN, iX, iY;
  ArrayList eL, tempReturn;
  boolean looping = true;
  tempReturn = new ArrayList<Entity>();
  while(looping){
    iN = max(aSearchPointer*4,1);
    while(aSearchPointer2 < iN){
      iX = aSearchX+min(aSearchPointer2,aSearchPointer)-min(2*aSearchPointer,max(0,(aSearchPointer2-aSearchPointer)))+max(0,(aSearchPointer2-aSearchPointer*3));
      iY = aSearchY-aSearchPointer+min(2*aSearchPointer,aSearchPointer2)-max(0,(aSearchPointer2-2*aSearchPointer));
      if(iX >= 0 && iY >= 0 && iX < wSize && iY < wSize){
        
        if(wUEntities[iX][iY].size() > 0){
          
          eL = wUEntities[iX][iY];
          for(int i = eL.size()-1; i >= 0; i--){
            tempReturn.add(eL.get(i));
          }
          aSearchPointer2++;
          return tempReturn;
        }
      }
      aSearchPointer2++;
    }
    aSearchPointer2 = 0;
    aSearchPointer++;
    if(aSearchPointer > aSearchR){
      looping = false;
    }
  }
  return null;
}

PVector findNonAirWU(){
  int iN, iX, iY;
  boolean looping = true;
  while(looping){
    iN = max(aSearchPointer*4,1);
    while(aSearchPointer2 < iN){
      iX = aSearchX+min(aSearchPointer2,aSearchPointer)-min(2*aSearchPointer,max(0,(aSearchPointer2-aSearchPointer)))+max(0,(aSearchPointer2-aSearchPointer*3));
      iY = aSearchY-aSearchPointer+min(2*aSearchPointer,aSearchPointer2)-max(0,(aSearchPointer2-2*aSearchPointer));
      if(iX >= 0 && iY >= 0 && iX < wSize && iY < wSize){
        if(wU[iX][iY] != 0){
          aSearchPointer2++;
          return new PVector(iX,iY);
        }
      }
      aSearchPointer2++;
    }
    aSearchPointer2 = 0;
    aSearchPointer++;
    if(aSearchPointer > aSearchR){
      looping = false;
    }
  }
  return null;
}

/*
Entity getGridEntity(ArrayList eL, int tTeam){
  if(eL.size() > 0){
    if(eL.size() == 1){
      if(EConfigs[((Entity)eL.get(0)).EC].Team == tTeam){
        return (Entity)eL.get(0);
      }
    } else {
      for(int i = eL.size()-1; i >= 0; i--){
        if(EConfigs[((Entity)eL.get(i)).EC].Team == tTeam){
          return (Entity)eL.get(i);
        }
      }
    }
  }
  return null;
}
*/

void removeEntityFromGridPos(ArrayList eL, int tID){
  if(eL.size() == 0){
    return;
  } else if(eL.size() == 1){
    if(((Entity)eL.get(0)).ID == tID){
      eL.remove(0);
      return;
    }
  } else {
    for(int i = eL.size()-1; i >= 0; i--){
      if(((Entity)eL.get(i)).ID == tID){
        eL.remove(i);
      }
    }
    return;
  }
}

void addEntityToGridPos(ArrayList eL, Entity tE){
  if(eL.size() == 0){
    eL.add(tE);
    return;
  } else if(eL.size() == 1){
    if(((Entity)eL.get(0)).ID != tE.ID){
      eL.add(tE);
      return;
    }
  } else {
    boolean foundSelf = false;
    for(int i = eL.size()-1; i >= 0; i--){
      if(((Entity)eL.get(i)).ID == tE.ID){
        foundSelf = true;
      }
    }
    if(foundSelf == false){
      eL.add(tE);
      return;
    }
  }
}

void removeEntityFromGridArea(float x1, float y1, float tx2, float ty2, int tID){
  int x2 = min(max((int) tx2,0),wSize-1);
  int y2 = min(max((int) ty2,0),wSize-1);
  for(int i = min(max((int) x1,0),wSize-1); i <= x2; i++){
    for(int j = min(max((int) y1,0),wSize-1); j <= y2; j++){
      removeEntityFromGridPos(aGSAL(wUEntities,i,j),tID);
    }
  }
}

void addEntityToGridArea(float x1, float y1, float tx2, float ty2, Entity tE){
  int x2 = min(max((int) tx2,0),wSize-1);
  int y2 = min(max((int) ty2,0),wSize-1);
  for(int i = min(max((int) x1,0),wSize-1); i <= x2; i++){
    for(int j = min(max((int) y1,0),wSize-1); j <= y2; j++){
      addEntityToGridPos(aGSAL(wUEntities,i,j),tE);
    }
  }
}

ArrayList getEntitiesFromGridAreaOther(float x1, float y1, float tx2, float ty2, int tID){
  ArrayList myReturn = new ArrayList();
  ArrayList tempAL;
  int x2 = min(max((int) tx2,0),wSize-1);
  int y2 = min(max((int) ty2,0),wSize-1);
  for(int i = min(max((int) x1,0),wSize-1); i <= x2; i++){
    for(int j = min(max((int) y1,0),wSize-1); j <= y2; j++){
      tempAL = aGSAL(wUEntities,i,j);
      switch(tempAL.size()){
        case 0:
          break;
        case 1:
          if(((Entity)tempAL.get(0)).ID != tID){
            addUniqueEntityAL(myReturn,(Entity)tempAL.get(0));
          }
          break;
        default:
          for(int k = tempAL.size()-1; k >= 0; k--){
            if(((Entity)tempAL.get(k)).ID != tID){
              addUniqueEntityAL(myReturn,(Entity)tempAL.get(k));
            }
          }
          break;
      }
    }
  }
  return myReturn;
}

void addUniqueEntityAL(ArrayList Tal, Entity Te){
  switch(Tal.size()){
    case 0:
      Tal.add(Te);
      return;
    case 1:
      if(((Entity)Tal.get(0)).ID != Te.ID){
        Tal.add(Te);
        return;
      }
      break;
    default:
      for(int i = Tal.size()-1; i >= 0; i--){
        //println(str(i)+"ESCAPE "+str(((Entity)Tal.get(i)).ID)+" "+Te.ID);
        if(((Entity)Tal.get(i)).ID == Te.ID){
          //println("EQ");
          return;
        }
      }
      Tal.add(Te);
      return;
  }
}

//STEM Phagescape API v(see above)
