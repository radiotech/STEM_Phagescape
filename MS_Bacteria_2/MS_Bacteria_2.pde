/* @pjs preload="block.png"; */
/* @pjs preload="block2.png"; */
/* @pjs preload="block3.png"; */
/* @pjs preload="block4.png"; */
/* @pjs preload="face.png"; */

int gSelected = 1; //current selected 
EConfig bulletEntity = new EConfig();
Entity testEntity;

void setup(){
  size(700,700); //must be square
  M_Setup();
}

void safePresetup(){
  //wSize = 50;
}

void safeSetup(){ 
  //blockImg = loadImage("block.png");
  addGeneralBlock(0,color(0,0,0),true,1);
  addGeneralBlock(1,color(255,0,0),false,0);
  addGeneralBlock(2,color(0,255,0),true,1);
  addGeneralBlock(3,color(0,0,255),true,1);
  addGeneralBlock(4,color(0,255,255),true,1);
  addGeneralBlock(5,color(255,0,255),false,0);
  addGeneralBlock(6,color(255,255,0),true,1);
  addGeneralBlock(7,color(255,255,255),true,1);
  addGeneralBlock(8,color(100,100,100),true,1);
  addGeneralBlock(9,color(200,200,200),true,1);
//  addImageSpecialBlock(3,loadImage("block2.png"),2);
//  addTextSpecialBlock(0,"Hello World",11);
  bulletEntity.Size = .1;
  
  testEntity = new Entity(51,51,new EConfig(),0);
  testEntity.EC.Genre = 1;
  testEntity.EC.Img = loadImage("face.png");
  testEntity.EC.AISearchMode = 1;
  testEntity.EC.AITarget = -1;
  testEntity.EC.AITargetID = player.EC.ID;
  testEntity.EC.SMax = .05;
  testEntity.EC.Type = 1;
  entities.add(testEntity);
  
  genRect(0,0,wSize,wSize,1);
  int[] blocksArg = { 1, 2, 3 };
  float[] probArg = { 3, 1, 1 };
  genRandomProb(1,blocksArg,probArg);
  
  println(genSpread(1600,2,4));
  println(genCountBlock(4));
  
  scaleView(100);
  
  //***WAVE***//updateWaveImages();
}

void safeAsync(int n){
  if(n%25 == 0){ //every second
    //println(frameRate);
  }
  if(n%250 == 0){ //every ten seconds
    
  }
}

float tempZooms = 0;
void safeUpdate(){
  centerView(player.x,player.y);
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6);
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2-2,maxAbs(0,float(mouseY-height/2)/50)+height/2-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX)-2,height/2+(pmouseY-mouseY)-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);}
}

void safeDraw(){
  //genRing(mouseX,mouseY,float(mouseX)/2,mouseY/2,10,0);
  //genCircle(mouseX,mouseY,float(mouseX)/5,0);
  //genLine(60,60,mouseX,mouseY,10,0);
  //genRect(60,60,mouseX,mouseY,0);
  //genBox(60,60,mouseX,mouseY,10,0);
  //genRoundRect(30,30,50,50,5,0);
}

void mousePressed(){
  
  if(mouseButton == RIGHT){
    //moveToAnimate(new PVector(10,10), 4000);
  } else {
    //moveToAnimate(new PVector(90,90), 4000);
  }
  
  if(!menu){
    if(mouseButton == RIGHT){
      PVector tempPosS = screen2Pos(new PVector(mouseX,mouseY));
      
      if(aGS(wU,tempPosS.x,tempPosS.y) == 0){
        aSS(wU,tempPosS.x,tempPosS.y,gSelected);
      } else {
        aSS(wU,tempPosS.x,tempPosS.y,0);
      }
      //wU[min(wSize-1,max(0,(int)tempPosS.x))][min(wSize-1,max(0,floor(float(mouseY)/gScale+pV.y)+round(pG.y)))] = gSelected;
    }
    refreshWorld();
  }
  
  PVector tempV = screen2Pos(new PVector(mouseX,mouseY));
  player.fire(tempV);
  //genFlood(tempV.x,tempV.y,4);
  //genReplace(2,6);
  println(genTestPathExists(tempV.x,tempV.y,player.x,player.y));
  refreshWorld();
}

void keyPressed(){
  if(chatPushing){
    if(key != CODED){
      if(keyCode == BACKSPACE){
        if(chatKBS.length() > 0){
          chatKBS = chatKBS.substring(0,chatKBS.length()-1);
        }
      } else if(key == ESC) {
        chatPushing = false;
        chatKBS = "";
      } else if(keyCode == ENTER) {
        if(chatKBS.length() > 0){
          cL.add(new Chat(chatKBS));
          chatKBS = "";
          chatPushing = false;
          chatPush = 0;
        }
      } else {
        chatKBS = chatKBS+key;
      }
    }
  } else {
    if(key == 't' || key == 'T' || key == 'c' || key == 'C' || key == ENTER){
      chatPushing = true;
    }
    
    player.moveEvent(0);
  }
  
  if(key == ESC) {
    key = 0;
  }
}

void keyReleased(){
  player.moveEvent(1);
}
