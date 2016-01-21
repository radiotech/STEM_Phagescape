//STEM Phagescape API v(see above)

void setupWorld(){
  gScale = float(width)/(gSize-1);
  wU = new int[wSize][wSize];
  wUP = new int[wSize][wSize];
  wUC = new int[wSize][wSize];
  wUText = new boolean[wSize][wSize];
  wUDamage = new int[wSize][wSize];
  gU = new int[ceil(gSize)][ceil(gSize)];
  gUHUD = new boolean[ceil(gSize)][ceil(gSize)];
  wUUpdate = new int[wSize][wSize];
}

void refreshWorld(){
  refreshHUD();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      if(aGS(nmap,i+wView.x,j+wView.y)>0 || shadows == false){
        gU[i][j] = aGS(wU,i+wView.x,j+wView.y);
      } else {
        gU[i][j] = 255;
      }
      
    }
  }
  waveGrid();
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
  //println("..");
  //wPhase += .09;
  boolean anyBlockChanges = false;
  boolean theseBlockChanges = true;
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUUpdate[i][j] = 0;
    }
  }
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUC[i][j] = wU[i][j];
    }
  }
  while(theseBlockChanges){
    theseBlockChanges = false;
    
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        if(wUUpdate[i][j] == 20){
          wUUpdate[i][j] = -1;
          updateBlock(i,j,0,0);
          theseBlockChanges = true;
        }
        if(wUUpdate[i][j] == 21){
          wUUpdate[i][j] = 20;
          theseBlockChanges = true;
        }
      }
    }
    
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        if(wUC[i][j] != wUP[i][j]){
          if(aGS1D(gBBreakType,wUP[i][j]) == wUC[i][j]){
            if(aGS1DS(gBBreakCommand,wUP[i][j]) != null){
              //entities.add(new Entity(i+.5,j+.5, gBBreakEntity[wUP[i][j]],random(TWO_PI)));
              tryCommand((aGS1DS(gBBreakCommand,wUP[i][j])).replaceAll("_x_",str(i)).replaceAll("_y_",str(j)),"");//aGS1DS(gBBreakCommand,wUP[i][j])
            }
            color tempC = aGS1DC(gBColor,aGS(wUP,i,j));
            particleEffect(i,j,1,1,15,tempC,tempC,.01);
          }
          
          //if(wUUpdate[i][j] == 0){wUUpdate[i+1][j] = 20;}
          if(wUUpdate[i][j] == 0){wUUpdate[i][j] = -1;}
          if(i+1<wSize){if(wUUpdate[i+1][j] == 0){wUUpdate[i+1][j] = 21;}}
          if(i-1>=0){if(wUUpdate[i-1][j] == 0){wUUpdate[i-1][j] = 21;}}
          if(j+1<wSize){if(wUUpdate[i][j+1] == 0){wUUpdate[i][j+1] = 21;}}
          if(j-1>=0){if(wUUpdate[i][j-1] == 0){wUUpdate[i][j-1] = 21;}}
          theseBlockChanges = true;
          
          wUP[i][j] = wUC[i][j];
          wU[i][j] = wUC[i][j];
        }
      }
    }
    if(theseBlockChanges){
      anyBlockChanges = true;
    }
  }
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUP[i][j] = wU[i][j];
    }
  }
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wU[i][j] = wUC[i][j];
    }
  }
  
  if(anyBlockChanges){
    refreshWorld();
  }
}

void updateBlock(int x, int y, int xs, int ys){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    int tempBT = aGS(wUC,x,y);
    if(aGS1DB(sBHasAction,tempBT)){
      int tAction = sBAction[tempBT];
      if(tAction == 0){
        if(aGS(wUP,x+xs,y+ys) == aGS(wU,x,y))
        aSS(wUC,x,y,aGS1D(gBBreakType,tempBT));
      }
      if(tAction == 46){
        if(aGS(wUP,x,y) == tempBT){
          aSS(wUC,x,y,aGS1D(gBBreakType,tempBT));
        }
      }
    }
  }
}

void updateSpecialBlocks(){
  boolean updateAgain = false;
  int iTo = (int)player.x+10;
  int jTo = (int)player.y+10;
  for(int i = (int)player.x-10; i < iTo; i++){
    for(int j = (int)player.y-10; j < jTo; j++){
      if(aGS1DB(sBHasAction,aGS(wU,i,j))){
        int thisBlock = aGS(wU,i,j);
        int tAction = sBAction[thisBlock];
        
        if(tAction >= 1 && tAction <= 10){
          if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<tAction){
            aSS(wU,i,j,aGS1D(gBBreakType,thisBlock));
          }
        }
        if(tAction >= 11 && tAction <= 20){
          if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<tAction-10){
            if(genTestPathExists(player.x,player.y,i,j)){
              aSS(wU,i,j,aGS1D(gBBreakType,thisBlock));
              updateAgain = true;
            }
          }
        }
        if(tAction >= 21 && tAction < 30){
          if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<=tAction-20){
            if(genTestPathExists(player.x,player.y,i,j)){
              if(rayCast(i,j,(int)player.x,(int)player.y)){
                aSS(wU,i,j,aGS1D(gBBreakType,thisBlock));
                updateAgain = true;
              }
            }
          }
        }
      }
    }
  }
  if(updateAgain){
    updateSpecialBlocks();
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
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(aGS1DB(sBHasAction,wU[i][j])){
        int tempBlock = wU[i][j];
        int tempAction = aGS1D(sBAction,tempBlock);
        if(tempAction >= 31 && tempAction <= 45){
          int tempVal = (int)sq(tempAction-30);
          if(random(tempVal)<=1){
            entities.add(new Entity(i+.5,j+.5, testEntity.EC,random(TWO_PI)));
          }
        }
      }
    }
  }
}

void drawWorld(){
  background(0);
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      noStroke();
      
      int thisBlock = gU[i][j];
      
      fill(aGS1D(gBColor,thisBlock));
      PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
      rect(floor(tempV.x),floor(tempV.y),ceil(gScale),ceil(gScale)); //-pV.x*gScale
      
      if(sBHasImage[thisBlock]){
        float tScale;
        if(sBImageDrawType[thisBlock] == 0){
          image(sBImage[thisBlock],floor(tempV.x),floor(tempV.y));
        } else if(sBImageDrawType[thisBlock] == 1) {
          image(sBImage[thisBlock],floor(tempV.x),floor(tempV.y));
        } else {
          tScale = width/sBImage[thisBlock].width;
          image(sBImage[thisBlock].get(floor(tempV.x+gScale),floor(tempV.y+gScale),ceil(gScale),ceil(gScale)),floor(tempV.x),floor(tempV.y));
        }
      }
      
      thisBlock = aGS(wU,i+wView.x,j+wView.y);
      
      if(aGS1DB(gBIsSolid,thisBlock)){
        PVector tempV2 = grid2Pos(new PVector(i,j));
        if(aGS1D(gBStrength,thisBlock) > -1){
          if(aGS(wUDamage,tempV2.x,tempV2.y) > 0){
            if(aGS(wUDamage,tempV2.x,tempV2.y) > aGS1D(gBStrength,thisBlock)){
              aSS(wU,tempV2.x,tempV2.y,aGS1D(gBBreakType,thisBlock));
              aSS(wUDamage,tempV2.x,tempV2.y,0);
              
            } else {
              stroke(255);
              strokeWeight(gScale/15);
              float Crumble = float(aGS(wUDamage,tempV2.x,tempV2.y))/(aGS1D(gBStrength,thisBlock)-.01);
              //line(tempV.x,tempV.y+gScale/2-Crumble,tempV.x+gScale,tempV.y+gScale/2+Crumble);
              //line(tempV.x+gScale/2+Crumble,tempV.y,tempV.x+gScale/2-Crumble,tempV.y+gScale);
              //println(Crumble);
              arc(tempV.x+gScale/2,tempV.y+gScale/2,gScale*2/3,gScale*2/3,HALF_PI,HALF_PI+TWO_PI*Crumble);
            }
          }
        }
      }
    }
  }
  
  if(gSize < 30){
    for (Wave w : (ArrayList<Wave>) wL) {
      w.display();
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
      //if(gBIsSolid[aGS(wU,tempPV.x,tempPV.y)]){
      //  a.clear();
      //  a.add(new PVector(50,50));
      //  return -1;
      //}
      return i;
    }
  }
  return -1;
}

//STEM Phagescape API v(see above)
