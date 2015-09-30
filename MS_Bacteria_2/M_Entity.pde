
void setupEntities(){
  player = new Entity(50,50,1,0);
  entities.add(player);
}

void updateEntities(){
  for (Entity e : (ArrayList<Entity>) entities) {
    e.moveAI();
  }
}

void drawEntities(){
  for (Entity e : (ArrayList<Entity>) entities) {
    e.display();
  }
}

class Entity {
  float x;
  float y;
  PVector eV;
  float eDir = 0;
  float eSize;
  PVector eD;
  
  float eAccel = .010;
  float eTAccel = .010;
  float eSMax = .10;
  float eTSMax = .10;
  float eTDrag = .008;
  float eDrag = .002;
  float eSpeed = 0; //Player speed
  float eTSpeed = 0; //Player turn speed
  
  PImage eImg;
  
  boolean eMove = false;
  int eType;
  
  Entity(float tx, float ty, float tSize, int tType) {
    x = tx;
    y = ty;
    eD = new PVector(tx,ty-1);
    eImg = loadImage("player.png");
    eSize = tSize;
    eType = tType;
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
    eMove = false;
    if(eType == 0){
      if(mousePressed || max(pKeys) == 1){
        if(!mousePressed){
          eD = new PVector(eV.x+(-pKeys[2]+pKeys[3]),eV.y+(-pKeys[0]+pKeys[1]));
        } else {
          eD = screen2Pos(new PVector(mouseX,mouseY));
        }
        eMove = true;
      }
    }
    if(eMove){
      if(eSpeed+eAccel < eSMax){
        eSpeed += eAccel;
      } else {
        eSpeed = eSMax;
      }
    }
    if(eSpeed-eDrag > 0){
      eSpeed -= eDrag;
    } else {
      eSpeed = 0;
    }
    if(abs(eTSpeed)+eTAccel < eTSMax){
      eTSpeed += angleDir(eDir,pointDir(eV, eD))*eTAccel;
    }
    eDir += eTSpeed*eSpeed/eSMax; //pTSpeed*pSpeed/pSMax
    if(abs(eTSpeed)-eTDrag > 0){
      eTSpeed = (abs(eTSpeed)-eTDrag)*abs(eTSpeed)/eTSpeed;
    } else {
      eTSpeed = 0;
    }
    eV = moveInWorld(eV, new PVector(eSpeed*cos(eDir),eSpeed*sin(eDir)),eSize-.5,eSize-.5);
    x = eV.x;
    y = eV.y;
  }
  
  void display() {
    stroke(255);
    strokeWeight(4);
    fill(0,255,0);
    pushMatrix();
    PVector tempV = new PVector(eV.x,eV.y);
    tempV = pos2Screen(tempV);
    translate(tempV.x,tempV.y);
    rotate(eDir+PI/2);
    image(eImg,-gScale/2*eSize,-gScale/2*eSize,gScale*eSize,gScale*eSize);
    //rect(-gScale/2*eSize,-gScale/2*eSize,gScale*eSize,gScale*eSize);
    popMatrix();
  }
}
