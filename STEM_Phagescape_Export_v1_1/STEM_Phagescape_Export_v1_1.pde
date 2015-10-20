/*LOCK*/void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/void safePreSetup(){} //first function called, in case you need to set some variables before anything else starts

/*LOCK*/void safeSetup(){ //called when world generation and entity placement is ready to begin
  addGeneralBlock(0,color(225,180,255),false,0); //set block 0 to be a light purple block that is not solid
  addGeneralBlock(1,color(255,0,0),true,0); //set block 1 to be a red block that is solid and breaks in 1 hit
  addGeneralBlock(2,color(0,255,0),true,1); //set block 2 to be a green block that is solid and breaks in 2 hits
  addGeneralBlock(3,color(0,0,255),true,4); //set block 3 to be a blue block that is solid and breaks in 5 hits
  addGeneralBlock(4,color(0,0,0),true,20); //set block 4 to be a black block that is solid and breaks in 21 hit
  //addImageSpecialBlock(4,loadImage("block.png"),0); //make block four have an image that (0 or 1 = ) fits inside the block (or 2 = moves with background)
  //addTextSpecialBlock(4,"Hello World",11); //make block four display text when the player is near
  
  int[] blocksArg = { 0, 1, 2, 3, 4 }; //create a set of blocks
  float[] probArg = { 20, 14, 3, 2, 1 }; //create a list of probabilities for these blocks
  genRandomProb(0, blocksArg, probArg); //place these blocks in the world with their respective probabilities (the world, by default is all 0 and these random blocks replace 0 here)
  
  scaleView(wSize); //scale the view to fit the entire map
  centerView(wSize/2,wSize/2); //center the view in the middle of the world
  
  entities.remove(player); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
}

/*LOCK*/void safeAsync(int n){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  if(n%25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    println(frameRate); //display the game FPS
  }
  if(n%250 == 0){} //every ten seconds (similar idea applies here)
}

/*LOCK*/void safeUpdate(){ //called before anything has been drawn to the screen (update the world before it is drawn)
  //centerView(player.x,player.y); //center the view on the player
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6); //center view on the player but pull toward the mouse slightly
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2,maxAbs(0,float(mouseY-height/2)/50)+height/2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y); //move the view in the direction of the mouse
  if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX),height/2+(pmouseY-mouseY)); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);} //drag the view around
}

/*LOCK*/void safeDraw(){} //called after everything else has been drawn on the screen (draw things on the game)
/*LOCK*/void safeKeyPressed(){} //called when a key is pressed
/*LOCK*/void safeKeyReleased(){} //called when a key is released
/*LOCK*/void safeMousePressed(){} //called when the mouse is pressed

/*LOCK*/void safeKeyTyped(){} //may be added in the future
/*LOCK*/void safeMouseWheel(){} //may be added in the future
/*LOCK*/void safeMouseClicked(){} //may be added in the future
/*LOCK*/void safeMouseMoved(){} //may be added in the future
/*LOCK*/void safeMouseDragged(){} //may be added in the future
