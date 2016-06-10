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

int particleCycle = 0;

//EConfig bulletEntity = new EConfig();



void setupEntities(){
  
  EConfigs[1] = new EConfig();
  
  EConfigs[1].Size = .13; //TO BE REMOVED
  EConfigs[EC_PLAYER] = new EConfig();
  EConfigs[EC_PLAYER].Genre = 1;
  EConfigs[EC_PLAYER].Img = loadImage("player.png");
  player = new Entity(wSize/2,wSize/2,EC_PLAYER,0);
  entities.add(player);
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
  
  int thisI;
  int EC;
  float x;
  float y;
  PVector eV;
  float eDir = 0;
  PVector eD;
  int eHealth = 1;
  float eSpeed = 0; //Player speed
  float eTSpeed = 0; //Player turn speed
  boolean eMove = false;
  
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
    ID = entityIDCycle;
    entityIDCycle++;
    //println("ID "+str(ID));
    x = tx;
    y = ty;
    eDir = tDir;
    eD = new PVector(tx+cos(tDir),ty+sin(tDir));
    EC = tEC;
    eVLast = new PVector(x,y);
    eV = new PVector(x,y);
    eID = floor(random(2147483.647))*1000;
    eHealth = EConfigs[EC].HMax;
    path.add(new PVector(eV.x, eV.y));
    
    tryCommand(StringReplaceAll(StringReplaceAll(EConfigs[EC].BirthCommand,"_x_",str(x)),"_y_",str(y)),"");
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
    eV = new PVector(x,y);
    if(EConfigs[EC].Genre == 0){
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
        eV = new PVector(x,y);
      }
    } else if(EConfigs[EC].Genre == 1){
      eMove = false;
      if(EConfigs[EC].Type == 0 || EConfigs[EC].Type == 1){
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
      if(EConfigs[EC].Type == 0){
        if(mousePressed || max(pKeys) == 1){
          if(!mousePressed){
            eD = new PVector(eV.x+(-pKeys[2]+pKeys[3]),eV.y+(-pKeys[0]+pKeys[1]));
          } else {
            eD = screen2Pos(new PVector(mouseX,mouseY));
          }
          eMove = true;
        }
      }
      if(EConfigs[EC].Type == 1){
        if(EConfigs[EC].AISearchMode > -1){
          

          
          
          if(EConfigs[EC].AISearchMode < 10){
            if(fn % EConfigs[EC].FireDelay == timeOff % EConfigs[EC].FireDelay){
              if(pointDistance(eV,AITargetPos)<EConfigs[EC].ActDist){
                if(rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y))){
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
            if(pointDistance(eV,AITargetPos)>EConfigs[EC].GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y)) == false){
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
              if(pointDistance(eV,AITargetPos)>EConfigs[EC].GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y))==false){
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
              if(pointDistance(eV,AITargetPos)>EConfigs[EC].GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y))==false){
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
                eV = new PVector(AITargetPos.x,AITargetPos.y);
              } else {
                eV = new PVector(eV.x+cos(eDir)*EConfigs[EC].SMax,eV.y+sin(eDir)*EConfigs[EC].SMax);
              }
            }
          }
        }
      }
      //PVector tVecss = pos2Screen(new PVector(eD.x,eD.y));
      //ellipse(tVecss.x,tVecss.y,30,30);
      
      eVLast = new PVector(eV.x,eV.y);
      
      if(eMove){
        if(eSpeed+EConfigs[EC].Accel < EConfigs[EC].SMax){
          eSpeed += EConfigs[EC].Accel;
        } else {
          eSpeed = EConfigs[EC].SMax;
        }
      }
      if(eSpeed-EConfigs[EC].Drag > 0){
        eSpeed -= EConfigs[EC].Drag;
      } else {
        eSpeed = 0;
      }
      if(abs(eTSpeed)+EConfigs[EC].TAccel < EConfigs[EC].TSMax){
        eTSpeed += angleDir(eDir,pointDir(eV, eD))*EConfigs[EC].TAccel;
      }
      eDir += eTSpeed*eSpeed/EConfigs[EC].SMax; //pTSpeed*pSpeed/pSMax
      if(abs(eTSpeed)-EConfigs[EC].TDrag > 0){
        eTSpeed = (abs(eTSpeed)-EConfigs[EC].TDrag)*abs(eTSpeed)/eTSpeed;
      } else {
        eTSpeed = 0;
      }
      eV = moveInWorld(eV, new PVector(eSpeed*cos(eDir),eSpeed*sin(eDir)),EConfigs[EC].Size*EConfigs[EC].HitboxScale-.5,EConfigs[EC].Size*EConfigs[EC].HitboxScale-.5);
      
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
        if(te.sourceID != ID){
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
  
    } else if(EConfigs[EC].Genre == 2){
      x += EConfigs[EC].SMax*cos(eDir);
      y += EConfigs[EC].SMax*sin(eDir);
      eV = new PVector(x,y);
      eFade += EConfigs[EC].FadeRate;
      if(eFade>1){
        destroy();
      }
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
          if(rayCast((int)tPoints[smallestIndex].x,(int)tPoints[smallestIndex].y,(int)x,(int)y)){
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
    float tempDir = pointDir(eV,tempV);
    Entity tempEntity = new Entity(x+EConfigs[EC].Size/2*cos(tempDir),y+EConfigs[EC].Size/2*sin(tempDir),EConfigs[EC].myBulletEntity,tempDir);
    tempEntity.sourceID = ID;
    entities.add(tempEntity);
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
        }
      }
    }
  }
  
  void destroy(){
    tryCommand(StringReplaceAll(StringReplaceAll(EConfigs[EC].DeathCommand,"_x_",str(x)),"_y_",str(y)),"");
    for (int i = 0; i < entities.size(); i++) {
      Entity tempE = (Entity) entities.get(i);
      if(tempE.ID == ID){
        println(str(tempE.ID)+" = "+str(ID));
        entities.remove(i);
        if(tempE.EC < 256){
          segments.add(new Segment("=" + str(ID*100+playerID) + ";dead;1&", 3));
        }
        break;
      }
    }
  }
}

class EConfig {
  float ID = random(1000);
  int Genre = 0;
  
  color Color = color(0);
  color AltColor = color(255,0,0);
  String DeathCommand = "";
  String BirthCommand = "";
  String HitCommand = "";
  
  int HMax = 20;
  float Size = 1;
  float HitboxScale = 1;
  float SMax = .15;
  
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
  
  float FadeRate = .1;
  float Vision = 100; //100 is generaly a good number... be careful with this and AI mode 3+... if > 140 and no target is near lag is created
  float GoalDist = 3; //Want to get this close
  float ActDist = 10; //Will start acting at this dis
  int FireDelay = 25;
  
  int myBulletEntity = 1;
  
  EConfig() {}
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
    entities.add(new Entity(x+random(w),y+random(h),256+(particleCycle-3+floor(random(3))),random(TWO_PI)));
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

//STEM Phagescape API v(see above)
