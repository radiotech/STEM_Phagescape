/* @pjs preload="block.png"; */
/* @pjs preload="block2.png"; */
/* @pjs preload="block3.png"; */
/* @pjs preload="block4.png"; */

int gSelected = 1; //current selected 

int wavePixels = 100;
int waveFrames = 60;
int waveHeight = 25;
int waveOffset = 13;
int waveStroke = 6;
PGraphics[] waveGraphics;
PImage[] waveImages;
int adder;

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
  //scaleWorld(float(mouseX)/50);
  
  //println(frameRate);
  
  /*
  //tempZooms+=99;
  if(tempZooms < 100){
    centerView(10,10);
    scaleView(7);
  } else {
    if(tempZooms < 1100){
      
      
    } else {
      //centerView(90,90);
      //float temp2 = 1/(1+pow(9000,(-(tempZooms-100)/1000+.5)));
      //centerView(10+temp2*80,10+temp2*80);
      //scaleWorld(7);
    }
  }
  */
  
  
  
  
  
  centerView(player.x,player.y);
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6);
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2-2,maxAbs(0,float(mouseY-height/2)/50)+height/2-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX)-2,height/2+(pmouseY-mouseY)-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);}
}

void safeDraw(){
  /* recommended order of events: draw things over the world (if needed) */
}
/*
int spread(int x, int y, int energy){
  
  int myReturn = 999;
  if(wUSpread[x][y] < energy){
  
    wUSpread[x][y] = energy;
    if(energy > 1){
      if(gBIsSolid[aGS(wU,x,y)]==false){
        myReturn = min(myReturn,spread(x+1,y,energy-1));
        myReturn = min(myReturn,spread(x-1,y,energy-1));
        myReturn = min(myReturn,spread(x,y+1,energy-1));
        myReturn = min(myReturn,spread(x,y-1,energy-1));
      }
    }
    if(aGS(wU,x,y) == 0){
      myReturn = 0;
    }
    PVector tempVs = pos2Screen(new PVector(x+.5,y+.5));
    fill(0,energy*70,0,100);
    ellipse(tempVs.x,tempVs.y,20,20);
    fill(0);
    text(myReturn,tempVs.x,tempVs.y);
  }
  return myReturn+1;
}



void plotLine(int x0, int y0, int x1, int y1){
  int dx=x1-x0;
  int dy=y1-y0;

  int D = 2*dy - dx;
  ellipse(x0,y0,2,2);
  int y=y0;

  for(int x = x0+1; x < x1+1; x++){
    D = D + (2*dy);
    if(D > 0){
      y = y+1;
      D = D - (2*dx);
    }
    ellipse(x,y,2,2);
  }
    
}
*/
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
