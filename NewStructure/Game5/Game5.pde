/* @pjs preload="D/face.png,D/map4.png"; */

PVector testingV = new PVector();

int[] bacteriaAlive = {0,0,0,0,0,0};
int[] bacteriaGoal = {0,0,0,0,0,0};

Entity testEntity;
int EC_NORM_ENEMY;
int EC_FAST_ENEMY;
int EC_BOSS_ENEMY;
ArrayList<RoomType>[] randomRooms = (ArrayList<RoomType>[])new ArrayList[8];

/*LOCK*/void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/void safePreSetup(){} //first function called, in case you need to set some variables before anything else starts

/*LOCK*/void safeSetup(){ //called when world generation and entity placement is ready to begin

  //bulletEntity.Size = .1;
  
  EConfigs[EC_PLAYER].HMax = 200;
  player.eHealth = 198;
  
  EC_NORM_ENEMY = EC_NEXT();
  EC_FAST_ENEMY = EC_NEXT();
  EC_BOSS_ENEMY = EC_NEXT();
  
  EConfigs[EC_NORM_ENEMY] = new EConfig();
  EConfigs[EC_NORM_ENEMY].Genre = 1;
  EConfigs[EC_NORM_ENEMY].Img = loadImage(aj.D()+"player.png");
  EConfigs[EC_NORM_ENEMY].AISearchMode = 1;
  EConfigs[EC_NORM_ENEMY].AITarget = -1;
  EConfigs[EC_NORM_ENEMY].AITargetID = EConfigs[player.EC].ID;
  EConfigs[EC_NORM_ENEMY].SMax = .05;
  EConfigs[EC_NORM_ENEMY].Type = 1;
  EConfigs[EC_NORM_ENEMY].HMax = 20;
  
  EConfigs[EC_FAST_ENEMY] = new EConfig();
  EConfigs[EC_FAST_ENEMY].Genre = 1;
  EConfigs[EC_FAST_ENEMY].Img = loadImage(aj.D()+"face.png");
  EConfigs[EC_FAST_ENEMY].AISearchMode = 1;
  EConfigs[EC_FAST_ENEMY].AITarget = -1;
  EConfigs[EC_FAST_ENEMY].AITargetID = EConfigs[player.EC].ID;
  EConfigs[EC_FAST_ENEMY].SMax = .1;
  EConfigs[EC_FAST_ENEMY].Type = 1;
  EConfigs[EC_FAST_ENEMY].HMax = 10;
  
  EConfigs[EC_BOSS_ENEMY] = new EConfig();
  EConfigs[EC_BOSS_ENEMY].Genre = 1;
  EConfigs[EC_BOSS_ENEMY].Img = loadImage(aj.D()+"face.png");
  EConfigs[EC_BOSS_ENEMY].AISearchMode = 1;
  EConfigs[EC_BOSS_ENEMY].AITarget = -1;
  EConfigs[EC_BOSS_ENEMY].AITargetID = EConfigs[player.EC].ID;
  EConfigs[EC_BOSS_ENEMY].SMax = .03;
  EConfigs[EC_BOSS_ENEMY].Type = 1;
  EConfigs[EC_BOSS_ENEMY].HMax = 100;
  EConfigs[EC_BOSS_ENEMY].DeathCommand = "openDoors";
  
  
  CFuns.add(new CFun(0,"spawn",3,false)); //add a function
  CFuns.add(new CFun(1,"openDoors",0,false));
  CFuns.add(new CFun(2,"question",0,false));
  CFuns.add(new CFun(3,"key",0,false));
  CFuns.add(new CFun(4,"chest",2,false));
  
  addGeneralBlock(0,color(100,0,0),false,0); //background
  addGeneralBlock(1,color(255,255,190),true,-1); //bone
  addGeneralBlock(2,color(200,0,0),true,50); //flesh
  addGeneralBlock(3,color(102,0,51),false,-1); //spawn
  addGeneralBlock(4,color(204,0,102),false,-1); //around spawn background
  addGeneralBlock(5,color(255,165,0),false,-1); //spawn help 1
  //addTextSpecialBlock(5,"Help 1",1);
  addGeneralBlock(6,color(255,165,0),false,-1); //spawn help 2
  //addTextSpecialBlock(6,"Help 2",1);
  addGeneralBlock(7,color(255,165,0),false,-1); //spawn help 3
  //addTextSpecialBlock(7,"Help 3",1);
  addGeneralBlock(8,color(255,165,0),false,-1); //spawn help 4
  //addTextSpecialBlock(8,"Help 4",1);
  addGeneralBlock(9,color(102,51,0),false,-1); //end
  addGeneralBlock(10,color(204,102,0),false,-1); //around end background
  addGeneralBlock(11,color(255,165,0),false,-1); //end help 1
  //addTextSpecialBlock(11,"Help 5",1);
  addGeneralBlock(12,color(255,165,0),false,-1); //end help 2
  //addTextSpecialBlock(12,"Help 6",1);
  addGeneralBlock(13,color(255,165,0),false,-1); //end help 3
  //addTextSpecialBlock(13,"Help 7",1);
  addGeneralBlock(14,color(255,165,0),false,-1); //end help 4
  //addTextSpecialBlock(14,"Help 8",1);
  addGeneralBlock(15,color(255,255,0),false,-1); //key
  addGeneralBlockBreak(15,0,"key");
  addActionSpecialBlock(15,21);
  addGeneralBlock(16,color(255,200,30),false,-1); //chest
  addGeneralBlockBreak(16,0,"chest _x_ _y_");
  //addTextSpecialBlock(16,"You may need a key##to open this chest!",1);
  addGeneralBlock(17,color(0),true,0); //boss egg
  addGeneralBlockBreak(17,0,"spawn _x_ _y_ boss");
  addActionSpecialBlock(17,14);
  addGeneralBlock(18,color(0),true,0); //fast egg
  addGeneralBlockBreak(18,0,"spawn _x_ _y_ fast");
  addActionSpecialBlock(18,20);
  addGeneralBlock(19,color(0),true,0); //norm egg
  addGeneralBlockBreak(19,0,"spawn _x_ _y_ norm");
  addActionSpecialBlock(19,20);
  addGeneralBlock(20,color(0,255,0),true,2); //question
  addGeneralBlockBreak(20,0,"question");
  addGeneralBlock(21,color(100,100,100),true,50); //fast spawner
  ///////////////////////////////////////////////////////////////////spawn
  addGeneralBlock(22,color(100,100,100),true,50); //norm spawner
  ///////////////////////////////////////////////////////////////////spawn
  addGeneralBlock(40,color(200,200,110),false,-1); //door frame
  addGeneralBlockBreak(40,49,null);
  addGeneralBlock(49,color(200,200,110),true,4); //door frame 2
  addGeneralBlockBreak(49,40,null);
  addGeneralBlock(41,color(204,50,102),true,-1); //door closed
  addGeneralBlockBreak(41,42,null);
  addActionSpecialBlock(41,46);
  addGeneralBlock(42,color(100,0,0),false,0); //door open
  addGeneralBlockBreak(42,41,null);
  addActionSpecialBlock(42,46);
  addGeneralBlock(43,color(204,50,102),true,-1); //boss door closed
  addGeneralBlockBreak(43,44,null);
  addActionSpecialBlock(43,46);
  addGeneralBlock(44,color(100,0,0),false,0); //boss door open
  addGeneralBlock(45,color(204,50,102),true,-1); //boss door locked
  
  
  genLoadMap(loadImage(aj.D()+"map4.png")); //load the map to read the room types
  
  for(int i = 0; i < 8; i++){ //for each room type
    randomRooms[i] = new ArrayList<RoomType>(); //make a list of room type variations
  }
  
  for(int i = 0; i < wSize; i++){ //for each block in the world (x)
    for(int j = 0; j < wSize; j++){ //for each block in the world (y)
      if(wU[i][j]>=100 && wU[i][j]<108){ //if it is a block that indicates that this room needs to be loaded
        randomRooms[wU[i][j]-100].add(new RoomType(i-8,j,9,9)); //load the room into the correct list for the room type
      }
    }
  }
  
  boolean badMap = true; //sat that the map is bad to induce the first level generation
  
  while(badMap){ //if the level is bad, try to generate it until it is not bad
    badMap = false; //a new level generation has begun, lets start out by saying this level is good
    genLoadMap(loadImage(aj.D()+"map4.png")); //load the premade map to work with, this resets the map back to the original version
    
    genSpread(50,200,201); //mark up to 50 doors to be removed
    
    for(int i = 0; i < wSize; i++){ //for each block in the world (x)
      for(int j = 0; j < wSize; j++){ //for each block in the world (y)
        if(wU[i][j] == 201){ //if this block is a door marked for removal,
          wU[i][j] = 200; //chage this block back to normal door
          genFlood(i,j,40); //change the door into doorframe
          genFlood(i,j,1); //change the door frame into bone
        }
      }
    }
    
    genReplace(200,41); //make all of the remporary doors actual doors since we are done messing with them
    
    for(int i = 0; i < wSize; i++){ //for each block in the world (x)
      for(int j = 0; j < wSize; j++){ //for each block in the world (y)
        if(wU[i][j]>=100 && wU[i][j]<108){ //if it is a block that indicates that this room has stuff in it
          genRect(i-7,j,8,9,0); //clear the room (leave the upper left corner intact)
          genRect(i-8,j+1,9,8,0); //clear the room (leave the upper left corner intact - this indicates the room type)
        }
      }
    }
    
    genTestPathExists(50,50,-1,-1); //run a test path to nowhere to flood the maze with imaginary water from the center
    
    for(int i = 0; i < 9; i++){ //for each room (x)
      for(int j = 0; j < 9; j++){ //for each room (y)
        if(nmap[i*10+9][j*10+9] == 0){ //if the imaginary water did not reach this room
          badMap = true; //mark this generation as bad (will generate again)
        }
      }
    }
  }
  
  addGeneralBlock(40,color(200,200,110),true,4); //make door frames solid (they were not solid so imaginary water could flood through doors but not walls)
  
  for(int i = 0; i < 9; i++){ //for each room (x)
    for(int j = 0; j < 9; j++){ //for each room (y)
      RoomType tempRoom = randomRooms[wU[i*10+5][j*10+5]-108].get(floor(random(randomRooms[wU[i*10+5][j*10+5]-108].size()))); //load a random room of the correct type
      tempRoom.paste(i*10+5,j*10+5); //paste this room in
      wU[i*10+5][j*10+5] = 1; //remove temporary indicator block
      wU[i*10+13][j*10+5] = 1; //remove temporary indicator block
    }
  }
    
  shadows = true;
  //scaleView(10); //scale the view to fit the entire map
  scaleView(10);
  
  centerView(wSize/2-.5,wSize/2-.5); //center the view in the middle of the world
  player.x = wSize/2-.5;
  player.y = wSize/2-.5;
  
}

/*LOCK*/void safeAsync(){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  if(fn%25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    //println(frameRate); //display the game FPS
    
  }
  if(mousePressed){
    println("true"+str(fn));
  }
  if(fn%250 == 0){} //every ten seconds (similar idea applies here)
}

/*LOCK*/void safeUpdate(){ //called before anything has been drawn to the screen (update the world before it is drawn)
  centerView(player.x,player.y); //center the view on the player
}

class RoomType{
  int[][] data;
  int w;
  int h;
  RoomType(int x, int y, int tW, int tH){
    w = tW;
    h = tH;
    data = new int[w][h];
    for(int i = 0; i < w; i++){
      for(int j = 0; j < h; j++){
        data[i][j] = aGS(wU,x+i,y+j);
      }
    }
  }
  void paste(int x, int y){
    for(int i = 0; i < w; i++){
      for(int j = 0; j < h; j++){
        aSS(wU,x+i,y+j,data[i][j]);
      }
    }
  }
}

/*LOCK*/void safeDraw(){} //called after everything else has been drawn on the screen (draw things on the game)
/*LOCK*/void safePostDraw(){
  
  stroke(255);
  strokeWeight(2);
  for(int i = -5; i <= 5; i++){
    for(int j = -5; j <= 5; j++){
      PVector tempPV = new PVector(floor(player.x)+i+.5,floor(player.y)+j+.5);
      
      PVector tempPV2 = pos2Screen(new PVector(tempPV.x,tempPV.y));
      
      ArrayList tempAL = aGSAL(wUEntities,tempPV.x,tempPV.y);
      
      for(int k = 0; k < tempAL.size(); k++){
        if(((Entity)tempAL.get(k)).ID == player.ID){
          fill(0,100,255);
        } else {
          fill(255,0,100);
        }
        ellipse(tempPV2.x+gScale/10*k,tempPV2.y,10,10);
      }
      //text(.size(),tempPV2.x,tempPV2.y);
      
    }
  }
  
} //called after everything else has been drawn on the screen (draw things on the screen)
/*LOCK*/void safeKeyPressed(){
  if(key == 't'){
    //player.x = mouseX;
    //player.y = mouseY;
  }
  if(key == 'u'){
    genReplace(43,44);
    genReplace(44,45);
  }
} //called when a key is pressed
/*LOCK*/void safeKeyReleased(){} //called when a key is released
/*LOCK*/void safeMousePressed(){} //called when the mouse is pressed

/*LOCK*/void chatEvent(String source){} //called when a chat message is created

void executeCommand(int index,String[] commands){
  switch(index){
    case 0: //function id stated above
      if(commands[3].equals("norm")){
        entities.add(new Entity(int(commands[1])+.5,int(commands[2])+.5, EC_NORM_ENEMY,random(TWO_PI)));
      } else if(commands[3].equals("fast")){
        entities.add(new Entity(int(commands[1])+.5,int(commands[2])+.5, EC_FAST_ENEMY,random(TWO_PI)));
      } else if(commands[3].equals("boss")){
        entities.add(new Entity(int(commands[1])+.5,int(commands[2])+.5, EC_BOSS_ENEMY,random(TWO_PI)));
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////tp followers to player
        
        for(int i = entities.size()-1; i >= 0; i--){
          Entity te = (Entity)entities.get(i);
          if(EConfigs[te.EC].Genre == 1 && te.ID != player.ID){
            te.x = int(commands[1])+.5;
            te.y = int(commands[2])+.5;
          }
        }
        
        genReplace(43,44);
        genReplace(44,45);
      }
      break;
    case 1: //function id stated above
      genReplace(45,0);
      genReplace(17,0);
      refreshWorld();
      break;
    case 2: //function id stated above
      //question
      break;
    case 3: //function id stated above
      //key
      HUDText("You collected a key!", "", 58, 40, color(255), color(255), 24, 25, 12, 75);
      //sBHasText[16] = false;
      addActionSpecialBlock(16,21);
      break;
    case 4: //function id stated above
      //chest
      for(int i = 0; i < 5; i++){
        entities.add(new Entity(int(commands[1])+.5,int(commands[2])+.5, EC_BOSS_ENEMY,random(TWO_PI)));
      }
      break;
      
      
  }
}

void safePostUpdate(){

}

void safePluginAI(Entity e){};
/*LOCK*/void safeMouseReleased(){} //may be added in the future

/*LOCK*/void safeKeyTyped(){} //may be added in the future
/*LOCK*/void safeMouseWheel(){} //may be added in the future
/*LOCK*/void safeMouseClicked(){} //may be added in the future
/*LOCK*/void safeMouseMoved(){} //may be added in the future
/*LOCK*/void safeMouseDragged(){} //may be added in the future
