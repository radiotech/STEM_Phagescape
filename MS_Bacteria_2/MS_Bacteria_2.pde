/* @pjs preload="block.png"; */
/* @pjs preload="block2.png"; */
/* @pjs preload="block3.png"; */
/* @pjs preload="block4.png"; */

int gSelected = 1; //current selected 

PImage blockImg;

EConfig bulletEntity = new EConfig();
Entity testEntity;

void setup(){
  size(700,700); //must be same as sSize above (square) //YOU MUST CHANGE THIS LINE IF YOU CHANGE THE SIZE ABOVE
  M_Setup();
}


void safeSetup(){ 
  
  /* recommended order of events: add required world blocks, generate the world */
  blockImg = loadImage("block.png");
  addGeneralBlock(0,color(0,0,0),false);
  addGeneralBlock(1,color(255,0,0),true);
  addGeneralBlock(2,color(0,255,0),true);
  addGeneralBlock(3,color(0,0,255),false);
  addGeneralBlock(4,color(0,255,255),false);
  addGeneralBlock(5,color(255,0,255),false);
  addGeneralBlock(6,color(255,255,0),true);
  addGeneralBlock(7,color(255,255,255),true);
  addGeneralBlock(8,color(100,100,100),true);
  addGeneralBlock(9,color(200,200,200),true);
  addImageSpecialBlock(3,loadImage("block2.png"),2);
  addImageSpecialBlock(4,loadImage("block.png"),1);
  addImageSpecialBlock(5,loadImage("block.png"),1);
  //addImageSpecialBlock(0,loadImage("block4.png"),2);
  addTextSpecialBlock(0,"Hello World",11);
  bulletEntity.Size = .1;
  
  testEntity = new Entity(51,51,new EConfig(),0);
  testEntity.EC.Genre = 1;
  testEntity.EC.Img = loadImage("face.png");
  testEntity.EC.AISearchMode = 3;
  testEntity.EC.AITarget = 0;
  testEntity.EC.SMax = .05;
  testEntity.EC.Type = 1;
  entities.add(testEntity);
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wU[i][j] = 5;
      if(random(100)<40){
        wU[i][j] = floor(random(7))+1;
      }
    }
  }
  
  for(int i = 0; i < 10; i++){
    wU[floor(random(wSize))][floor(random(wSize))] = 0;
  }
  
  centerView(10,10);
  scaleView(100);
  
  //***WAVE***//updateWaveImages();
}

void safeAsync(int n){
  if(n%10 == 0){ //every second
    
  }
  if(n%100 == 0){ //every ten seconds
    
  }
}

float tempZooms = 0;
void safeUpdate(){
  /* recommended order of events: make chan2es to the world and entities, change the view */
  
  centerView(player.x,player.y);
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6);
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2-2,maxAbs(0,float(mouseY-height/2)/50)+height/2-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX)-2,height/2+(pmouseY-mouseY)-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);}
}

void safeDraw(){
  /* recommended order of events: draw things over the world (if needed) */
  
  //genRing(mouseX,mouseY,float(mouseX)/2,mouseY/2,10,0);
  //genCircle(mouseX,mouseY,float(mouseX)/5,0);
  //genLine(60,60,mouseX,mouseY,10,0);
  //genRect(60,60,mouseX,mouseY,0);
  //genBox(60,60,mouseX,mouseY,10,0);
  genRoundRect(30,30,50,50,5,0);
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
      aSS(wU,tempPosS.x,tempPosS.y,gSelected);
      //wU[min(wSize-1,max(0,(int)tempPosS.x))][min(wSize-1,max(0,floor(float(mouseY)/gScale+pV.y)+round(pG.y)))] = gSelected;
    }
    refreshWorld();
  } else {
    if(bEdit){
      mousePressedBEdit();
    }
  }
  
  PVector tempV = screen2Pos(new PVector(width/2,height/2));
  entities.add(new Entity(tempV.x+player.EC.Size/2*cos(player.eDir),tempV.y+player.EC.Size/2*sin(player.eDir),bulletEntity,player.eDir));
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
