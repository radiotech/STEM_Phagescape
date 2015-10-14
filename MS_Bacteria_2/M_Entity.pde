
void setupEntities(){
  player = new Entity(50,50,new EConfig(),0);
  player.EC.Genre = 1;
  player.EC.Img = loadImage("player.png");
  entities.add(player);
}

void updateEntities(){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    tempE.moveAI();
  }
}

void drawEntities(){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    tempE.display();
  }
}

class Entity {
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
  int AITargetSetTime = 0;
  
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
  
  void moveAI(){
    eV = new PVector(x,y);
    if(EC.Genre == 0){
      x += EC.SMax*cos(eDir);
      y += EC.SMax*sin(eDir);
      eV = new PVector(x,y);
      if(x>wSize || x<0 || y>wSize || y<0 || aGS1DB(gBIsSolid,aGS(wU,x,y))){
        destroy();
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
        if(EC.AISearchMode == 0 || EC.AISearchMode == 1 || EC.AISearchMode == 2 || EC.AISearchMode == 3){
          if(aGS(wU,AITargetPos.x,AITargetPos.y) != EC.AITarget){
            setAITarget();
          }
          if(pointDistance(eV,AITargetPos)>1){
            if(EC.AISearchMode == 1 || EC.AISearchMode == 2){
              if(AITargetSetTime+1000 < millis() && pointDistance(eVLast,eV)<EC.Drag){
                setAITarget();
              }
            }
            eMove = true;
          }
          
          if(EC.AISearchMode == 3){
            setAITarget();
            if(path.size()>0){
              eD = new PVector(((Node)path.get(path.size()-1)).x+.5,((Node)path.get(path.size()-1)).y+.5);
            }
          }
        }
        
      }
      PVector tVecss = pos2Screen(new PVector(eD.x,eD.y));
      ellipse(tVecss.x,tVecss.y,30,30);
      
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
    }
    x = eV.x;
    y = eV.y;
  }
  
  void setAITarget(){
    if(EC.AISearchMode == 0){
      AITargetPos = blockNear(eV,EC.AITarget,100);
    } else if(EC.AISearchMode == 1){
      AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);
    } else if(EC.AISearchMode == 2){
      AITargetPos = blockNearCasting(eV,EC.AITarget);
      if(aGS(wU,AITargetPos.x,AITargetPos.y) != EC.AITarget){
        AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);
      }
    } else if(EC.AISearchMode == 3){
      searchWorld(eV,0);
      nodeDraw();
      if(path.size()>0){
        AITargetPos = new PVector(((Node)path.get(0)).x,((Node)path.get(0)).y);
      }
      
    }
    AITargetPos = new PVector(AITargetPos.x+.5,AITargetPos.y+.5);
    eD = new PVector(AITargetPos.x,AITargetPos.y);
    AITargetSetTime = millis();
  }
  
  void display() {
    PVector tempV = pos2Screen(new PVector(x,y));
    if(EC.Genre == 0){
      stroke(255);
      strokeWeight(4);
      fill(0,255,0);
      ellipse(tempV.x,tempV.y,EC.Size*gScale,EC.Size*gScale);
    } else if(EC.Genre == 1) {
      pushMatrix();
      translate(tempV.x,tempV.y);
      rotate(eDir+PI/2);
      image(EC.Img,-gScale/2*EC.Size,-gScale/2*EC.Size,gScale*EC.Size,gScale*EC.Size);
      popMatrix();
    }
  }
  
  void destroy(){
    for (int i = 0; i < entities.size(); i++) {
      Entity tempE = (Entity) entities.get(i);
      if(tempE.x == x){
        entities.remove(i);
      }
    }
  }
}

class EConfig {
  int Genre = 0;
  
  float Size = 1;
  float SMax = .10;
  
  float Accel = .010;
  float Drag = .002;
  float TAccel = .010;
  float TSMax = .10;
  float TDrag = .008;
  PImage Img;
  int Type = 0;
  
  int AISearchMode = -1;
  int AITarget = -1;
  float AIActionMode = -1;
  
  EConfig() {}
}
