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
//STEM Phagescape API v(see above)

int Astart = -1;

void AIWander(Entity e, int AIradius, int AItestDelay, int AItestChance){ //Total behavior function
  float disToD = pointDistance(e.eV,e.eD);
  if(fn % AItestDelay == 0){
    if(random(100) < AItestChance || disToD > wSize-10){
      int loopingC = 0;
      while(loopingC < 100){
        e.eD = new PVector(e.x+random(AIradius*2)-AIradius,e.y+random(AIradius*2)-AIradius);
        if(rayCast(e.x,e.y,e.eD.x,e.eD.y,false)){
          loopingC = 101;
        }
        loopingC++;
        println(loopingC);
      }
      if(loopingC == 100){
        e.eD = new PVector(e.x,e.y);
      }
    }
  }
  if(disToD > 2){
    e.eMove = true;
  }
}




void nodeWorld(PVector startV, int targetBlock, int vision){
  int q;
  Node n2;
  for ( int ix = 0; ix < wSize; ix+=1 ) {
    for ( int iy = 0; iy < wSize; iy+=1) {
      if ((gBIsSolid[wU[ix][iy]] == false && mDis(ix,iy,startV.x,startV.y)<vision) || (ix == floor(startV.x) && iy == floor(startV.y)) || wU[ix][iy] == targetBlock) {
        nodes.add(new Node(ix,iy));
        nmap[iy][ix] = nodes.size()-1;
        if (ix>0) {
          if (nmap[iy][ix-1]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy][ix-1]),cost);
            ((Node)nodes.get(nmap[iy][ix-1])).addNbor(n2,cost);
          }
        }
        if (iy>0) {
          if (nmap[iy-1][ix]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy-1][ix]),cost);
            ((Node)nodes.get(nmap[iy-1][ix])).addNbor(n2,cost);
          }
        }
      } else {
        nmap[iy][ix] = -1;
      }
    }
  }
}

void nodeWorldPos(PVector startV, PVector targetBlock, int vision){
  int q;
  Node n2;
  
  
  for ( int ix = 0; ix < wSize; ix+=1 ) {
    for ( int iy = 0; iy < wSize; iy+=1) {

      
      if ((gBIsSolid[wU[ix][iy]] == false && mDis(ix,iy,startV.x,startV.y)<vision) || (ix == floor(startV.x) && iy == floor(startV.y)) || (ix == floor(targetBlock.x) && iy == floor(targetBlock.y))) {
        //entities.add(new Entity(ix+.5,iy+.5,0,0));
        
        nodes.add(new Node(ix,iy));
        nmap[iy][ix] = nodes.size()-1;
        if (ix>0) {
          if (nmap[iy][ix-1]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy][ix-1]),cost);
            ((Node)nodes.get(nmap[iy][ix-1])).addNbor(n2,cost);
          }
        }
        if (iy>0) {
          if (nmap[iy-1][ix]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy-1][ix]),cost);
            ((Node)nodes.get(nmap[iy-1][ix])).addNbor(n2,cost);
          }
        }
      } else {
        nmap[iy][ix] = -1;
      }
    }
  }
}
 
boolean astar(int iStart, int targetBlock, PVector endV) {
  
  println("d");
  
  openSet.clear();
  closedSet.clear();
  Apath.clear();
   
  //add initial node to openSet
  openSet.add( ((Node)nodes.get(iStart)) );
  ((Node)openSet.get(0)).p = -1;
  ((Node)openSet.get(0)).g = 0;
  PVector tVec;
  if(targetBlock != -1){
    tVec = blockNear(new PVector(((Node)openSet.get(0)).x,((Node)openSet.get(0)).y), targetBlock, 100);
  } else {
    tVec = new PVector(endV.x,endV.y);
  }
  ((Node)openSet.get(0)).h = mDis( ((Node)openSet.get(0)).x, ((Node)openSet.get(0)).y, tVec.x, tVec.y );
   
  Node current;
  float tentativeGScore;
  boolean tentativeIsBetter;
  float lowest = 999999999;
  int lowId = -1;
  
  println("NOa");
  
  while( openSet.size()>0 ) {
    println("NOb");
    lowest = 999999999;
    for ( int a = 0; a < openSet.size(); a++ ) {
      if ( ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h ) <= lowest ) {
        lowest = ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h );
        lowId = a;
      }
    }
    current = (Node)openSet.get(lowId);
    if(targetBlock != -1){
      if ( aGS(wU,current.x,current.y) == targetBlock) { //path found
        //follow parents backward from goal
        Node d = (Node)openSet.get(lowId);
        while( d.p != -1 ) {
          Apath.add( d );
          println("NOc");
          d = (Node)nodes.get(d.p);
        }
          println("NO1");
        return true;
      }
    } else {
      if ( abs(current.x-endV.x) <= .5 && abs(current.y-endV.y) <= .5 ) { //path found
        //follow parents backward from goal
        Node d = (Node)openSet.get(lowId);
        while( d.p != -1 ) {
          Apath.add(d);
          println("NOd");
          d = (Node)nodes.get(d.p);
        }
          println("NO2");
        return true;
      }
    }
    closedSet.add( (Node)openSet.get(lowId) );
    openSet.remove( lowId );
    for ( int n = 0; n < current.nbors.size(); n++ ) {
      if ( closedSet.contains( (Node)current.nbors.get(n) ) ) {
        continue;
      }
      tentativeGScore = current.g + mDis( current.x, current.y, ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y )*((Float)current.nCost.get(n));
      if ( !openSet.contains( (Node)current.nbors.get(n) ) ) {
        openSet.add( (Node)current.nbors.get(n) );
        tentativeIsBetter = true;
      }
      else if ( tentativeGScore < ((Node)current.nbors.get(n)).g ) {
        tentativeIsBetter = true;
      }
      else {
        tentativeIsBetter = false;
      }
       
      if ( tentativeIsBetter ) {
        ((Node)current.nbors.get(n)).p = nodes.indexOf( (Node)closedSet.get(closedSet.size()-1) ); //!!!!
        ((Node)current.nbors.get(n)).g = tentativeGScore;
        if(targetBlock != -1){
          tVec = blockNear(new PVector(((Node)current.nbors.get(n)).x,((Node)current.nbors.get(n)).y), targetBlock, 100);
        } else {
          tVec = new PVector(endV.x,endV.y);
        }
        
        ((Node)current.nbors.get(n)).h = mDis( ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y, tVec.x, tVec.y );
      }
    }
  }
  //no path found
  println("noz");
  return false;
}

class Node {
  float x,y;
  float g,h;
  int p;
  ArrayList nbors; //array of node objects, not indecies
  ArrayList nCost; //cost multiplier for each corresponding
  Node(float _x,float _y) {
    x = _x;
    y = _y;
    g = 0;
    h = 0;
    p = -1;
    nbors = new ArrayList();
    nCost = new ArrayList();
  }
  void addNbor(Node _node,float cm) {
    nbors.add(_node);
    nCost.add(cm);
  }
}

int[][] nmap;
int start = -1;
 
ArrayList openSet;
ArrayList closedSet;
ArrayList nodes = new ArrayList();
ArrayList Apath = new ArrayList();
 
ArrayList searchWorld(PVector startV, int targetBlock, int vision) {
  //size(480,320); //can be any dimensions as long as divisible by 16
  nmap = new int[wSize][wSize];
  openSet = new ArrayList();
  closedSet = new ArrayList();
  nodes = new ArrayList();
  Apath = new ArrayList();
  
  //generateMap(targetBlock);
  

  nodeWorld(startV, targetBlock, vision);
  
  
  Astart = aGS(nmap,startV.y,startV.x);
  boolean tempB = false;
  if(Astart > -1 && targetBlock > -1){
    tempB = astar(Astart,targetBlock,null);
  }
  
  if(tempB == false){
    //Apath = new ArrayList();
  }
  
  return Apath;
}

ArrayList searchWorldPos(PVector startV, PVector endV, int vision) {
  //size(480,320); //can be any dimensions as long as divisible by 16
  nmap = new int[wSize][wSize];
  openSet = new ArrayList();
  closedSet = new ArrayList();
  nodes = new ArrayList();
  Apath = new ArrayList();
  
  //generateMap(targetBlock);

  nodeWorldPos(startV, endV, vision);
  
  
  Astart = aGS(nmap,startV.y,startV.x);
  boolean tempB = false;
  if(Astart > -1){
    tempB = astar(Astart,-1,endV);
  }
  
  if(tempB == false){
    Apath = new ArrayList();
  }
  
  return Apath;
}

void nodeDraw() {
  Node t1;
  for ( int i = 0; i < nodes.size(); i++ ) {
    t1 = (Node)nodes.get(i);
    if (i==Astart) {
      fill(0,255,0);
    } else {
      if (Apath.contains(t1)) {
        fill(255);
        if(((Node)Apath.get(Apath.size()-1)).x == t1.x && ((Node)Apath.get(Apath.size()-1)).y == t1.y){
          fill(0,0,255);
        }
      }
      else {
        fill(150,150,150);
      }
    }
    noStroke();
    PVector tVec = pos2Screen(new PVector(t1.x,t1.y));
    rect(tVec.x+gScale/4,tVec.y+gScale/4,+gScale/2,+gScale/2);
  }
}

//STEM Phagescape API v(see above)
//STEM Phagescape API v1.0

//DO NOT MAKE ANY CHANGES TO THIS DOCUMENT. IF YOU NEED TO MAKE A CHANGE, CONTACT ME (AJ) - lavabirdaj@gmail.com
int wSize = 100; //blocks in the world (square)
float gSize = 10; //grid units displayed on the screen (blocks in view) (square)
//END OF CONFIGURATION, DO NOT CHANGE BELOW THIS LINE - WITH NO EXCEPTIONS
/*
********** Important Function and Variable Outline **********
//for each item please replace the '_VARIABLE_' including the _ characters with your function values
***** View Changes *****
centerView(_X_,_Y_) //set the center of the screen view to a world coordinate position, such as the player position
scaleView(_SIZE_)
moveToAnimate(new PVector(_X_,_Y_),_T_) //moves to a position over time in milliseconds
***** World Changes *****
setupWorld() //apply changes to world size (wSize) and clear the world
aGS(wU,_X_,_Y_) //access a block at a position in the world - each block is represented by a general block ID
aSS(wU,_X_,_Y_,_BLOCK_ID_) //change a block at a position in the world
addGeneralBlock(_BLOCK_ID_,color(_R_,_G_,_B_),_IS_SOLID?_) //make this block ID represent a block with a certain color that is either solid (true) or not solid (false)
addImageSpecialBlock(_BLOCK_ID_,_IMAGE_,_IMAGE_MODE_) //make this block ID represent a block with an image (PImage) and an integer representing the drawing method (0 = no squish, 1 = squish, 2 = absolute position (like the cartoon Chowder))
addTextSpecialBlock(_BLOCK_ID_,_TEXT_,_TEXT_MODE_) //make this block ID represent a block with text (A string, ex. "hello there!") and an integer representing the drawing method (0 = always display text bubble, 1-10 = display buble at distances, 11-20 = send chat message at distances)

***** General Functions *****
pointDir(_POS1_,_POS2_)
turnWithSpeed(_FROM_,_TO_,_SPEED_)
angleDif(_ANGLE_1_,_ANGLE_2_)
angleDir(_ANGLE_1_,_ANGLE_2_)
posMod(_NUM_,_DEN_)
aSS(_2D_MAT_,_I_,_J_,_VAL_)
aGS(_2D_MAT_,_I_,_J_)
aGS(_1D_MAT_,_I_)
maxAbs(_NUM_1_,_NUM_2_)
minAbs(_NUM_1_,_NUM_2_)
*/
//These variables should not be changed
import ddf.minim.*;
Minim minim;

int playerID = 0;


float wPhase = 0; //the current phase of all waves in the world (where they are in their animation)
ArrayList wL = new ArrayList<Wave>(); //Wave list - list of all waves in the world
PVector wView = new PVector(45,45); //current world position of the center of the viewing window
PVector wViewLast = new PVector(0,0); //previous world position of the center of the viewing window (last time draw was executed)
int[] pKeys = new int[4];
Entity player;
boolean menu = false;

ArrayList mimics = new ArrayList<Mimic>();
color strokeColor = color(255);
color[] gBColor = new color[256];
boolean[] gBIsSolid = new boolean[256];
int[] gBStrength = new int[256];
int[] gBBreakType = new int[256];
String[] gBBreakCommand = new String[256];
boolean[] sBHasAction = new boolean[256];
int[] sBAction = new int[256];
PVector moveToAnimateStart;
PVector moveToAnimateEnd;
PVector moveToAnimateTime = new PVector(0,0);
PVector wViewCenter = new PVector(50,50);
PFont fontNorm;
PFont fontBold;
int[][] distanceMatrix = new int[300][300];
boolean shadows = false; //are there shadows?
int lightStrength = 10;
boolean mouseClicked = false;
boolean drawHUDSoftEdge = false;
int fn = 0;
int frameRateGoal = 45;

boolean clicking = true;
PVector clickPos = new PVector(-1,-1);
boolean isLeft;
boolean isRight;
boolean isI;

void M_Setup(){
  minim = new Minim(this);
  fontNorm = createFont("monofontolight.ttf",18);//"Monospaced.norm-23.vlw"
  fontBold = createFont("monofonto.ttf",18);//"Monospaced.bold-23.vlw"
  HUDImage = loadImage("shadowHUD.png");
  arrowImg = loadImage("arrow.png");
  frameRate(frameRateGoal);
  strokeCap(SQUARE);
  textAlign(LEFT,CENTER);
  textSize(20);
  safePreSetup();
  
  setupHUD();
  setupWorld();
  setupDebug();
  setupEntities();
  scaleView(10);
  centerView(wSize/2,wSize/2);
  safeSetup();
  
  refreshWorld();
  
  wView.x -= .1; wView.y -= .1; refreshWorld(); wView.x += .1; wView.y += .1; // prefrence for positive blocks rendering on minimap
  
  refreshWorld();
  
  setupServer();
}


void draw(){
  if(clicking){
    if(pointDistance(clickPos,new PVector(mouseX,mouseY)) > 5){
      clicking = false;
    } else if(mousePressed == false){
      mouseClicked = true;
      safeMouseClicked();
      clicking = false;
    }
  }
  
    clickQuestion();
  
    animate();
  
    nodeDraw();
  
  manageAsync();
  
  safeUpdate();
  
  drawWorld();
  
    safePostUpdate();
  
  drawEntities();
  
    drawSound();
  
  safeDraw();
  
    drawHUD();
  
    drawChat();
  
    safePostDraw();
  
  mouseClicked = false;
  
  
  //updateDebug();
  
}

void keyPressed(){
  keyPressedChat();
  
  if(key == ESC) {
    key = 0;
  }
  
  if(key == 'i' || key == 'I'){
    isI = true;
  }
  
  if(chatPushing == false){
    player.moveEvent(0);
  }
  
  if(key == 'F' || key == 'f') {
    if(HUDSstage == 0){
      HUDSstage = 1;
      disconnect();
    } else {
      HUDSstage = -HUDSstage;
    }
  }
  
  if(key == '+') {
    if(miniMapZoomSmall < 20){
      miniMapZoomSmall++;
    }
    miniMapZoomLarge = 4;
  }
  if(key == '-') {
    if(miniMapZoomSmall > 0){
      miniMapZoomSmall--;
    }
    miniMapZoomLarge = 0;
  }
  
  safeKeyPressed();
}

void keyReleased(){
  player.moveEvent(1);
  safeKeyReleased();
  if(key == 'i' || key == 'I'){
    isI = false;
  }
  
}

void mousePressed(){
  clicking = true;
  if(mouseButton == RIGHT){
    isRight = true;
  } else if(mouseButton == LEFT){
    isLeft = true;
  }
  clickPos = new PVector(mouseX,mouseY);
  
  safeMousePressed();
}

void mouseReleased(){
  
  if(mouseButton == RIGHT){
    isRight = false;
    println("Right");
  } else if(mouseButton == LEFT){
    isLeft = false;
    println("Left");
  }
  
  safeMouseReleased();
}

float pointDir(PVector v1,PVector v2){
  if((v2.x-v1.x) != 0){
    float tDir = atan((v2.y-v1.y)/(v2.x-v1.x));
    if(v1.x-v2.x > 0){
      tDir -= PI;
    }
    return tDir;
  } else {
    if((v2.y-v1.y) != 0){
      if(v2.y > v1.y){
        return PI/2;
      } else {
        return PI/2*3;
      }
    } else {
      return random(2*PI);
    }
  }
}

float pointDistance(PVector v1,PVector v2){
  return sqrt(sq(v1.x-v2.x)+sq(v1.y-v2.y));
}


float turnWithSpeed(float tA, float tB, float tSpeed){
  if(tSpeed == 0){
    return tA;
  }
  tA = posMod(tA,PI*2);
  tB = posMod(tB,PI*2);
  if(tA<tB-PI){tA+=PI*2;}
  if(tB<tA-PI){tB+=PI*2;}
  if(abs(tB-tA)<tSpeed){return tB;}
  return tA+tSpeed*(tB-tA)/abs(tB-tA);
}

float angleDif(float tA, float tB){
  tA = posMod(tA,PI*2);
  tB = posMod(tB,PI*2);
  if(tA<tB-PI){tA+=PI*2;}
  if(tB<tA-PI){tB+=PI*2;}
  return tB-tA;
}

float angleDir(float tA, float tB){
  tA = posMod(tA,PI*2);
  tB = posMod(tB,PI*2);
  if(tA<tB-PI){tA+=PI*2;}
  if(tB<tA-PI){tB+=PI*2;}
  if(tB == tA){
    return 0;
  }
  return (tB-tA)/abs(tB-tA);
}

int total(int[] list){
  int myReturn = 0;
  for(int i = 0; i < list.length; i++){
    myReturn += list[i];
  }
  return myReturn;
}

float posMod(float tA, float tB){
  float myReturn = tA%tB;
  if(myReturn < 0){
    myReturn+=tB;
  }
  return myReturn;
}

void aSS(int[][] tMat, float tA, float tB, int tValue){ //array set safe
  //println(tValue);
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

void aSS2DB(boolean[][] tMat, float tA, float tB, boolean tValue){ //array set safe
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

int aGS(int[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

ArrayList aGSAL(ArrayList[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

int aGS1D(int[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

void aSS1D(int[] tMat, float tA, int tValue){ //array set safe
  //println(tValue);
  tMat[max(0,min(tMat.length-1,(int)tA))] = tValue;
}

boolean aGS1DB(boolean[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

String aGS1DS(String[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

color aGS1DC(color[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

boolean aGS2DB(boolean[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

int[] aGAS(int[][] tMat, float tA, float tB){ //array get around safe
  return new int[]{aGS(tMat,tA,tB-1),aGS(tMat,tA+1,tB-1),aGS(tMat,tA+1,tB),aGS(tMat,tA+1,tB+1),aGS(tMat,tA,tB+1),aGS(tMat,tA-1,tB+1),aGS(tMat,tA-1,tB),aGS(tMat,tA-1,tB-1)};
}

float maxAbs(float tA, float tB){
  if(abs(tA)>abs(tB)){
    return tA;
  } else {
    return tB;
  }
}

float minAbs(float tA, float tB){
  if(abs(tA)>abs(tB)){
    return tB;
  } else {
    return tA;
  }
}

float runAvg(float curAvg, float newVal, int pastValNum){
  return (curAvg*pastValNum+newVal)/float(pastValNum+1);
}

int mode(int[] array) {
    int[] modeMap = new int [255];
    int maxEl = array[0];
    int maxCount = 1;

    for (int i = 0; i < array.length; i++) {
        int el = array[i];
        if (modeMap[el] == 0) {
            modeMap[el] = 1;
        }
        else {
            modeMap[el]++;
        }

        if (modeMap[el] > maxCount) {
            maxEl = el;
            maxCount = modeMap[el];
        }
    }
    return maxEl;
}

boolean boxHitsBlocks(float x, float y, float w, float h){
  if(gBIsSolid[aGS(wU,x-w/2,y-h/2)]){
    return true;
  }
  if(gBIsSolid[aGS(wU,x+w/2,y-h/2)]){
    return true;
  }
  if(gBIsSolid[aGS(wU,x-w/2,y+h/2)]){
    return true;
  }
  if(gBIsSolid[aGS(wU,x+w/2,y+h/2)]){
    return true;
  }
  return false;
}


PImage resizeImage(PImage tImg, int tw, int th){
  PImage tImgNew = createImage(tw,th,ARGB);
  //tImgNew.loadPixels();
  //tImg.loadPixels();
  for(int i = 0; i < tw; i++){
    for(int j = 0; j < th; j++){
      //tImgNew.pixels[j*tw+i] = tImg.pixels[floor(float(j)/th*tImg.height)*tImg.width+floor(float(i)/tw*tImg.width)];
      tImgNew.set(i,j,tImg.get(5,5));
    }
  }
  //tImgNew.updatePixels();
  //tImg.updatePixels();
  return tImgNew;
}

int lastMillis = 0;
int asyncT = 1000;
void manageAsync(){
  while(millis()-40>asyncT){
    if(millis()-1000 > asyncT){ asyncT = millis(); }
    asyncT += 40;
    fn++;
    safeAsync();
    debugLog(color(0,255,0));
    updateWorld();
    updateEntities();
    updateSound();
    updateHUD();
    if(fn % 13 == 0){
      updateSpawners();
    }
    if(fn % 125 == 0){
      healEntities();
    }
    //updateServer();
  }
}

float mDis(float x1,float y1,float x2,float y2) {
  return abs(y2-y1)+abs(x2-x1);
}

String StringReplaceAll(String str, String from, String to){
  int index = str.indexOf(from);
  while(index != -1){
    str = str.substring(0,index) + to + str.substring(index+from.length(),str.length());
    index = str.indexOf(from);
  }
  return str;
}

PImage toughRect(PImage canvas, int x, int y, int w, int h, int col){
  int xCap = min(max(x+w,0),canvas.width-1);
  int yCap = min(max(y+h,0),canvas.width-1);
  for(int i = min(max(x,0),canvas.width-1); i < xCap; i++){
    for(int j = min(max(y,0),canvas.width-1); j < yCap; j++){
      canvas.pixels[j*canvas.width+i] = col;
    }
  }
  return canvas;
}
//STEM Phagescape API v(see above)

float charWidth = 9;
boolean isHoverText = false;
String hoverText = "";

float chatHeight = 40;
float chatPush = 0;
float chatPushSpeed = .07;
boolean chatPushing = false;
String chatKBS = "";
int totalChatWidth = 0;
int lastChatCount = 0;
ArrayList cL = new ArrayList<Chat>();

ArrayList CFuns = new ArrayList<CFun>();

void drawChat(){
  
  if(lastChatCount!=cL.size()){
    chatEvent("");
  }
  lastChatCount = cL.size();
  
  
  if(chatPushing){
    if(chatPush < 1){
      chatPush+=chatPushSpeed;
    } else {
      chatPush = 1;
    }
  } else {
    if(chatPush > 0){
      chatPush-=chatPushSpeed;
    } else {
      chatPush = 0;
    }
  }
  
  Chat tempChat;
  for(int i = 0; i < cL.size(); i++){
    tempChat = (Chat) cL.get(i);
    tempChat.display(cL.size()-i-1);
  }
  
  if(chatPush > 0){
    textAlign(LEFT,CENTER);
    textSize(18);
    stroke(255,220*chatPush);
    strokeWeight(3);
    fill(0,200*chatPush);
    rect(0-10,floor(height-chatHeight),width/5*4+10,floor(chatHeight+10),0,100,0,0);
    totalChatWidth = textMarkup(chatKBS,18,chatHeight/5,height-chatHeight/2,color(255),220*chatPush,true);
    simpleText(chatKBS,chatHeight/5,height-chatHeight/2);
  }
  
  if(isHoverText){
    if(chatPush > .5){drawTextBubble(mouseX,mouseY,hoverText,127);} else {drawTextBubble(mouseX,mouseY,hoverText,90);}
    isHoverText = false;
  }
}

void simpleText(String a, float x, float y){
  text(a,x,y);
}

int textMarkup(String text, float size, float x, float y, color defCol, float alpha, boolean showMarks){
  size = size/18;
  
  textFont(fontBold);
  
  textSize(size*18);
  fill(defCol,alpha);
  noStroke();
  int pointer = 0;
  color lastColor = defCol;
  boolean tUL = false;
  boolean tST = false;
  boolean rURL = false;
  String tREF = "";
  String tempStr;
  String tempStr2;
  for(int i = 0; i < text.length(); i++){
    //println(text.charAt(i));
    tempStr = text.charAt(i)+"";
    if(tempStr.equals("*")){
      if(showMarks){
        fill(200,0,255,alpha);
        simpleText(text.charAt(i)+"",x+pointer*charWidth*size,y);
        pointer++;
      }
      if(text.length() > i+1){
        if(showMarks){
          simpleText(text.charAt(i+1)+"",x+pointer*charWidth*size,y);
          pointer++;
        }
        tempStr = text.charAt(i+1)+"";
        if(tempStr.equals("r")){fill(255,0,0,alpha); lastColor=color(255,0,0);}  //red
        if(tempStr.equals("o")){fill(255,150,0,alpha); lastColor=color(255,150,0);} //orange
        if(tempStr.equals("y")){fill(255,255,0,alpha); lastColor=color(255,255,0);} //yellow
        if(tempStr.equals("g")){fill(0,255,0,alpha); lastColor=color(0,255,0);} //green
        if(tempStr.equals("c")){fill(0,255,255,alpha); lastColor=color(0,255,255);} //cyan
        if(tempStr.equals("b")){fill(0,0,255,alpha); lastColor=color(0,0,255);} //blue
        if(tempStr.equals("p")){fill(225,0,255,alpha); lastColor=color(225,0,255);} //purple
        if(tempStr.equals("m")){fill(255,0,255,alpha); lastColor=color(255,0,255);} //magenta
        if(tempStr.equals("w")){fill(255,255,255,alpha); lastColor=color(255,255,255);} //white
        if(tempStr.equals("l")){fill(255,255,255,alpha); lastColor=color(200,200,200);} //light grey
        if(tempStr.equals("d")){fill(255,255,255,alpha); lastColor=color(100,100,100);} //dark grey
        if(tempStr.equals("k")){fill(0,0,0,alpha); lastColor=color(0,0,0);} //black (key)
        if(tempStr.equals("i")){/*textFont(fontNorm);*/}
        if(tempStr.equals("n")){fill(defCol,alpha); lastColor=defCol; /*textFont(fontBold);*/ tUL = false; tST = false;}
        if(tempStr.equals("u")){tUL = true;}
        if(tempStr.equals("s")){tST = true;}
        if(tempStr.equals("a")){
          tREF = "";
          tempStr = text.charAt(i+1)+"";
          tempStr2 = text.charAt(i)+"";
          while(text.length() > i+2 && ((!tempStr.equals("!")) || (!tempStr2.equals("!")))){
            if(showMarks){
              simpleText(text.charAt(i+2)+"",x+pointer*charWidth*size,y);
              pointer++;
            }
            tREF = tREF + text.charAt(i+2);
            i++;
            tempStr = text.charAt(i+1)+"";
            tempStr2 = text.charAt(i)+"";
          }
          if(tREF.indexOf("!!") > -1){
            tREF = tREF.substring(0,tREF.length()-2);
            if(tREF.indexOf("::") > -1){
              String[] tREF2 = split(tREF,"::");
              if(tREF2.length == 2){
                for(int j = 0; j < tREF2[1].length(); j++){
                  simpleText(tREF2[1].charAt(j)+"",x+pointer*charWidth*size,y);
                  pointer++;
                }
                if(mouseX > x+(pointer-tREF2[1].length())*charWidth*size && mouseX < x+pointer*charWidth*size){
                  if(mouseY > y-chatHeight/4 && mouseY < y+chatHeight/4){
                    if(tREF2[0].indexOf("\"\"") > -1){
                      String[] tREF3 = split(tREF2[0],"\"\"");
                      if(tREF3.length == 2){
                        isHoverText = true;
                        hoverText = tREF3[1];
                        if(mouseClicked){
                          tryCommand(tREF3[0],"");
                        }
                      }
                    }
                  }
                }
              }
            }
            fill(lastColor,alpha);
          }
        }
        tempStr = text.charAt(i+1)+"";
        if(tempStr.equals("#")){ textMarkup(text.substring(i+2,text.length()), size*18, x, y+size*18, defCol, alpha, showMarks); i = text.length(); }
      }
      i++;
    } else {
      simpleText(text.charAt(i)+"",x+pointer*charWidth*size,y);
      pointer++;
      if(tUL){
        rect(x+pointer*charWidth*size-charWidth*size,y+10,charWidth*size,1);
      }
      if(tST){
        rect(x+pointer*charWidth*size-charWidth*size,y,charWidth*size,1);
      }
    }
    
  }
  return pointer;
}

float simpleTextWidth(String str, float size){
  if(str.indexOf("*#") == -1){
    return str.length()*charWidth*size/18;
  } else {
    int pos = str.indexOf("*#");
    return max(pos*charWidth*size/18,simpleTextWidth(str.substring(pos+2,str.length()),size));
  }
}

float simpleTextHeight(String str, float size){
  int lines = 1;
  int nextIndex = str.indexOf("*#");
  while(nextIndex != -1){
    lines++;
    nextIndex = str.indexOf("*#",nextIndex+1);
  }
  return lines*size;
}

String simpleTextCrush(String str, float size, float w){
  String[] lines = new String[100];
  int nextLine = 1;
  int pointer = 0;
  String tempStr;
  lines[0] = StringReplaceAll(str,"*#"," ");
  
  while(nextLine < 99 && simpleTextWidth(lines[nextLine-1],size) > w){
    pointer = floor(w/(charWidth*size/18));
    tempStr = lines[nextLine-1].charAt(pointer) + "";
    while(pointer > 0 && !tempStr.equals(" ")){
      pointer--;
      tempStr = lines[nextLine-1].charAt(pointer) + "";
    }
    if(pointer > 0){
      lines[nextLine] = lines[nextLine-1].substring(pointer+1,lines[nextLine-1].length());
    } else {
      pointer = ceil(w/(charWidth*size/18));
      lines[nextLine] = lines[nextLine-1].substring(pointer,lines[nextLine-1].length());
    }
    lines[nextLine-1] = lines[nextLine-1].substring(0,pointer);
    if(nextLine > 1){
      str = str + "*#" + lines[nextLine-1];
    } else {
      str = lines[0];
    }
    nextLine++;
  }
  if(nextLine > 1){
    str = str + "*#" + lines[nextLine-1];
  }
  return str;
}

class Chat{
  String content;
  int time;
  int totalChatWidthL;
  
  Chat(String tContent) {
    content = tContent;
    time = millis();
    totalChatWidthL = width*2;
  }
  
  void display(int i){
    if(i < height/chatHeight+2){
      if(time+5000>millis() || chatPush > 0){
        float fadeOut = float(millis()-(time+4000))/1000;
        fadeOut = min(max(fadeOut,0),1);
        if(chatPush > 0){
          fadeOut -= chatPush;
        }
        fadeOut = min(max(fadeOut,0),1);
        
        noStroke();
      
        fill(0,100+100*chatPush-255*fadeOut);
        rect(0-10,height-chatHeight-chatHeight*i-chatHeight*chatPush,charWidth*totalChatWidthL+chatHeight,chatHeight,0,100,100,0);
        totalChatWidthL = textMarkup(content,18,chatHeight/5,height-chatHeight/2-chatHeight*i-chatHeight*chatPush,color(255),100+100*chatPush-255*fadeOut,false);
      }
    }
  }
}

void drawTextBubble(float tx, float ty, String tText, float opacity){
  if(tText != ""){
    String[] textFragments = split(tText,"##");
    float tw = 0;
    for(int i = 0; i < textFragments.length; i++){
      tw = max(textFragments[i].length()*charWidth+chatHeight,tw);
    }
    
    float td = chatHeight+(textFragments.length-1)*chatHeight*2/3;
    
    float tx2 = abs(width-tx-tw+.5)/(width-tx-tw+.5)*tw/2+tx;
    if(tx2-tw/2 < 0){tx2 = tw/2; if(tw>width){tx2 = width/2;}}
    float ty2 = -abs(ty-(td+chatHeight/2)+.5)/(ty-(td+chatHeight/2)+.5)*(td-chatHeight*2/3*(textFragments.length-1)/2)+ty;
    
    noStroke();
    
    int fliph=1;
    int flipv=1;
    if(tx2<tx){fliph=-1;}
    if(ty2>ty){flipv=-1;}
    
    fill(255,opacity/2);
    triangle(tx,ty,tx-3*fliph,ty-(chatHeight/2-3)*flipv,tx+(chatHeight/3+3)*fliph,ty-(chatHeight/2-3)*flipv);
    rect(tx2-tw/2-3-chatHeight/10,ty2-chatHeight/2-3-chatHeight*2/3*(textFragments.length-1)/2,tw+6+chatHeight/5,td+6,chatHeight/10);
    
    fill(255,opacity);
    triangle(tx,ty,tx,ty-chatHeight/2*flipv,tx+chatHeight/3*fliph,ty-chatHeight/2*flipv);
    rect(tx2-tw/2-chatHeight/10,ty2-chatHeight/2-chatHeight*2/3*(textFragments.length-1)/2,tw+chatHeight/5,td,chatHeight/10);
    
    for(int i = 0; i < textFragments.length; i++){
      textMarkup(textFragments[i],18,tx2-tw/2+chatHeight/2,ty2-chatHeight*2/3*(textFragments.length-1)/2+chatHeight*2/3*i,color(0),opacity*2,false);
    }
  }
}

void keyPressedChat(){
  println(key);
  println(keyCode);
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
          if(chatKBS.charAt(0) == '/'){
            tryCommand(chatKBS.substring(1,chatKBS.length()),"player");
          } else {
            cL.add(new Chat(chatKBS));
          }
          chatKBS = "";
          chatPushing = false;
          chatPush = 0;
        }
      } else {
        if(charWidth*totalChatWidth < width/5*4-chatHeight/5*2){
          chatKBS = chatKBS+str(key);
        }
      }
    }
  } else {
    if(key == 't' || key == 'T' || key == 'c' || key == 'C' || key == ENTER){
      chatPushing = true;
    }
  }
}

void tryCommand(String command, String source) {
  String[] commands = split(command," ");
  int args = commands.length-1;
  commands[0] = commands[0].toLowerCase();
  
  Boolean didNone = true;
  for(int i = 0; i < CFuns.size(); i++){
    CFun tempFun = (CFun)CFuns.get(i);
    
    if(tempFun.name.toLowerCase().equals(commands[0])){
      didNone = false;
      if(source.equals("") || tempFun.free){
        if(tempFun.args == args){
          executeCommand(tempFun.ID,commands);
        } else {
          cL.add(new Chat("*o/*i*o"+commands[0]+"*n*o requires *s*o"+str(tempFun.args)+"*c*o arguments, you provided *s*o"+str(args)));
        }
      } else {
        cL.add(new Chat("*oYou need permission to use /*i*o"+commands[0]+"*n"));
      }
    }
    

  }
  
  if(commands[0].length()!=0){
    if(didNone){
      cL.add(new Chat("*o/*i*o"+commands[0]+"*n*o was not recognized as a command"));
    }
  }
}



class CFun{
  int ID;
  String name;
  int args;
  boolean free;
  CFun(int tID, String tName, int tArgs, boolean tFree){
    ID = tID;
    name = tName;
    args = tArgs;
    free = tFree;
  }
}




//STEM Phagescape API v(see above)
//String[] effects = {""}
PImage debugGraph;
ArrayList debugWave = new ArrayList<PVector>();
ArrayList debugEvents = new ArrayList<PVector>();

void setupDebug(){
  debugGraph = new PImage(width/2,height/3);
  debugWave.add(new PVector(width/2-1,0));
}

void debugLog(int argColor){
  debugEvents.add(new PVector(argColor,0));
}

void updateDebug(){
  
  int bar = int(height/3-(1000/frameRateGoal));
  
  PVector tempPointer = (PVector)debugWave.get(debugWave.size()-1);
  debugWave.add(new PVector((tempPointer.x+1)%(width/2),min(millis()-lastMillis,height/3-1-15*debugEvents.size())));
  if(debugWave.size() > 10){
    debugWave.remove(0);
  }
  tempPointer = (PVector)debugWave.get(debugWave.size()-1);
  
  debugGraph.loadPixels();
  for(int i = 0; i < height/3; i++){
    if(i == bar){
      debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(0,255,0);
    } else {
      debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(0);
    }
  }
  for(int j = debugEvents.size()-1; j >= 0; j--){
    PVector eventColor = (PVector) debugEvents.get(j);
    for(int i = 1; i < 16; i++){
      debugGraph.pixels[int(min(tempPointer.x,width/2-1))+(min(i+15*j,height/3-1))*(width/2)] = int(eventColor.x);
    }
  }
  debugEvents.clear();
  for(int i = floor((height/3)-tempPointer.y); i < height/3; i++){
    if(i == bar){
      debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(0,255,0);
    } else {
      debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(255,0,0);
    }
  }
  for(int j = debugWave.size()-2; j >= 0; j--){
    tempPointer = (PVector)debugWave.get(j);
    for(int i = floor((height/3)-tempPointer.y); i < height/3; i++){
      if(i == bar){
        debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(0,255,0);
      } else {
        debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(150+j*10,0,0);
      }
      
    }
  }
  debugGraph.updatePixels();
  image(debugGraph,width/2,height/3*2);
  
  lastMillis = millis();
}
//STEM Phagescape API v(see above)

EConfig[] EConfigs = new EConfig[356];

boolean[][] smap;
int entityIDCycle = 0;
int maxMimicID = -1;
ArrayList entities = new ArrayList<Entity>(); //Entity list - list of all entities in the world
Mimic[][] mimicIDs = new Mimic[100][0];

int EC_PLAYER = 0;
int EC_BULLET = 1;
int EC_NEXT(){return ecCycleNext++;}
int ecCycleNext = 2;

PImage arrowImg;

int particleCycle = 0;

//EConfig bulletEntity = new EConfig();



void setupEntities(){
  
  EConfigs[EC_BULLET] = new EConfig();
  EConfigs[EC_BULLET].Size = .13; //TO BE REMOVED
  EConfigs[EC_BULLET].Team = -3;
  EConfigs[EC_PLAYER] = new EConfig();
  EConfigs[EC_PLAYER].Genre = 1;
  EConfigs[EC_PLAYER].Team = -3;
  EConfigs[EC_PLAYER].SuckRange = 1;
  EConfigs[EC_PLAYER].Img = loadImage("player.png");
  player = new Entity(wSize/2,wSize/2,EC_PLAYER,0);
  addEntity(player);
}

void reloadMimicIDs(){
  mimicIDs = new Mimic[100][maxMimicID+1];
  for (int i = mimics.size()-1; i >= 0; i--) {
    Mimic tempM = (Mimic) mimics.get(i);
    mimicIDs[tempM.playerID-1][tempM.ID] = tempM;
  }
}

void updateEntities(){
  /*for (int i = 0; i < mimics.size(); i++) {
    Mimic tempM = (Mimic) mimics.get(i);
    tempM.update();
  }*/
  
  for (int i = entities.size()-1; i >= 0; i--) {
    Entity tempE = (Entity) entities.get(i);
    tempE.moveAI();
  }
}

void healEntities(){
  for (int i = entities.size()-1; i >= 0; i--) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.eHealth < EConfigs[tempE.EC].HMax){
      tempE.eHealth++;
    } else {
      tempE.eHealth = EConfigs[tempE.EC].HMax;
    }
  }
}

void drawEntities(){
  for (int i = 0; i < mimics.size(); i++) {
    Mimic tempM = (Mimic) mimics.get(i);
    tempM.display();
  }
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    tempE.display();
  }
}

class Entity {
  int ID;
  
  int trail = 20;
  ArrayList path = new ArrayList<PVector>();
  ArrayList pathing = new ArrayList<Node>();
  ArrayList blockSet = new ArrayList<PVector>();
  
  int thisI;
  int EC;
  float x;
  float y;
  PVector eV;
  float eDir = 0;
  PVector eD;
  PVector eFireD;
  int eHealth = 1;
  float eStamina = 0;
  int eFireCooldown = 0;
  float eSpeed = 0; //Player speed
  float eTSpeed = 0; //Player turn speed
  boolean eMove = false;
  int birthTime = 0;
  
  PVector eVLast;
  
  float eFade = 0; //Particle fade
  
  int eID;
  float sourceID = -1;
  
  
  PVector AITargetPos = new PVector(-1,-1);
  int AIDir = 1;
  boolean AIFollowSide = false;
  int[][] AIMap = new int[100][100];
  
  int timeOff = floor(random(100));
  
  Entity(float tx, float ty, int tEC, float tDir) {
    birthTime = millis();
    ID = entityIDCycle;
    entityIDCycle++;
    //println("ID "+str(ID));
    x = tx;
    y = ty;
    eDir = tDir;
    eD = new PVector(tx+cos(tDir)*wSize,ty+sin(tDir)*wSize);
    eFireD = new PVector(eD.x,eD.y);
    EC = tEC;
    eVLast = new PVector(x,y);
    eV = new PVector(x,y);
    eID = floor(random(2147483.647))*1000;
    eHealth = EConfigs[EC].HMax;
    path.add(new PVector(eV.x, eV.y));
    
    
    tryCommand(StringReplaceAll(StringReplaceAll(EConfigs[EC].BirthCommand,"_x_",str(x)),"_y_",str(y)),"");
    
    if(EConfigs[EC].Genre == 1 || EConfigs[EC].Genre == 3){
      addEntityToGridArea(eV.x-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eV.y-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eV.x+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eV.y+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,this);
    }
    if(EConfigs[EC].Genre == 3){
      eSpeed = max(0,random(EConfigs[EC].SMax-.1)+.1);
    }
  }
  
  void moveEvent(int eventID){
    
    if(eventID == 0 || eventID == 1){
      int tempTo = 1;
      if(eventID == 1){
        tempTo = 0;
      }
      if(key == CODED){
        if(keyCode == UP){
            pKeys[0] = tempTo;
        } else if(keyCode == DOWN){
            pKeys[1] = tempTo;
        } else if(keyCode == LEFT){
            pKeys[2] = tempTo;
        } else if(keyCode == RIGHT){
            pKeys[3] = tempTo;
        }
      } else {
        switch(key){
          case 'W':
          case 'w':
            pKeys[0] = tempTo;
            break;
          case 'S':
          case 's':
            pKeys[1] = tempTo;
            break;
          case 'A':
          case 'a':
            pKeys[2] = tempTo;
            break;
          case 'D':
          case 'd':
            pKeys[3] = tempTo;
            break;
        }
      }
    }
  }
  
  void moveAI(){
    //println(eSpeed);
    //println(str(testingV.x)+":"+str(testingV.y));
    eV.x = x; eV.y = y; // = new PVector(x,y);
    if(EConfigs[EC].Genre == 0){  //BULLET GENRE *****************************************************************************
      if(x>wSize+5 || x<-5 || y>wSize+5 || y<-5 || aGS1DB(gBIsSolid,aGS(wU,x,y))){
        if(aGS1DB(gBIsSolid,aGS(wU,x,y))){
          EConfig tempConfig;
          particleEffect(x-.5,y-.5,1,1,5,aGS1DC(gBColor,aGS(wU,x,y)),EConfigs[EC].Color,EConfigs[EC].SMax/5);
          hitBlock(x,y,1,false);
        }
        
        destroy();
        
      } else {
        x += EConfigs[EC].SMax*cos(eDir);
        y += EConfigs[EC].SMax*sin(eDir);
        eV.x = x; eV.y = y; // = new PVector(x,y);
      }
    } else if(EConfigs[EC].Genre == 1){ //MOB AND PLAYER GENRE *****************************************************************************
      eMove = false;
      if(EConfigs[EC].Type == 0 || EConfigs[EC].Type == 1){ //PLAYER TYPE OR MOB TYPE *****************************************************************************
        if(fn % 15 == 0){
          if(EConfigs[EC].AIDoorBlock > -1 || EConfigs[EC].AIDoorBlockClose > -1){
            PVector doorCenter = new PVector(0,0);
            int pastFrames = 0;
            boolean isClosed = false;
            boolean isOpen = false;
            for(int i = -EConfigs[EC].AIDoorWidth; i <= EConfigs[EC].AIDoorWidth; i++){
              for(int j = -EConfigs[EC].AIDoorWidth; j <= EConfigs[EC].AIDoorWidth; j++){
                if(aGS(wU,x+i,y+j)==EConfigs[EC].AIDoorBlock || aGS(wU,x+i,y+j)==EConfigs[EC].AIDoorBlockClose){
                  if(pastFrames == 0){
                    doorCenter = new PVector(x+i,y+j);
                  } else if(pastFrames == 1){
                    doorCenter = new PVector((x+i+doorCenter.x)/2,(y+j+doorCenter.y)/2);
                  }
                  if(aGS(wU,x+i,y+j)==EConfigs[EC].AIDoorBlock){
                    isClosed = true;
                  } else {
                    isOpen = true;
                  }
                  pastFrames++;
                }
              }
            }
            
            if(isOpen != isClosed){
              if(pastFrames > 0 && pastFrames < 3){
                boolean changeDoorState = false;
                if(pointDistance(doorCenter,new PVector(eV.x+cos(eDir)/20,eV.y+sin(eDir)/20)) < pointDistance(doorCenter,eV)){
                  if(isOpen == false){
                    changeDoorState = true;
                  }
                }
              
                if(pointDistance(doorCenter,new PVector(eV.x+cos(eDir)/20,eV.y+sin(eDir)/20)) > pointDistance(doorCenter,eV)){
                  if(isOpen){
                    changeDoorState = true;
                  }
                }
                
                if(changeDoorState){
                  for(int i = -EConfigs[EC].AIDoorWidth; i <= EConfigs[EC].AIDoorWidth; i++){
                    for(int j = -EConfigs[EC].AIDoorWidth; j <= EConfigs[EC].AIDoorWidth; j++){
                      if(aGS(wU,x+i,y+j)==EConfigs[EC].AIDoorBlock){
                        aSS(wU,x+i,y+j,gBBreakType[EConfigs[EC].AIDoorBlock]);
                      } else if(aGS(wU,x+i,y+j)==EConfigs[EC].AIDoorBlockClose){
                        aSS(wU,x+i,y+j,gBBreakType[EConfigs[EC].AIDoorBlockClose]);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      if(EConfigs[EC].Type == 0){ //PLAYER TYPE *****************************************************************************
        if((isLeft) || max(pKeys) == 1){
          if(!(isLeft)){
            eD = new PVector(eV.x+(-pKeys[2]+pKeys[3]),eV.y+(-pKeys[0]+pKeys[1]));
          } else {
            eD = screen2Pos(new PVector(mouseX,mouseY));
            float tempDir = pointDir(eV,eD);
            eD = new PVector(eV.x+cos(tempDir)*wSize,eV.y+sin(tempDir)*wSize);
          }
          eMove = true;
        }
        
        
        if(isRight && eFireCooldown == 0){
          player.fire(screen2Pos(new PVector(mouseX,mouseY)));
        }
        
        if(isI && eFireCooldown == 0){
          boolean foundEFireD = false;;
          float tEDir = round(eDir/(HALF_PI))*HALF_PI;
          PVector tempPV = new PVector(0,0);
          tempPV = findBreakableNear(x+cos(tEDir),y+sin(tEDir),10);
          tempPV.x += .5; tempPV.y += .5;
          
          
          
          if(rayCast(x,y,tempPV.x,tempPV.y,true)){
            eFireD = new PVector(tempPV.x,tempPV.y);
            foundEFireD = true;
            println("YES!");
          } else if(abs(x-tempPV.x) > abs(y-tempPV.y)){
            if(rayCast(x,y,tempPV.x+.501*(abs(x-tempPV.x)/(x-tempPV.x)),tempPV.y,false)){
              eFireD = new PVector(tempPV.x+.501*(abs(x-tempPV.x)/(x-tempPV.x)),tempPV.y);
              foundEFireD = true;
            } else if(rayCast(x,y,tempPV.x,tempPV.y+.501*(abs(y-tempPV.y)/(y-tempPV.y)),false)){
              eFireD = new PVector(tempPV.x,tempPV.y+.501*(abs(y-tempPV.y)/(y-tempPV.y)));
              foundEFireD = true;
            }
          } else {
            if(rayCast(x,y,tempPV.x,tempPV.y+.501*(abs(y-tempPV.y)/(y-tempPV.y)),false)){
              eFireD = new PVector(tempPV.x,tempPV.y+.501*(abs(y-tempPV.y)/(y-tempPV.y)));
              foundEFireD = true;
            } else if(rayCast(x,y,tempPV.x+.501*(abs(x-tempPV.x)/(x-tempPV.x)),tempPV.y,false)){
              eFireD = new PVector(tempPV.x+.501*(abs(x-tempPV.x)/(x-tempPV.x)),tempPV.y);
              foundEFireD = true;
            }
          }
          
          //find players
          //if none found, find entities
          
          Entity tempE = null;
          
          resetSearches(x+cos(tEDir),y+sin(tEDir),10);
          boolean searchLoop = true;ArrayList eLResults;while(searchLoop){eLResults = findEntityGrid();if(eLResults != null){for(int j = eLResults.size()-1; j >= 0; j--){ //compact search loop structure
                println("FOUND!");
                if(EConfigs[((Entity)eLResults.get(j)).EC].Team == -2){ //if team == -2
                  tempE = (Entity)eLResults.get(j);
                  
                  float mobFutureMotion = (pointDistance(eV,tempE.eV)/EConfigs[EConfigs[EC].myBulletEntity].SMax)*tempE.eSpeed/2;
                  PVector mobFuturePos;
                  if(gBIsSolid[aGS(wU,tempE.x+cos(tempE.eDir),tempE.y+sin(tempE.eDir))] == false){
                    mobFuturePos = new PVector(tempE.x+cos(tempE.eDir)*mobFutureMotion,tempE.y+sin(tempE.eDir)*mobFutureMotion);
                  } else {
                    mobFuturePos = new PVector(tempE.x,tempE.y);
                  }
                  //project motion
                  if(rayCast(x,y,mobFuturePos.x,mobFuturePos.y,false)){
                    eFireD = mobFuturePos;
                    foundEFireD = true;
                    searchLoop = false;
                  }
                  
                }
          }}else{searchLoop = false;}}
          
          
          
          
          if(foundEFireD){
            fire(eFireD);
          }
        }
        
      }
      
      
      if(EConfigs[EC].Type == 1){
        safePluginAI(this);
      }
      
      /*
      if(EConfigs[EC].Type == 1){ //MOB TYPE *****************************************************************************
        if(EConfigs[EC].AISearchMode > -1){
          

          
          
          if(EConfigs[EC].AISearchMode < 10){
            if(fn % EConfigs[EC].FireDelay == timeOff % EConfigs[EC].FireDelay){
              if(pointDistance(eV,AITargetPos)<EConfigs[EC].ActDist){
                if(rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y),true)){
                  fire(AITargetPos);
                }
              }
            }
            if(EConfigs[EC].AITarget > -1){
              if(fn % 125 == 0){
              
                if(aGS(wU,AITargetPos.x,AITargetPos.y) != EConfigs[EC].AITarget){
                  setAITarget();
                }
              }
            } else {
              if(fn % 10 == 0){ 
                if(pointDistance(entityNearID(AITargetPos,EConfigs[EC].AITargetID,30,100),AITargetPos)>.2){
                  //println("HEY, YOU MOVED!");
                  setAITarget();
                }
              }
            }
            if(pointDistance(eV,AITargetPos)>EConfigs[EC].GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y),true) == false){
              if(EConfigs[EC].AISearchMode == 1 || EConfigs[EC].AISearchMode == 2){
                if(fn % EConfigs[EC].FireDelay == timeOff % EConfigs[EC].FireDelay){
                  if(pointDistance(eVLast,eV)<EConfigs[EC].Drag){
                    setAITarget();
                  }
                }
                
              }
              eMove = true;
              
              if(EConfigs[EC].AISearchMode == 3){
                if(fn % 125 == 0){
                  setAITarget();
                }
                if(floor(eVLast.x) != floor(eV.x) || floor(eVLast.y) != floor(eV.y)){
                  setAITarget();
                }
                if(Apath.size()>0){
                  eD = new PVector(((Node)Apath.get(Apath.size()-1)).x+.5,((Node)Apath.get(Apath.size()-1)).y+.5);
                } else {
                  if(fn % 25 == 0){
                    if(pointDistance(eVLast,eV)<EConfigs[EC].Drag){
                      AITargetPos = blockNear(eV,EConfigs[EC].AITarget,random(90)+10);
                    }
                  }
                }
              }
            }
          } else if(EConfigs[EC].AISearchMode < 30) {
            if(fn % EConfigs[EC].FireDelay == timeOff % EConfigs[EC].FireDelay){
              PVector tempTarget = entityNearID(eV,EConfigs[EC].AITargetID,EConfigs[EC].ActDist,100);
              if(tempTarget.z != -1){
                fire(AITargetPos);
              }
            }
            if(EConfigs[EC].AISearchMode == 11){
              if(pointDistance(eV,AITargetPos)>EConfigs[EC].GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y),true)==false){
                eMove = true;
              }
              if(fn % 25 == 0){
                setAITarget();
              }
            } else if(EConfigs[EC].AISearchMode == 12){
              eMove = true;
              if(fn % 250 == 0){
                AITargetPos = new PVector(eV.x,eV.y);
              }
              if(pointDistance(eV,AITargetPos) < .5){
                setAITarget();
              }
            }
            
            if(EConfigs[EC].AISearchMode == 21){
              if(pointDistance(eV,AITargetPos)>EConfigs[EC].GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y),true)==false){
                eMove = true;
              }
              if(fn % 35 == 0){
                setAITarget();
              }
            } else if(EConfigs[EC].AISearchMode == 22){
              eMove = true;
              if(fn % 300 == 0){
                for(int i = 0; i < wSize; i++){
                  for(int j = 0; j < wSize; j++){
                    if(aGS(AIMap,i,j) > 1){aSS(AIMap,i,j,aGS(AIMap,i,j)-1);}
                    if(aGS(AIMap,i,j) < -1){aSS(AIMap,i,j,aGS(AIMap,i,j)+1);}
                  }
                }
              }
              if(fn % 10 == 0){
                for(int i = -6; i < 7; i++){
                  for(int j = -6; j < 7; j++){
                    aSS(AIMap,x+i,y+j,min(aGS(AIMap,x+i,y+j)+1,6));
                  }
                }
                
                for (int k = 0; k < entities.size(); k++) {
                  Entity tempE = (Entity) entities.get(k);
                  if(EConfigs[tempE.EC].ID == EConfigs[EC].AITargetID){
                    for(int i = -6; i < 7; i++){
                      for(int j = -6; j < 7; j++){
                        aSS(AIMap,tempE.x+i,tempE.y+j,max(aGS(AIMap,tempE.x+i,tempE.y+j)-1,-6));
                      }
                    }
                  }
                }
                
              }
              if(fn % 25 == 0){
                AITargetPos = new PVector(eV.x,eV.y);
              }
              if(pointDistance(eV,AITargetPos) < 1.5){
                setAITarget();
              }
            }
          } else {
            if(EConfigs[EC].AISearchMode == 30){
              eDir = pointDir(eV,AITargetPos);
              if(pointDistance(eV,AITargetPos) < EConfigs[EC].SMax){
                eV.x = AITargetPos.x; eV.y = AITargetPos.y; //eV = new PVector(AITargetPos.x,AITargetPos.y);
              } else {
                eV.x = eV.x+cos(eDir)*EConfigs[EC].SMax; eV.y = eV.y+sin(eDir)*EConfigs[EC].SMax; //eV = new PVector(eV.x+cos(eDir)*EConfigs[EC].SMax,eV.y+sin(eDir)*EConfigs[EC].SMax);
              }
            }
          }
        }
      }
      */
      //PVector tVecss = pos2Screen(new PVector(eD.x,eD.y));
      //ellipse(tVecss.x,tVecss.y,30,30);
                                           //PLAYER AND MOB TYPE *****************************************************************************
      
      if(EConfigs[EC].SuckRange > -1){
        resetSearches(x,y,EConfigs[EC].SuckRange+1);
        float tempDis,tempSpeed, tempDir;
        Entity te;
        boolean searchLoop = true;ArrayList eLResults;while(searchLoop){eLResults = findEntityGrid();if(eLResults != null){for(int j = eLResults.size()-1; j >= 0; j--){ //compact search loop structure
              if(EConfigs[((Entity)eLResults.get(j)).EC].Genre == 3  && (millis()-((Entity)eLResults.get(j)).birthTime)>500){ //if team == -2
                te = (Entity)eLResults.get(j);
                tempDis = pointDistance(eV,te.eV);
                if(tempDis < EConfigs[EC].SuckRange){
                  if(tempDis < EConfigs[EC].Size*EConfigs[EC].HitboxScale/2*.75){
                    tryCommand(StringReplaceAll(StringReplaceAll(StringReplaceAll(EConfigs[te.EC].HitCommand,"_x_",str(te.x)),"_y_",str(te.y)),"_collector_",str(ID)),"");
                    te.destroy();
                  } else {
                    tempDir = pointDir(te.eV,eV);
                    tempSpeed = min((1-tempDis/EConfigs[EC].SuckRange)*EConfigs[te.EC].Accel,EConfigs[te.EC].SMax);
                    moveInWorld(te.eV, new PVector(tempSpeed*cos(tempDir),tempSpeed*sin(tempDir)),0,0);
                    te.x = te.eV.x; te.y = te.eV.y;
                  }
                }
              }
        }}else{searchLoop = false;}}
      }
      
      ArrayList tempALs = getEntitiesFromGridAreaOther(x-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,y-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,x+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,y+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,ID);
      if(tempALs.size() > 0){
        Entity te;
        Float tdis, tgoaldis, rmovefade, tdir;
        for(int i = tempALs.size()-1; i >= 0; i--){
          te = (Entity)tempALs.get(i);
          if(EConfigs[te.EC].Genre == 1 && EConfigs[te.EC].HitboxScale > 0){
            tdis = pointDistance(eV,te.eV);
            tgoaldis = EConfigs[EC].Size*EConfigs[EC].HitboxScale/2*.75+EConfigs[te.EC].Size*EConfigs[te.EC].HitboxScale/2*.75;
            if(tdis < tgoaldis){
              rmovefade = (tgoaldis-tdis)/15;
              tdir = pointDir(eV,te.eV);
              moveInWorld(eV, new PVector(min(rmovefade,EConfigs[EC].SMax)*cos(tdir+PI),min(rmovefade,EConfigs[EC].SMax)*sin(tdir+PI)),EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,EConfigs[EC].Size*EConfigs[EC].HitboxScale/2);
              moveInWorld(te.eV, new PVector(min(rmovefade,EConfigs[te.EC].SMax)*cos(tdir),min(rmovefade,EConfigs[te.EC].SMax)*sin(tdir)),EConfigs[te.EC].Size*EConfigs[te.EC].HitboxScale/2,EConfigs[te.EC].Size*EConfigs[te.EC].HitboxScale/2);
              te.x = te.eV.x; te.y = te.eV.y;
            }
          }
        }
      }
      
      eStamina++;
      
      if(eMove){
        //if(eSpeed+EConfigs[EC].Accel < EConfigs[EC].SMax){
          if(tryStaminaAction(1)){
            eSpeed += EConfigs[EC].Accel;
          }
        //} else {
        //  eSpeed = EConfigs[EC].SMax;
        //}
      }
      
      if(eSpeed-EConfigs[EC].Drag > 0){
        eSpeed -= EConfigs[EC].Drag;
      } else {
        eSpeed = 0;
      }
      
      eSpeed = min(EConfigs[EC].SMax, eSpeed);
      
      float aDif = angleDif(eDir,pointDir(eV, eD));
      //if(abs(aDif) > abs(eTSpeed)+EConfigs[EC].TAccel-EConfigs[EC].TDrag){ //prevent wiggle of the player when going streight
      int dirS = round(aDif/abs(aDif));
      float innspeed = eTSpeed+EConfigs[EC].TAccel*dirS-EConfigs[EC].TDrag*dirS;
      int num = floor(innspeed/EConfigs[EC].TDrag*dirS);
      float rotDis = (num+1)*(innspeed-num/2*EConfigs[EC].TDrag*dirS);
      if(abs(rotDis) / abs(aDif) < 1 ){
        eTSpeed += dirS*EConfigs[EC].TAccel;
      } 
      //}
      
      if(abs(eTSpeed)-EConfigs[EC].TDrag > 0){
        eTSpeed = (abs(eTSpeed)-EConfigs[EC].TDrag)*(abs(eTSpeed)/eTSpeed);
      } else {
        eTSpeed = 0;
      }
      
      eTSpeed = min(EConfigs[EC].TSMax, max(-EConfigs[EC].TSMax, eTSpeed));
      
      eDir += eTSpeed*eSpeed/EConfigs[EC].SMax; //pTSpeed*pSpeed/pSMax
      moveInWorld(eV, new PVector(eSpeed*cos(eDir),eSpeed*sin(eDir)),EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,EConfigs[EC].Size*EConfigs[EC].HitboxScale/2);

      
      
      if(floor(eV.x) != floor(eVLast.x) || floor(eV.y) != floor(eVLast.y)){
        path.add(new PVector(eV.x, eV.y));
        if(path.size() > trail){
          path.remove(0);
        }
      } else {
        PVector tempPV = (PVector)path.get(path.size()-1);
        tempPV.x = eV.x;
        tempPV.y = eV.y;
      }
      
      if(isEntityNearGenreSpecial(eV, 0, EConfigs[EC].Size*EConfigs[EC].HitboxScale/3)) {
        Entity te = entityNearGenreSpecial(eV, 0, EConfigs[EC].Size*EConfigs[EC].HitboxScale/3);
        //tryCommand(StringReplaceAll(StringReplaceAll(te.EC.DeathCommand,"_x_",str(te.x)),"_y_",str(te.y)),"");
        if(EConfigs[te.EC].Team != EConfigs[EC].Team){
          te.destroy();
          eHealth--;
          
          tryCommand(StringReplaceAll(StringReplaceAll(EConfigs[EC].HitCommand,"_x_",str(x)),"_y_",str(y)),"");
          if(EConfigs[EC].HMax > -1 && eHealth <= 0){
            particleEffect(x-.5,y-.5,1,1,30,EConfigs[EC].AltColor,EConfigs[EC].Color,.1);
            //tryCommand(StringReplaceAll(StringReplaceAll(EC.DeathCommand,"_x_",str(x)),"_y_",str(y)),"");//aGS1DS(gBBreakCommand,wUP[i][j])
            
            destroy();
          }
        }
      }
      
      if(eFireCooldown > 0){
        eFireCooldown--;
      }
      if(eStamina > 110){
        eStamina = 110;
      }
      if(eStamina < 0){
        eStamina = 0;
      }
    } else if(EConfigs[EC].Genre == 2){ //particle effect genre ********************************************************************************************************
      x += EConfigs[EC].SMax*cos(eDir);
      y += EConfigs[EC].SMax*sin(eDir);
      eV.x = x; eV.y = y; //eV = new PVector(x,y);
      eFade += EConfigs[EC].FadeRate;
      if(eFade>1){
        destroy();
      }
    } else if(EConfigs[EC].Genre == 3){ //item genre *******************************************************************************************************************
      
      //eSpeed += EConfigs[EC].Accel * distance to near player;
      
      
      if(eSpeed > .01){
        eSpeed = eSpeed*.95;
        moveInWorld(eV, new PVector(eSpeed*cos(eDir),eSpeed*sin(eDir)),0,0);
        eDir = pointDir(eVLast,eV);
      }
    }
    if(EConfigs[EC].Genre == 1 || EConfigs[EC].Genre == 3){
      if(floor(eV.x-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2) != floor(eVLast.x-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2) || floor(eV.x+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2) != floor(eVLast.x+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2) || floor(eV.y-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2) != floor(eVLast.y-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2) || floor(eV.y+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2) != floor(eVLast.y+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2)){
        removeEntityFromGridArea(eVLast.x-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eVLast.y-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eVLast.x+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eVLast.y+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,ID);
        addEntityToGridArea(eV.x-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eV.y-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eV.x+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eV.y+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,this);
      }
      
      eVLast = new PVector(eV.x,eV.y);
    }
    x = eV.x;
    y = eV.y;
  }
  
  void setAITarget(){
    if(EConfigs[EC].AISearchMode == 0){
      if(EConfigs[EC].AITarget > -1){AITargetPos = blockNear(eV,EConfigs[EC].AITarget,100);} else {AITargetPos = entityNearID(eV,EConfigs[EC].AITargetID,30,100);}
    } else if(EConfigs[EC].AISearchMode == 1){
      if(EConfigs[EC].AITarget > -1){AITargetPos = blockNear(eV,EConfigs[EC].AITarget,random(90)+10);} else {AITargetPos = entityNearID(eV,EConfigs[EC].AITargetID,30,random(90)+10);}
    } else if(EConfigs[EC].AISearchMode == 2){
      AITargetPos = blockNearCasting(eV,EConfigs[EC].AITarget);
      if(aGS(wU,AITargetPos.x,AITargetPos.y) != EConfigs[EC].AITarget){
        AITargetPos = blockNear(eV,EConfigs[EC].AITarget,random(90)+10);
      }
    } else if(EConfigs[EC].AISearchMode == 3){
      
      if(aGS(wU,eV.x,eV.y) != EConfigs[EC].AITarget){
        searchWorld(eV,EConfigs[EC].AITarget,(int)EConfigs[EC].Vision/10);
        
        if(Apath.size()>0){
          AITargetPos = new PVector(((Node)Apath.get(0)).x,((Node)Apath.get(0)).y);
        }
      }
      
    } else if(EConfigs[EC].AISearchMode == 11){
      //follow path (line of sight)
      //test line of sight, if none, change mode, call again
      PVector tempTarget = rayCastAllPathsID(eV,EConfigs[EC].AITargetID,30);
      if(tempTarget != null){
        AITargetPos = tempTarget;
      } else {
        EConfigs[EC].AISearchMode = 12;
        setAITarget();
        return;
      }
    } else if(EConfigs[EC].AISearchMode == 12){
      //Strange (no line > 10)
      //test line of sight, change mode, call again

      if(rayCastAllPathsID(eV,EConfigs[EC].AITargetID,30) == null){
        AITargetPos.x = floor(AITargetPos.x)+.5;
        AITargetPos.y = floor(AITargetPos.y)+.5;
        
        boolean Side = false;
        boolean Front = false;
        boolean LastSide = false;
        boolean[] BlocksAround = getSolidAround(AITargetPos,AIDir,AIFollowSide);
        
        boolean SlideForward = true;
        
        Side = BlocksAround[2];
        Front = BlocksAround[0];
        LastSide = BlocksAround[3];
        if(Side){
          if(Front){
            //turn left
            SlideForward = false;
            if(AIFollowSide){
              AIDir++;
            } else {
              AIDir--;
            }
          } else {
            
          }
        } else {
          if(LastSide){
            //turn right and move into side
            if(AIFollowSide){
              AIDir--;
            } else {
              AIDir++;
            }
          } else {
            if(Front){
              //turn left and start following wall
              SlideForward = false;
              if(AIFollowSide){
                AIDir++;
              } else {
                AIDir--;
              }
            } else {
              //continue streight
            }
          }
        }
        
        if(random(50)<1 && BlocksAround[6] == false){
          if(AIFollowSide){
            AIDir++;
          } else {
            AIDir--;
          }
          AIFollowSide = false;
          if(random(100)<50){
            AIFollowSide = true;
          }
        }
        
        AIDir = (int)posMod(AIDir,4);
        if(SlideForward){
          if(AIDir == 0){
            AITargetPos.y--;
          } else if(AIDir == 1){
            AITargetPos.x++;
          } else if(AIDir == 2){
            AITargetPos.y++;
          } else if(AIDir == 3){
            AITargetPos.x--;
          }
        }
      } else {
        EConfigs[EC].AISearchMode = 11;
        setAITarget();
        return;
      }
      
    } else if(EConfigs[EC].AISearchMode == 21){
      //follow path (line of sight)
      //test line of sight, if none, change mode, call again
      PVector tempTarget = rayCastAllPathsID(eV,EConfigs[EC].AITargetID,30);
      if(tempTarget != null){
        AITargetPos = tempTarget;
        println("aa");
      } else {
        EConfigs[EC].AISearchMode = 22;
        setAITarget();
        return;
      }
    } else if(EConfigs[EC].AISearchMode == 22){
      //Strange (no line > 10)
      //test line of sight, change mode, call again

      if(rayCastAllPathsID(eV,EConfigs[EC].AITargetID,30) == null){
        
        PVector[] tPoints = new PVector[30];
        for(int i = 0; i < 30; i++){
          int tx = (int) (x+random(20)-10);
          int ty = (int) (y+random(20)-10);
          tPoints[i] = new PVector(tx,ty,aGS(AIMap,tx,ty));
        }
        for(int i = 0; i < 30; i++){
          int smallest = 256;
          int smallestIndex = 0;
          for(int j = 0; j < 30; j++){
            if(tPoints[j].z<smallest){
              smallest = (int) tPoints[j].z;
              smallestIndex = j;
            }
          }
          tPoints[smallestIndex].z = 999;
          if(rayCast((int)tPoints[smallestIndex].x,(int)tPoints[smallestIndex].y,(int)x,(int)y,true)){
            AITargetPos = new PVector(tPoints[smallestIndex].x,tPoints[smallestIndex].y);
            i = 1000;
          }
        }
        
        //set point:
        //pick 10 points around
        //sort based upon weight value
        //pick lowest weight that is line of sight
        
        
        println("cc");
      } else {
        EConfigs[EC].AISearchMode = 21;
        setAITarget();
        return;
      }
      
    }
    if(EConfigs[EC].AITarget > -1){
      AITargetPos = new PVector(AITargetPos.x+.5,AITargetPos.y+.5);
    }
    eD = new PVector(AITargetPos.x,AITargetPos.y);
  }
  
  void fire(PVector tempV){
    if(eFireCooldown == 0){
      if(tryStaminaAction(5)){
        float tempDir = pointDir(eV,tempV);
        Entity tempEntity = new Entity(x+EConfigs[EC].Size/2*cos(tempDir),y+EConfigs[EC].Size/2*sin(tempDir),EConfigs[EC].myBulletEntity,tempDir);
        tempEntity.sourceID = ID;
        addEntity(tempEntity);
        eFireCooldown += EConfigs[EC].FireDelay;
      }
    }
  }
  
  boolean tryStaminaAction(float cost){
    cost = cost*EConfigs[EC].StaminaRate;
    if(eStamina > cost){
      eStamina -= cost;
      return true;
    } else {
      eStamina -= cost/5;
      return false;
    }
  }
  
  void display() {
    if(aGS(nmapShade,x,y) > 0){
      PVector tempV = pos2Screen(new PVector(x,y));
      if(tempV.x > -gScale*EConfigs[EC].Size/2 && tempV.y > -gScale*EConfigs[EC].Size/2 && tempV.x < width+gScale*EConfigs[EC].Size/2 && tempV.y < height+gScale*EConfigs[EC].Size/2){
      
        if(EConfigs[EC].Genre == 0){
          //stroke(strokeColor);
          //strokeWeight(1);
          noStroke();
          fill(EConfigs[EC].Color);
          ellipse(tempV.x,tempV.y,EConfigs[EC].Size*gScale,EConfigs[EC].Size*gScale);
        } else if(EConfigs[EC].Genre == 1) {
          pushMatrix();
          translate(tempV.x,tempV.y);
          rotate(eDir+PI/2);
          image(EConfigs[EC].Img,-gScale/2*EConfigs[EC].Size,-gScale/2*EConfigs[EC].Size,gScale*EConfigs[EC].Size,gScale*EConfigs[EC].Size);
          
          
          rotate(pointDir(eV,new PVector(eFireD.x,eFireD.y))-eDir);//
          image(arrowImg,-gScale/2*(EConfigs[EC].Size+.5),-gScale/2*(EConfigs[EC].Size+.5),gScale*(EConfigs[EC].Size+.5),gScale*(EConfigs[EC].Size+.5));
          popMatrix();
          
          if(eHealth > 0 && eHealth < EConfigs[EC].HMax && eHealth < 1000000 && EConfigs[EC].HMax > -1){
            float tempFade = float(eHealth)/EConfigs[EC].HMax;
            noFill();
            strokeWeight(gScale/15);
            stroke(255,255-tempFade*150);
            arc(tempV.x,tempV.y,gScale*(EConfigs[EC].Size+.1),gScale*(EConfigs[EC].Size+.1),-HALF_PI,-HALF_PI+TWO_PI*tempFade);
            stroke((1-tempFade)*510,tempFade*510,0,255-tempFade*150);
            arc(tempV.x,tempV.y,gScale*(EConfigs[EC].Size+.1),gScale*(EConfigs[EC].Size+.1),-HALF_PI,-HALF_PI+TWO_PI*tempFade);
          }         
          
          
          //PVector tempV2 = pos2Screen(new PVector(eFireD.x,eFireD.y));
          //stroke(255,0,0);
          //ellipse(tempV2.x,tempV2.y,gScale*(EConfigs[EC].Size-.1),gScale*(EConfigs[EC].Size-.1));
          //eFireD = new PVector(x,y);
          
          
          
          //Entity te = (Entity) entities.get(floor(random(entities.size())));
          //if(){
          //  eFireD = te.eV;
          //}
          
        } else if(EConfigs[EC].Genre == 2){
          stroke(strokeColor,255-eFade*255);
          strokeWeight(2);
          fill(EConfigs[EC].Color,255-eFade*255);
          if(EConfigs[EC].Type == 0){
            ellipse(tempV.x,tempV.y,EConfigs[EC].Size*gScale,EConfigs[EC].Size*gScale);
          } else if(EConfigs[EC].Type == 1) {
            rect(tempV.x-EConfigs[EC].Size*gScale/2,tempV.y-EConfigs[EC].Size*gScale/2,EConfigs[EC].Size*gScale,EConfigs[EC].Size*gScale);
          } else {
            rect(tempV.x-EConfigs[EC].Size*gScale/2,tempV.y-EConfigs[EC].Size*gScale/2,EConfigs[EC].Size*gScale,EConfigs[EC].Size*gScale);
          }
        } else if(EConfigs[EC].Genre == 3){
          stroke(strokeColor,255);
          strokeWeight(2);
          fill(EConfigs[EC].Color,255);
          
          ellipse(tempV.x,tempV.y,EConfigs[EC].Size*gScale,EConfigs[EC].Size*gScale);
          
        }
      }
    }
  }
  
  void destroy(){
    if(EConfigs[EC].Genre == 1 || EConfigs[EC].Genre == 3){
      removeEntityFromGridArea(eVLast.x-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eVLast.y-EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eVLast.x+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,eVLast.y+EConfigs[EC].Size*EConfigs[EC].HitboxScale/2,ID);
    }
    tryCommand(StringReplaceAll(StringReplaceAll(EConfigs[EC].DeathCommand,"_x_",str(x)),"_y_",str(y)),"");
    removeEntity(this,-1);
    
  }
}

class EConfig {
  float ID = random(1000);
  int Genre = 0;
  int Team = -2;//-1 = no team, -2 = bad mobs, -3 = good mobs
  
  color Color = color(0);
  color AltColor = color(255,0,0);
  String DeathCommand = "";
  String BirthCommand = "";
  String HitCommand = "";
  
  int HMax = 20;
  float Size = 1;
  float HitboxScale = 1;
  float SMax = .15;
  float StaminaRate = 1;
  float FireDelay = 5;
  
  float Accel = .040;
  float Drag = .008;
  float TAccel = .030;
  float TSMax = .20;
  float TDrag = .016;
  PImage Img;
  int Type = 0;
  
  int AISearchMode = -1;
  int AITarget = -1;
  float AITargetID = -1;
  float AIActionMode = -1;
  int AIDoorBlock = -1;
  int AIDoorBlockClose = -1;
  int AIDoorWidth = 5;
  
  int SuckRange = -1;
  
  float FadeRate = .1;
  float Vision = 100; //100 is generaly a good number... be careful with this and AI mode 3+... if > 140 and no target is near lag is created
  float GoalDist = 3; //Want to get this close
  float ActDist = 10; //Will start acting at this dis
//  int FireDelay = 25;
  
  int myBulletEntity = EC_BULLET;
  
  EConfig() {
    int goodness = 1;
    SMax = .15; // - Speed based slider
  
    float moveTime = .3; //time to start - Agility based slider
    float moveSpeed = SMax/(max(25*moveTime,1));
    
    float dragTime = 1; //time to stop - Agility based slider
    float dragSpeed = SMax/(max(25*dragTime,1));
    
    Drag = dragSpeed;
    Accel = dragSpeed+moveSpeed;
    
    
    
    //0 to 10 -> 0 is .02, 10 is 0.27;
    float TtotSpeed = 5;
    TSMax = TtotSpeed/25/2+.02;// - Speed based slider
    
    
    float TsetSpeed = 5;//0 to 10 -> 0 is 1 seconds, 10 is 0 seconds 
    float TmoveTime = (1-TsetSpeed/10)*1; //time to start - Agility based slider
    float TmoveSpeed = TSMax/(max(25*TmoveTime,1));
    
    float TsetDrag = 5;//0 to 10 -> 0 is 1 seconds, 10 is 0 seconds 
    float TdragTime = (1-TsetSpeed/10)*1/2; //time to stop - Agility based slider
    float TdragSpeed = TSMax/(max(25*TdragTime,1));
    
    TDrag = TdragSpeed;
    TAccel = TdragSpeed+TmoveSpeed;

    //Fire rate - Speed based slider
    //Sprint speed - Speed based slider
    
    //all movement takes away from endurance - based upon speed that is set to, so endurance limits all activities, distribute speed wisly to prevent exaustion where movement stops bacause there is no remaining endurance
    //Endurance - limits all movment, agility - ability to make suddent movements, speed - ability to maintain a rate of movment
  }
}

void particleEffect(float x, float y, float w, float h, int num, color c1, color c2, float ts){
  if(particleCycle+3 != (particleCycle+3)%100){
    particleCycle = 0;
  }
  EConfigs[256+particleCycle] = new EConfig();
  EConfigs[256+particleCycle].Genre = 2;
  EConfigs[256+particleCycle].Size = .1;
  EConfigs[256+particleCycle].FadeRate = random(.1)+.05;
  EConfigs[256+particleCycle].Type = 0;
  EConfigs[256+particleCycle].SMax = random(ts);
  EConfigs[256+particleCycle].Color = c1;
  particleCycle = (particleCycle+1)%100;
  EConfigs[256+particleCycle] = new EConfig();
  EConfigs[256+particleCycle].Genre = 2;
  EConfigs[256+particleCycle].Size = .1;
  EConfigs[256+particleCycle].FadeRate = random(.1)+.05;
  EConfigs[256+particleCycle].Type = 1;
  EConfigs[256+particleCycle].SMax = random(ts);
  if(random(100)<50){
    EConfigs[256+particleCycle].Color = c1;
  } else {
    EConfigs[256+particleCycle].Color = c2;
  }
  particleCycle = (particleCycle+1)%100;
  EConfigs[256+particleCycle] = new EConfig();
  EConfigs[256+particleCycle].Genre = 2;
  EConfigs[256+particleCycle].Size = .1;
  EConfigs[256+particleCycle].FadeRate = random(.1)+.05;
  EConfigs[256+particleCycle].Type = 2;
  EConfigs[256+particleCycle].SMax = random(ts);
  EConfigs[256+particleCycle].Color = c2;
  particleCycle = (particleCycle+1)%100;
  
  for(int i = 0; i <num; i++){
    addEntity(new Entity(x+random(w),y+random(h),256+(particleCycle-3+floor(random(3))),random(TWO_PI)));
  }
  
}

Entity getEntityID(float tEID){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.ID == tEID){
      return tempE;
    }
  }
  return null;
}

PVector entityNearID(PVector eV,float tEID, float tDis, float tChance){
  float minDis = tDis;
  PVector tRV = new PVector(random(wSize),random(wSize),-1);
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(EConfigs[tempE.EC].ID == tEID){
      if(random(100)<tChance){
        if(pointDistance(eV, tempE.eV) < minDis){
          tRV = new PVector(tempE.x,tempE.y,0);
          minDis = pointDistance(eV, tRV);
        }
      }
    }
  }
  return tRV;
}

boolean isEntityNearID(PVector eV,float tEID, float tDis){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(EConfigs[tempE.EC].ID == tEID){
      if(pointDistance(eV, tempE.eV) < tDis){
        return true;
      }
    }
  }
  return false;
}
/*
boolean spreadSmell(int x, int y, int dis){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    if(aGS2DB(smap,x,y) == false){
      aSS2DB(smap,x,y,true);
      if(dis<1){
        return false;
      }
      boolean bools = false;
      if(aGS1DB(gBIsSolid,aGS(wU,x+1,y)) == false || aGS(wU,x+1,y)==8){if(spreadSmell(x+1,y,dis-1)){bools=true;}}
      if(aGS1DB(gBIsSolid,aGS(wU,x-1,y)) == false || aGS(wU,x-1,y)==8){if(spreadSmell(x-1,y,dis-1)){bools=true;}}
      if(aGS1DB(gBIsSolid,aGS(wU,x,y+1)) == false || aGS(wU,x,y+1)==8){if(spreadSmell(x,y+1,dis-1)){bools=true;}}
      if(aGS1DB(gBIsSolid,aGS(wU,x,y-1)) == false || aGS(wU,x,y-1)==8){if(spreadSmell(x,y-1,dis-1)){bools=true;}}
      return bools;
    }
  }
  return false;
}
*/
/*
boolean isEntityNearIDSmell(PVector eV,float tEID, float tDis){
  smap = new boolean[wSize][wSize];
  spreadSmell((int)eV.x,(int)eV.y,(int)tDis);
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.EC.ID == tEID){
      //if(pointDistance(eV, tempE.eV) < tDis){
        if(aGS2DB(smap,tempE.eV.x,tempE.eV.y)){
          return true;
        }
      //}
    }
  }
  return false;
}
*/
boolean isEntityNearGenreSpecial(PVector eV,float tEGenre, float tDis){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(EConfigs[tempE.EC].Genre == tEGenre){
      if(max(abs(eV.x-tempE.eV.x), abs(eV.y-tempE.eV.y)) < tDis){
        return true;
      }
    }
  }
  return false;
}

Entity entityNearGenreSpecial(PVector eV,float tEGenre, float tDis){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(EConfigs[tempE.EC].Genre == tEGenre){
      if(max(abs(eV.x-tempE.eV.x), abs(eV.y-tempE.eV.y)) < tDis){
        return tempE;
      }
    }
  }
  return null;
}


PVector rayCastAllPathsID(PVector eV,float tEID, float tDis){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(EConfigs[tempE.EC].ID == tEID){
      if(pointDistance(eV, tempE.eV) < tDis){
        int tempInt = rayCastPath(tempE.path, (int)eV.x, (int)eV.y);
        if(tempInt > -1){
          PVector tempPV = (PVector)tempE.path.get(tempInt);
          return new PVector(tempPV.x,tempPV.y);
        }
      }
    }
  }
  return null;
}

void addEntity(Entity te){
  entities.add(te);
  if(EConfigs[te.EC].Genre == 1 && EConfigs[te.EC].Type == 1){
    miniMapEntities.add(te);
  }
}
void removeEntity(Entity te, int n){
  if(n < 0){
    Entity tempE;
    for (int i = entities.size()-1; i >= 0; i--) {
      tempE = (Entity) entities.get(i);
      if(tempE.ID == te.ID){
        n = i;
        break;
      }
    }
    if(n < 0){
      return;
    }
  }
  
  entities.remove(n);
  if(te.EC < 256){
    segments.add(new Segment("=" + str(te.ID*100+playerID) + ";dead;1&", 3));
  }
  if(EConfigs[te.EC].Genre == 1 && EConfigs[te.EC].Type == 1){
    n = -1;
    Entity tempE;
    for (int i = miniMapEntities.size()-1; i >= 0; i--) {
      
      tempE = (Entity) miniMapEntities.get(i);
      if(tempE.ID == te.ID){
        n = i;
        break;
      }
    }
    if(n > -1){
      miniMapEntities.remove(n);
    }
  }
}

//STEM Phagescape API v(see above)

PImage HUDImage;

String HUDTtext = "";
String HUDTsubText = "";
float HUDTtextSize = 10;
float HUDTsubTextSize = 10;
color HUDTtextColor = 0;
color HUDTsubTextColor = 0;
int HUDTfadeIn = 0;
int HUDTfadeOut = 0;
int HUDTsubTextDelay = 0;
int HUDTdisplayTime = 0;
int HUDTstage = 0;
float HUDTtextWidth = 0;
float HUDTsubTextWidth = 0;

float HUDStaminaSize = 12;

int HUDSstage = 0;
int HUDSfade = 10;
float HUDSradius = float(1)/3;

boolean showBars = true;
boolean showMiniMap = true;
boolean loadMiniMap = true;
boolean lockMinimapToCamera = true;
int[][] miniMap;
ArrayList miniMapEntities = new ArrayList();
int miniMapScale = 2;
int miniMapZoomSmall = 6;
int miniMapZoomLarge = 18; //18 is equal
int miniMapZoom;
int miniMapX = 30;
int miniMapY = 30;
int viewCX = 50;
int viewCY = 50;

void setupHUD(){
  miniMapX = width-floor(HUDStaminaSize)-miniMapScale*wSize;
  miniMapY = height-floor(HUDStaminaSize)-miniMapScale*wSize;
}

void drawHUD(){
  
  miniMapScale = 2;
  
  if(showBars){
    noStroke();
    fill(0);
    rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize,miniMapScale*wSize,HUDStaminaSize);
    float tFade = min(player.eStamina/100,1);
    //fill(255-255*tFade,255,0);
    fill((1-tFade)*(255*2),tFade*(255*2),0);
    rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize,miniMapScale*wSize*tFade,HUDStaminaSize);
    stroke(255);
    strokeWeight(2);
    noFill();
    rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize,miniMapScale*wSize,HUDStaminaSize);
  }
  
  if(showMiniMap){
    if(keyPressed && key == 'm'){
      miniMapScale = 6;
      miniMapX = (width-miniMapScale*wSize)/2;
      miniMapY = (height-miniMapScale*wSize)/2;
      miniMapZoom = miniMapZoomLarge;
    } else {
      miniMapScale = 2;
      miniMapX = width-floor(HUDStaminaSize)-miniMapScale*wSize;
      miniMapY = height-floor(HUDStaminaSize)-miniMapScale*wSize;
      miniMapZoom = miniMapZoomSmall;
    }
    
    int wBlocks = ceil(float(miniMapScale)/(miniMapScale+miniMapZoom)*wSize);
    if(lockMinimapToCamera){
      viewCX = min(wSize-ceil(float(wBlocks)/2),max(floor(float(wBlocks)/2),floor(wViewCenter.x)));
      viewCY = min(wSize-ceil(float(wBlocks)/2),max(floor(float(wBlocks)/2),floor(wViewCenter.y)));
    }
    
    int tempScale = miniMapScale+miniMapZoom;
    int tempOffX = viewCX-floor(float(wBlocks)/2);
    int tempOffY = viewCY-floor(float(wBlocks)/2);
    int tempX = miniMapX-tempScale*wBlocks+wSize*miniMapScale;
    int tempY = miniMapY-tempScale*wBlocks+wSize*miniMapScale;
    
    noStroke();
    fill(red(gBColor[0]),green(gBColor[0]),blue(gBColor[0]));
    if(keyPressed && key == 'm'){ //if large scale mini map
      rect(tempX,tempY,6*wSize,6*wSize);
    } else {
      rect(tempX,tempY,2*wSize,2*wSize);
    }
    
    noStroke();
    for(int i = 0; i < wBlocks; i++){
      for(int j = 0; j < wBlocks; j++){
        fill(miniMap[tempOffX+i][tempOffY+j]);
        rect(tempX+tempScale*i,tempY+tempScale*j,tempScale,tempScale);
      }
    }
  
    
    Entity tempE;
    float tx, ty;
    for (int i = miniMapEntities.size()-1; i >= 0; i--) {
      tempE = (Entity) miniMapEntities.get(i);
      tx = tempE.x-tempOffX;
      ty = tempE.y-tempOffY;
      if(tx > .5 && ty > .5 && tx < wBlocks-.5 && ty < wBlocks-.5){ // is on map
        fill(EConfigs[tempE.EC].Color);
        ellipse(tempX+(tx)*tempScale,tempY+(ty)*tempScale,tempScale,tempScale);
      }
    }
    fill(255);
    ellipse(tempX+((int)player.x-tempOffX+.5)*tempScale+.5,tempY+((int)player.y-tempOffY+.5)*tempScale+.5,tempScale,tempScale);
    
    noFill();
    stroke(255);
    if(keyPressed && key == 'm'){ //if large scale mini map
      rect(tempX,tempY,6*wSize,6*wSize);
    } else {
      rect(tempX,tempY,2*wSize,2*wSize);
    }
  
    miniMapScale = 2;
  }
  
  if(drawHUDSoftEdge){
    image(HUDImage,0,0);
  }
  
  if(HUDTstage < HUDTfadeIn+HUDTdisplayTime+HUDTfadeOut){
    float tempAlpha = 255;
    float tempAlpha2 = 255;
    float mainOffset = height/15;
    if(HUDTstage < HUDTfadeIn){
      tempAlpha = float(HUDTstage)/HUDTfadeIn*255;
    }
    if(HUDTstage < HUDTfadeIn+HUDTsubTextDelay){
      tempAlpha2 = float(HUDTstage-HUDTsubTextDelay)/HUDTfadeIn*255;
    }
    if(HUDTstage > HUDTfadeIn+HUDTdisplayTime){
      tempAlpha = 255-float(HUDTstage-(HUDTfadeIn+HUDTdisplayTime))/HUDTfadeOut*255;
      tempAlpha2 = min(tempAlpha2,tempAlpha);
    }
    
    if(HUDTsubText.equals("")){
      mainOffset = +HUDTtextSize/2;
    }
    textMarkup(HUDTtext, HUDTtextSize, (width-HUDTtextWidth)/2, height/2-mainOffset, HUDTtextColor, tempAlpha, false);
    if(!HUDTsubText.equals("")){
      textMarkup(HUDTsubText, HUDTsubTextSize, (width-HUDTsubTextWidth)/2, height/2+mainOffset, HUDTsubTextColor, tempAlpha2, false);
    }
  }
  
  if(HUDSstage != 0){
    
    int items = 35;
    float tempFade = float(abs(HUDSstage))/HUDSfade*255;
    float sliceSize = TWO_PI/items;
    
    if(mouseX != width/2 && pointDistance(new PVector(width/2,height/2), new PVector(mouseX,mouseY)) < width*HUDSradius){
      fill(0,255,0,tempFade*4/5);
      noStroke();
      float mousePlace = float(floor((pointDir(new PVector(width/2,height/2), new PVector(mouseX,mouseY))+PI/2)/sliceSize)+0)*sliceSize-PI/2;
      arc(width/2,height/2,width*HUDSradius*2,width*HUDSradius*2,mousePlace,mousePlace+sliceSize);
    }
    
    stroke(255,tempFade);
    strokeWeight(width*HUDSradius/30);
    fill(200,tempFade*4/5);
    ellipse(width/2,height/2,width*HUDSradius*2,width*HUDSradius*2);
    ellipse(width/2,height/2,width*HUDSradius/30,width*HUDSradius/30);
    float dir = -PI/2;
    fill(100,tempFade);
    
    for(int i = 0; i < items; i++){
      line(width/2,height/2,width/2+width*HUDSradius*cos(dir),height/2+width*HUDSradius*sin(dir));
      
      textAlign(CENTER,CENTER);
      textSize(20);
      if(i < 10){
        text(str((i+1)%10),width/2+(width*HUDSradius-18)*cos(dir+.08),height/2+(width*HUDSradius-18)*sin(dir+.08));
      }
      textAlign(CENTER,LEFT);
      
      dir += sliceSize;
    }
    
    stroke(0,255,0);
    
  }
}

void refreshHUD(){
  if(shadows == true){
    HUDAddLight(int(player.x),int(player.y),lightStrength);
  } else {
    nmapShade = new int[wSize][wSize];
    for(int i = 0; i < 100; i++){
      for(int j = 0; j < 100; j++){
        nmapShade[i][j] = 10;
      }
    }
  }
}

void HUDAddLight(int x1, int y1, int strength){
  nmapShade = new int[wSize][wSize];
  HUDAddLightLoop(max(0,min(wSize,x1)),max(0,min(wSize,y1)),strength);
}

void HUDAddLightLoop(int x, int y, int dist){
  if(aGS(nmapShade,x,y) < dist){
    aSS(nmapShade,x,y,dist);
    if(aGS1DB(gBIsSolid,aGS(wU,x,y)) == false){
      HUDAddLightLoop(x+1,y,dist-1);
      HUDAddLightLoop(x-1,y,dist-1);
      HUDAddLightLoop(x,y+1,dist-1);
      HUDAddLightLoop(x,y-1,dist-1);
    }
  }
}

void updateHUD(){
  if(HUDTstage < HUDTfadeIn+HUDTdisplayTime+HUDTfadeOut){
    HUDTstage++;
  }
  
  if(HUDSstage != 0){
    if(HUDSstage > 0 && HUDSstage < HUDSfade){
      HUDSstage++;
    }
    if(HUDSstage < 0 && HUDSstage < 0){
      HUDSstage++;
    }
    
    noStroke();
    fill(255,float(abs(HUDSstage))/HUDSfade*255);
    ellipse(width/2,height/2,width*HUDSradius*2,width*HUDSradius*2);
  }  
}

void HUDText(String ttext, String tsubText, float ttextSize, float tsubTextSize, color ttextColor, color tsubTextColor, int tfadeIn, int tfadeOut, int tsubTextDelay, int tdisplayTime){
  HUDTtext = ttext;
  HUDTsubText = tsubText;
  HUDTtextSize = ttextSize;
  HUDTsubTextSize = tsubTextSize;
  HUDTtextColor = ttextColor;
  HUDTsubTextColor = tsubTextColor;
  HUDTfadeIn = tfadeIn;
  HUDTfadeOut = tfadeOut;
  HUDTsubTextDelay = tsubTextDelay;
  HUDTdisplayTime = tdisplayTime;
  HUDTstage = 0;
  
  HUDTtextWidth = simpleTextWidth(HUDTtext, HUDTtextSize);
  HUDTsubTextWidth =simpleTextWidth(HUDTsubText, HUDTsubTextSize);
}

String qText = "";
String[] qAnswerLabels = {"a. ", "b. ", "c. ", "d. ", "e. ", "f. ", "g. ", "h. ", "i. ", "J. "};
String[] qAnswers = new String[4];
int qCorrectAnswer = 0;
float qSize;
float qAnswerSize;
float qWidth;
float qHeight;
float qHoverPad = 7;
float qHover = -1;
String qGoodCallback;
String qBadCallback;
float qLastFade = -1;

void newQuestion(String goodCallback, String badCallback){
  qHover = -1;
  qSize = 45.5;
  qAnswerSize = 40;
  qWidth = width/10*9;
  qHeight = height/10*9;
  
  qCorrectAnswer = 2;
  
  String qTText = "Did you know, if you cut off your left arm, your right arm would be left? Don't worry though, you will (JUSTIN WAS HERE) be all right. [insert question here] The quick brown fox jumped over the lazy dog! When does 1+1 equal three? ";
  String qTAnswers_0 = "One pluse one equals three when you read 1984 by George Orwell";
  String qTAnswers_1 = "One pluse one equals three for large values of 1";
  String qTAnswers_2 = "One pluse one doesn't equal three";
  String qTAnswers_3 = "One pluse one equals three when a cop says it does. Stop resisting! I'm-a light you up!";
  
  boolean resize = true;
  while(resize){
    qText = simpleTextCrush(qTText,qSize,qWidth);
    qAnswers[0] = simpleTextCrush(qAnswerLabels[0]+qTAnswers_0,qAnswerSize,qWidth);
    qAnswers[1] = simpleTextCrush(qAnswerLabels[1]+qTAnswers_1,qAnswerSize,qWidth);
    qAnswers[2] = simpleTextCrush(qAnswerLabels[2]+qTAnswers_2,qAnswerSize,qWidth);
    qAnswers[3] = simpleTextCrush(qAnswerLabels[3]+qTAnswers_3,qAnswerSize,qWidth);
    
    float tempH = simpleTextHeight(qText, qSize) + qSize + qAnswerSize*float(qAnswers.length-1);
    for(int i = 0; i < qAnswers.length; i++){
      tempH += simpleTextHeight(qAnswers[i], qAnswerSize);
    }
    if(tempH > qHeight){
      qSize-=.5;
      qAnswerSize = qSize/5*4;
    } else {
      resize = false;
    }
  }
  
  qGoodCallback = goodCallback;
  qBadCallback = badCallback;
}

void clickQuestion(){
  if(mouseClicked){
    if(qHover > -1){
      if(qLastFade >= 255){
        if(qHover == qCorrectAnswer){
          tryCommand(qGoodCallback,"");
        } else {
          tryCommand(qBadCallback,"");
        }
        mouseClicked = false;
        qHover = -1;
      }
    }
  }
  
  
}

void drawQuestion(float fade){
  qLastFade = fade;
  float yPointer = (height-qHeight)/2 + qSize/2;
  
  textMarkup(qText, qSize, (width-qWidth)/2, yPointer, 255, fade, false);
  
  yPointer += simpleTextHeight(qText, qSize) + qSize/2 + qAnswerSize/2;
  
  qHover = -1;
  for(int i = 0; i < qAnswers.length; i++){
    if(mouseY > yPointer-qAnswerSize/2+qAnswerSize/5-qHoverPad){
      if(mouseY < yPointer-qAnswerSize/2+qAnswerSize/5+simpleTextHeight(qAnswers[i], qAnswerSize)+qHoverPad){
        if(mouseX > (width-qWidth)/2-qHoverPad){
          if(mouseX < (width-qWidth)/2+simpleTextWidth(qAnswers[i], qAnswerSize)+qHoverPad){
            qHover = i;
            fill(0,100);
            noStroke();
            rect((width-qWidth)/2-qHoverPad,yPointer-qAnswerSize/2+qAnswerSize/15-qHoverPad,simpleTextWidth(qAnswers[i], qAnswerSize)+qHoverPad*2,simpleTextHeight(qAnswers[i], qAnswerSize)+qHoverPad*2,qHoverPad);
          }
        }
      }
    }
    textMarkup(qAnswers[i], qAnswerSize, (width-qWidth)/2, yPointer, 255, fade, false);
    yPointer += simpleTextHeight(qAnswers[i], qAnswerSize) + qAnswerSize;
  }
  
  noFill();
  stroke(255);
  strokeWeight(3);
}
String serverURL = "http://harvway.com/BetaBox/STEMPhagescape/testing.php?id=";
ArrayList segments = new ArrayList<Segment>();
ArrayList packets = new ArrayList<Packet>();
ArrayList packetThreads = new ArrayList<PacketThread>();
int packetCycle = 0;
int packetIDCycle = 1;
AudioPlayer serverCastAP;
AudioMetaData serverCastMeta;
int[] buildups = new int[10];
int eventIDCycle = 0;
Boolean[][] eventIDs = new Boolean[100][0];
int maxEventID = 0;


int Rplayers = 0;
int Rhost = 1;
int Rgenerated = 0;

boolean worldDownloaded = false;

boolean online = false;
boolean offline = false;
boolean sentPackets = false;

void setupServer(){
  
  try{
    serverCastAP = minim.loadFile("block-solid1.mp3");
    serverCastMeta = serverCastAP.getMetaData();
  } catch(Throwable e){}
  
  
  updateWorldColumn(0);
  buildPackets();
  
  /*
  String builtString = serverURL;
  for(int k = 0; k < 20; k++){
    builtString = serverURL;
    for(int i = 0; i < 5; i++){
      builtString = builtString + "LWC" + str(i) + "=" + str(k*5+i) + ";";
      for(int j = 0; j < 100; j++){
        if(j > 0){
          builtString = builtString + "|";
        }
        builtString = builtString + wU[k*5+i][j];
      }
      builtString = builtString + "&";
    }
    println(builtString.length());
    //loadStrings(builtString);
  }
  */
}

void updateWorldColumn(int i){
  String worldC = "=" + str(i) + ";";
  int running = 0;
  for(int j = 0; j < 100; j++){
    if(j == 99 || wU[i][min(j+1,100)] != wU[i][j]){
      if(running > 0){
        worldC = worldC + "|";
      }
      if(j-running == 0){
        worldC = worldC + wU[i][j];//print one value
      } else {
        worldC = worldC + wU[i][j] + "x" + str(j-running+1);//print multiple value
      }
      running = j+1;
    }
  }
  worldC = worldC + "&";
  segments.add(new Segment(worldC, 1));
}

void updateEntityData(){
  String entityD;
  for(Entity tempE: (ArrayList<Entity>)entities){ //each entity
    if(tempE.EC < 256){
      entityD = "=" + str(tempE.ID*100+playerID) + ";x;"+str(tempE.x)+"&";
      segments.add(new Segment(entityD, 3));
      entityD = "=" + str(tempE.ID*100+playerID) + ";y;"+str(tempE.y)+"&";
      segments.add(new Segment(entityD, 3));
      entityD = "=" + str(tempE.ID*100+playerID) + ";dir;"+str(tempE.eDir)+"&";
      segments.add(new Segment(entityD, 3));
      entityD = "=" + str(tempE.ID*100+playerID) + ";EC;"+str(tempE.EC)+"&";
      segments.add(new Segment(entityD, 3));
    }
  }
  
}

void updateServer(){
  
  try{
    String packetResponse = serverCastMeta.fileName(); //*checkPacketCallbacks* 
    if(!packetResponse.equals("")){
      
      String[] response = split(packetResponse,"<br>");
      println(response);
      packetRecievedCallback(response);

    }
  } catch(Throwable e){}
  
  if(fn % 10 == 0){
    
    if(packets.size() == 0){
      if(online){
        //updateWorldColumn(packetCycle % 100);
        //sometimes request a world update
        
        //updateEntityData();
        if(worldDownloaded){
          updateEntityData();
        } else if(Rgenerated == 1){
          segments.add(new Segment("GETW=1&", 0));
        } else if(playerID == Rhost){
          for(int k = 1; k < 100; k++){
            updateWorldColumn(k);
          }
          segments.add(new Segment("GETW=1&", 0));
        } else {
          segments.add(new Segment("PING", 0));
        }
        
      }
      buildPackets();
      
    } else if((sentPackets == true && online == false) && offline==false) {
      packets.clear();
    }
    println(str(packets.size())+" packets");
    if(packets.size() > 0){
      sentPackets = true;
      Packet tempPacket = (Packet)packets.get(packetCycle % packets.size());
      println(tempPacket.content);
      
      try {
        PacketThread tempPacketThread = new PacketThread(this,tempPacket.content);
        tempPacketThread.start();
        packetThreads.add(tempPacketThread);
      } catch(Throwable e) {
        //println("FAIL");
        try {
          minim.loadSample(tempPacket.content); //*requestPacket*
          println("called load sample on "+tempPacket.content);
        } catch(Throwable ee) {
          println("ERROR");
        }
      }
      if(offline){
        packets.clear();
      }
    }
    packetCycle++;
  }
  
}

void packetRecievedCallback(String[] response){
  Packet tempPacket;
  println(response[0]);
  if(int(response[0]) > 0){
    if(int(response[0]) == 100){
      processResponse(response);
    } else {
      for(int i = packets.size()-1; i >= 0; i--){
        tempPacket = (Packet)packets.get(i);
        if(tempPacket.id == int(response[0])){
          packets.remove(i);
          processResponse(response);
          break;
        }
      }
    }
  }
}

void processResponse(String[] response){
  int mode = -1;
  int submode = -1;
  
  String tKey = "";
  int tPlayer = 0;
  Mimic tMimic = null;
  
  segments.add(new Segment("="+response[0]+"&", 4));
  
  String[] tempStrA;
  for(int i = 1; i < response.length; i++){
    if(response[i].equals("{[END]}")){mode = -1; submode=-1;} else
    if(response[i].equals("{[BREAK]}")){submode = -1; tKey="";} else
    if(mode == 0){
      tempStrA = split(response[i],";");
      if(tempStrA.length == 3){
        if(aGS(wU,int(tempStrA[0]),int(tempStrA[1])) != int(tempStrA[2])){
          aSS(wU,int(tempStrA[0]),int(tempStrA[1]),int(tempStrA[2]));
          wViewLast.x = -1;
        }
      }
    } else
    if(mode == 1){
      tempStrA = split(response[i],";");
      if(tempStrA.length == 2){
        if(tempStrA[0].equals("PID")){
          online = true;
          packets.clear();
          playerID = int(tempStrA[1]);
        } else
        if(tempStrA[0].equals("WGET")){
          worldDownloaded = true;
        } else
        if(tempStrA[0].equals("P#")){Rplayers = int(tempStrA[1]);} else
        if(tempStrA[0].equals("HOST")){Rhost = int(tempStrA[1]);} else
        if(tempStrA[0].equals("GENERATED")){Rgenerated = int(tempStrA[1]);}
      }
    } else if(mode == 2){
      if(submode == -1){
        submode = int(response[i]);
        tPlayer = submode % 100;
        if(tPlayer == playerID){
          submode = -2;
        } else {
          submode = floor(submode/100);
          if(maxMimicID < submode){
            maxMimicID = submode;
            reloadMimicIDs();
            tMimic = new Mimic(submode, tPlayer);
            mimicIDs[tPlayer-1][submode] = tMimic;
            mimics.add(tMimic);
          } else if(mimicIDs[tPlayer-1][submode] == null){
            if(response[i+1].equals("dead") || response[i+1].equals("exp")){
              submode = -2;
            } else {
              tMimic = new Mimic(submode, tPlayer);
              mimicIDs[tPlayer-1][submode] = tMimic;
              mimics.add(tMimic);
            }
          } else {
            tMimic = mimicIDs[tPlayer-1][submode];
          }
          println("MIMIC REGISTERED" + submode*100+tPlayer);
        }
      } else if(submode != -2) {
        if(tKey.equals("")){
          tKey = response[i];
        } else {
          if(tKey.equals("x")){
            tMimic.x = float(response[i]);
          } else if(tKey.equals("y")){
            tMimic.y = float(response[i]);
          } else if(tKey.equals("dir")){
            tMimic.eDir = float(response[i]);
          } else if(tKey.equals("EC")){
            tMimic.EC = int(response[i]);
          } else if(tKey.equals("dead") || tKey.equals("exp")){
            Mimic ttMimic;
            for(int j = 0; j < mimics.size(); j++){
              ttMimic = (Mimic)mimics.get(j);
              if(ttMimic.ID == tMimic.ID && ttMimic.playerID == tMimic.playerID){
                mimics.remove(j);
                break;
              }
            }
            reloadMimicIDs();
          }
          tKey = "";
        }
      }
    } else
    if(mode == 3){
      tempStrA = split(response[i],",");
      if(tempStrA.length > 1){
        tPlayer = int(tempStrA[0])%100;
        if(tPlayer != playerID){
          submode = floor(int(tempStrA[0])/100);
          if(submode >= eventIDs[tPlayer].length){
            eventIDs[tPlayer] = (Boolean[])expand(eventIDs[tPlayer],submode+1);
            for(int k = 0; k < eventIDs.length; k++){
              for(int j = 0; j < eventIDs[k].length; j++){
                if(eventIDs[k][j] == null){
                  eventIDs[k][j] = false;
                }
              }
            }
          }
          if(eventIDs[tPlayer][submode] == false){
            eventIDs[tPlayer][submode] = true;
            if(tempStrA[1].equals("HB")){
              if(aGS(wU,int(tempStrA[2]),int(tempStrA[3])) == int(tempStrA[4])){
                hitBlock(int(tempStrA[2]),int(tempStrA[3]),int(tempStrA[5]),true);
              }
            } else
            if(tempStrA[1].equals("HE")){
              
            } //end else
          }
        }
      }
    } else
    if(response[i].equals("{[WORLD_UPDATES]}")){mode = 0;} else
    if(response[i].equals("{[GLOBAL_VARS]}")){mode = 1;} else
    if(response[i].equals("{[ENTITY_DATA]}")){mode = 2;} else 
    if(response[i].equals("{[UPDATE_DATA]}")){mode = 3;}
  }
}

void buildPackets(){
  if(segments.size() > 0){
    buildups = new int[buildups.length];
    Segment tempSeg = (Segment)segments.get(0);
    String builtString = tempSeg.buildSegment();
    buildups[tempSeg.type]++;
    if(segments.size() > 1){
      for(int i = 1; i < segments.size(); i++){
        tempSeg = (Segment)segments.get(i);
        if(builtString.length() + (tempSeg.buildSegment()).length() < 2080){
          builtString = builtString + tempSeg.buildSegment();
          buildups[tempSeg.type]++;
        } else {
          packets.add(new Packet(builtString));
          buildups = new int[buildups.length];
          builtString = tempSeg.buildSegment();
          buildups[tempSeg.type]++;
        }
      }
    }
    packets.add(new Packet(builtString));
    eventIDCycle += buildups[5];
  }
  segments.clear();
}

class Packet {
  String content;
  int id;
  Packet(String tContent) {
    id = packetIDCycle*100+playerID;
    packetIDCycle++;
    content = serverURL + str(id) + "&" + "rand=" + str(floor(random(1000))) + "&" + tContent;
  }
}

class Segment {
  String content;
  int type;
  Segment(String tContent, int tType) {
    content = tContent;
    type = tType;
  }
  String buildSegment(){
    if(type == 0){ //general
      return content;
    }
    if(type == 1){ //load world column
      return "LWC"+str(buildups[type])+content;
    }
    if(type == 2){ //load world unit
      return "WU"+str(buildups[type])+content;
    }
    if(type == 3){ //load entity data
      return "MOB"+str(buildups[type])+content;
    }
    if(type == 4){ //packet reciept
      return "GOT"+str(buildups[type])+content;
    }
    if(type == 5){ //packet reciept
      return "EV"+str(buildups[type])+"="+str((eventIDCycle+buildups[type])*100+playerID)+";"+content+"&";
    }
    return "";
  }
}



public class PacketThread implements Runnable {
  Thread thread;
  String packetContent;
  
  public PacketThread(PApplet parent, String tPacketContent){
    parent.registerDispose(this);
    packetContent = tPacketContent;
  }

  public void start(){
    thread = new Thread(this);
    thread.start();
  }

  public void run(){
    String[] primaryResponse = loadStrings(packetContent);
    String[] response = split(primaryResponse[0],"<br>");
    println(response);
    packetRecievedCallback(response);
  }

  public void stop(){
    thread = null;
  }

  // this will magically be called by the parent once the user hits stop 
  // this functionality hasn't been tested heavily so if it doesn't work, file a bug 
  public void dispose() {
    stop();
  }
} 









class Mimic {
  float x = -100;
  float y = -100;
  float eDir = 0;
  int EC = EC_BULLET;
  int ID;
  int playerID;
  boolean expired = false;
  boolean dead = false;
  
  Mimic(int tID, int tPlayerID) {
    ID = tID;
    playerID = tPlayerID;
  }
  
  void update(){
    x+=random(.1)-.05;
    y+=random(.1)-.05;
  }
  
  void display(){
    PVector tempV = pos2Screen(new PVector(x,y));
    //println(ID*100+playerID);
    noStroke();
    fill(0,255,0);
    if(expired){fill(255,200,0);}
    if(dead){fill(255,0,0);}
    ellipse(tempV.x,tempV.y,gScale/2,gScale/2);
  }
  
}

void disconnect(){
  online = false;
  offline = true;
  packets.clear();
  segments.add(new Segment("DIS", 5));
  buildPackets();
}

ArrayList sL = new ArrayList<Sound>();

void updateSound(){
  Sound tempS;
  for (int i = 0; i < sL.size(); i++){
    tempS = (Sound) sL.get(i);
    if(tempS.update()){
      sL.remove(i);
      i--;
    }
  }
}

void drawSound(){
  Sound tempS;
  for (int i = 0; i < sL.size(); i++){
    tempS = (Sound) sL.get(i);
    tempS.display();
  }
}

class Sound {
  float x;
  float y;
  PVector posV;
  SoundConfig config;
  float r = 0;
  int index = 100;
  float offX;
  float offY;
  float wallMult = 1;
  Sound(float tx, float ty, SoundConfig tconfig, int tindex) {
    x = tx;
    y = ty;
    index = tindex;
    config = tconfig;
    offX = random(config.variance*2)-config.variance;
    offY = random(config.variance*2)-config.variance;
    //0 = no effect - always loud
    //if there is a ray cast - 0 to 100 always loud -> 200 is no sound
    //if there is a path     - 0 = loud 200 = no sound scales
    //if completely seperate - 0 to 100 scales -> 100 to 200 no sound
    if(config.wallEffect > 0){
      if(rayCast((int) x, (int) y, (int) wViewCenter.x, (int) wViewCenter.y,true)){
        wallMult = (100-max(config.wallEffect-100,0))/100;
      } else if(genTestPathExists( x, y, wViewCenter.x, wViewCenter.y)){
        wallMult = (200-config.wallEffect)/200;
      } else {
        wallMult = (100-config.wallEffect)/100;
      }
      wallMult = max(min(wallMult,1),0);
    }
    if(index == 0){
      if(wallMult > 0 && pointDistance(wViewCenter, new PVector(x,y)) < config.rMax*wallMult){
        AudioPlayer tempAP = (AudioPlayer)config.sound.get(floor(random(config.sound.size())));
        tempAP.setGain((1-pointDistance(wViewCenter, new PVector(x,y))/(config.rMax*wallMult))*35-35); //-35 to 0 dB
        tempAP.rewind();
        tempAP.play();
      }
    }
  }
  void display() {
    if(config.drawWave){
      posV = pos2Screen(new PVector(x+offX,y+offY));
      noFill();
      stroke(config.baseColor,(config.rMax*gScale*wallMult-r*gScale)/(config.rMax*gScale*wallMult)*255);
      strokeWeight(max(0,(r/(config.rMax*wallMult)*config.bandWidth+.6)*gScale));
      ellipse(posV.x,posV.y,r*2*gScale,r*2*gScale);
    }
  }
    
  boolean update() {
    if(config.drawWave == false){
      return true;
    }
    r+=config.rSpeed;
    if(index < config.waveCount-1){
      if(r > config.waveLength){
        sL.add(new Sound(x,y,config,index+1));
        index = 999;
      }
    }
    if(r>config.rMax*wallMult){
      return true;
    } else {
      return false;
    }
  }
}

class SoundConfig {
  boolean drawWave;
  float rSpeed=1;
  int rMax=0;
  float darkness=255;
  color baseColor=0;
  float bandWidth=0;
  int waveCount = 0;
  float waveLength = 0;
  float variance = 0;
  float wallEffect = 0;
  ArrayList sound = new ArrayList<AudioPlayer>();
  SoundConfig(boolean tdrawWave, float trSpeed, int trMax, float tdarkness, color tbaseColor, float tbandWidth, int twaveCount, float twaveLength, float tvariance, float twallEffect) {
    drawWave = tdrawWave;
    rSpeed=trSpeed;
    rMax=trMax;
    darkness=tdarkness;
    baseColor=tbaseColor;
    bandWidth=tbandWidth;
    waveCount = twaveCount;
    waveLength = twaveLength;
    variance = tvariance;
    wallEffect = twallEffect;
  }
}
//STEM Phagescape API v(see above)

void genRing(float x, float y, float w, float h, float weight, int b){
  genArc(0,TWO_PI,x,y,w,h,weight,b);
}

void genArc(float rStart, float rEnd, float x, float y, float w, float h, float weight, int b){
  if(rStart > rEnd){float rTemp = rStart; rStart = rEnd; rEnd = rTemp;}
  float dR = rEnd-rStart;
  float c = dR/floor(dR*max(w,h)*10); //dR is range -> range/(circumfrence of arc(radians * 2*max_radius *5 -> 20*radius -> 20 points per block)) -> gives increment value
  float r;
  for(float i = rStart; i < rEnd; i+=c){
    r = (w*h/2)/sqrt(sq(w*cos(i))+sq(h*sin(i)))-weight/2;
    for(float j = 0; j <= weight; j+=.2){
      aSS(wU,round(x+(r+j)*cos(i)),round(y+(r+j)*sin(i)),b);
    }
  }
}

void genCircle(float x, float y, float r, int b){
  PVector centerV = new PVector(x,y);
  for(int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      if(pointDistance(new PVector(i,j), centerV) < r){
        aSS(wU,i,j,b);
      }
    }
  }
}

void genLine(float x1, float y1, float x2, float y2, float weight, int b){
  int itt = ceil(10*pointDistance(new PVector(x1,y1), new PVector(x2,y2)));
  float rise = (y2-y1)/itt;
  float run = (x2-x1)/itt;
  float xOff = 0;
  float yOff = 0;
  for(float i = 0; i < itt-1; i+=1){
    for(float j = 0; j <= weight*10; j+=2){
      xOff = (j-weight*5)*rise;
      yOff = (j-weight*5)*-run;
      aSS(wU,floor(x1+xOff+i*run),floor(y1+yOff+i*rise),b);
    }
  }
  aSS(wU,floor(x1),floor(y1),b);
  aSS(wU,floor(x2),floor(y2),b);
  
}

void genRect(float x, float y, float w, float h, int b){
  w = round(w);
  h = round(h);
  x = round(x);
  y = round(y);
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      aSS(wU,(int)x+i,(int)y+j,b);
    }
  }
}

void genBox(float x, float y, float w, float h, float weight, int b){
  genLine(x,y,x+w-1,y,weight,b);
  genLine(x,y,x,y+h-1,weight,b);
  genLine(x,y+h-1,x+w-1,y+h-1,weight,b);
  genLine(x+w-1,y,x+w-1,y+h-1,weight,b);
}

void genRoundRect(float x, float y, float w, float h, float rounding, int b){
  x = round(x); y = round(y); w = round(w); h = round(h); rounding = round(rounding);
  genRect(x+rounding,y,w-rounding*2,h,b);
  genRect(x,y+rounding,w,h-rounding*2,b);
  genCircle(x+rounding,y+rounding,rounding,b);
  genCircle(x+w-rounding,y+rounding,rounding,b);
  genCircle(x+rounding,y+h-rounding,rounding,b);
  genCircle(x+w-rounding,y+h-rounding,rounding,b);
}

void genRandomProb(int from, int[] to, float[] prob){
  float totProb = 0;
  float tRand;
  int k;
  for(int i=0; i<prob.length; i++) {
    totProb += prob[i];
  }
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == from){
        tRand = random(totProb);
        k = 0;
        while(tRand > 0){
          tRand -= prob[k];
          k++;
        }
        wU[i][j] = to[k-1];
      }
    }
  }
}

void genFlood(float x, float y, int b){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    int tB = aGS(wU,x,y);
    if(tB != b){
      aSS(wU,x,y,b);  
      if(aGS(wU,x+1,y) == tB){genFlood(x+1,y,b);}
      if(aGS(wU,x-1,y) == tB){genFlood(x-1,y,b);}
      if(aGS(wU,x,y+1) == tB){genFlood(x,y+1,b);}
      if(aGS(wU,x,y-1) == tB){genFlood(x,y-1,b);}
    }
  }
}

void genReplace(int from, int to){
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == from){
        wU[i][j] = to;
      }
    }
  }
}

boolean genTestPathExists(float x1, float y1, float x2, float y2){
  nmap = new int[wSize][wSize];
  return genTestPathExistsLoop((int) x1, (int) y1, (int) x2, (int) y2);
}

boolean genTestPathExistsLoop(int x, int y, int x2, int y2){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
      if(aGS(nmap,x,y) == 0){
        if(abs(x-x2)+abs(y-y2) <= 1){
          return true;
        }
        aSS(nmap,x,y,1);  
        boolean bools = false;
        if(aGS1DB(gBIsSolid,aGS(wU,x+1,y)) == false){if(genTestPathExistsLoop(x+1,y,x2,y2)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x-1,y)) == false){if(genTestPathExistsLoop(x-1,y,x2,y2)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x,y+1)) == false){if(genTestPathExistsLoop(x,y+1,x2,y2)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x,y-1)) == false){if(genTestPathExistsLoop(x,y-1,x2,y2)){bools=true;}}
        return bools;
      }
  }
  return false;
}

boolean genTestPathExistsDis(float x1, float y1, float x2, float y2, float dis){
  nmap = new int[wSize][wSize];
  return genTestPathExistsDisLoop((int) x1, (int) y1, (int) x2, (int) y2, (int) dis);
}

boolean genTestPathExistsDisLoop(int x, int y, int x2, int y2, int dis){
  println(millis());
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
      if(aGS(nmap,x,y) == 0){
        if(abs(x-x2)+abs(y-y2) <= 1){
          return true;
        }
        aSS(nmap,x,y,1);  
        boolean bools = false;
        if(aGS1DB(gBIsSolid,aGS(wU,x+1,y)) == false){if(genTestPathExistsDisLoop(x+1,y,x2,y2,dis)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x-1,y)) == false){if(genTestPathExistsDisLoop(x-1,y,x2,y2,dis)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x,y+1)) == false){if(genTestPathExistsDisLoop(x,y+1,x2,y2,dis)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x,y-1)) == false){if(genTestPathExistsDisLoop(x,y-1,x2,y2,dis)){bools=true;}}
        return bools;
      }
  }
  return false;
}

boolean genSpread(int num, int from, int to){
  int froms = 0;
  int tos = 0;
  int tx, ty;
  froms = genCountBlock(from);
  if(froms <= num){
    genReplace(from, to);
    if(froms == num){
      return true;
    } else {
      return false;
    }
  }
  while(tos < num){
    tx = floor(random(wSize));
    ty = floor(random(wSize));
    if(wU[tx][ty] == from){
      wU[tx][ty] = to;
      tos++;
    }
  }
  return true;
}

int genCountBlock(int b){
  int count = 0;
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == b){
        count++;
      }
    }
  }
  return count;
}

boolean genLoadMap(PImage thisImage){
  if(thisImage.width == wSize && thisImage.height == wSize){
    thisImage.loadPixels();
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        wU[i][j] = int(blue(thisImage.pixels[i+j*wSize]));
      }
    }
  }
  return false;
}

void genSpreadClump(int n, int from, int to, int seeds, int[] falloff){
  int total = 0;
  if(genCountBlock(from)>=n){
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        if(aGS(wU,i,j) == from){
          distanceMatrix[i][j] = 6;
        } else {
          distanceMatrix[i][j] = 0;
        }
      }
    }
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        if(aGS(distanceMatrix,i,j) == 6){
          if(aGS(wU,i+1,j) == to || aGS(wU,i-1,j) == to || aGS(wU,i,j+1) == to || aGS(wU,i,j-1) == to){
            distanceMatrix[i][j] = 1;
          }
        }
      }
    }
    
    while(total < seeds){
      int x = floor(random(wSize));
      int y = floor(random(wSize));
      if(aGS(wU,x,y) == from){
        aSS(wU,x,y,to);
        pinDistanceMatrix(x,y,0);
        total++;
      }
    }
    while(total < n){
      int x = floor(random(wSize));
      int y = floor(random(wSize));
      if(aGS(distanceMatrix,x,y)<6){
        int tempDis = aGS(distanceMatrix,x,y);
        if(tempDis > 0){
          if(random(100)<falloff[tempDis-1]){
            aSS(wU,x,y,to);
            pinDistanceMatrix(x,y,0);
            total++;
          }
        }
      }
    }
    
  } else {
    genReplace(from, to);
  }
}

void pinDistanceMatrix(int x, int y, int d){
  if(aGS(distanceMatrix,x,y)>d){
    aSS(distanceMatrix,x,y,d);
    if(aGS(distanceMatrix,x+1,y)>d+1){pinDistanceMatrix(x+1,y,d+1);}
    if(aGS(distanceMatrix,x-1,y)>d+1){pinDistanceMatrix(x-1,y,d+1);}
    if(aGS(distanceMatrix,x,y+1)>d+1){pinDistanceMatrix(x,y+1,d+1);}
    if(aGS(distanceMatrix,x,y-1)>d+1){pinDistanceMatrix(x,y-1,d+1);}
  }
  
}

//STEM Phagescape API v(see above)
//STEM Phagescape API v(see above)

/*
int wavePixels = 100;
int waveFrames = 60;
int waveHeight = 25;
int waveOffset = 13;
int waveStroke = 6;
PGraphics[] waveGraphics;
PImage[] waveImages;
int adder;
*/

void waveGrid(){
  gM = new int[ceil(gSize)*2+1][ceil(gSize)*2+1];
  wL.clear();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      
      if(aGS(gUShade,i,j) == 0){
        //gM[i*2+1][j*2+1] = -2;
      } else {
        gM[i*2+1][j*2+1] = aGS(gU,i,j);
      }
      
      
      //if(gUHUD[i][j] == false){gM[i*2+1][j*2+1] = 255;}
    }
  }
  for(int i = 0; i < gSize*2+1; i++){
    for(int j = 0; j < gSize*2+1; j++){
      if(i%2!=j%2){
        if(gBColor[gM[min(i+1,ceil(gSize)*2)][j]] != gBColor[gM[max(i-1,0)][j]]){
           wL.add(new Wave(i,j,0,1,(j+i)%4-2));
         }
        if(gBColor[gM[i][min(j+1,ceil(gSize)*2)]] != gBColor[gM[i][max(j-1,0)]]){
          wL.add(new Wave(i,j,1,0,(j+i+2)%4-2));
        }
      }
    }
  }
}

void arcHeightV(PVector v1,PVector v2,float h1, color c1, color c2){
  if(h1 > 0){
    stroke(c2);
  } else {
    stroke(c1);
  }
  strokeWeight(2);
  line(v1.x,v1.y,v2.x,v2.y);
  if(h1 > 0){
    fill(c2);
  } else {
    fill(c1);
  }
  
  PVector v4 = PVector.sub(v2,v1); //vector between points
  PVector v3 = PVector.add(v2,v1); //find midpoint
  v3.div(2);
  float d1 = v4.mag(); //dis
  
  float h2 = (sq(h1)+sq(d1/2))/(2*h1)-h1;
  
  v4.div(v4.mag()/h2); //unit vector between points
  v3 = PVector.add(v3,new PVector(v4.y,-v4.x));
  float d2 = v3.dist(v1); //radius
  
  PVector v11 = PVector.sub(v1,v3);
  v11.div(d2/(h1*d2*2.5/gScale));
  PVector v1C = PVector.add(v1,new PVector(v11.y,-v11.x));
  
  PVector v12 = PVector.sub(v2,v3);
  v12.div(d2/(h1*d2*2.5/gScale));
  PVector v2C = PVector.add(v2,new PVector(-v12.y,v12.x));
  
  strokeWeight(5);
  stroke(255);
  bezier(v1.x, ceil(v1.y), v1C.x, v1C.y, v2C.x, v2C.y, v2.x, v2.y);
  noStroke();
  fill(255);
  ellipse((.5-1/2)+v1.x,(.5-1/2)+v1.y,4,4);
  ellipse((.5-1/2)+v2.x,(.5-1/2)+v2.y,4,4);
}

/*
void arcHeightV2(int tI){
  PVector v1 = new PVector(0,waveOffset-1);
  PVector v2 = new PVector(wavePixels,waveOffset-1);
  float h1 = -1*(wavePixels/10)*sin(float(tI)/(waveFrames-1)*PI/2);
  
  PVector v4 = PVector.sub(v2,v1); //vector between points
  PVector v3 = PVector.add(v2,v1); //find midpoint
  v3.div(2);
  float d1 = v4.mag(); //dis
  
  float h2 = (sq(h1)+sq(d1/2))/(2*h1)-h1;
  
  v4.div(v4.mag()/h2); //unit vector between points
  v3 = PVector.add(v3,new PVector(v4.y,-v4.x));
  float d2 = v3.dist(v1); //radius
  
  PVector v11 = PVector.sub(v1,v3);
  v11.div(d2/(h1*d2*2.5/wavePixels));
  PVector v1C = PVector.add(v1,new PVector(v11.y,-v11.x));
  
  PVector v12 = PVector.sub(v2,v3);
  v12.div(d2/(h1*d2*2.5/wavePixels));
  PVector v2C = PVector.add(v2,new PVector(-v12.y,v12.x));
  
  waveGraphics[tI].strokeWeight(waveStroke);
  waveGraphics[tI].noFill();
  waveGraphics[tI].stroke(255);
  waveGraphics[tI].bezier(v1.x, ceil(v1.y), v1C.x, v1C.y, v2C.x, v2C.y, v2.x, v2.y);
}
*/
class Wave {
  PVector a;
  PVector b;
  int amp;
  float shift;
  color c1;
  color c2;
  
  boolean wDir;
  Wave(int tx, int ty, int ta, int tb, int tAmp) {
    wDir = boolean(ta);
    a = new PVector(floor((tx+1-ta)/2),floor((ty+1-tb)/2));
    b = new PVector(floor((tx+1+ta)/2),floor((ty+1+tb)/2));
    amp = tAmp;
    shift = (tx+ty+(wView.x+wView.y)*2)*PI/30;
    c1 = aGS1D(gBColor,aGS(gM,tx-tb,ty+ta));
    c2 = aGS1D(gBColor,aGS(gM,tx+tb,ty-ta));
  }
  void display() {
    PVector ta = pos2Screen(grid2Pos(new PVector(a.x,a.y)));
    PVector tb = pos2Screen(grid2Pos(new PVector(b.x,b.y)));
    
    //float tH = -1*(wavePixels/10)*sin(posMod(amp*floor((wPhase+shift)*10),waveFrames*4)/(waveFrames-1)*PI/2);
    
    //strokeWeight(1);
    
    
    
    //gridBuffer.strokeWeight(gScale/15-3);
    //gridBuffer.stroke(strokeColor);
    
    int strokeWe = ceil((gScale/15-3)/2);
    rectL.add(new RectObj(ceil(ta.x)+ceil(gScale)-strokeWe,ceil(ta.y)+ceil(gScale)-strokeWe,ceil(tb.x)+ceil(gScale)-ceil(ta.x+ceil(gScale))+strokeWe,int(tb.y)+ceil(gScale)-int(ta.y+ceil(gScale))+strokeWe,color(255)));
    
    //gridBuffer.line(ta.x+ceil(gScale),ta.y+ceil(gScale),tb.x+ceil(gScale),tb.y+ceil(gScale));
    //gridBuffer.noStroke();
    //gridBuffer.fill(255);
    //ellipse(ta.x,ta.y,gScale/15-1-1,gScale/15-1-1);
    //ellipse(tb.x,tb.y,gScale/15-1-1,gScale/15-1-1);
    //waveFromImage(ta.x,ta.y,amp*floor((wPhase+shift)*10),wDir);
  }
}
/*
void updateWaveImages(){
  waveGraphics = new PGraphics[waveFrames*4];
  waveImages = new PImage[waveFrames*4];
  for(int i = 0; i < waveFrames; i++){
    waveGraphics[i] = createGraphics(wavePixels,waveHeight);
    waveGraphics[i].beginDraw();
    arcHeightV2(i);
    waveGraphics[i].endDraw();
    waveImages[i] = waveGraphics[i].get();
  }
  for(int i = waveFrames; i < waveFrames*2; i++){
    waveGraphics[i] = createGraphics(waveHeight,wavePixels);
    waveGraphics[i].beginDraw();
    waveGraphics[i].rotate(-PI/2);
    waveGraphics[i].translate(-wavePixels,0);
    
    waveGraphics[i].image(waveImages[i-waveFrames],0,0);
    waveGraphics[i].endDraw();
    waveImages[i] = waveGraphics[i].get();
  }
  for(int i = waveFrames*2; i < waveFrames*3; i++){
    waveGraphics[i] = createGraphics(wavePixels,waveHeight);
    waveGraphics[i].beginDraw();
    waveGraphics[i].scale(1,-1);
    waveGraphics[i].translate(0,-waveHeight);
    
    waveGraphics[i].image(waveImages[i-waveFrames*2],0,0);
    waveGraphics[i].endDraw();
    waveImages[i] = waveGraphics[i].get();
  }
  for(int i = waveFrames*3; i < waveFrames*4; i++){
    waveGraphics[i] = createGraphics(waveHeight,wavePixels);
    waveGraphics[i].beginDraw();
    waveGraphics[i].scale(-1,1);
    waveGraphics[i].translate(-waveHeight,0);
    
    waveGraphics[i].image(waveImages[i-waveFrames*2],0,0);
    waveGraphics[i].endDraw();
    waveImages[i] = waveGraphics[i].get();
  }
}


void waveFromImage(float tx, float ty, int tI, boolean tDir){
  int tNewIndex = floor(posMod(tI,waveFrames));
  int tActualPhase = floor(posMod(tI,waveFrames*4)/waveFrames);
  noStroke();
  fill(255);
  ellipse(tx,ty,waveStroke-.5,waveStroke-.5);
  if(tDir){
    ellipse(tx+wavePixels,ty,waveStroke-.5,waveStroke-.5);
    switch(tActualPhase){
      case 0:
        image(waveImages[tNewIndex], tx, ty-waveOffset);
        break;
      case 1:
        image(waveImages[waveFrames-tNewIndex-1], tx, ty-waveOffset);
        break;
      case 2:
        image(waveImages[tNewIndex+waveFrames*2], tx,ty-waveOffset);
        break;
      case 3:
        image(waveImages[waveFrames-tNewIndex-1+waveFrames*2], tx,ty-waveOffset);
        break;
    }
  } else {
    ellipse(tx,ty+wavePixels,waveStroke-.5,waveStroke-.5);
    switch(tActualPhase){
      case 0:
        image(waveImages[tNewIndex+waveFrames], tx-waveOffset, ty);
        break;
      case 1:
        image(waveImages[waveFrames-tNewIndex-1+waveFrames], tx-waveOffset, ty);
        break;
      case 2:
        image(waveImages[tNewIndex+waveFrames+waveFrames*2], tx-waveOffset, ty);
        break;
      case 3:
        image(waveImages[waveFrames-tNewIndex-1+waveFrames+waveFrames*2], tx-waveOffset, ty);
        break;
    }
  }
}
*/

//STEM Phagescape API v(see above)
//STEM Phagescape API v(see above)

ArrayList updates = new ArrayList<PVector>();

int[][] gU; //Grid unit - contains all blocks being drawn to the screen
boolean[][] gUHUD;
int[][] gM; //Grid Mini - stores information regarding the position of block boundries and verticies for wave generation
int[][] wU; //World Unit - contains all blocks in the world


int[][] wUDamage;
boolean[][] wUText; //
int[][] wUUpdate; //
ArrayList<Entity>[][] wUEntities; //new ArrayList()[][];
float gScale; //the width and height of blocks being drawn to the screen in pixels

PGraphics gridBuffer;
PImage gridBufferImage;
PVector gridBufferPos = new PVector(0,0);
int[][] gUShade;
int[][] nmapShade;
ArrayList rectL = new ArrayList<RectObj>();
ArrayList damageL = new ArrayList<DamageObj>();
ArrayList textL = new ArrayList<TextObj>();

//searching around for entities
ArrayList eSearchResults;
int aSearchPointer;
int aSearchPointer2;
int aSearchX;
int aSearchY;
int aSearchR;


class RectObj {
  int x, y, w, h, col;
  RectObj(int tx, int ty, int tw, int th, int tcol) {
    x = tx; y = ty; w = tw; h = th; col = tcol;
  }
  void display(float offx, float offy) {
    fill(col);
    rect(offx+x,offy+y,w,h);
  }
}

class DamageObj {
  int x, y, d, posx, posy;
  float maxstage;
  DamageObj(int tx, int ty, int td, int tposx, int tposy) {
    x = tx; y = ty; d = td; posx = tposx; posy = tposy;
    maxstage = aGS1D(gBStrength,aGS(wU,posx,posy))-.01;
  }
  void display(float offx, float offy) {
    arc(offx+x,offy+y,d,d,HALF_PI,HALF_PI+TWO_PI*(float(aGS(wUDamage,posx,posy))/maxstage));
  }
}

class TextObj {
  int x, y, w, h, col;
  TextObj(int tx, int ty, int tw, int th, int tcol) {
    x = tx; y = ty; w = tw; h = th; col = tcol;
  }
  void display(float offx, float offy) {
    fill(col);
    rect(offx+x,offy+y,w,h);
  }
}

void setupWorld(){
  gScale = float(width)/(gSize-1);
  gridBuffer = createGraphics(width+ceil(gScale*2),height+ceil(gScale*2));
  gridBufferImage = createImage(width+ceil(gScale*2),height+ceil(gScale*2),RGB);
  wU = new int[wSize][wSize];
  wUText = new boolean[wSize][wSize];
  wUDamage = new int[wSize][wSize];
  gU = new int[ceil(gSize)][ceil(gSize)];
  gUHUD = new boolean[ceil(gSize)][ceil(gSize)];
  wUUpdate = new int[wSize][wSize];
  wUEntities = new ArrayList[wSize][wSize];
  miniMap = new int[wSize][wSize];
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUEntities[i][j] = new ArrayList(0);
    }
  }
}

void refreshWorld(){
  
  refreshHUD();
  gUShade = new int[floor(gSize)][floor(gSize)];
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      gU[i][j] = aGS(wU,i+wView.x,j+wView.y);
      gUShade[i][j] = aGS(nmapShade,i+wView.x,j+wView.y);
      if(i+wView.x < 0 || j+wView.y < 0 || i+wView.x >= wSize || j+wView.y  >= wSize){
        gUShade[i][j] = 0;
      }
    }
  }
  waveGrid();

  rectL.clear();
  damageL.clear();
  
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      //gridBuffer.noStroke();
      
      int thisBlock = gU[i][j];
      
      int tempColor = aGS1D(gBColor,thisBlock);
      
      float tempShade = float(gUShade[i][j])/5;
      
      PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
      
      
      if(tempShade > 1){
        tempShade = 1;
      }
      
      if(aGS1DB(gBIsSolid,thisBlock)){
        if(aGS1D(gBStrength,thisBlock) > -1){
          if(aGS(gUShade,i,j) > 0){
            if(aGS1D(gBStrength,thisBlock) > -1){
              damageL.add(new DamageObj(floor(tempV.x)+ceil(gScale*1.5),floor(tempV.y)+ceil(gScale*1.5),ceil(gScale*2/3),int(i+wView.x),int(j+wView.y)));
            }
          }
        }
      }
      //gridBuffer.fill(red(tempColor)*tempShade,green(tempColor)*tempShade,blue(tempColor)*tempShade);
      
      if(tempShade > 0){
        if(loadMiniMap){
          aSS(miniMap,i+wView.x,j+wView.y,tempColor);
        }
      }
      
      
      //gridBufferImage = toughRect(gridBufferImage, floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),ceil(gScale),ceil(gScale), color(red(tempColor)*tempShade,green(tempColor)*tempShade,blue(tempColor)*tempShade));
      //gridBufferImage.set(floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),airMonster.Img);
      if(tempColor != gBColor[0] || tempShade != 1){
        rectL.add(new RectObj(floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),ceil(gScale+.1),ceil(gScale+.1), color(red(tempColor)*tempShade,green(tempColor)*tempShade,blue(tempColor)*tempShade)));
      }
      //gridBuffer.rect(floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale),ceil(gScale),ceil(gScale)); //-pV.x*gScale
      
      /*
      if(sBHasImage[thisBlock]){
        float tScale;
        if(sBImageDrawType[thisBlock] == 0){
          //gridBuffer.image(sBImage[thisBlock],floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale));
        } else if(sBImageDrawType[thisBlock] == 1) {
          //gridBuffer.image(sBImage[thisBlock],floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale));
        } else {
          tScale = width/sBImage[thisBlock].width;
          //gridBuffer.image(sBImage[thisBlock].get(floor(tempV.x),floor(tempV.y),ceil(gScale),ceil(gScale)),floor(tempV.x)+ceil(gScale),floor(tempV.y)+ceil(gScale));
        }
      }*/
    }
  }
  
  if(gSize < 30){
    for (Wave w : (ArrayList<Wave>) wL) {
      w.display();
    }
  }
  
  gridBufferPos = new PVector(wViewCenter.x,wViewCenter.y);
  
  updateSpecialBlocks();
  
}

void moveToAnimate(PVector tV, float tTime){
  if(millis() > moveToAnimateTime.y){
    moveToAnimateStart = new PVector(wViewCenter.x,wViewCenter.y,wViewCenter.z);
    moveToAnimateEnd = new PVector(tV.x-wViewCenter.x,tV.y-wViewCenter.y);
    moveToAnimateTime = new PVector(millis(), millis()+tTime);
  }
}

void animate(){
  if(millis() <= moveToAnimateTime.y){
    float temp1 = (millis()-moveToAnimateTime.x)/(moveToAnimateTime.y-moveToAnimateTime.x);
    float temp2 = sin(temp1*PI);
    float temp3 = (-cos(temp1*PI)+1)/2;
    centerView(moveToAnimateStart.x+temp3*moveToAnimateEnd.x,moveToAnimateStart.y+temp3*moveToAnimateEnd.y);
    scaleView(moveToAnimateStart.z+temp2*10);
  }
}

void scaleView(float tGSize){
  gSize = tGSize;
  gScale = float(width)/(gSize-1);
  gU = new int[ceil(gSize)][ceil(gSize)];
  gUHUD = new boolean[ceil(gSize)][ceil(gSize)];
  refreshWorld();
}

void addGeneralBlock(int tIndex, color tColor, boolean tIsSolid, int tStrength){
  gBColor[tIndex] = tColor;
  gBIsSolid[tIndex] = tIsSolid;
  gBStrength[tIndex] = tStrength;
}

void addGeneralBlockBreak(int tIndex, int tBreakType, String tBreakCommand){
  gBBreakType[tIndex] = tBreakType;
  if(tBreakCommand != ""){
    gBBreakCommand[tIndex] = tBreakCommand;
  }
}

/*
void addImageSpecialBlock(int tIndex, PImage tImage, int tImageDrawType){
  sBHasImage[tIndex] = true;
  if(tImageDrawType == 0){
    tImage.resize(ceil(gScale), ceil(gScale));
  } else if(tImageDrawType == 1){
    tImage.resize(ceil(gScale), ceil(gScale));
  } else {
    tImage.resize(width+ceil(gScale*2), height+ceil(gScale*2));
  }
  sBImage[tIndex] = tImage;
  sBImageDrawType[tIndex] = tImageDrawType;
}
*/

/*
void addTextSpecialBlock(int tIndex, String tText, int tTextDrawType){
  sBHasText[tIndex] = true;
  sBText[tIndex] = tText;
  sBTextDrawType[tIndex] = tTextDrawType;
}
*/

void addActionSpecialBlock(int tIndex, int tAction){
  sBHasAction[tIndex] = true;
  sBAction[tIndex] = tAction;
}

void centerView(float ta, float tb){
  wViewCenter = new PVector(ta,tb,gSize);
  wView = new PVector(ta-(gSize-1)/2,tb-(gSize-1)/2);
  if(floor(wViewLast.x) != floor(wView.x) || floor(wViewLast.y) != floor(wView.y)){
    refreshWorld();
    wPhase -= PI;
    debugLog(color(0,255,255));
  }
  wViewLast = new PVector(wView.x,wView.y);
}

void updateWorld(){
  if(updates.size() > 0) {
    int removedUpdates = 0;
    while(updates.size()-removedUpdates > 0){
      PVector update;
      for (int i = updates.size() - 1; i >= 0; i--) {
        update = (PVector) updates.get(i);
        if(update.z == 20){
          if(updateBlock(int(update.x),int(update.y))){
            update.z = -1;
          } else {
            update.z = 0;
          }
        }
        if(update.z == 21){
          update.z = 20;
        }
      }
      for (int i = updates.size() - 1; i >= 0; i--) {
        update = (PVector) updates.get(i);
        if(update.z == -1){
          if(!updateExists(update.x+1,update.y)){updates.add(new PVector(update.x+1,update.y,21));}
          if(!updateExists(update.x-1,update.y)){updates.add(new PVector(update.x-1,update.y,21));}
          if(!updateExists(update.x,update.y+1)){updates.add(new PVector(update.x,update.y+1,21));}
          if(!updateExists(update.x,update.y-1)){updates.add(new PVector(update.x,update.y-1,21));}
        }
        if(update.z == 0 || update.z == -1){update.z = -2; removedUpdates++; /*segments.add(new Segment("="+str(int(update.x))+";"+str(int(update.y))+";"+str(aGS(wU,update.x,update.y))+"&", 2));*/}
      }
    }
    refreshWorld();
    updates.clear();
  }
}

boolean updateBlock(int x, int y){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    int tempBT = aGS(wU,x,y);
    if(aGS1DB(sBHasAction,tempBT)){
      int tAction = sBAction[tempBT];
      if(tAction == 0){
        //if(aGS(wUP,x+xs,y+ys) == aGS(wU,x,y))
        //aSS(wUC,x,y,aGS1D(gBBreakType,tempBT)); //what is action 0 again? - needs updated to new system of update list
      }
      if(tAction == 46){
        //if(aGS(wUP,x,y) == tempBT){
          hitBlock(x,y,10000,false);
          return true;
        //}
      }
    }
  }
  return false;
}

void updateSpecialBlocks(){
  boolean updateAgain = true;
  
  int updateDist = 10;
  int capX = min(max(floor(player.x)+updateDist,0),wSize-1);
  int capY = min(max(floor(player.y)+updateDist,0),wSize-1);
  
  while(updateAgain){
    updateAgain = false;
    for(int i = min(max(floor(player.x)-updateDist,0),wSize-1); i <= capX; i++){
      for(int j = min(max(floor(player.y)-updateDist,0),wSize-1); j <= capY; j++){
        if(aGS1DB(sBHasAction,aGS(wU,i,j))){
          int thisBlock = aGS(wU,i,j);
          int tAction = sBAction[thisBlock];
          
          if(tAction >= 1 && tAction <= 10){
            if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<tAction){
              hitBlock(i,j,10000,false);
              updateAgain = true;
            }
          }
          if(tAction >= 11 && tAction <= 20){
            if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<tAction-10){
              if(genTestPathExists(player.x,player.y,i,j)){
                hitBlock(i,j,10000,false);
                updateAgain = true;
              }
            }
          }
          if(tAction >= 21 && tAction < 30){
            if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<=tAction-20){
              if(genTestPathExists(player.x,player.y,i,j)){
                if(rayCast(i,j,(int)player.x,(int)player.y,true)){
                  hitBlock(i,j,10000,false);
                  updateAgain = true;
                }
              }
            }
          }
        }
      }
    }
  }
}

/*
void updateBlockLight(int x, int y){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    wUCovers[x][y] = wU[x][y];
    int tempBT = aGS(wU,x,y);
    if(aGS1DB(sBHasAction,tempBT)){
      int tAction = sBAction[tempBT];
      if(tAction == 51){
        
        int[] array1 = new int[8];
        int tempCounter = 0;
        if(aGS(wU,x+1,y) != tempBT && gBIsSolid[aGS(wU,x+1,y)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x+1,y); tempCounter++;}
        if(aGS(wU,x+1,y+1) != tempBT && gBIsSolid[aGS(wU,x+1,y+1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x+1,y+1); tempCounter++;}
        if(aGS(wU,x,y+1) != tempBT && gBIsSolid[aGS(wU,x,y+1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x,y+1); tempCounter++;}
        if(aGS(wU,x-1,y+1) != tempBT && gBIsSolid[aGS(wU,x-1,y+1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x-1,y+1); tempCounter++;}
        if(aGS(wU,x-1,y) != tempBT && gBIsSolid[aGS(wU,x-1,y)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x-1,y); tempCounter++;}
        if(aGS(wU,x-1,y-1) != tempBT && gBIsSolid[aGS(wU,x-1,y-1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x-1,y-1); tempCounter++;}
        if(aGS(wU,x,y-1) != tempBT && gBIsSolid[aGS(wU,x,y-1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x,y-1); tempCounter++;}
        if(aGS(wU,x+1,y-1) != tempBT && gBIsSolid[aGS(wU,x+1,y-1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x+1,y-1); tempCounter++;}
        int[] array2 = new int[tempCounter];
        arrayCopy(array1,array2,tempCounter);
        int newCover = tempBT;
        if(tempCounter > 0){
          newCover = mode(array2);
        }
        wUCovers[x][y] = newCover;
        
      }
    }
  }
}
*/

void updateSpawners(){
  int spawnDist = 5;
  int capX = min(max(floor(player.x)+spawnDist,0),wSize-1);
  int capY = min(max(floor(player.y)+spawnDist,0),wSize-1);
  for(int i = min(max(floor(player.x)-spawnDist,0),wSize-1); i <= capX; i++){
    for(int j = min(max(floor(player.y)-spawnDist,0),wSize-1); j <= capY; j++){
      if(aGS1DB(sBHasAction,wU[i][j])){
        int tempBlock = wU[i][j];
        int tempAction = aGS1D(sBAction,tempBlock);
        if(tempAction >= 31 && tempAction <= 45){
          if(nmapShade[i][j] > 0){
            particleEffect(i-.25,j-.25,1.5,1.5,3,aGS1DC(gBColor,aGS(wU,i,j)),color(255),0.03);
            
            if(tempAction < 45){
              if(random(100) < 25){
                tempAction++;
              }
            }
            
            if(tempAction == 45){
            //try to spawn
            
              float tempX;
              float tempY;
              for(int k = 0; k < 5; k++){
                tempX = random(5)-2.5;
                tempY = random(5)-2.5;
                if(aGS(nmapShade,i+tempX+.5,j+tempY+.5) > 0){
                  if(boxHitsBlocks(i+tempX+.5,j+tempY+.5,.6,.6) == false){ //add enemy size
                    //addEntity(new Entity(i+tempX+.5,j+tempY+.5, EC_AIR_MONSTER,random(TWO_PI)));
                    aSS1D(sBAction,tempBlock,31+floor(random(10)));
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void drawWorld(){
  if(alpha(gBColor[0]) == 255){
    background(gBColor[0]);
  }
  
  noStroke();
  int baseDrawX = int((gridBufferPos.x-wViewCenter.x)*gScale-gScale);
  int baseDrawY = int((gridBufferPos.y-wViewCenter.y)*gScale-gScale);
  for(RectObj tempObj : (ArrayList<RectObj>) rectL) {
    tempObj.display(baseDrawX,baseDrawY);
  }
  noFill();
  stroke(strokeColor);
  strokeWeight(gScale/15);
  for(DamageObj tempObj : (ArrayList<DamageObj>) damageL) {
    tempObj.display(baseDrawX,baseDrawY);
  }
  for(TextObj tempObj : (ArrayList<TextObj>) textL) {
    tempObj.display(baseDrawX,baseDrawY);
  }
  /*
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      int thisBlock = gU[i][j];
      if(sBHasText[thisBlock]){
        PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
        if(sBTextDrawType[thisBlock] == 0){
          drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock],255);
        } else if(sBTextDrawType[thisBlock] <= 10) {
          if(pointDistance(new PVector(width/2-gScale/2,height/2-gScale/2),tempV) < sBTextDrawType[thisBlock]*gScale){
            drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock],255);
          }
        } else if(sBTextDrawType[thisBlock] <= 20) {
          PVector tempV2 = grid2Pos(new PVector(i,j));
          if(pointDistance(new PVector(width/2-gScale/2,height/2-gScale/2),tempV) < (sBTextDrawType[thisBlock]-10)*gScale){
            if(aGS2DB(wUText,tempV2.x,tempV2.y) == false){
              cL.add(new Chat(sBText[thisBlock]));
              aSS2DB(wUText,tempV2.x,tempV2.y,true);
            }
          } else {
            aSS2DB(wUText,tempV2.x,tempV2.y,false);
          }
        }
      }
    }
  }
  */
}

PVector screen2Pos(PVector tA){tA.div(gScale);tA.add(wView); return tA;}

PVector pos2Screen(PVector tA){tA.sub(wView); tA.mult(gScale); return tA;}

PVector grid2Pos(PVector tA){tA.add(new PVector(floor(wView.x),floor(wView.y))); return tA;}

//PVector pos2Grid(PVector tA){tA.sub(new PVector(floor(wView.x),floor(wView.y))); return tA;}

void moveInWorld(PVector tV, PVector tS, float tw, float th){
  if(tS.x > 0){
    if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y+th/2)) || aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y-th/2))){
      tS = new PVector(0,tS.y);
      
      tV.x = floor(tV.x+tw/2+tS.x)+.999-tw/2;
    }
  } else if(tS.x < 0) {
    if(aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2+tS.x,tV.y+th/2)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2+tS.x,tV.y-th/2))){
      tS = new PVector(0,tS.y);
      tV.x = floor(tV.x-tw/2+tS.x)+tw/2;
    }
  }
  tV.x += tS.x;
  
  if(tS.y > 0){
    if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2,tV.y+th/2+tS.y)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2,tV.y+th/2+tS.y))){
      tS = new PVector(tS.x,0);
      tV.y = floor(tV.y+th/2+tS.y)+.999-th/2;
    }
  } else if(tS.y < 0){
    if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2,tV.y-th/2+tS.y)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2,tV.y-th/2+tS.y))){
      tS = new PVector(tS.x,0);
      tV.y = floor(tV.y-th/2+tS.y)+th/2;
    }
  }
  tV.y += tS.y;
}

boolean[] getSolidAround(PVector pos, int dir, boolean clockwise){ //array get safe
  //dir = posMod(dir);
  boolean[] tempBool = new boolean[8];
  if(clockwise == false){
    tempBool[(int)posMod(0-dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y-1)];
    tempBool[(int)posMod(1-dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y-1)];
    tempBool[(int)posMod(2-dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y)];
    tempBool[(int)posMod(3-dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y+1)];
    tempBool[(int)posMod(4-dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y+1)];
    tempBool[(int)posMod(5-dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y+1)];
    tempBool[(int)posMod(6-dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y)];
    tempBool[(int)posMod(7-dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y-1)];
  } else {
    tempBool[(int)posMod(0+dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y-1)];
    tempBool[(int)posMod(7+dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y-1)];
    tempBool[(int)posMod(6+dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y)];
    tempBool[(int)posMod(5+dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y+1)];
    tempBool[(int)posMod(4+dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y+1)];
    tempBool[(int)posMod(3+dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y+1)];
    tempBool[(int)posMod(2+dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y)];
    tempBool[(int)posMod(1+dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y-1)];
  }
  return tempBool;
}

PVector blockNear(PVector eV,int tBlock, float tChance){
  float minDis = wSize*wSize;
  PVector tRV = new PVector(random(wSize),random(wSize));
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == tBlock){
        if(random(100)<tChance){
          if(pointDistance(eV, new PVector(i,j)) < minDis){
            tRV = new PVector(i,j);
            minDis = pointDistance(eV,tRV);
          }
        }
      }
    }
  }
  return tRV;
}

PVector blockNearCasting(PVector eV,int tBlock){
  float minDis = 25;
  PVector tRV = new PVector(eV.x,eV.y);
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == tBlock){
        if(pointDistance(eV, new PVector(i,j)) < minDis){
          if(rayCast(i,j,(int) eV.x,(int) eV.y,true)){
            tRV = new PVector(i,j);
            minDis = mDis(eV.x,eV.y, i,j);
          }
        }
      }
    }
  }
  return tRV;
}

boolean rayCast(float x0, float y0, float x1, float y1, boolean ignoreEnds){
  boolean tClear = true;
  int itts = ceil(mDis(x0,y0,x1,y1)*5);
  float tempDispX = (x1-x0)/itts;
  float tempDispY = (y1-y0)/itts;
  
  PVector res = pos2Screen(new PVector(x0,y0));
  PVector res1 = pos2Screen(new PVector(x1,y1));
  
  
  for(int i = 0; i < itts; i++){
    if(ignoreEnds == false || ((floor(x0+tempDispX*i) != floor(x0) || floor(y0+tempDispY*i) != floor(y0)) && (floor(x0+tempDispX*i) != floor(x1) || floor(y0+tempDispY*i) != floor(y1)))){
      if(gBIsSolid[aGS(wU,floor(x0+tempDispX*i),floor(y0+tempDispY*i))]){
        stroke(255,0,0);
        line(res.x,res.y,res1.x,res1.y);
        return false;
      }
    }
  }
  stroke(0,255,0);
  line(res.x,res.y,res1.x,res1.y);
  return true;
}

int rayCastPath(ArrayList a, int x1, int y1){
  PVector tempPV;
  for(int i = a.size()-1; i >= 0; i--){
    tempPV = (PVector)a.get(i);
    if(rayCast((int)tempPV.x, (int)tempPV.y, x1, y1,true)){
      return i;
    }
  }
  return -1;
}

void hitBlock(float x, float y, int hardness, boolean sent){
  if(aGS1D(gBStrength,aGS(wU,x,y)) >= 0 || hardness >= 999){
    aSS(wUDamage,x,y,aGS(wUDamage,x,y)+hardness);
    if(sent == false){segments.add(new Segment("HB,"+str(int(x))+","+str(int(y))+","+str(aGS(wU,x,y))+","+str(hardness), 5));}
    
    if(aGS(wUDamage,x,y) > aGS1D(gBStrength,aGS(wU,x,y))){
      
      if(!updateExists(int(x),int(y))){
        updates.add(new PVector(int(x),int(y),-1));
      }
      if(aGS1DS(gBBreakCommand,aGS(wU,x,y)) != null){
        tryCommand(StringReplaceAll(StringReplaceAll(aGS1DS(gBBreakCommand,aGS(wU,x,y)),"_x_",str(int(x))),"_y_",str(int(y))),"");//aGS1DS(gBBreakCommand,wUP[i][j])
      }
      color tempC = aGS1DC(gBColor,aGS(wU,x,y));
      aSS(wU,x,y,aGS1D(gBBreakType,aGS(wU,x,y)));
      particleEffect(x,y,1,1,15,tempC,aGS1DC(gBColor,aGS(wU,x,y)),.01);
        
        
      
      aSS(wUDamage,x,y,0);
    } else if(aGS(wUDamage,x,y) < 0){
      aSS(wUDamage,x,y,0);
    }
  }
}

boolean updateExists(float x, float y){
  for (PVector update : (ArrayList<PVector>) updates) {
    if(update.x == x && update.y == y){
      return true;
    }
  }
  return false;
}

PVector findBreakableNear(float x, float y, int searchR){
  int tX = (int) x;
  int tY = (int) y;
  int iN, iX, iY, i = 0, tB;
  PVector myReturn = new PVector(-1,-1);
  boolean looping = true;
  while(looping){
    iN = max(i*4,1);
    for(int j = 0; j < iN; j++){
      iX = tX+min(j,i)-min(2*i,max(0,(j-i)))+max(0,(j-i*3));
      iY = tY-i+min(2*i,j)-max(0,(j-2*i));
      if(iX >= 0 && iY >= 0 && iX < wSize && iY < wSize){
        tB = wU[iX][iY];
        if(tB != 0){
          if(gBIsSolid[tB]){
            if(gBStrength[tB] >= 0){
              myReturn = new PVector(iX,iY);
              looping = false;
              if(j != 0 && j != i && j != i*2 & j != i*3){
                break;
              }
            }
          }
        }
      }
    }
    i++;
    if(i > searchR){
      looping = false;
    }
  }
  return myReturn;
}

void resetSearches(float x, float y, int r){
  aSearchPointer = 0;
  aSearchPointer2 = 0;
  
  aSearchX = (int) x;
  aSearchY = (int) y;
  aSearchR = r;
}

ArrayList findEntityGrid(){
  int iN, iX, iY;
  ArrayList eL, tempReturn;
  boolean looping = true;
  tempReturn = new ArrayList<Entity>();
  while(looping){
    iN = max(aSearchPointer*4,1);
    while(aSearchPointer2 < iN){
      iX = aSearchX+min(aSearchPointer2,aSearchPointer)-min(2*aSearchPointer,max(0,(aSearchPointer2-aSearchPointer)))+max(0,(aSearchPointer2-aSearchPointer*3));
      iY = aSearchY-aSearchPointer+min(2*aSearchPointer,aSearchPointer2)-max(0,(aSearchPointer2-2*aSearchPointer));
      if(iX >= 0 && iY >= 0 && iX < wSize && iY < wSize){
        
        if(wUEntities[iX][iY].size() > 0){
          
          eL = wUEntities[iX][iY];
          for(int i = eL.size()-1; i >= 0; i--){
            tempReturn.add(eL.get(i));
          }
          aSearchPointer2++;
          return tempReturn;
        }
      }
      aSearchPointer2++;
    }
    aSearchPointer2 = 0;
    aSearchPointer++;
    if(aSearchPointer > aSearchR){
      looping = false;
    }
  }
  return null;
}

PVector findNonAirWU(){
  int iN, iX, iY;
  boolean looping = true;
  while(looping){
    iN = max(aSearchPointer*4,1);
    while(aSearchPointer2 < iN){
      iX = aSearchX+min(aSearchPointer2,aSearchPointer)-min(2*aSearchPointer,max(0,(aSearchPointer2-aSearchPointer)))+max(0,(aSearchPointer2-aSearchPointer*3));
      iY = aSearchY-aSearchPointer+min(2*aSearchPointer,aSearchPointer2)-max(0,(aSearchPointer2-2*aSearchPointer));
      if(iX >= 0 && iY >= 0 && iX < wSize && iY < wSize){
        if(wU[iX][iY] != 0){
          aSearchPointer2++;
          return new PVector(iX,iY);
        }
      }
      aSearchPointer2++;
    }
    aSearchPointer2 = 0;
    aSearchPointer++;
    if(aSearchPointer > aSearchR){
      looping = false;
    }
  }
  return null;
}

/*
Entity getGridEntity(ArrayList eL, int tTeam){
  if(eL.size() > 0){
    if(eL.size() == 1){
      if(EConfigs[((Entity)eL.get(0)).EC].Team == tTeam){
        return (Entity)eL.get(0);
      }
    } else {
      for(int i = eL.size()-1; i >= 0; i--){
        if(EConfigs[((Entity)eL.get(i)).EC].Team == tTeam){
          return (Entity)eL.get(i);
        }
      }
    }
  }
  return null;
}
*/

void removeEntityFromGridPos(ArrayList eL, int tID){
  if(eL.size() == 0){
    return;
  } else if(eL.size() == 1){
    if(((Entity)eL.get(0)).ID == tID){
      eL.remove(0);
      return;
    }
  } else {
    for(int i = eL.size()-1; i >= 0; i--){
      if(((Entity)eL.get(i)).ID == tID){
        eL.remove(i);
      }
    }
    return;
  }
}

void addEntityToGridPos(ArrayList eL, Entity tE){
  if(eL.size() == 0){
    eL.add(tE);
    return;
  } else if(eL.size() == 1){
    if(((Entity)eL.get(0)).ID != tE.ID){
      eL.add(tE);
      return;
    }
  } else {
    boolean foundSelf = false;
    for(int i = eL.size()-1; i >= 0; i--){
      if(((Entity)eL.get(i)).ID == tE.ID){
        foundSelf = true;
      }
    }
    if(foundSelf == false){
      eL.add(tE);
      return;
    }
  }
}

void removeEntityFromGridArea(float x1, float y1, float tx2, float ty2, int tID){
  int x2 = min(max((int) tx2,0),wSize-1);
  int y2 = min(max((int) ty2,0),wSize-1);
  for(int i = min(max((int) x1,0),wSize-1); i <= x2; i++){
    for(int j = min(max((int) y1,0),wSize-1); j <= y2; j++){
      removeEntityFromGridPos(aGSAL(wUEntities,i,j),tID);
    }
  }
}

void addEntityToGridArea(float x1, float y1, float tx2, float ty2, Entity tE){
  int x2 = min(max((int) tx2,0),wSize-1);
  int y2 = min(max((int) ty2,0),wSize-1);
  for(int i = min(max((int) x1,0),wSize-1); i <= x2; i++){
    for(int j = min(max((int) y1,0),wSize-1); j <= y2; j++){
      addEntityToGridPos(aGSAL(wUEntities,i,j),tE);
    }
  }
}

ArrayList getEntitiesFromGridAreaOther(float x1, float y1, float tx2, float ty2, int tID){
  ArrayList myReturn = new ArrayList();
  ArrayList tempAL;
  int x2 = min(max((int) tx2,0),wSize-1);
  int y2 = min(max((int) ty2,0),wSize-1);
  for(int i = min(max((int) x1,0),wSize-1); i <= x2; i++){
    for(int j = min(max((int) y1,0),wSize-1); j <= y2; j++){
      tempAL = aGSAL(wUEntities,i,j);
      switch(tempAL.size()){
        case 0:
          break;
        case 1:
          if(((Entity)tempAL.get(0)).ID != tID){
            addUniqueEntityAL(myReturn,(Entity)tempAL.get(0));
          }
          break;
        default:
          for(int k = tempAL.size()-1; k >= 0; k--){
            if(((Entity)tempAL.get(k)).ID != tID){
              addUniqueEntityAL(myReturn,(Entity)tempAL.get(k));
            }
          }
          break;
      }
    }
  }
  return myReturn;
}

void addUniqueEntityAL(ArrayList Tal, Entity Te){
  switch(Tal.size()){
    case 0:
      Tal.add(Te);
      return;
    case 1:
      if(((Entity)Tal.get(0)).ID != Te.ID){
        Tal.add(Te);
        return;
      }
      break;
    default:
      for(int i = Tal.size()-1; i >= 0; i--){
        //println(str(i)+"ESCAPE "+str(((Entity)Tal.get(i)).ID)+" "+Te.ID);
        if(((Entity)Tal.get(i)).ID == Te.ID){
          //println("EQ");
          return;
        }
      }
      Tal.add(Te);
      return;
  }
}

//STEM Phagescape API v(see above)
/*

boolean bEdit = false;
int[][] bU;
int bW = 18;
int bH = 26;
float bHScale;
float bVScale;
PGraphics pg1;
PGraphics pg2;
ArrayList membraneL = new ArrayList<float[]>();

void setupBEdit(){
  bHScale = ceil(((float(width)/3*2)/bW));
  bVScale = ceil((float(height)/bH));
  bU = new int[bW][bH];
  
  pg1 = createGraphics(ceil(bHScale), ceil(bVScale));
  pg2 = createGraphics(ceil(bHScale), ceil(bVScale));
}

void drawBEdit(){
  background(0);
  
  stroke(255);
  strokeWeight(5);
  line(width/3*2,0,width/3*2,height);
  strokeWeight(2);
  line(width/6*5,0,width/6*5,height);
  
  for(int i = 0; i < bW; i++){
    for(int j = 0; j < bH; j++){
      if(bU[i][j] == 7){
        renderCilia(i*bHScale,j*bVScale,bHScale,bVScale, aGAS(bU,i,j), color(255,255,200), 7);
      }
    }
  }
  
  membraneL = new ArrayList<float[]>();
  fill(255);
  rectMode(CORNER);
  for(int i = 0; i < bW; i++){
    for(int j = 0; j < bH; j++){
      if(bU[i][j] != 0){
        if(bU[i][j] != 1 && bU[i][j] != 5 && bU[i][j] != 8){
          fill(bBlockColor(bU[i][j]));
          noStroke();
          rect(i*bHScale,j*bVScale,bHScale,bVScale);
        }
        if(bU[i][j] == 1){
          linkSmooth(i*bHScale,j*bVScale,bHScale,bVScale,1, aGAS(bU,i,j), color(0,127,255));
        }
        if(bU[i][j] == 2){
          strokeWeight(4); stroke(150,0,150); noFill(); ellipse(i*bHScale+bHScale/2,j*bVScale+bVScale/2,bHScale/3*2,bVScale/3*2);
        }
        if(bU[i][j] == 4){
          strokeWeight(4); stroke(0,255,0); fill(150,255,150); ellipse(i*bHScale+bHScale/2,j*bVScale+bVScale/2,bHScale/3*2,bVScale/3*2);
        }
        if(bU[i][j] == 5){
          linkSmooth(i*bHScale,j*bVScale,bHScale,bVScale,5, aGAS(bU,i,j), color(255,255,0));
        }
        if(bU[i][j] == 8){
          linkSmooth(i*bHScale,j*bVScale,bHScale,bVScale,8, aGAS(bU,i,j), color(150,0,150));
        }
      }
    }
  }
  
  
  strokeWeight(5);
  noFill();
  for (float[] b : (ArrayList<float[]>) membraneL) {
    stroke((color)b[8]);
    bezier(b[0],b[1],b[2],b[3],b[4],b[5],b[6],b[7]);
  }
  
  
  strokeWeight(1);
  stroke(255);
  for(int i = 0; i < bH+1; i++){
    line(0,i*bVScale,bW*bHScale,i*bVScale);
  }
  for(int i = 0; i < bW+1; i++){
    line(i*bHScale,0,i*bHScale,bH*bVScale);
  }
  
  
}

void mousePressedBEdit(){
  bU[floor(mouseX/bHScale)][floor(mouseY/bVScale)] = gSelected;
}

void linkSmooth(float tx, float ty, float tw, float th, int tU, int[] tC, color tCol){
  
  strokeWeight(3);
  stroke(tCol);
  noFill();
  
  int tPointer = 0;
  int[] tCInt = new int[8];
  PVector[] tVec = new PVector[8];
  if(tC[0]==tU){tVec[tPointer] = new PVector(tx+tw/2,ty); tCInt[tPointer] = tC[1]; tPointer++;}
  if(tC[1]==tU){tVec[tPointer] = new PVector(tx+tw,ty); tCInt[tPointer] = tC[2]; tPointer++;}
  if(tC[2]==tU){tVec[tPointer] = new PVector(tx+tw,ty+th/2); tCInt[tPointer] = tC[3]; tPointer++;}
  if(tC[3]==tU){tVec[tPointer] = new PVector(tx+tw,ty+th); tCInt[tPointer] = tC[4]; tPointer++;}
  if(tC[4]==tU){tVec[tPointer] = new PVector(tx+tw/2,ty+th); tCInt[tPointer] = tC[5]; tPointer++;}
  if(tC[5]==tU){tVec[tPointer] = new PVector(tx,ty+th); tCInt[tPointer] = tC[6]; tPointer++;}
  if(tC[6]==tU){tVec[tPointer] = new PVector(tx,ty+th/2); tCInt[tPointer] = tC[7]; tPointer++;}
  if(tC[7]==tU){tVec[tPointer] = new PVector(tx,ty); tCInt[tPointer] = tC[0]; tPointer++;}
  
  if(tPointer == 2){
    tVec[2] = new PVector(tVec[1].x,tVec[0].y);
    tVec[3] = new PVector(tVec[0].x,tVec[1].y);
    tCInt[2] = tCInt[0];
    tCInt[0] = tCInt[1];
    tCInt[1] = tCInt[2];
    tCInt[2] = tCInt[0];
    boolean tRect = false;
    boolean pass = false;
    
    if(tC[0]==tU && tC[3]==tU){pass = true;}
    if(tC[0]==tU && tC[4]==tU){tRect = true; pass = true;}
    if(tC[0]==tU && tC[5]==tU){tCInt[0] = tCInt[1]; tCInt[1] = tCInt[2]; pass = true;}
    if(tC[1]==tU && tC[3]==tU){pass = true;}
    if(tC[1]==tU && tC[4]==tU){tVec[2] = tVec[3]; pass = true;}
    if(tC[1]==tU && tC[5]==tU){tCInt[0] = tCInt[1]; tCInt[1] = tCInt[2]; pass = true;}
    if(tC[1]==tU && tC[6]==tU){tCInt[0] = tCInt[1]; tCInt[1] = tCInt[2]; pass = true;}
    if(tC[1]==tU && tC[7]==tU){tCInt[0] = tCInt[1]; tCInt[1] = tCInt[2]; pass = true;}
    if(tC[2]==tU && tC[5]==tU){tVec[2] = tVec[3]; pass = true;}
    if(tC[2]==tU && tC[6]==tU){tRect = true; tCInt[0] = tCInt[1]; tCInt[1] = tCInt[2]; pass = true;}
    if(tC[2]==tU && tC[7]==tU){tCInt[0] = tCInt[1]; tCInt[1] = tCInt[2]; tVec[2] = tVec[3]; pass = true;}
    if(tC[3]==tU && tC[5]==tU){pass = true;}
    if(tC[3]==tU && tC[6]==tU){pass = true;}
    if(tC[3]==tU && tC[7]==tU){pass = true;}
    if(tC[4]==tU && tC[7]==tU){pass = true;}
    if(tC[5]==tU && tC[7]==tU){pass = true;}
    
    if(pass){
      pg1.beginDraw();
      pg1.background(0,1);
      pg1.noStroke();
      pg1.fill(bBlockColor(tCInt[0]));
      pg1.rect(0,0,tw,th);
      pg1.endDraw();
      
      pg2.beginDraw();
      pg2.background(0,1);
      pg2.strokeWeight(2);
      pg2.stroke(1,2,3);
      pg2.line(tVec[0].x-tx,tVec[0].y-ty,tVec[1].x-tx,tVec[1].y-ty);
      
      pg2.noStroke();
      pg2.fill(1,2,3);
      pg2.triangle(tVec[0].x-tx,tVec[0].y-ty,tVec[2].x-tx,tVec[2].y-ty,tVec[1].x-tx,tVec[1].y-ty);
      if(tRect){
        pg2.rect(tVec[1].x-tx,tVec[1].y-ty,tx+tw-tVec[1].x,ty-tVec[1].y);
      }
      
      pg2.bezier(tVec[0].x-tx,tVec[0].y-ty,.75*(tx+tw/2)+.25*tVec[0].x-tx,.75*(ty+th/2)+.25*tVec[0].y-ty,.75*(tx+tw/2)+.25*tVec[1].x-tx,.75*(ty+th/2)+.25*tVec[1].y-ty,tVec[1].x-tx,tVec[1].y-ty);
      //123 to bBlockColor(tCInt[1])
      pg2.endDraw();
      
      color tCol2 = color(0,1);
      color tCol3 = bBlockColor(tCInt[1]);
      pg1.loadPixels();
      pg2.loadPixels(); 
      for (int i=0; i<pg1.pixels.length; i++) {
       if (pg2.pixels[i] != tCol2) pg1.pixels[i] = tCol3; 
      }
      pg1.updatePixels();
      
      image(pg1, tx, ty);
      
      membraneL.add(new float[]{tVec[0].x,tVec[0].y,.75*(tx+tw/2)+.25*tVec[0].x,.75*(ty+th/2)+.25*tVec[0].y,.75*(tx+tw/2)+.25*tVec[1].x,.75*(ty+th/2)+.25*tVec[1].y,tVec[1].x,tVec[1].y,tCol});
      
    } else {
      ellipse(tx+tw/2,ty+th/2,tw/2,th/2);
    }
  } else {
    ellipse(tx+tw/2,ty+th/2,tw/2,th/2);
  }
  
}

void renderCilia(float tx, float ty, float tw, float th, int[] tU, color tCol, int tThis){
  PVector tVec = new PVector(0,0);
  int tPointer = 0;
  if(tU[0]!=0 && tU[0]!=tThis){tVec = new PVector((tVec.x*tPointer+(0))/(tPointer+1),(tVec.y*tPointer+(-1))/(tPointer+1)); tPointer++;}
  if(tU[1]!=0 && tU[1]!=tThis){tVec = new PVector((tVec.x*tPointer+(1))/(tPointer+1),(tVec.y*tPointer+(-1))/(tPointer+1)); tPointer++;}
  if(tU[2]!=0 && tU[2]!=tThis){tVec = new PVector((tVec.x*tPointer+(1))/(tPointer+1),(tVec.y*tPointer+(0))/(tPointer+1)); tPointer++;}
  if(tU[3]!=0 && tU[3]!=tThis){tVec = new PVector((tVec.x*tPointer+(1))/(tPointer+1),(tVec.y*tPointer+(1))/(tPointer+1)); tPointer++;}
  if(tU[4]!=0 && tU[4]!=tThis){tVec = new PVector((tVec.x*tPointer+(0))/(tPointer+1),(tVec.y*tPointer+(1))/(tPointer+1)); tPointer++;}
  if(tU[5]!=0 && tU[5]!=tThis){tVec = new PVector((tVec.x*tPointer+(-1))/(tPointer+1),(tVec.y*tPointer+(1))/(tPointer+1)); tPointer++;}
  if(tU[6]!=0 && tU[6]!=tThis){tVec = new PVector((tVec.x*tPointer+(-1))/(tPointer+1),(tVec.y*tPointer+(0))/(tPointer+1)); tPointer++;}
  if(tU[7]!=0 && tU[7]!=tThis){tVec = new PVector((tVec.x*tPointer+(-1))/(tPointer+1),(tVec.y*tPointer+(-1))/(tPointer+1)); tPointer++;}
  
  strokeWeight(3);
  stroke(tCol);
  if(tVec.x == 0 && tVec.y == 0){
    noFill();
    ellipse(tx+tw/2,ty+th/2,tw/2,th/2);
  } else {
    tVec.div(tVec.mag()/1.6);
    line(tx+tw/2,ty+th/2,tx+tw/2+tw*tVec.x,ty+tw/2+tw*tVec.y);
  }
}

color bBlockColor(int intC){
  switch(intC){
    case 0:
      return color(0,1);
    case 1:
      return color(200,200,255);
    case 2:
      return color(200,200,255);
    case 3:
      return color(200,200,255);
    case 4:
      return color(200,200,255);
    case 5:
      return color(200,200,255);
    case 6:
      return color(255,0,255);
    case 7:
      return color(0,1);
    case 8:
      return color(200,200,255);
    default:
      return color(0);
  }
}

/*
class Membrane {
  float p
  Wave(int tx, int ty, int ta, int tb, int tAmp) {
    a = new PVector(floor((tx+1-ta)/2)*gScale,floor((ty+1-tb)/2)*gScale);
    b = new PVector(floor((tx+1+ta)/2)*gScale,floor((ty+1+tb)/2)*gScale);
    amp = tAmp;
    shift = (tx+ty+(pG.x+pG.y)*2)*PI/30;
    c1 = blockColor(gM[max(tx-tb,0)][min(ty+ta,gSize*2)]);
    c2 = blockColor(gM[min(tx+tb,gSize*2)][max(ty-ta,0)]);
  }
  void display() {
    arcHeightV(a,b,amp*(gScale/10)*sin(wPhase+shift),c1,c2);
  }
}
*//*

*/

