/* @pjs preload="D/face.png, D/map5.png"; */

Entity testEntity;
int EC_AIR_MONSTER = EC_NEXT();
int EC_ENEMY_BULLET = EC_NEXT();

/*LOCK*/void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/void safePreSetup(){
  EConfigs[EC_AIR_MONSTER] = new EConfig();
  EConfigs[EC_AIR_MONSTER].Genre = 1;
  EConfigs[EC_AIR_MONSTER].Img = loadImage(aj.D()+"face.png");
  EConfigs[EC_AIR_MONSTER].AISearchMode = 11;
  EConfigs[EC_AIR_MONSTER].AITarget = -1;
  EConfigs[EC_AIR_MONSTER].SMax = .05;
  EConfigs[EC_AIR_MONSTER].TSMax = .1;
  EConfigs[EC_AIR_MONSTER].TAccel = .03;
  EConfigs[EC_AIR_MONSTER].TDrag = .01;
  EConfigs[EC_AIR_MONSTER].Type = 1;
  EConfigs[EC_AIR_MONSTER].GoalDist = 3; //Want to get this close
  EConfigs[EC_AIR_MONSTER].ActDist = 10;
  EConfigs[EC_AIR_MONSTER].HMax = 1;
  EConfigs[EC_AIR_MONSTER].myBulletEntity = EC_ENEMY_BULLET;
  EConfigs[EC_ENEMY_BULLET] = new EConfig();
  EConfigs[EC_ENEMY_BULLET].Size = .13;
  EConfigs[EC_ENEMY_BULLET].SMax = .1;
  EConfigs[EC_ENEMY_BULLET].Color = color(0,100);
  EConfigs[EC_ENEMY_BULLET].BirthCommand = "sound _x_ _y_ 2";
  EConfigs[EC_ENEMY_BULLET].DeathCommand = "sound _x_ _y_ 2";
  EConfigs[EC_AIR_MONSTER].BirthCommand = "sound _x_ _y_ 3";
  EConfigs[EC_AIR_MONSTER].DeathCommand = "sound _x_ _y_ 1";
  EConfigs[EC_AIR_MONSTER].FireDelay = 15;
  EConfigs[EC_AIR_MONSTER].AltColor = color(0,100);
} //first function called, in case you need to set some variables before anything else starts

/*LOCK*/void safeSetup(){ //called when world generation and entity placement is ready to begin
  EConfigs[EC_AIR_MONSTER].AITargetID = EConfigs[EC_PLAYER].ID;

  EConfigs[EC_BULLET].Size = .1;
  
  for(int i = 0; i < 5; i++){
    //testEntity = new Entity(51,51,airMonster,0);
    //entities.add(testEntity);
  }
  
  
  addGeneralBlock(0,color(100,0,0),false,0); //background
  //addImageSpecialBlock(0,loadImage(aj.D()+"a.png"),0);
  
  addGeneralBlock(1,color(255,255,190),true,-1); //bone
  
  addGeneralBlock(2,color(150,250,100),true,5); //door closed
  addActionSpecialBlock(2,46);
  addGeneralBlockBreak(2,0,"reset_Spawners");

  addGeneralBlock(3,color(200,0,0),true,0); //flesh //strength 10
  
  addGeneralBlock(4,color(100,100,100),true,50); //norm spawner
  //addActionSpecialBlock(4,45);
  ///////////////////////////////////////////////////////////////////spawn
  
  addGeneralBlock(5,color(0),true,0); //boss egg
  addGeneralBlockBreak(5,0,"spawn _x_ _y_ boss");
  addActionSpecialBlock(5,18);
  
  
  addGeneralBlock(6,color(255,165,0),true,25); //Protein
  addGeneralBlock(7,color(0,255,255),true,15); //Lipids
  addGeneralBlock(8,color(205,0,205),true,20); //Nucleotides
  addGeneralBlock(9,color(225,225,255),true,35); //Sugar
  
  for(int i = 0; i < 8; i++){
    addGeneralBlock(10+i,color(20,200,20),true,0); //key
    addGeneralBlockBreak(10+i,0,"key");
    addActionSpecialBlock(10+i,21);
  }
  
  genLoadMap(loadImage(aj.D()+"map5.png"));

  genSpread(307, 4, 60); //eliminate 80% of spawners

  for(int i = 0; i < 4; i++){
    genSpread(1, 50+i, 10+i); //spread keys in the rooms
    genSpread(5, 50+i, 5); //spread bosses
    genReplace(50+i, 4); //spread spawners
  }

  int[] toArray = {0,1,6,7,8,9,3};
  float[] probArray = {60,30,2,3,4,5,100};
  genRandomProb(60,toArray,probArray);
  
  scaleView(100); //scale the view to fit the entire map
  shadows = false;
  centerView(wSize/2,wSize/2); //center the view in the middle of the world
  
  //entities.remove(player); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  
  //entities.remove(player); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  //testEntity.destroy();
}

/*LOCK*/void safeAsync(){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  if(fn % 25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    //println(frameRate); //display the game FPS
  }
}

/*LOCK*/void safeUpdate(){ //called before anything has been drawn to the screen (update the world before it is drawn)
  centerView(player.x,player.y); //center the view on the player
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6); //center view on the player but pull toward the mouse slightly
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2,maxAbs(0,float(mouseY-height/2)/50)+height/2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y); //move the view in the direction of the mouse
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX),height/2+(pmouseY-mouseY)); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);} //drag the view around
}
/*LOCK*/void safePostUpdate(){}
/*LOCK*/void safeDraw(){} //called after everything else has been drawn on the screen (draw things on the game)
/*LOCK*/void safePostDraw(){
  if(chatPush != 0){
    stroke(255,chatPush*500);
    strokeWeight(2);
    fill(0,chatPush*500);
    rect(-10,height-chatHeight-2,width+20,100);
    //textMarkup(chatKBS,chatHeight/5,height-chatHeight/2,color(255),220*chatPush,true);
  }
  
} //called after everything else has been drawn on the screen (draw things on the screen)
/*LOCK*/void safeKeyPressed(){} //called when a key is pressed
/*LOCK*/void safeKeyReleased(){} //called when a key is released
/*LOCK*/void safeMousePressed(){
  if(mouseButton == RIGHT){
    PVector tempV = screen2Pos(new PVector(mouseX,mouseY));
    player.fire(tempV);
  }
  
} //called when the mouse is pressed

/*LOCK*/void chatEvent(String source){
} //called when a chat message is created

void executeCommand(int index, String[] commands){
  switch(index){
    
  }
}

void safePluginAI(Entity te){};
void safeMouseReleased(){};
/*LOCK*/void safeKeyTyped(){} //may be added in the future
/*LOCK*/void safeMouseWheel(){} //may be added in the future
/*LOCK*/void safeMouseClicked(){} //may be added in the future
/*LOCK*/void safeMouseMoved(){} //may be added in the future
/*LOCK*/void safeMouseDragged(){} //may be added in the future
