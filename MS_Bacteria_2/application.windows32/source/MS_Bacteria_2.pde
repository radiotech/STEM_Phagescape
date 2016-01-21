/* @pjs preload="face.png"; */

Entity testEntity;
SoundConfig doorSound = new SoundConfig( 3, 200, 255, color(100,100,255), 10, 1, 15, 2, 0);
SoundConfig entitySound = new SoundConfig( .2, 55, 100, color(0), -1, 3, 2, 0, 90);

/*LOCK*/void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/void safePreSetup(){} //first function called, in case you need to set some variables before anything else starts

/*LOCK*/void safeSetup(){ //called when world generation and entity placement is ready to begin
  
  //shadows = true;
  
  
  bulletEntity.Size = .1;
  
  for(int i = 0; i < 1; i++){
    testEntity = new Entity(51,51,new EConfig(),0);
    testEntity.EC.Genre = 1;
    testEntity.EC.Img = loadImage("face.png");
    testEntity.EC.AISearchMode = 11;
    testEntity.EC.AITarget = -1;
    testEntity.EC.AITargetID = player.EC.ID;
    testEntity.EC.AIDoorBlock = 8;
    testEntity.AITargetPos = new PVector(wSize/2,wSize/2);
    testEntity.EC.SMax = .15;
    testEntity.EC.TSMax = .31;
    testEntity.EC.TAccel = .300;
    testEntity.EC.TDrag = 8;
    testEntity.EC.Type = 1;
    testEntity.EC.GoalDist = 0; //Want to get this close
    testEntity.EC.ActDist = 1;
    entities.add(testEntity);
    
  }
  
  CFuns.add(new CFun(0,"door",2,false)); //add a function that adds a number, n, to the goal number for a type of bacteria, type, (id, function, argument #, can be used by the user directly? true/false)
  
  //genReplace(0,1);
  //genReplace(2,1);
  //genReplace(3,2);
  //genReplace(4,1);
  
  //wU[50][48] = 4;
  
  /*
  genReplace(0,1);
  for(int i = 1; i < 10; i++){
    genRing(50,50,i*10,i*10,0,3);
  }
  
  int[] blocksArg = { 3, 5}; //create a set of blocks
  float[] probArg = { 20, 4 }; //create a list of probabilities for these blocks
  genRandomProb(3, blocksArg, probArg); //place these blocks in the world with their respective probabilities (the world, by default is all 0 and these random blocks replace 0 here)
  
  
  
  scaleView(10); //scale the view to fit the entire map
  centerView(wSize/2,wSize/2); //center the view in the middle of the world
  */
  
  
  
  addGeneralBlock(0,color(120,12,0),false,0); //inside
  addGeneralBlock(5,color(120,12,0),false,0); //inside
  addGeneralBlock(6,color(120,12,0),false,0); //inside
  
  
  addGeneralBlock(1,color(100,100,120),false,0); //outside
  
  addGeneralBlock(2,color(100,100,120),false,1); //safety
  
  addGeneralBlock(3,color(50,0,0),true,-1); //wall
  
  addGeneralBlock(4,color(255,30,30),true,-1); //door closed
  addActionSpecialBlock(4,46);
  addGeneralBlockBreak(4,7,"door _x_ _y_");
  addGeneralBlock(7,color(120,12,0),false,-1); //door open
  addActionSpecialBlock(7,46);
  addGeneralBlockBreak(7,4,"door _x_ _y_");
  
  addGeneralBlock(8,color(200,180,30),true,0); //door frame
  addActionSpecialBlock(8,46);
  addGeneralBlockBreak(8,9,"door _x_ _y_");
  addGeneralBlock(9,color(0,180,30),true,0); //door frame2
  addActionSpecialBlock(9,46);
  addGeneralBlockBreak(9,8,"door _x_ _y_");
  
  addGeneralBlock(30,color(200,180,30),true,0); //door frame (closet)
  addActionSpecialBlock(30,46);
  addGeneralBlockBreak(30,31,"door _x_ _y_");
  addGeneralBlock(31,color(200,180,30),true,0); //door frame2 (closet)
  addActionSpecialBlock(31,46);
  addGeneralBlockBreak(31,30,"door _x_ _y_");
  
  addGeneralBlock(10,color(0,0,0),true,0); //block
  
  /*
  addImageSpecialBlock(7,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(0,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(5,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(6,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(3,loadImage("a.png"),0); //
  addImageSpecialBlock(8,loadImage("log_birch_top.png"),0); //
  addImageSpecialBlock(9,loadImage("log_birch_top.png"),0); //
  addImageSpecialBlock(4,loadImage("log_birch.png"),0); //
  */
  
  //addTextSpecialBlock(4,"Hello World",11); //make block four display text when the player is near
  
  //int[] blocksArg = { 0, 1, 2, 3, 4 }; //create a set of blocks
  //float[] probArg = { 20, 14, 3, 2, 1 }; //create a list of probabilities for these blocks
  //genRandomProb(0, blocksArg, probArg); //place these blocks in the world with their respective probabilities (the world, by default is all 0 and these random blocks replace 0 here)

  
  genLoadMap(loadImage("map.png"));
  
  scaleView(100); //scale the view to fit the entire map
  centerView(wSize/2,wSize/2); //center the view in the middle of the world
  //player.y = -3;
  
  //entities.remove(player); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  
  
  
  //entities.remove(player); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  //testEntity.destroy();
}

/*LOCK*/void safeAsync(int n){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  if(n%25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    println(frameRate); //display the game FPS
  }
  if(n%150 == 1){
    sL.add(new Sound(testEntity.eV.x,testEntity.eV.y,entitySound,0));
  }
  if(n%250 == 0){} //every ten seconds (similar idea applies here)
}

/*LOCK*/void safeUpdate(){ //called before anything has been drawn to the screen (update the world before it is drawn)
  centerView(player.x,player.y); //center the view on the player
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6); //center view on the player but pull toward the mouse slightly
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2,maxAbs(0,float(mouseY-height/2)/50)+height/2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y); //move the view in the direction of the mouse
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX),height/2+(pmouseY-mouseY)); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);} //drag the view around
}

/*LOCK*/void safeDraw(){
  ellipse(testEntity.eV.x/100*width,testEntity.eV.y/100*width,10,10);
  
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(testEntity.AIMap[i][j] > 0){
        fill(0,0,255,testEntity.AIMap[i][j]*40);
      } else {
        fill(0,255,0,-testEntity.AIMap[i][j]*40);
      }
      noStroke();
      rect(i*width/wSize-wView.x*gScale,j*height/wSize-wView.y*gScale,width/wSize,height/wSize);
    }
  }
  
} //called after everything else has been drawn on the screen (draw things on the game)
void safePostDraw(){};
/*LOCK*/void safeKeyPressed(){} //called when a key is pressed
/*LOCK*/void safeKeyReleased(){} //called when a key is released
/*LOCK*/void safeMousePressed(){
  if(mouseButton == RIGHT){
    PVector tempV = screen2Pos(new PVector(mouseX,mouseY));
    player.fire(tempV);
  }
  
} //called when the mouse is pressed
void chatEvent(String source){};
void executeCommand(int index,String[] commands){
  switch(index){
    case 0:
      sL.add(new Sound(int(commands[1])+.5,int(commands[2])+.5,doorSound,0));
      break;
  }
}

/*LOCK*/void safeKeyTyped(){} //may be added in the future
/*LOCK*/void safeMouseWheel(){} //may be added in the future
/*LOCK*/void safeMouseClicked(){} //may be added in the future
/*LOCK*/void safeMouseMoved(){} //may be added in the future
/*LOCK*/void safeMouseDragged(){} //may be added in the future

