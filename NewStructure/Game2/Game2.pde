/* @pjs preload="D/face.png,D/map3.png"; */

int[] EC_BACT = new int[6];
int[] EC_ITEM = new int[4];
int[] bacteriaAlive = {0,0,0,0,0,0};
int[] bacteriaGoal = {0,0,0,0,0,0};
String[] bacteriaNames = {"Reproducer","Decomposer","Digester","Basic Warrior","Fast Warrior","Tough Warrior"};
String[] bacteriaDetails = {"This bacteria will birth your army!","This bacteria will rot flesh to##provide resources!","This bacteria will collect##your resources!","This bacteria will fight for you!","This fighter is fast but weak!","This fighter is strong but slow!"};
int[][] bacteriaCosts = {{60,0,0,0},{0,60,0,0},{0,0,60,0},{10,20,10,20},{10,10,10,30},{30,10,10,10}};
float[] resources = new float[4];
Entity testEntity;
String EOL = "                                                                           ";

/*LOCK*/void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/void safePreSetup(){} //first function called, in case you need to set some variables before anything else starts

/*LOCK*/void safeSetup(){ //called when world generation and entity placement is ready to begin
  
  resources[0] = 600;
  resources[1] = 600;
  resources[2] = 600;
  resources[3] = 600;
  
  for(int i = 0; i < bacteriaGoal.length; i++){
    EC_BACT[i] = EC_NEXT();
    EConfigs[EC_BACT[i]] = new EConfig();
    EConfigs[EC_BACT[i]].Genre = 1;
    EConfigs[EC_BACT[i]].Img = loadImage(aj.D()+"Jacob"+str(i)+".png");
    EConfigs[EC_BACT[i]].AISearchMode = 11;
    EConfigs[EC_BACT[i]].AITarget = -1;
    EConfigs[EC_BACT[i]].AITargetID = EConfigs[player.EC].ID;
    EConfigs[EC_BACT[i]].SMax = .05;
    EConfigs[EC_BACT[i]].TSMax = .1;
    EConfigs[EC_BACT[i]].TAccel = .03;
    EConfigs[EC_BACT[i]].TDrag = .01;
    EConfigs[EC_BACT[i]].Type = 1;
    EConfigs[EC_BACT[i]].GoalDist = 3; //Want to get this close
    EConfigs[EC_BACT[i]].ActDist = -1;
    EConfigs[EC_BACT[i]].HMax = 100;
    EConfigs[EC_BACT[i]].AltColor = color(0,100);
    EConfigs[EC_BACT[i]].Team = -3;
    EConfigs[EC_BACT[i]].DeathCommand = "die _x_ _y_ "+str(i);
  }
  EConfigs[EC_BACT[2]].SuckRange = 1;
  EConfigs[EC_BACT[0]].Color = color(120,0,255);
  EConfigs[EC_BACT[1]].Color = color(0,150,0);
  EConfigs[EC_BACT[2]].Color = color(200,200,255);
  
    
  addGeneralBlock(6,color(255,165,0),true,50); //Protein
  addGeneralBlock(7,color(0,255,255),true,50); //Lipids
  addGeneralBlock(8,color(205,0,205),true,50); //Nucleotides
  addGeneralBlock(9,color(225,225,255),true,50); //Sugar
  addGeneralBlockBreak(6,0,"break _x_ _y_ 0");
  addGeneralBlockBreak(7,0,"break _x_ _y_ 1");
  addGeneralBlockBreak(8,0,"break _x_ _y_ 2");
  addGeneralBlockBreak(9,0,"break _x_ _y_ 3");
  addGeneralBlock(5,color(200,0,0),true,30); //rock
  addGeneralBlockBreak(5,0,"break _x_ _y_ -1");
  
    
  for(int i = 0; i < resources.length; i++){
    EC_ITEM[i] = EC_NEXT();
    EConfigs[EC_ITEM[i]] = new EConfig();
    EConfigs[EC_ITEM[i]].Genre = 3;
    EConfigs[EC_ITEM[i]].Size = .1;
    EConfigs[EC_ITEM[i]].Accel = .1;
    EConfigs[EC_ITEM[i]].SMax = .1;
    EConfigs[EC_ITEM[i]].ActDist = 5;
    EConfigs[EC_ITEM[i]].Color = gBColor[6+i];
    EConfigs[EC_ITEM[i]].AltColor = gBColor[6+i];
    EConfigs[EC_ITEM[i]].HitCommand = "collect _collector_ "+str(i);
  }
  
  for(int i = 0; i < 5; i++){
    //testEntity = new Entity(51,51,airMonster,0);
    //addEntity(testEntity);
  }
  
  CFuns.add(new CFun(0,"add",2,false)); //add a function that adds a number, n, to the goal number for a type of bacteria, type, (id, function, argument #, can be used by the user directly? true/false)
  CFuns.add(new CFun(1,"die",3,false)); //add a function that subs a bacteria from the number alive for a type of bacteria, type (id, function, argument #, can be used by the user directly? true/false)
  CFuns.add(new CFun(2,"collect",2,false));
  CFuns.add(new CFun(3,"break",3,false));
  
  addGeneralBlock(0,color(100,0,0),false,0); //background
  //addImageSpecialBlock(0,loadImage(aj.D()+"a.png"),0);
  
  addGeneralBlock(1,color(255,255,190),true,-1); //bone
  
  addGeneralBlock(2,color(100,100,120),true,-1); //door
  addGeneralBlockBreak(2,0,null);
  addActionSpecialBlock(2,46);
  //addImageSpecialBlock(2,loadImage(aj.D()+"woodDoor.png"),0);
  
  addGeneralBlock(3,color(102,51,0),false,-1); //enemy base
  
  addGeneralBlock(4,color(102,0,51),false,-1); //player base
  
  addGeneralBlock(10,color(0,255,0),false,-1); //question
  addGeneralBlockBreak(10,0,"break _x_ _y_ -2");
  addActionSpecialBlock(10,1);

  
  addGeneralBlock(20,color(0),false,-1); //sign by the door
  addGeneralBlockBreak(20,21,"");
  //addTextSpecialBlock(20,"Enter this block to open the door!",9);
  addActionSpecialBlock(20,1);
  addGeneralBlock(21,gBColor[1],false,-1); //used door key
  
  
  genLoadMap(loadImage(aj.D()+"map3.png"));
  
  int[] falloff = {100,25,1,1,1}; //
  genSpreadClump(300,201,200,10,falloff); //
  
  genReplace(201,0); //clear out the player's area (fill with air)
  genReplace(200,5); //turn the area around the player's area to stone
  
  int[] falloff5 = {100,0,0,0,0}; //make bone collect on walls
  genSpreadClump(300,5,1,20,falloff5); //add bone
  
  int[] falloff4 = {100,0,0,0,0}; //make sugar clump
  genSpreadClump(300,5,9,50,falloff4); //add sugar

  int[] falloff3 = {100,100,0,0,0}; //make nucleotides spawn in patches
  genSpreadClump(300,5,8,30,falloff3); //add nucleotides
  
  int[] falloff2 = {0,100,0,0,0}; //make lipids collect in little circles
  genSpreadClump(300,5,7,50,falloff2); //add lipids
  
  int[] falloff1 = {0,0,0,100,100}; //make protein spread out
  genSpreadClump(300,5,6,50,falloff1); //add protein
  
  genSpread(25,5,10);
  //genReplace(200,0);
  //genReplace(201,0);
  
  drawMenu();

  
  player.x = 70.5;
  player.y = 52.5;
  scaleView(10); //scale the view to fit the entire map
  player.eDir = random(2*PI);
  //shadows = false;
  centerView(player.x,player.y); //center the view in the middle of the world
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      miniMap[i][j] = gBColor[wU[i][j]];
    }
  }
  //removeEntity(player,-1); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  //testEntity.destroy();
}

/*LOCK*/void safeAsync(){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  
  
  
  
  if(fn%10 == 0){
    
    int totalAlive = 0;
    int birthChance;
    for(int i = 0; i < 6; i++){
      totalAlive += bacteriaAlive[i];
    }
    
    if(totalAlive < 50){
      if(totalAlive < 3){
        birthChance = 200;
      } else {
        birthChance = bacteriaAlive[0]*50;
      }
      
      if(random(1000) < birthChance){
        if(bacteriaAlive[0] == 0){
          if(bacteriaGoal[0] > 0){
            if(resources[0] >= bacteriaCosts[0][0] && resources[1] >= bacteriaCosts[0][1] && resources[2] >= bacteriaCosts[0][2] && resources[3] >= bacteriaCosts[0][3]){
              resources[0] -= bacteriaCosts[0][0];
              resources[1] -= bacteriaCosts[0][1];
              resources[2] -= bacteriaCosts[0][2];
              resources[3] -= bacteriaCosts[0][3];
              bacteriaAlive[0]++;
              addEntity(new Entity(player.x,player.y,EC_BACT[0],random(TWO_PI)));
              drawMenu();
            }
          }
        } else {
          int birthSum = 0;
          for(int i = 0; i < bacteriaGoal.length; i++){
            birthSum += max(0,bacteriaGoal[i]-bacteriaAlive[i]);
          }
          if(birthSum > 0){
            boolean loopingB = true;
            while(loopingB){
              int randPos = floor(random(bacteriaGoal.length));
              if(bacteriaGoal[randPos]-bacteriaAlive[randPos] > 0){
                loopingB = false;
                if(resources[0] >= bacteriaCosts[randPos][0] && resources[1] >= bacteriaCosts[randPos][1] && resources[2] >= bacteriaCosts[randPos][2] && resources[3] >= bacteriaCosts[randPos][3]){
                  Entity te;
                  Entity selected = null;
                  for(int i = entities.size()-1; i >= 0 ; i--){
                    te = (Entity)entities.get(i);
                    if(EConfigs[te.EC].Genre == 1){
                      if(te.EC == EC_BACT[0]){
                        if(selected == null || random(100)<33){
                          selected = te;
                        }
                      }
                    }
                  }
                  if(selected != null){
                    resources[0] -= bacteriaCosts[randPos][0];
                    resources[1] -= bacteriaCosts[randPos][1];
                    resources[2] -= bacteriaCosts[randPos][2];
                    resources[3] -= bacteriaCosts[randPos][3];
                    bacteriaAlive[randPos]++;
                    addEntity(new Entity(selected.x,selected.y,EC_BACT[randPos],random(TWO_PI)));
                  }
                  drawMenu();
                }
              }
            }
          } 
        }
      }
    }
    
    if(totalAlive > 0){
      if(fn % 25 == 0){
        int randPos = floor(random(bacteriaGoal.length));
        if(bacteriaGoal[randPos]-bacteriaAlive[randPos] < 0){
          Entity te;
          Entity selected = null;
          int selHel = 999;
          for(int i = entities.size()-1; i >= 0 ; i--){
            te = (Entity)entities.get(i);
            if(EConfigs[te.EC].Genre == 1){
              if(te.EC == EC_BACT[randPos]){
                if(te.eHealth < selHel || (te.eHealth < selHel && random(100)<33)){
                  selected = te;
                  selHel = te.eHealth;
                }
              }
            }
          }
          if(selected != null){
            selected.destroy();
          }
        }
      }
    }
    
    
  }
  
  if(fn%25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    //println(frameRate); //display the game FPS
  }
  if(fn%100 == 0){
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        miniMap[i][j] = gBColor[wU[i][j]];
      }
    }
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
  if(e.EC == EC_BACT[0]){
    AIWander(e,20,25,10);
  } else if(e.EC == EC_BACT[1]){
    int tempBlock = aGS(wU,e.eD.x,e.eD.y);
    float disToD = pointDistance(e.eV,e.eD);
    if(fn % 25 == 0){
      if(tempBlock == 0 || rayCast(e.x,e.y,e.eD.x,e.eD.y,true) == false || random(100) < 4){
        PVector choice = null;
        resetSearches(e.x,e.y,10);
        boolean searchLoop = true;PVector tempPV;while(searchLoop){tempPV = findNonAirWU();if(tempPV != null){
            tempBlock = aGS(wU,tempPV.x,tempPV.y);
            if(tempBlock >= 6 && tempBlock <= 9){
              if(rayCast(tempPV.x+.5,tempPV.y+.5,e.x,e.y,true)){
                choice = tempPV;
                searchLoop = false;
              }
            } else if(tempBlock == 5){
              if(choice == null){
                if(rayCast(tempPV.x+.5,tempPV.y+.5,e.x,e.y,true)){
                  choice = tempPV;
                }
              }
            }
        }else{searchLoop = false;}}
        if(choice == null){
          AIWander(e,20,1,10);
        } else {
          e.eD = new PVector(choice.x+.5,choice.y+.5);
        }
      }
    }
    if(disToD > 2){
      e.eMove = true;
    }
    if(tempBlock >= 5 && tempBlock <= 9 && e.eFireCooldown == 0 && e.eStamina > 50){
      e.fire(e.eD);
    }
    
  } else if(e.EC == EC_BACT[2]){
    
    float disToD = pointDistance(e.eV,e.eD);
    if(fn % 12 == 0){
      if(aGS(wU,e.eD.x,e.eD.y) == 0 || rayCast(e.x,e.y,e.eD.x,e.eD.y,true) == false || random(100) < 4){
        PVector choice = null;
        Entity tempE;
        resetSearches(e.x,e.y,10);
        boolean searchLoop = true;ArrayList eLResults;while(searchLoop){eLResults = findEntityGrid();if(eLResults != null){for(int j = eLResults.size()-1; j >= 0; j--){ //compact search loop structure
              tempE = (Entity)eLResults.get(j);
              if(EConfigs[tempE.EC].Genre == 3 && rayCast(tempE.x,tempE.y,e.x,e.y,false)){
                choice = new PVector(tempE.x,tempE.y);
                searchLoop = false;
              }
        }}else{searchLoop = false;}}
        if(choice == null){
          AIWander(e,20,1,10);
        } else {
          e.eD = new PVector(choice.x,choice.y);
        }
      }
    }
    if(disToD > .9){
      e.eMove = true;
    }
  } else if(e.EC == EC_BACT[3]){
    
  } else if(e.EC == EC_BACT[4]){
    
  } else if(e.EC == EC_BACT[5]){
    
  }
}

void drawMenu(){
  cL.clear();
  cL.add(new Chat(EOL));
  cL.add(new Chat(EOL));
  cL.add(new Chat(EOL));
  cL.add(new Chat("*m*a\"\"This is where you##buy and sell your bacteria##minions::Bacteria Control Center!!"+EOL));
  cL.add(new Chat(EOL));
  for(int i = 0; i < bacteriaAlive.length; i++){
    cL.add(new Chat("*b*a\"\""+bacteriaDetails[i]+"::"+bacteriaNames[i]+"!!"+EOL));
    cL.add(new Chat("Alive:*i*a\"\""+onTheField(bacteriaAlive[i],bacteriaNames[i])+"::"+str(bacteriaAlive[i])+"!!*n Requested:*i*a\"\""+bornOrDie(bacteriaGoal[i]-bacteriaAlive[i],bacteriaNames[i])+"::"+str(bacteriaGoal[i]-bacteriaAlive[i])+"!!*n Actions: *i*g*aadd 1 "+str(i)+"\"\"Click here to add one::+1!! *i*o*aadd -1 "+str(i)+"\"\"Click here to remove one##(half cost is returned)::-1!!*n cost:*i "+bCost(i)+EOL));
  }

  for(int i = 0; i < cL.size(); i++){
    Chat tempChat = (Chat)cL.get(i);
    tempChat.time = millis()-100000;
  }
}

String bCost(int i){
  String myReturn = "";
  if(bacteriaCosts[i][0] > 0){
    myReturn = "*o"+"*a\"\"One "+bacteriaNames[i]+" requires "+str(bacteriaCosts[i][0])+" protein::"+str(bacteriaCosts[i][0])+"!! ";
  }
  if(bacteriaCosts[i][1] > 0){
    myReturn = myReturn+"*c"+"*a\"\"One "+bacteriaNames[i]+" requires "+str(bacteriaCosts[i][1])+" lipid::"+str(bacteriaCosts[i][1])+"!! ";
  }
  if(bacteriaCosts[i][2] > 0){
    myReturn = myReturn+"*m"+"*a\"\"One "+bacteriaNames[i]+" requires "+str(bacteriaCosts[i][2])+" nucleotide::"+str(bacteriaCosts[i][2])+"!! ";
  }
  if(bacteriaCosts[i][3] > 0){
    myReturn = myReturn+"*l"+"*a\"\"One "+bacteriaNames[i]+" requires "+str(bacteriaCosts[i][3])+" sugar::"+str(bacteriaCosts[i][3])+"!! ";
  }
  return myReturn;
}

String bornOrDie(int n, String name){
  String plural = "s";
  if(abs(n) == 1){plural = "";}
  if(n < 0){
    return str(-n)+" "+name+plural+" scheduled for death";
  } else if(n > 0){
    return str(n)+" "+name+plural+" scheduled for birth";
  } else {
    return "No "+name+plural+" currently requested";
  }
}

String onTheField(int n, String name){
  String plural = "s";
  if(abs(n) == 1){plural = "";}
  if(n > 0){
    return str(n)+" "+name+plural+" on the field";
  } else {
    return "No "+name+plural+" on the field";
  }
}

/*LOCK*/void safeDraw(){
  if(wU[34][32] == 20){
    if(pointDistance(player.eV,new PVector(34.5,32.5)) < 4){
      PVector tempPos = pos2Screen(new PVector(34.5,32.5));
      drawTextBubble(tempPos.x,tempPos.y,"Enter this block##to open the door!",255);
    }
  }
} //called after everything else has been drawn on the screen (draw things on the game)
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
  
  
  
  
  
  noStroke();
  fill(0);
  
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*3,miniMapScale*wSize,HUDStaminaSize);
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*4.3,miniMapScale*wSize,HUDStaminaSize);
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*5.6,miniMapScale*wSize,HUDStaminaSize);
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*6.9,miniMapScale*wSize,HUDStaminaSize);
  float tFade = min(player.eStamina/100,1);
  //fill(255-255*tFade,255,0);
  
  //rect(width-HUDStaminaSize*16,HUDStaminaSize,HUDStaminaSize*15*tFade,HUDStaminaSize);
  fill(gBColor[6]); rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*3,miniMapScale*wSize*(1-1/(resources[0]/60+1)),HUDStaminaSize);
  fill(gBColor[7]); rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*4.3,miniMapScale*wSize*(1-1/(resources[1]/60+1)),HUDStaminaSize);
  fill(gBColor[8]); rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*5.6,miniMapScale*wSize*(1-1/(resources[2]/60+1)),HUDStaminaSize);
  fill(gBColor[9]); rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*6.9,miniMapScale*wSize*(1-1/(resources[3]/60+1)),HUDStaminaSize);
  stroke(255);
  strokeWeight(2);
  noFill();
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*3,miniMapScale*wSize,HUDStaminaSize);
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*4.3,miniMapScale*wSize,HUDStaminaSize);
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*5.6,miniMapScale*wSize,HUDStaminaSize);
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*6.9,miniMapScale*wSize,HUDStaminaSize);
  
  textMarkup(str(int(resources[0])), HUDStaminaSize*.9, width-HUDStaminaSize*15,HUDStaminaSize*3+HUDStaminaSize/2, 255, 255, false);
  textMarkup(str(int(resources[1])), HUDStaminaSize*.9, width-HUDStaminaSize*15,HUDStaminaSize*4.3+HUDStaminaSize/2, 255, 255, false);
  textMarkup(str(int(resources[2])), HUDStaminaSize*.9, width-HUDStaminaSize*15,HUDStaminaSize*5.6+HUDStaminaSize/2, 255, 255, false);
  textMarkup(str(int(resources[3])), HUDStaminaSize*.9, width-HUDStaminaSize*15,HUDStaminaSize*6.9+HUDStaminaSize/2, 255, 255, false);
  
  
  
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
  drawMenu();
} //called when a chat message is created

void executeCommand(int index,String[] commands){
  switch(index){
    case 0: //function id stated above
      bacteriaGoal[int(commands[2])] = max(0,bacteriaGoal[int(commands[2])]+int(commands[1]));
      drawMenu();
      break;
    case 1: //function death of entity
      bacteriaAlive[int(commands[3])]--;
      drawMenu();
      for(int i = 0; i < resources.length; i++){
        for(int j = 0; j < bacteriaCosts[int(commands[3])][i]/5/2; j++){
          addEntity(new Entity(float(commands[1]),float(commands[2]),EC_ITEM[i],random(TWO_PI)));
        }
      }
      //particleEffect
      break;
    case 2: //function collection of item (HitCommand)
      //addEntity(new Entity(player.x,player.y,EC_BACT[0],random(TWO_PI)));
      resources[int(commands[2])] += 5;
      break;
    case 3: //function breaking of block
      //addEntity(new Entity(player.x,player.y,EC_BACT[0],random(TWO_PI)));
      if(int(commands[3]) > -1){
        for(int i = floor(random(3)); i >= 0; i--){
          addEntity(new Entity(float(commands[1])+.5,float(commands[2])+.5,EC_ITEM[int(commands[3])],random(TWO_PI)));
        }
      } else {
        if(int(commands[3]) == -1){
          for(int i = 0; i < resources.length; i++){
            if(random(100) < 25/4){
              addEntity(new Entity(float(commands[1])+.5,float(commands[2])+.5,EC_ITEM[i],random(TWO_PI)));
            }
          }
        } else {
          for(int k = 0; k < 3; k++){
            for(int i = 0; i < resources.length; i++){
              if(random(100) < 50){
                addEntity(new Entity(float(commands[1])+.5,float(commands[2])+.5,EC_ITEM[i],random(TWO_PI)));
              }
            }
          }
        }
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
