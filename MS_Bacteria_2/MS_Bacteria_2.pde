int gSelected = 1; //current selected 

void safeSetup(){ 
  /* recommended order of events: add required world blocks, generate the world */
  
  addGeneralBlock(0,color(0,0,0),false);
  addGeneralBlock(1,color(255,0,0),true);
  addGeneralBlock(2,color(0,255,0),true);
  addGeneralBlock(3,color(0,0,255),true);
  addGeneralBlock(4,color(0,255,255),true);
  addGeneralBlock(5,color(255,0,255),true);
  addGeneralBlock(6,color(255,255,0),true);
  addGeneralBlock(7,color(255,255,255),true);
  addGeneralBlock(8,color(100,100,100),true);
  addGeneralBlock(9,color(200,200,200),true);
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wU[i][j] = 0;
      if(random(100)<40){
        wU[i][j] = floor(random(7));
      }
    }
  }
}

float tempZooms = 0;
void safeUpdate(){
  /* recommended order of events: make changes to the world and entities, change the view */
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

void mousePressed(){
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
}

void keyPressed(){
  player.moveEvent(0);
}
void keyReleased(){
  player.moveEvent(1);
}
