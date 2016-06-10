/* @pjs preload="face.png,map3.png"; */

String[] CardText = {"q:What is 1x1?","q:What is 2x2?","q:What is 3x3?","q:What is 4x4?","q:What is 5x5?","q:What is 6x6?","q:What is 7x7?","q:What is 8x8?","a:1","a:4","a:9","a:16","a:25","a:36","a:49","a:64"};
int[] CardPairs = {1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8};
int flipStage = -2;
int pairState = 0;
int trackEs = 0;
Entity testEntity;

int EC_DEATH_M, EC_AIR_M;

/*LOCK*/void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/void safePreSetup(){} //first function called, in case you need to set some variables before anything else starts

/*LOCK*/void safeSetup(){ //called when world generation and entity placement is ready to begin
  
  EC_DEATH_M = EC_NEXT();
  EC_AIR_M = EC_NEXT();
  
  EConfigs[EC_AIR_M] = new EConfig();
  EConfigs[EC_AIR_M].Genre = 1;
  EConfigs[EC_AIR_M].Img = loadImage("airMonster.png");
  EConfigs[EC_AIR_M].AISearchMode = 11;
  EConfigs[EC_AIR_M].AITarget = -1;
  EConfigs[EC_AIR_M].AITargetID = EC_PLAYER;
  EConfigs[EC_AIR_M].SMax = .05;
  EConfigs[EC_AIR_M].TSMax = .1;
  EConfigs[EC_AIR_M].TAccel = .03;
  EConfigs[EC_AIR_M].TDrag = .01;
  EConfigs[EC_AIR_M].Type = 1;
  EConfigs[EC_AIR_M].GoalDist = 3; //Want to get this close
  EConfigs[EC_AIR_M].ActDist = 10;
  EConfigs[EC_AIR_M].HMax = 1;
  EConfigs[EC_AIR_M].myBulletEntity = EC_NEXT();
  EConfigs[EConfigs[EC_AIR_M].myBulletEntity] = new EConfig();
  EConfigs[EConfigs[EC_AIR_M].myBulletEntity].Size = .13;
  EConfigs[EConfigs[EC_AIR_M].myBulletEntity].SMax = .1;
  EConfigs[EConfigs[EC_AIR_M].myBulletEntity].Color = color(0,100);
  EConfigs[EC_AIR_M].BirthCommand = "trackE 1";
  EConfigs[EC_AIR_M].DeathCommand = "trackE -1";
  EConfigs[EC_AIR_M].FireDelay = 15;
  EConfigs[EC_AIR_M].AltColor = color(0,100);
  
  EConfigs[EC_DEATH_M] = new EConfig();
  EConfigs[EC_DEATH_M].Genre = 1;
  EConfigs[EC_DEATH_M].Img = loadImage("D/deathMonster.png");
  EConfigs[EC_DEATH_M].AISearchMode = 11;
  EConfigs[EC_DEATH_M].AITarget = -1;
  EConfigs[EC_DEATH_M].AITargetID = EC_PLAYER;
  EConfigs[EC_DEATH_M].SMax = .05;
  EConfigs[EC_DEATH_M].TSMax = .1;
  EConfigs[EC_DEATH_M].TAccel = .03;
  EConfigs[EC_DEATH_M].TDrag = .01;
  EConfigs[EC_DEATH_M].Type = 1;
  EConfigs[EC_DEATH_M].GoalDist = 3; //Want to get this close
  EConfigs[EC_DEATH_M].ActDist = 10;
  EConfigs[EC_DEATH_M].HMax = 17;
  EConfigs[EC_DEATH_M].myBulletEntity = EC_NEXT();
  EConfigs[EConfigs[EC_DEATH_M].myBulletEntity] = new EConfig();
  EConfigs[EConfigs[EC_DEATH_M].myBulletEntity].Size = .13;
  EConfigs[EConfigs[EC_DEATH_M].myBulletEntity].SMax = .3;
  EConfigs[EConfigs[EC_DEATH_M].myBulletEntity].Color = color(0,100);
  EConfigs[EC_DEATH_M].BirthCommand = "trackE 1";
  EConfigs[EC_DEATH_M].DeathCommand = "trackE -1";
  EConfigs[EC_DEATH_M].FireDelay = 35;
  EConfigs[EC_DEATH_M].AltColor = color(0,100);
  
  CFuns.add(new CFun(0,"flip",1,false));
  CFuns.add(new CFun(1,"trackE",1,false));
  
  int ta,tb,tcI;
  String tcS;
  for(int i = 0; i < 50; i++){
    ta = floor(random(16));
    tb = floor(random(16));
    if(ta != tb){
      tcI = CardPairs[ta];
      tcS = CardText[ta];
      CardPairs[ta] = CardPairs[tb];
      CardText[ta] = CardText[tb];
      CardPairs[tb] = tcI;
      CardText[tb] = tcS;
    }
  }
  
  addGeneralBlock(5,color(200,0,0),true,5); //rock1
  addGeneralBlock(6,color(230,0,0),true,10); //rock2

  addGeneralBlock(0,color(100,0,0),false,0); //background
  
  addGeneralBlock(1,color(255,255,190),true,-1); //bone1
  addGeneralBlock(2,color(255,255,170),true,-1); //bone2
  addGeneralBlock(3,color(255,255,210),true,-1); //bone3
  
  addGeneralBlock(4,color(0,255,0),true,-1); //correct answer
  addGeneralBlock(7,color(255,0,0),true,-1); //jail wall
  
  for(int i = 0; i < 16; i++){
    addGeneralBlock(10+i,color(255,127,0),true,5); //question
    addGeneralBlockBreak(10+i,30+i,"flip "+str(i));
    
    addGeneralBlock(30+i,color(255,255,0),true,-1); //answer
    addGeneralBlockBreak(30+i,10+i,"");
  }

  
  
  boolean genLoop = true;
  while(genLoop){
    genLoop = false;
    genRect(0,0,wSize,wSize,0);
    genBox(0,0,wSize,wSize, 1, 1);

    int[] falloff = {10,0,0,0,0}; //
    
    for(int i = 35; i < 75; i+=10){
      for(int j = 35; j < 75; j+=10){
        genCircle(i,j,3,1);
      }
    }
    
    genSpreadClump(2500,0,1,100,falloff); //
    
    genSpreadClump(1500,0,5,200,falloff); //
    genSpreadClump(700,1,5,0,falloff); //
    
    genCircle(wSize/2,wSize/2,5,0);
    for(int i = 35; i < 75; i+=10){
      for(int j = 35; j < 75; j+=10){
        genCircle(i,j,4,0);
      }
    }
    
    genFlood(wSize/2,wSize/2,200);
    //genReplace(0,1);
    genBox(0,0,wSize,wSize, 1, 1);
    genReplace(200,0);
    
    int tempCount = 0;
    for(int i = 35; i < 75; i+=10){
      for(int j = 35; j < 75; j+=10){
        if(wU[i][j] == 0){
          wU[i][j] = 10+tempCount++;
        } else {
          genLoop = true;
        }
      }
    }
    
    if(!genLoop){
      genSpread(genCountBlock(1)/5,1,2);
      genSpread(genCountBlock(2),1,3);
      genSpread(genCountBlock(5)/4,5,6);
    }
    
    println("Generated");
    
  }
  
  
  scaleView(10); //scale the view to fit the entire map
  player.eDir = random(2*PI);
  shadows = true;
  centerView(player.x,player.y); //center the view in the middle of the world
  /*
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      miniMap[i][j] = gBColor[wU[i][j]];
    }
  }
  */
  //removeEntity(player,-1); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  //testEntity.destroy();
}

/*LOCK*/void safeAsync(){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  
  if(flipStage > 0){
    flipStage--;
    if(flipStage == 0){
      if(pairState != -1){
        
        flipStage = -2;
        HUDTtext = "";
        HUDText("Correct!", " ", 40, 40, color(0,255,0), color(255), 25, 25, 0, 10);
        genReplace(30+pairState,4);
        for(int i = 0; i < 16; i++){
          if(CardPairs[i] == pairState){
            genReplace(30+i,4);
          } else {
            genReplace(30+i,10+i);
          }
          
        }
      } else {
        HUDText("Incorrect!", " ", 40, 40, color(255,0,0), color(255), 25, 25, 0, 10);
        for(int i = 0; i < 16; i++){
          gBColor[30+i] = color(255,0,0);
        }
        
        PVector spawnCenter = new PVector(player.x,player.y);
        
        resetSearches(player.x,player.y,100);
        boolean searchLoop = true;PVector tempPV;while(searchLoop){tempPV = findNonAirWU();if(tempPV != null){
            if(aGS(wU,tempPV.x,tempPV.y) >= 30 && aGS(wU,tempPV.x,tempPV.y) < 30+16){
              spawnCenter = new PVector(tempPV.x+.5,tempPV.y+.5);
              searchLoop = false;
            }
        }else{searchLoop = false;}}
        
        genLine(spawnCenter.x-2,spawnCenter.y-3,spawnCenter.x+2,spawnCenter.y-3,0,7);
        genLine(spawnCenter.x-2,spawnCenter.y+3,spawnCenter.x+2,spawnCenter.y+3,0,7);
        genLine(spawnCenter.x-3,spawnCenter.y-2,spawnCenter.x-3,spawnCenter.y+2,0,7);
        genLine(spawnCenter.x+3,spawnCenter.y-2,spawnCenter.x+3,spawnCenter.y+2,0,7);
        
        float td = pointDir(spawnCenter,player.eV);
        
        if(pointDistance(spawnCenter,player.eV) > 2){
          player.x = spawnCenter.x+cos(td)*2;
          player.y = spawnCenter.y+sin(td)*2;
        }
        
        td+= PI;
        
        for(int i = 2+floor(random(4)); i > 0; i--){
          float tdr = td + random(PI/2)-PI/4;
          entities.add(new Entity(spawnCenter.x+cos(tdr)*2,spawnCenter.y+sin(tdr)*2,EC_DEATH_M+floor(random(2)),tdr+PI));
        }
        
      }
      refreshWorld();
      refreshMiniMapCards();
    }
  }
  
  
  if(fn%10 == 0){
    
  }
  
  if(fn%25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    //println(frameRate); //display the game FPS
  }
  if(fn%100 == 0){
    
    
    
  } //every ten seconds (similar idea applies here)
}

/*LOCK*/void safeUpdate(){ //called before anything has been drawn to the screen (update the world before it is drawn)
  centerView(player.x,player.y); //center the view on the player
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6); //center view on the player but pull toward the mouse slightly
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2,maxAbs(0,float(mouseY-height/2)/50)+height/2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y); //move the view in the direction of the mouse
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX),height/2+(pmouseY-mouseY)); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);} //drag the view around
}

void safePostUpdate(){}

void safePluginAI(Entity e){
  /*
  Control the AI of an entity e
  This function is called 25 times each second
  Input: all data associated with entity such as position, EC (basic entity type), speed, direction, AI variables, etc.
  Output: fire() usage with direction to fire a bullet, eMove value, eD destination value
  */
  if(e.EC == EC_AIR_M){
    AIWander(e,6,20,90);
    e.eStamina = 100;
    if(e.eFireCooldown == 0){
      e.fire(player.eV);
    }
  } else if(e.EC == EC_DEATH_M){
    AIWander(e,6,20,90);
    e.eStamina = 100;
    if(e.eFireCooldown == 0){
      e.fire(player.eV);
    }
  }
  /*
  Control the AI of an entity e
  This function is called 25 times each second
  Input: all data associated with entity such as position, EC (basic entity type), speed, direction, AI variables, etc.
  Output: fire() usage with direction to fire a bullet, eMove value, eD destination value
  */
}

/*LOCK*/void safeDraw(){} //called after everything else has been drawn on the screen (draw things on the game)
/*LOCK*/void safePostDraw(){
  
  
  
  
  /*
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
        } else if(EConfigs[((Entity)tempAL.get(k)).EC].Genre == 3){
          fill(0,255,0);
        } else {
          fill(255,0,100);
        }
        ellipse(tempPV2.x+gScale/10*k,tempPV2.y,10,10);
      }
      //text(.size(),tempPV2.x,tempPV2.y);
      
    }
  }
  */
  
  
  
  

  
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

void refreshMiniMapCards(){
  for(int i = 35; i < 75; i+=10){
    for(int j = 35; j < 75; j+=10){
      if(miniMap[i][j] != 0){
        miniMap[i][j] = gBColor[wU[i][j]];
      }
    }
  }
}

/*LOCK*/void chatEvent(String source){
} //called when a chat message is created

void executeCommand(int index, String[] commands){
  switch(index){
    case 0: //function id stated above
      if(flipStage < 0){
        
        String thisCardText = CardText[int(commands[1])];
        if(thisCardText.substring(0,2).equals("q:")){
          thisCardText = "Question "+thisCardText.substring(2,thisCardText.length());
          if(flipStage == -1){
            HUDText(thisCardText, HUDTtext, 40, 40, color(255), color(255), 25, 25, 0, 50);
          }
        } else {
          thisCardText = "Answer "+thisCardText.substring(2,thisCardText.length());
          if(flipStage == -1){
            HUDText(HUDTtext, thisCardText, 40, 40, color(255), color(255), 25, 25, 0, 50);
          }
        }
        if(flipStage == -2){
          HUDText(thisCardText, " ", 40, 40, color(255), color(255), 25, 25, 0, 50);
        }
        
        
        
        
        if(flipStage == -2){
          flipStage = -1;
          pairState = CardPairs[int(commands[1])];
        } else {
          flipStage = 100;
          if(pairState != CardPairs[int(commands[1])]){
            pairState = -1;
          }
        }
        refreshMiniMapCards();
      }
      break;
    case 1:
      if(commands[1].equals("-1")){
        trackEs--;
        if(trackEs == 0){
          genReplace(7,5);
          for(int i = 0; i < 16; i++){
            gBColor[30+i] = color(255,0,0);
            genReplace(30+i,10+i);
          }
          flipStage = -2;
          refreshWorld();
          refreshMiniMapCards();
        }
      } else {
        trackEs++;
      }
      break;
  }
}

void safeMouseReleased(){}
/*LOCK*/void safeKeyTyped(){} //may be added in the future
/*LOCK*/void safeMouseWheel(){} //may be added in the future
/*LOCK*/void safeMouseClicked(){} //may be added in the future
/*LOCK*/void safeMouseMoved(){} //may be added in the future
/*LOCK*/void safeMouseDragged(){} //may be added in the future
