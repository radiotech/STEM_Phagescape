void setupEntities(){
  player = new Entity(50,50,new EConfig(),0);
  player.EC.Genre = 1;
  player.EC.Img = loadImage("player.png");
  entities.add(player);
}

void updateEntities(int cycle){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    tempE.moveAI(cycle);
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
    
  int thisI;
  EConfig EC;
  float x;
  float y;
  PVector eV;
  float eDir = 0;
  PVector eD;
  float eSpeed = 0; //Player speed
  float eTSpeed = 0; //Player turn speed
  boolean eMove = false;
  
  PVector eVLast;
  
  float eFade = 0; //Particle fade
  
  int eID;
  
  PVector AITargetPos = new PVector(-1,-1);
  
  Entity(float tx, float ty, EConfig tEC, float tDir) {
    x = tx;
    y = ty;
    eDir = tDir;
    eD = new PVector(tx+cos(tDir),ty+sin(tDir));
    EC = tEC;
    eVLast = new PVector(x,y);
    eV = new PVector(x,y);
    eID = floor(random(2147483.647))*1000;
  }
  
  void moveEvent(int eventID){
    
    if(eventID == 0 || eventID == 1){
      int tempTo = 1;
      if(eventID == 1){
        tempTo = 0;
      }
      if(key == CODED){
        switch(keyCode){
          case UP:
            pKeys[0] = tempTo;
            break;
          case DOWN:
            pKeys[1] = tempTo;
            break;
          case LEFT:
            pKeys[2] = tempTo;
            break;
          case RIGHT:
            pKeys[3] = tempTo;
            break;
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
  
  void moveAI(int cycle){
    eV = new PVector(x,y);
    if(EC.Genre == 0){
      if(x>wSize || x<0 || y>wSize || y<0 || aGS1DB(gBIsSolid,aGS(wU,x,y))){
        if(aGS1DB(gBIsSolid,aGS(wU,x,y))){
          EConfig tempConfig;
          for(int i = 0; i <100; i++){
            if(random(100)<30){
              tempConfig = new EConfig();
              tempConfig.Genre = 2;
              tempConfig.Size = .1;
              tempConfig.FadeRate = random(.1)+.05;
              tempConfig.Type = floor(random(3));
              tempConfig.SMax = random(EC.SMax/5);
              if(random(100)<50){
                tempConfig.Color = aGS1DC(gBColor,aGS(wU,x,y));
              } else {
                tempConfig.Color = EC.Color;
              }
              entities.add(new Entity(x,y,tempConfig,random(TWO_PI)));
            }
          }
          aSS(wUDamage,x,y,aGS(wUDamage,x,y)+1);
        }
        destroy();
      } else {
        x += EC.SMax*cos(eDir);
        y += EC.SMax*sin(eDir);
        eV = new PVector(x,y);
      }
    } else if(EC.Genre == 1){
      eMove = false;
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
          if(cycle % 25 == 0){
            if(pointDistance(eV,AITargetPos)<EC.ActDist){
              if(rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y))){
                fire(AITargetPos);
              }
            }
          }
          if(EC.AITarget > -1){
            if(cycle % 125 == 0){
            
              if(aGS(wU,AITargetPos.x,AITargetPos.y) != EC.AITarget){
                setAITarget();
              }
            }
          } else {
            if(cycle % 10 == 0){ 
              if(pointDistance(entityNear(AITargetPos,EC.AITargetID,100),AITargetPos)>.2){
                //println("HEY, YOU MOVED!");
                setAITarget();
              }
            }
          }
          if(pointDistance(eV,AITargetPos)>EC.GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y)) == false){
            if(EC.AISearchMode == 1 || EC.AISearchMode == 2){
              if(cycle % 25 == 0){
                if(pointDistance(eVLast,eV)<EC.Drag){
                  setAITarget();
                }
              }
              
            }
            eMove = true;
            
            if(EC.AISearchMode == 3){
              if(cycle % 125 == 0){
                setAITarget();
              }
              if(floor(eVLast.x) != floor(eV.x) || floor(eVLast.y) != floor(eV.y)){
                setAITarget();
              }
              if(path.size()>0){
                eD = new PVector(((Node)path.get(path.size()-1)).x+.5,((Node)path.get(path.size()-1)).y+.5);
              } else {
                if(cycle % 25 == 0){
                  if(pointDistance(eVLast,eV)<EC.Drag){
                    AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);
                  }
                }
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
      eV = moveInWorld(eV, new PVector(eSpeed*cos(eDir),eSpeed*sin(eDir)),EC.Size-.5,EC.Size-.5);
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
      if(EC.AITarget > -1){AITargetPos = blockNear(eV,EC.AITarget,100);} else {AITargetPos = entityNear(eV,EC.AITargetID,100);}
    } else if(EC.AISearchMode == 1){
      if(EC.AITarget > -1){AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);} else {AITargetPos = entityNear(eV,EC.AITargetID,random(90)+10);}
    } else if(EC.AISearchMode == 2){
      AITargetPos = blockNearCasting(eV,EC.AITarget);
      if(aGS(wU,AITargetPos.x,AITargetPos.y) != EC.AITarget){
        AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);
      }
    } else if(EC.AISearchMode == 3){
      
      if(aGS(wU,eV.x,eV.y) != EC.AITarget){
        searchWorld(eV,EC.AITarget,(int)EC.Vision/10);
        
        if(path.size()>0){
          AITargetPos = new PVector(((Node)path.get(0)).x,((Node)path.get(0)).y);
        }
      }
      
    }
    if(EC.AITarget > -1){
      AITargetPos = new PVector(AITargetPos.x+.5,AITargetPos.y+.5);
    }
    eD = new PVector(AITargetPos.x,AITargetPos.y);
  }
  
  void fire(PVector tempV){
    float tempDir = pointDir(eV,tempV);
    entities.add(new Entity(x+EC.Size/2*cos(tempDir),y+EC.Size/2*sin(tempDir),bulletEntity,tempDir));
  }
  
  void display() {
    PVector tempV = pos2Screen(new PVector(x,y));
    if(EC.Genre == 0){
      stroke(255);
      strokeWeight(4);
      fill(EC.Color);
      ellipse(tempV.x,tempV.y,EC.Size*gScale,EC.Size*gScale);
    } else if(EC.Genre == 1) {
      pushMatrix();
      translate(tempV.x,tempV.y);
      rotate(eDir+PI/2);
      image(EC.Img,-gScale/2*EC.Size,-gScale/2*EC.Size,gScale*EC.Size,gScale*EC.Size);
      popMatrix();
    } else if(EC.Genre == 2){
      stroke(255,255-eFade*255);
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
  
  void destroy(){
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
  
  float Size = 1;
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
  
  float FadeRate = .1;
  float Vision = 100; //100 is generaly a good number... be careful with this and AI mode 3+... if > 140 and no target is near lag is created
  float GoalDist = 3; //Want to get this close
  float ActDist = 10; //Will start acting at this dis
  
  EConfig() {}
}

PVector entityNear(PVector eV,float tEID, float tChance){
  float minDis = wSize*wSize;
  PVector tRV = new PVector(random(wSize),random(wSize));
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.EC.ID == tEID){
      if(random(100)<tChance){
        if(pointDistance(eV, tempE.eV) < minDis){
          tRV = new PVector(tempE.x,tempE.y);
          minDis = pointDistance(eV, tRV);
        }
      }
    }
  }
  return tRV;
}

