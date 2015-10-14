void setupWorld(){
  gScale = float(sSize)/(gSize-1);
  wU = new int[wSize][wSize];
  wUText = new boolean[wSize][wSize];
  gU = new int[ceil(gSize)][ceil(gSize)];
}
void refreshWorld(){
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      gU[i][j] = aGS(wU,i+wView.x,j+wView.y);
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
  gScale = float(sSize)/(gSize-1);
  
  gU = new int[ceil(gSize)][ceil(gSize)];
  
  refreshWorld();
}

void addGeneralBlock(int tIndex, color tColor, boolean tIsSolid){
  gBColor[tIndex] = tColor;
  gBIsSolid[tIndex] = tIsSolid;
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
  wPhase += .09;
}

void drawWorld(){
  background(0);
  
  noStroke();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      int thisBlock = gU[i][j];
      fill(aGSB(gBColor,thisBlock));
      PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
      rect(floor(tempV.x),floor(tempV.y),ceil(gScale),ceil(gScale)); //-pV.x*gScale
      
      if(sBHasImage[thisBlock]){
        float tScale;
        if(sBImageDrawType[thisBlock] == 0){
          image(sBImage[thisBlock],tempV.x,tempV.y);
        } else if(sBImageDrawType[thisBlock] == 1) {
          image(sBImage[thisBlock],tempV.x,tempV.y);
        } else {
          tScale = width/sBImage[thisBlock].width;
          image(sBImage[thisBlock].get(floor(tempV.x+gScale),floor(tempV.y+gScale),ceil(gScale),ceil(gScale)),tempV.x,tempV.y);
        }
      }
    }
  }
  
  for (Wave w : (ArrayList<Wave>) wL) {
    w.display();
  }
  

  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      int thisBlock = gU[i][j];
      if(sBHasText[thisBlock]){
        PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
        if(sBTextDrawType[thisBlock] == 0){
          drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock]);
        } else if(sBTextDrawType[thisBlock] <= 10) {
          if(pointDistance(new PVector(width/2-gScale/2,height/2-gScale/2),tempV) < sBTextDrawType[thisBlock]*gScale){
            drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock]);
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



color blockColor(int intC){
  switch(intC){
    case 0:
      return color(0);
    case 1:
      return color(255,255,0);
    case 2:
      return color(0,255,0);
    case 3:
      return color(0,255,255);
    case 4:
      return color(0,0,255);
    case 5:
      return color(255,0,255);
    case 6:
      return color(255,0,0);
    default:
      return color(0);
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

PVector blockNear(PVector eV,int tBlock, float tChance){
  float minDis = wSize*wSize;
  PVector tRV = new PVector(eV.x,eV.y);
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == tBlock){
        if(random(100)<tChance){
          if(pointDistance(eV, new PVector(i,j)) < minDis){
            tRV = new PVector(i,j);
            minDis = mDis(eV.x,eV.y, i,j);
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
  float tempDispX = float(x1-x0)/100;
  float tempDispY = float(y1-y0)/100;
  for(int i = 0; i < 100; i++){
    if((round(x0+tempDispX*i) != round(x0) || round(y0+tempDispY*i+.105) != round(y0)) && (round(x0+tempDispX*i) != round(x1) || round(y0+tempDispY*i+.105) != round(y1))){
      if(gBIsSolid[aGS(wU,round(x0+tempDispX*i),round(y0+tempDispY*i+.105))]){
        tClear = false;
      }
    }
  }
  //println(tClear);
  return tClear;
}

