//STEM Phagescape API v(see above)

//EConfig[] EConfigs = new EConfig[356];

boolean[][] smap;
//int entityIDCycle = 0;
//ArrayList entities = new ArrayList<Entity>(); //Entity list - list of all entities in the world
PImage arrowImg;
/*
int EC_BULLET = 1;
int EC_NEXT(){return ecCycleNext++;}
int ecCycleNext = 2;



int particleCycle = 0;

void setupEntities(){
  
  EConfigs[EC_BULLET] = new EConfig();
  EConfigs[EC_BULLET].Size = .13; //TO BE REMOVED
  EConfigs[EC_BULLET].Team = -3;
  EConfigs[EC_PLAYER] = new EConfig();
  EConfigs[EC_PLAYER].Genre = 1;
  EConfigs[EC_PLAYER].Team = -3;
  EConfigs[EC_PLAYER].SuckRange = 1;
  EConfigs[EC_PLAYER].Img = loadImage(aj.D()+"player.png");
  player = new Entity(wSize/2,wSize/2,EC_PLAYER,0);
  addEntity(player);
}

void updateEntities(){
  for (int i = 0; i < mimics.size(); i++) {
    Mimic tempM = (Mimic) mimics.get(i);
    tempM.update();
  }
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
        sendText("FIRE",player.x+","+player.y+","+tempDir);
        //Entity tempEntity = new Entity(x+EConfigs[EC].Size/2*cos(tempDir),y+EConfigs[EC].Size/2*sin(tempDir),EConfigs[EC].myBulletEntity,tempDir);
        //tempEntity.sourceID = ID;
        //addEntity(tempEntity);
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
/*
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
*/
//STEM Phagescape API v(see above)