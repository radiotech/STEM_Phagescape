Mimic[] mimicIDs = new Mimic[0];
int maxMimicID = -1;
void setupMimics(){
  player = new Mimic(-1);
  mimics.add(player);
  player.snap.v.x = 50;
  player.snap.v.y = 50;
  player.snap.dir = random(2*PI);
  player.type = "player";
}
void updateEntities(){
  for (int i = 0; i < mimics.size(); i++) {
    Mimic tempM = (Mimic) mimics.get(i);
    tempM.update();
  }
  println("updating entities");
}
void drawEntities(){
  for (int i = 0; i < mimics.size(); i++) {
    Mimic tempM = (Mimic) mimics.get(i);
    tempM.display();
  }
  stroke(strokeColor);
  strokeWeight(ceil((gScale/15-3)/2));
  for (int i = 0; i < mimics.size(); i++) {
    Mimic tempM = (Mimic) mimics.get(i);
    tempM.displayBulls();
  }
}

class Mimic {
  Snap snap;
  float drag = .008, tAccel = .03, accel = .04, tSMax = .2, sMax = .15, tDrag = .016,hitboxScale = 1, staminaRate = 1, fireDelay = 10,size = 1;
  float bulletSpeed = .14;
  color bullColor = color(0);
  boolean move;
  String type = "";
  float des = 0;
  float fireDes = 0;
  int col = 255;
  int hMax = 20;
  int hSteps = 100;
  PImage img;
  int id;
  ArrayList<MimicDes> MimicDess = new ArrayList();
  ArrayList<MimicDes> PendingDess = new ArrayList();
  int moves = 0;
  boolean isNew = true;
  color bullCol = color(0,0,0);
  float bullSize = .1;
  
  Mimic(int tId) {
    snap = new Snap(this);
    snap.v.x = 50;
    snap.v.y = 50;

    id = tId;
    img = loadImage(aj.D()+"general/entities/player.png");
  }
  void update(){
    
    
    if(type.equals("otherPlayer")){
      if(MimicDess.size() > 0){
        int goalSize = min(6,MimicDess.size()-1);
        MimicDes Des;
        while(MimicDess.size() > goalSize){
          Des = (MimicDes) MimicDess.get(0);
          //println(Des.id);
          snap.v.x = Des.val[0];
          snap.v.y = Des.val[1];
          snap.dir = Des.val[2];
          if(int(Des.val[3]) == 0){
            if(snap.health != 0){
              deathParticles(snap);
            }
          }
          snap.health = int(Des.val[3]);
          if(Des.bulls > 0){
            snap.bullets = new SnapBullet[Des.bulls];
            for(int i = 0; i < Des.bulls; i++){
              snap.bullets[i] = new SnapBullet(Des.bullV[i],0,0);
              bulletParticles(snap,i);
            }
          } else if(snap.bullets.length > 0) {
            snap.bullets = new SnapBullet[0]; 
          }
          MimicDess.remove(0);
        }
        //println(MimicDess.size());
        if(PendingDess.size() > 0){
          /*println("MD"+str(MimicDess.size()));
          println(moves);
          println(PendingDess.get(0).id);
          println("PD"+str(PendingDess.size()));*/
        }
        
      }
    } else {
      move = false;
      if(type.equals("player")){
        if((isLeft) || max(pKeys) == 1){
          if(!(isLeft)){
            des = pointDir(player.snap.v,new PVector(snap.v.x+(-pKeys[2]+pKeys[3]),snap.v.y+(-pKeys[0]+pKeys[1])));
          } else {
            des = pointDir(player.snap.v,screen2Pos(new PVector(mouseX,mouseY)));
            //float tempDir = pointDir(new PVector(snap.v.x,snap.v.y),des);
            //des = pointDir(player.snap.v,new PVector(snap.v.x+cos(tempDir)*wSize,snap.v.y+sin(tempDir)*wSize));
          }
          move = true;
        }
        
      }
      
      float imp2 = 0;
      if(isRight){
        imp2 = 1;
        fireDes = pointDir(player.snap.v,screen2Pos(new PVector(mouseX,mouseY)));
      }
      //player.fire(screen2Pos(new PVector(mouseX,mouseY)));
      float imp = 0;
      if(move){
        imp = 1;
      }
      float[] inputs = { imp,des,imp2,fireDes };
      println(movePackets.size());
      println(movePacketResponseId-movePacketId);
      if(conn == 5 && movePacketId-movePacketResponseId < 100){
        snap = snap.simulate(1,inputs,true);
        
        
        movePackets.add(new SnapInput(imp,des,imp2,fireDes));
        
        connData += "[\"MOVE\",";
        SnapInput pack;
        for (int i = movePackets.size() - 1; i >= 0; i--) {
          pack = (SnapInput) movePackets.get(i);
          if(pack.id > movePacketResponseId){
            connData += "["+pack.id+","+pack.val[0]+","+pack.val[1]+","+pack.val[2]+","+pack.val[3]+"],";
          } else {
            movePackets.remove(i);
          }
        }
        connData = connData.substring(0,connData.length()-1)+"],";
      }
      
      
    }
  }
  void display(){
    PVector tempV = pos2Screen(new PVector(snap.v.x,snap.v.y));
    if(type.equals("player") || type.equals("otherPlayer")){
      if(snap.health > 0){
        pushMatrix();
        translate(tempV.x,tempV.y);
        rotate(snap.dir+PI/2);
        image(img,-gScale/2*size,-gScale/2*size,gScale*size,gScale*size);
        //rotate(pointDir(eV,new PVector(eFireD.x,eFireD.y))-eDir);//
        //image(arrowImg,-gScale/2*(EConfigs[EC].Size+.5),-gScale/2*(EConfigs[EC].Size+.5),gScale*(EConfigs[EC].Size+.5),gScale*(EConfigs[EC].Size+.5));
        popMatrix();
        if(snap.health < hMax && hMax > -1){
          float tempFade = float(snap.health)/hMax;
          noFill();
          strokeWeight(gScale/15);
          stroke(255,255-tempFade*150);
          arc(tempV.x,tempV.y,gScale*(size+.1),gScale*(size+.1),-HALF_PI,-HALF_PI+TWO_PI*tempFade);
          stroke((1-tempFade)*510,tempFade*510,0,255-tempFade*150);
          arc(tempV.x,tempV.y,gScale*(size+.1),gScale*(size+.1),-HALF_PI,-HALF_PI+TWO_PI*tempFade);
        }
      }
    } else {
      noStroke();
      fill(0,255,0);
      ellipse(tempV.x,tempV.y,gScale/5,gScale/5);
    }
  }
  void displayBulls(){
    if(type.equals("player") || type.equals("otherPlayer")){
      fill(bullCol);
      for(int i = 0; i < snap.bullets.length; i++){
        PVector tempVe = pos2Screen(new PVector(snap.bullets[i].v.x,snap.bullets[i].v.y));
        ellipse(tempVe.x,tempVe.y,bullSize*gScale,bullSize*gScale);
      }
    }
  }
  /*
  void fire(PVector tempV){
    if(fireCooldown == 0){
      if(snap.tryStaminaAction(5)){
        float tempDir = pointDir(new PVector(snap.v.x,snap.v.y),tempV);
        sendText("FIRE",player.snap.v.x+","+player.snap.v.y+","+tempDir);
        fireCooldown += fireDelay;
      }
    }
  }
  */
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
}

class Snap {
  Mimic dad;
  SnapBullet[] bullets = new SnapBullet[0];
  int type = 0;
  float stamina = 0;
  PVector v = new PVector(0,0);
  float speed = 0;
  float tSpeed = 0;
  float dir = 0;
  int health = 0;
  int hSteps = 0;
  float fireCoolDown = 0;
  Snap newS;
  Snap(Mimic mom) {
    dad = mom;
  }
  Snap simulate(int reps,float[] input, boolean doEffects){
    newS = new Snap(dad);
    newS.type = type;
    switch(type){
      case 0://player simulation
        newS.bullets = new SnapBullet[bullets.length];
        for(int i = 0; i < bullets.length; i++){
          newS.bullets[i] = new SnapBullet(bullets[i].v,bullets[i].speed,bullets[i].dir);
        }
        newS.stamina = min(stamina+1,110);
        newS.v.x = v.x;
        newS.v.y = v.y;
        newS.speed = speed;
        newS.dir = dir;
        newS.tSpeed = tSpeed;
        newS.health = health;
        newS.hSteps = hSteps;
        newS.fireCoolDown = fireCoolDown;
        
        for(int i = 0; i < reps; i++){
          
          for(int j = newS.bullets.length-1; j >= 0; j--){
            newS.bullets[j].v.x += newS.bullets[j].speed * cos(newS.bullets[j].dir);
            newS.bullets[j].v.y += newS.bullets[j].speed * sin(newS.bullets[j].dir);
            if(doEffects){
              bulletParticles(this,j);
            }
            if(gBIsSolid[aGS(wU,newS.bullets[j].v.x,newS.bullets[j].v.y)]){
              if(doEffects){
                color[] cols = {-1,gBColor[aGS(wU,newS.bullets[j].v.x,newS.bullets[j].v.y)],dad.bullColor};
                float[] sizes = {-1,.1,.05};
                float[] speeds = {-1,.02,.005};
                int[] shapes = {0,1};
                int[] lifespans = {-1,20,30};
                particleEffect(5,5,newS.bullets[j].v.x,newS.bullets[j].v.y,.2,.2,cols,sizes,speeds,shapes,lifespans);
              }
              newS.bullets[j].v.x = -999;
            }
          }
          if(newS.health > 0){
            if(newS.fireCoolDown > 0){
              newS.fireCoolDown--;
            }
            if(input[0+i*5] == 1){//if move input
              if(tryStaminaAction(1,1)){//if we have stamina
                newS.speed += dad.accel;//accelerate
              }
            }
            if(newS.hSteps < newS.dad.hSteps){
              newS.hSteps++;
            } else if(newS.health < newS.dad.hMax && tryStaminaAction(5,0)){
              newS.health++;
              newS.hSteps = 0;
            }
            if(int(input[2+i*5]) == 1 && newS.fireCoolDown == 0){//if fire input
              if(tryStaminaAction(5,1)){//if we have stamina
                newS.fireCoolDown += newS.dad.fireDelay;
                newS.fire(newS,input[3+i*5]);
              }
            }
            newS.speed = min(max(newS.speed-dad.drag,0),dad.sMax);//apply drag and ensure speed is within limits
            
            float aDif = angleDif(newS.dir,input[1+i*5]);
            if(aDif != 0){
              int dirS = round(aDif/abs(aDif));
              float innspeed = newS.tSpeed+dad.tAccel*dirS-dad.tDrag*dirS;
              int num = floor(innspeed/dad.tDrag*dirS);
              float rotDis = (num+1)*(innspeed-num/2*dad.tDrag*dirS);
              if(abs(rotDis) / abs(aDif) < 1 ){
                newS.tSpeed += dirS*dad.tAccel;
              }
            }
            
            if(abs(newS.tSpeed)-dad.tDrag > 0){
              newS.tSpeed = (abs(newS.tSpeed)-dad.tDrag)*(abs(newS.tSpeed)/newS.tSpeed);
            } else {
              newS.tSpeed = 0;
            }
            
            newS.tSpeed = min(dad.tSMax, max(-dad.tSMax, newS.tSpeed));
            
            newS.dir += newS.tSpeed*newS.speed/dad.sMax; //pTSpeed*pSpeed/pSMax
            //if(aDif != 0){
            //  newS.dir = rotDis;
            //}
            
            moveInWorld(newS.v, new PVector(newS.speed*cos(newS.dir),newS.speed*sin(newS.dir)),dad.size*dad.hitboxScale/2,dad.size*dad.hitboxScale/2);
          }
        }
        break;
    }
    return newS;
  }
  boolean tryStaminaAction(float cost, float nCost){
    cost = cost*dad.staminaRate;
    if(newS.stamina > cost){
      newS.stamina -= cost;
      return true;
    } else {
      newS.stamina = max(0,newS.stamina-cost/5*nCost);
      return false;
    }
  }
  void fire(Snap newS, float tDir){
    newS.bullets = (SnapBullet[])append(newS.bullets,new SnapBullet(newS.v,newS.dad.bulletSpeed,tDir));
  }
}

class SnapBullet {
  PVector v = new PVector(0,0);
  float speed = 0;
  float dir = 0;
  SnapBullet(PVector tV, float tSpeed, float tDir) {
    v = new PVector(tV.x,tV.y);
    speed = tSpeed;
    dir = tDir;
  }
}

class SnapInput {
  int id;
  float[] val;
  SnapInput(float isMove, float moveDir, float isFire, float fireDir) {
    id = movePacketId++;
    float[] tVal = {isMove,moveDir,isFire,fireDir};
    val = tVal;
  }
}

class MimicDes {
  int id;
  float[] val;
  int bulls = 0;
  PVector[] bullV;
  MimicDes(int tId, float x, float y, float dir, int health) {
    id = tId;
    float[] tVal = {x,y,dir,health};
    val = tVal;
  }
}

void reloadMimicIDs(){
  mimicIDs = new Mimic[maxMimicID+1];
  for (int i = mimics.size()-1; i >= 0; i--) {
    Mimic tempM = (Mimic) mimics.get(i);
    if(tempM.id > -1){
      mimicIDs[tempM.id] = tempM;
    }
  }
}
Mimic getMimic(int id){
  if(maxMimicID < id){
    maxMimicID = id;
    reloadMimicIDs();
  }
  if(mimicIDs[id] == null){
    if(id == pid){
      return player;
    } else {
      mimicIDs[id] = new Mimic(id);
      mimics.add(mimicIDs[id]);
    }
  }
  return mimicIDs[id];
}
void killMimic(int id){
  if(maxMimicID < id){
    return;
  }
  if(mimicIDs[id] == null){
    return;
  }
  removeMimic(mimicIDs[id],-1);
}
void removeMimic(Mimic mob, int n){
  if(n < 0){
    Mimic tempM;
    for (int i = mimics.size()-1; i >= 0; i--) {
      tempM = (Mimic)mimics.get(i);
      if(tempM.id == mob.id){
        n = i;
      }
    }
    if(n < 0){
      return;
    }
  }
  mimics.remove(n);
  if(mob.id <= maxMimicID){
    mimicIDs[mob.id] = null;
  }
}

void sendText(String Key, String Val){
  connData += ("[\""+Key+"\","+Val.replaceAll("'","\"")+"],");
}
