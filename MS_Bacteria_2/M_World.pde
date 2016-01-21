//STEM Phagescape API v(see above)

ArrayList updates = new ArrayList<PVector>();

PGraphics gridBuffer;
PImage gridBufferImage;
PVector gridBufferPos = new PVector(0,0);
int[][] gUShade;
int[][] nmapShade;
ArrayList rectL = new ArrayList<RectObj>();

class RectObj {
  int x;
  int y;
  int w;
  int h;
  int col;
  
  RectObj(int tx, int ty, int tw, int th, int tcol) {
    x = tx;
    y = ty;
    w = tw;
    h = th;
    col = tcol;
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
  
  //gridBuffer.beginDraw();
  //gridBuffer.background(0);
  //gridBufferImage.loadPixels();
  rectL.clear();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      //gridBuffer.noStroke();
      
      int thisBlock = gU[i][j];
      
      int tempColor = aGS1D(gBColor,thisBlock);
      
      float tempShade = float(gUShade[i][j]+0)/5;
      
      if(tempShade > 1){
        tempShade = 1;
      }
      
      //gridBuffer.fill(red(tempColor)*tempShade,green(tempColor)*tempShade,blue(tempColor)*tempShade);
      PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
      
      //gridBufferImage = toughRect(gridBufferImage, floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),ceil(gScale),ceil(gScale), color(red(tempColor)*tempShade,green(tempColor)*tempShade,blue(tempColor)*tempShade));
      //gridBufferImage.set(floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),airMonster.Img);
      if(tempColor != gBColor[0] || tempShade != 1){
        rectL.add(new RectObj(floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),ceil(gScale),ceil(gScale), color(red(tempColor)*tempShade,green(tempColor)*tempShade,blue(tempColor)*tempShade)));
      }
      //gridBuffer.rect(floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),ceil(gScale),ceil(gScale)); //-pV.x*gScale
      
      
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
      }
    }
  }
  
  if(gSize < 30){
    for (Wave w : (ArrayList<Wave>) wL) {
      w.display();
    }
  }
  //gridBuffer.endDraw();
  
  
  //gridBufferImage = gridBuffer.get();
  //gridBuffer.loadPixels();
  //gridBufferImage.pixels = gridBuffer.pixels;
  
  //gridBufferImage.loadPixels();
  //for(int i = 0; i < gridBufferImage.pixels.length; i++){
  //  gridBufferImage.pixels[i] = 1;
  //}
  //gridBufferImage.updatePixels();
  
  //gridBufferImage = gridBuffer.get();
  //gridBufferImage.updatePixels();
  gridBufferPos = new PVector(player.x,player.y);
  
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

void addTextSpecialBlock(int tIndex, String tText, int tTextDrawType){
  sBHasText[tIndex] = true;
  sBText[tIndex] = tText;
  sBTextDrawType[tIndex] = tTextDrawType;
}

void addActionSpecialBlock(int tIndex, int tAction){
  sBHasAction[tIndex] = true;
  sBAction[tIndex] = tAction;
}

void centerView(float ta, float tb){
  wViewCenter = new PVector(ta,tb,gSize);
  wView = new PVector(ta-(gSize-1)/2,tb-(gSize-1)/2);
  if(floor(wViewLast.x) != floor(wView.x)){
    refreshWorld();
    wPhase -= PI;
  }
  if(floor(wViewLast.y) != floor(wView.y)){
    refreshWorld();
    wPhase -= PI;
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
        if(update.z == 0 || update.z == -1){update.z = -2; removedUpdates++;}
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
          hitBlock(x,y,10000);
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
              hitBlock(i,j,10000);
              updateAgain = true;
            }
          }
          if(tAction >= 11 && tAction <= 20){
            if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<tAction-10){
              if(genTestPathExists(player.x,player.y,i,j)){
                hitBlock(i,j,10000);
                updateAgain = true;
              }
            }
          }
          if(tAction >= 21 && tAction < 30){
            if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<=tAction-20){
              if(genTestPathExists(player.x,player.y,i,j)){
                if(rayCast(i,j,(int)player.x,(int)player.y)){
                  hitBlock(i,j,10000);
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
            //particles
            
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
                if(aGS(nmapShade,i,j) > 0){
                  if(boxHitsBlocks(i+tempX+.5,j+tempY+.5,.6,.6) == false){ //add enemy size
                    //entities.add(new Entity(i+tempX+.5,j+tempY+.5, airMonster,random(TWO_PI)));
                    tempAction = 31+floor(random(10));
                    
                    //spawn an enemey, poof
                  }
                }
              }
            }
              
            //println(tempAction-31);
            aSS1D(sBAction,tempBlock,tempAction);
          }
        }
      }
    }
  }
}

void drawWorld(){
  
  //image(gridBufferImage,(gridBufferPos.x-player.x)*gScale-gScale,(gridBufferPos.y-player.y)*gScale-gScale);
  
  background(gBColor[0]);
  int tempSize = rectL.size();
  RectObj tempRect;
  noStroke();
  for(int i = 0; i < tempSize; i++){
    tempRect = (RectObj) rectL.get(i);
    tempRect.display(int((gridBufferPos.x-player.x)*gScale-gScale),int((gridBufferPos.y-player.y)*gScale-gScale));
  }
  
  noFill();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      
      int thisBlock = aGS(wU,i+wView.x,j+wView.y);
      
      if(aGS1DB(gBIsSolid,thisBlock)){
        PVector tempV2 = grid2Pos(new PVector(i,j));
        if(aGS1D(gBStrength,thisBlock) > -1){
          if(aGS(nmapShade,tempV2.x,tempV2.y) > 0){
            if(aGS(wUDamage,tempV2.x,tempV2.y) > 0){
              stroke(strokeColor);
              strokeWeight(gScale/15);
              float Crumble = float(aGS(wUDamage,tempV2.x,tempV2.y))/(aGS1D(gBStrength,thisBlock)-.01);
              //line(tempV.x,tempV.y+gScale/2-Crumble,tempV.x+gScale,tempV.y+gScale/2+Crumble);
              //line(tempV.x+gScale/2+Crumble,tempV.y,tempV.x+gScale/2-Crumble,tempV.y+gScale);
              //println(Crumble);
              PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
              arc(tempV.x+gScale/2,tempV.y+gScale/2,gScale*2/3,gScale*2/3,HALF_PI,HALF_PI+TWO_PI*Crumble);
            }
          }
        }
      }
    }
  }

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
}

PVector screen2Pos(PVector tA){tA.div(gScale);tA.add(wView); return tA;}

PVector pos2Screen(PVector tA){tA.sub(wView); tA.mult(gScale); return tA;}

PVector grid2Pos(PVector tA){tA.add(new PVector(floor(wView.x),floor(wView.y))); return tA;}

//PVector pos2Grid(PVector tA){tA.sub(new PVector(floor(wView.x),floor(wView.y))); return tA;}

PVector moveInWorld(PVector tV, PVector tS, float tw, float th){
  PVector tV2 = new PVector(tV.x,tV.y);
  if(tS.x > 0){
    if(floor(tV.x+tw/2) != floor(tV.x+tw/2+tS.x)){
      if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y+th/2)) || aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y-th/2))){
        tS = new PVector(0,tS.y);
        tV2 = new PVector(floor(tV.x+tw/2+tS.x)+.999-tw/2,tV2.y);
      }
    }
  } else {
    if(floor(tV.x-tw/2) != floor(tV.x-tw/2+tS.x)){
      if(aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2+tS.x,tV.y+th/2)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2+tS.x,tV.y-th/2))){
        tS = new PVector(0,tS.y);
        tV2 = new PVector(floor(tV.x-tw/2+tS.x)+tw/2,tV2.y);
      }
    }
  }
  tV2 = new PVector(tV2.x+tS.x,tV2.y);
  
  if(tS.y > 0){
    if(floor(tV.y+th/2) != floor(tV.y+th/2+tS.y)){
      if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2,tV.y+th/2+tS.y)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2,tV.y+th/2+tS.y))){
        tS = new PVector(tS.x,0);
        tV2 = new PVector(tV2.x,floor(tV.y+th/2+tS.y)+.999-th/2);
      }
    }
  } else {
    if(floor(tV.y-th/2) != floor(tV.y-th/2+tS.y)){
      if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2,tV.y-th/2+tS.y)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2,tV.y-th/2+tS.y))){
        tS = new PVector(tS.x,0);
        tV2 = new PVector(tV2.x,floor(tV.y-th/2+tS.y)+th/2);
      }
    }
  }
  tV2 = new PVector(tV2.x,tV2.y+tS.y);
  
  return tV2;
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
          if(rayCast(i,j,(int) eV.x,(int) eV.y)){
            tRV = new PVector(i,j);
            minDis = mDis(eV.x,eV.y, i,j);
          }
        }
      }
    }
  }
  return tRV;
}

boolean rayCast(int x0, int y0, int x1, int y1){
  boolean tClear = true;
  int itts = ceil(mDis(x0,y0,x1,y1)*5);
  float tempDispX = float(x1-x0)/itts;
  float tempDispY = float(y1-y0)/itts;
  for(int i = 0; i < itts; i++){
    if((round(x0+tempDispX*i) != round(x0) || round(y0+tempDispY*i+.105) != round(y0)) && (round(x0+tempDispX*i) != round(x1) || round(y0+tempDispY*i+.105) != round(y1))){
      if(gBIsSolid[aGS(wU,round(x0+tempDispX*i),round(y0+tempDispY*i+.105))]){
        return false;
      }
    }
  }
  //println(tClear);
  return true;
}

int rayCastPath(ArrayList a, int x1, int y1){
  PVector tempPV;
  for(int i = a.size()-1; i >= 0; i--){
    tempPV = (PVector)a.get(i);
    if(rayCast((int)tempPV.x, (int)tempPV.y, x1, y1)){
      return i;
    }
  }
  return -1;
}

void hitBlock(float x, float y, int hardness){
  if(aGS1D(gBStrength,aGS(wU,x,y)) >= 0 || hardness >= 999){
    aSS(wUDamage,x,y,aGS(wUDamage,x,y)+hardness);
    
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

//STEM Phagescape API v(see above)
