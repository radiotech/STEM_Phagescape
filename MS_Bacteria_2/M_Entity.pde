//STEM Phagescape API v(see above)

boolean[][] smap;

EConfig bulletEntity = new EConfig();

void setupEntities(){
  
  bulletEntity.Size = .13; //TO BE REMOVED
  player = new Entity(wSize/2,wSize/2,new EConfig(),0);
  player.EC.Genre = 1;
  player.EC.Img = loadImage("player.png");
  entities.add(player);
}

void updateEntities(){
  for (int i = entities.size()-1; i >= 0; i--) {
    Entity tempE = (Entity) entities.get(i);
    tempE.moveAI();
  }
  if((floor(player.eV.x) != floor(player.eVLast.x)) || (floor(player.eV.y) != floor(player.eVLast.y))){
    updateSpecialBlocks();
  }
}

void healEntities(){
  for (int i = entities.size()-1; i >= 0; i--) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.eHealth < tempE.EC.HMax){
      tempE.eHealth++;
    } else {
      tempE.eHealth = tempE.EC.HMax;
    }
  }
}

void drawEntities(){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    tempE.display();
  }
}

class Entity {
  float ID = random(1000);
  
  int trail = 20;
  ArrayList path = new ArrayList<PVector>();
  
  int thisI;
  EConfig EC;
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
  
  Entity(float tx, float ty, EConfig tEC, float tDir) {
    x = tx;
    y = ty;
    eDir = tDir;
    eD = new PVector(tx+cos(tDir),ty+sin(tDir));
    EC = tEC;
    eVLast = new PVector(x,y);
    eV = new PVector(x,y);
    eID = floor(random(2147483.647))*1000;
    eHealth = EC.HMax;
    path.add(new PVector(eV.x, eV.y));
    
    tryCommand(StringReplaceAll(StringReplaceAll(EC.BirthCommand,"_x_",str(x)),"_y_",str(y)),"");
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
    if(EC.Genre == 0){
      if(x>wSize+5 || x<-5 || y>wSize+5 || y<-5 || aGS1DB(gBIsSolid,aGS(wU,x,y))){
        if(aGS1DB(gBIsSolid,aGS(wU,x,y))){
          EConfig tempConfig;
          particleEffect(x-.5,y-.5,1,1,5,aGS1DC(gBColor,aGS(wU,x,y)),EC.Color,EC.SMax/5);
          hitBlock(x,y,1);
        }
        
        destroy();
        
      } else {
        x += EC.SMax*cos(eDir);
        y += EC.SMax*sin(eDir);
        eV = new PVector(x,y);
      }
    } else if(EC.Genre == 1){
      eMove = false;
      if(EC.Type == 0 || EC.Type == 1){
        if(fn % 15 == 0){
          if(EC.AIDoorBlock > -1 || EC.AIDoorBlockClose > -1){
            PVector doorCenter = new PVector(0,0);
            int pastFrames = 0;
            boolean isClosed = false;
            boolean isOpen = false;
            for(int i = -EC.AIDoorWidth; i <= EC.AIDoorWidth; i++){
              for(int j = -EC.AIDoorWidth; j <= EC.AIDoorWidth; j++){
                if(aGS(wU,x+i,y+j)==EC.AIDoorBlock || aGS(wU,x+i,y+j)==EC.AIDoorBlockClose){
                  if(pastFrames == 0){
                    doorCenter = new PVector(x+i,y+j);
                  } else if(pastFrames == 1){
                    doorCenter = new PVector((x+i+doorCenter.x)/2,(y+j+doorCenter.y)/2);
                  }
                  if(aGS(wU,x+i,y+j)==EC.AIDoorBlock){
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
                  for(int i = -EC.AIDoorWidth; i <= EC.AIDoorWidth; i++){
                    for(int j = -EC.AIDoorWidth; j <= EC.AIDoorWidth; j++){
                      if(aGS(wU,x+i,y+j)==EC.AIDoorBlock){
                        aSS(wU,x+i,y+j,gBBreakType[EC.AIDoorBlock]);
                      } else if(aGS(wU,x+i,y+j)==EC.AIDoorBlockClose){
                        aSS(wU,x+i,y+j,gBBreakType[EC.AIDoorBlockClose]);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      if(EC.Type == 0){
        if(mousePressed || max(pKeys) == 1){
          if(!mousePressed){
            eD = new PVector(eV.x+(-pKeys[2]+pKeys[3]),eV.y+(-pKeys[0]+pKeys[1]));
          } else {
            eD = screen2Pos(new PVector(mouseX,mouseY));
          }
          eMove = true;
        }
      }
      if(EC.Type == 1){
        if(EC.AISearchMode > -1){
          

          
          
          if(EC.AISearchMode < 10){
            if(fn % EC.FireDelay == timeOff % EC.FireDelay){
              if(pointDistance(eV,AITargetPos)<EC.ActDist){
                if(rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y))){
                  fire(AITargetPos);
                }
              }
            }
            if(EC.AITarget > -1){
              if(fn % 125 == 0){
              
                if(aGS(wU,AITargetPos.x,AITargetPos.y) != EC.AITarget){
                  setAITarget();
                }
              }
            } else {
              if(fn % 10 == 0){ 
                if(pointDistance(entityNearID(AITargetPos,EC.AITargetID,30,100),AITargetPos)>.2){
                  //println("HEY, YOU MOVED!");
                  setAITarget();
                }
              }
            }
            if(pointDistance(eV,AITargetPos)>EC.GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y)) == false){
              if(EC.AISearchMode == 1 || EC.AISearchMode == 2){
                if(fn % EC.FireDelay == timeOff % EC.FireDelay){
                  if(pointDistance(eVLast,eV)<EC.Drag){
                    setAITarget();
                  }
                }
                
              }
              eMove = true;
              
              if(EC.AISearchMode == 3){
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
                    if(pointDistance(eVLast,eV)<EC.Drag){
                      AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);
                    }
                  }
                }
              }
            }
          } else if(EC.AISearchMode < 30) {
            if(fn % EC.FireDelay == timeOff % EC.FireDelay){
              PVector tempTarget = entityNearID(eV,EC.AITargetID,EC.ActDist,100);
              if(tempTarget.z != -1){
                fire(AITargetPos);
              }
            }
            if(EC.AISearchMode == 11){
              if(pointDistance(eV,AITargetPos)>EC.GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y))==false){
                eMove = true;
              }
              if(fn % 25 == 0){
                setAITarget();
              }
            } else if(EC.AISearchMode == 12){
              eMove = true;
              if(fn % 250 == 0){
                AITargetPos = new PVector(eV.x,eV.y);
              }
              if(pointDistance(eV,AITargetPos) < .5){
                setAITarget();
              }
            }
            
            if(EC.AISearchMode == 21){
              if(pointDistance(eV,AITargetPos)>EC.GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y))==false){
                eMove = true;
              }
              if(fn % 35 == 0){
                setAITarget();
              }
            } else if(EC.AISearchMode == 22){
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
                  if(tempE.EC.ID == EC.AITargetID){
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
            if(EC.AISearchMode == 30){
              eDir = pointDir(eV,AITargetPos);
              if(pointDistance(eV,AITargetPos) < EC.SMax){
                eV = new PVector(AITargetPos.x,AITargetPos.y);
              } else {
                eV = new PVector(eV.x+cos(eDir)*EC.SMax,eV.y+sin(eDir)*EC.SMax);
              }
            }
          }
        }
      }
      //PVector tVecss = pos2Screen(new PVector(eD.x,eD.y));
      //ellipse(tVecss.x,tVecss.y,30,30);
      
      eVLast = new PVector(eV.x,eV.y);
      
      if(eMove){
        if(eSpeed+EC.Accel < EC.SMax){
          eSpeed += EC.Accel;
        } else {
          eSpeed = EC.SMax;
        }
      }
      if(eSpeed-EC.Drag > 0){
        eSpeed -= EC.Drag;
      } else {
        eSpeed = 0;
      }
      if(abs(eTSpeed)+EC.TAccel < EC.TSMax){
        eTSpeed += angleDir(eDir,pointDir(eV, eD))*EC.TAccel;
      }
      eDir += eTSpeed*eSpeed/EC.SMax; //pTSpeed*pSpeed/pSMax
      if(abs(eTSpeed)-EC.TDrag > 0){
        eTSpeed = (abs(eTSpeed)-EC.TDrag)*abs(eTSpeed)/eTSpeed;
      } else {
        eTSpeed = 0;
      }
      eV = moveInWorld(eV, new PVector(eSpeed*cos(eDir),eSpeed*sin(eDir)),EC.Size*EC.HitboxScale-.5,EC.Size*EC.HitboxScale-.5);
      
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
      
      if(isEntityNearGenreSpecial(eV, 0, EC.Size*EC.HitboxScale/3)) {
        Entity te = entityNearGenreSpecial(eV, 0, EC.Size*EC.HitboxScale/3);
        //tryCommand(StringReplaceAll(StringReplaceAll(te.EC.DeathCommand,"_x_",str(te.x)),"_y_",str(te.y)),"");
        if(te.sourceID != ID){
          te.destroy();
          eHealth--;
          
          tryCommand(StringReplaceAll(StringReplaceAll(EC.HitCommand,"_x_",str(x)),"_y_",str(y)),"");
          if(EC.HMax > -1 && eHealth <= 0){
            particleEffect(x-.5,y-.5,1,1,30,EC.AltColor,EC.Color,.1);
            //tryCommand(StringReplaceAll(StringReplaceAll(EC.DeathCommand,"_x_",str(x)),"_y_",str(y)),"");//aGS1DS(gBBreakCommand,wUP[i][j])
            destroy();
          }
        }
      }
  
    } else if(EC.Genre == 2){
      x += EC.SMax*cos(eDir);
      y += EC.SMax*sin(eDir);
      eV = new PVector(x,y);
      eFade += EC.FadeRate;
      if(eFade>1){
        destroy();
      }
    }
    x = eV.x;
    y = eV.y;
  }
  
  void setAITarget(){
    if(EC.AISearchMode == 0){
      if(EC.AITarget > -1){AITargetPos = blockNear(eV,EC.AITarget,100);} else {AITargetPos = entityNearID(eV,EC.AITargetID,30,100);}
    } else if(EC.AISearchMode == 1){
      if(EC.AITarget > -1){AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);} else {AITargetPos = entityNearID(eV,EC.AITargetID,30,random(90)+10);}
    } else if(EC.AISearchMode == 2){
      AITargetPos = blockNearCasting(eV,EC.AITarget);
      if(aGS(wU,AITargetPos.x,AITargetPos.y) != EC.AITarget){
        AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);
      }
    } else if(EC.AISearchMode == 3){
      
      if(aGS(wU,eV.x,eV.y) != EC.AITarget){
        searchWorld(eV,EC.AITarget,(int)EC.Vision/10);
        
        if(Apath.size()>0){
          AITargetPos = new PVector(((Node)Apath.get(0)).x,((Node)Apath.get(0)).y);
        }
      }
      
    } else if(EC.AISearchMode == 11){
      //follow path (line of sight)
      //test line of sight, if none, change mode, call again
      PVector tempTarget = rayCastAllPathsID(eV,EC.AITargetID,30);
      if(tempTarget != null){
        AITargetPos = tempTarget;
      } else {
        EC.AISearchMode = 12;
        setAITarget();
        return;
      }
    } else if(EC.AISearchMode == 12){
      //Strange (no line > 10)
      //test line of sight, change mode, call again

      if(rayCastAllPathsID(eV,EC.AITargetID,30) == null){
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
        EC.AISearchMode = 11;
        setAITarget();
        return;
      }
      
    } else if(EC.AISearchMode == 21){
      //follow path (line of sight)
      //test line of sight, if none, change mode, call again
      PVector tempTarget = rayCastAllPathsID(eV,EC.AITargetID,30);
      if(tempTarget != null){
        AITargetPos = tempTarget;
        println("aa");
      } else {
        EC.AISearchMode = 22;
        setAITarget();
        return;
      }
    } else if(EC.AISearchMode == 22){
      //Strange (no line > 10)
      //test line of sight, change mode, call again

      if(rayCastAllPathsID(eV,EC.AITargetID,30) == null){
        
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
        EC.AISearchMode = 21;
        setAITarget();
        return;
      }
      
    }
    if(EC.AITarget > -1){
      AITargetPos = new PVector(AITargetPos.x+.5,AITargetPos.y+.5);
    }
    eD = new PVector(AITargetPos.x,AITargetPos.y);
  }
  
  void fire(PVector tempV){
    float tempDir = pointDir(eV,tempV);
    Entity tempEntity = new Entity(x+EC.Size/2*cos(tempDir),y+EC.Size/2*sin(tempDir),EC.myBulletEntity,tempDir);
    tempEntity.sourceID = ID;
    entities.add(tempEntity);
  }
  
  void display() {
    if(aGS(nmapShade,x,y) > 0){
      PVector tempV = pos2Screen(new PVector(x,y));
      if(tempV.x > -gScale*EC.Size/2 && tempV.y > -gScale*EC.Size/2 && tempV.x < width+gScale*EC.Size/2 && tempV.y < height+gScale*EC.Size/2){
      
        if(EC.Genre == 0){
          //stroke(strokeColor);
          //strokeWeight(1);
          noStroke();
          fill(EC.Color);
          ellipse(tempV.x,tempV.y,EC.Size*gScale,EC.Size*gScale);
        } else if(EC.Genre == 1) {
          pushMatrix();
          translate(tempV.x,tempV.y);
          rotate(eDir+PI/2);
          image(EC.Img,-gScale/2*EC.Size,-gScale/2*EC.Size,gScale*EC.Size,gScale*EC.Size);
          popMatrix();
          
          if(eHealth > 0 && eHealth < EC.HMax && eHealth < 1000000 && EC.HMax > -1){
            float tempFade = float(eHealth)/EC.HMax;
            noFill();
            strokeWeight(gScale/15);
            stroke(255,255-tempFade*150);
            arc(tempV.x,tempV.y,gScale*(EC.Size+.1),gScale*(EC.Size+.1),-HALF_PI,-HALF_PI+TWO_PI*tempFade);
            stroke((1-tempFade)*510,tempFade*510,0,255-tempFade*150);
            arc(tempV.x,tempV.y,gScale*(EC.Size+.1),gScale*(EC.Size+.1),-HALF_PI,-HALF_PI+TWO_PI*tempFade);
          }
        } else if(EC.Genre == 2){
          stroke(strokeColor,255-eFade*255);
          strokeWeight(2);
          fill(EC.Color,255-eFade*255);
          if(EC.Type == 0){
            ellipse(tempV.x,tempV.y,EC.Size*gScale,EC.Size*gScale);
          } else if(EC.Type == 1) {
            rect(tempV.x-EC.Size*gScale/2,tempV.y-EC.Size*gScale/2,EC.Size*gScale,EC.Size*gScale);
          } else {
            rect(tempV.x-EC.Size*gScale/2,tempV.y-EC.Size*gScale/2,EC.Size*gScale,EC.Size*gScale);
          }
        }
      }
    }
  }
  
  void destroy(){
    tryCommand(StringReplaceAll(StringReplaceAll(EC.DeathCommand,"_x_",str(x)),"_y_",str(y)),"");
    for (int i = 0; i < entities.size(); i++) {
      Entity tempE = (Entity) entities.get(i);
      if(tempE.ID == ID){
        entities.remove(i);
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
  
  EConfig myBulletEntity = bulletEntity;
  
  EConfig() {}
}

void particleEffect(float x, float y, float w, float h, int num, color c1, color c2, float ts){
  for(int i = 0; i <num; i++){
    EConfig ECParticle = new EConfig();
    ECParticle.Genre = 2;
    ECParticle.Size = .1;
    ECParticle.FadeRate = random(.1)+.05;
    ECParticle.Type = floor(random(3));
    ECParticle.SMax = random(ts);
    if(random(100)<50){
      ECParticle.Color = c1;
    } else {
      ECParticle.Color = c2;
    }
    entities.add(new Entity(x+random(w),y+random(h),ECParticle,random(TWO_PI)));
  }
}

PVector entityNearID(PVector eV,float tEID, float tDis, float tChance){
  float minDis = tDis;
  PVector tRV = new PVector(random(wSize),random(wSize),-1);
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.EC.ID == tEID){
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
    if(tempE.EC.ID == tEID){
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
    if(tempE.EC.Genre == tEGenre){
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
    if(tempE.EC.Genre == tEGenre){
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
    if(tempE.EC.ID == tEID){
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
