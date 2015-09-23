PVector pV;
PVector pG;
PImage pImg;
PVector pD; //Player destination
float pDir = -PI/2; //Player direction
//boolean pMove = false; //player moving
float pAccel = .005;
float pTAccel = .0005;
float pSMax = .05;
float pTSMax = .05;
float pTDrag = .0001;
float pDrag = .001;
float pSpeed = 0; //Player speed
float pTSpeed = 0; //Player turn speed
int[] pKeys = new int[4];

void setupPlayer(){
  pImg = loadImage("player.png");
  
  pV = new PVector(.5, .5);
  pG = new PVector(floor(wSize/2), floor(wSize/2));
  pD = new PVector(width/2,0);
}

void updatePlayer(){
  
  if(pmouseX != mouseX || pmouseY != mouseY){
    pD = new PVector(mouseX,mouseY);
  }
  
  if(mousePressed || max(pKeys) == 1){
    
    if(!mousePressed){
      pD = new PVector(width/2*(1-pKeys[2]+pKeys[3]),height/2*(1-pKeys[0]+pKeys[1]));
    }
    
    if(pSpeed+pAccel < pSMax){
      pSpeed += pAccel;
    } else {
      pSpeed = pSMax;
    }
    
    
  }
  
  if(pSpeed-pDrag > 0){
    pSpeed -= pDrag;
  } else {
    pSpeed = 0;
  }
  
  if(abs(pTSpeed)+pTAccel < pTSMax){
    pTSpeed += angleDir(pDir,pointDir(new PVector(width/2,height/2), pD))*pTAccel;
  }
  
  
  pDir += pTSpeed*pSpeed/pSMax; //pTSpeed*pSpeed/pSMax
  
  if(abs(pTSpeed)-pTDrag > 0){
    pTSpeed = (abs(pTSpeed)-pTDrag)*abs(pTSpeed)/pTSpeed;
  } else {
    pTSpeed = 0;
  }
  
  
  pV.add(pG);
  pV.add(new PVector(float(gSize)/2,float(gSize)/2));
  pV = moveInWorld(pV, new PVector(pSpeed*cos(pDir),pSpeed*sin(pDir)),.5,.5);
  
  pV.sub(new PVector(float(gSize)/2,float(gSize)/2));
  pV.sub(pG);
  
  if((pV.x+0)!=abs((pV.x+0)%1) || (pV.y+0)!=abs((pV.y+0)%1)){
    
    
    boolean tcx = false;
    boolean tcy = false;
    if((pV.x+0)!=abs((pV.x+0)%1)){
      tcx = true;
    }
    if((pV.y+0)!=abs((pV.y+0)%1)){
      tcy = true;
    }
    
    if(tcx){
      wPhase -= PI;
      if(pV.x < .5){
        pG.add(new PVector(-1,0));
      } else {
        pG.add(new PVector(1,0));
      }
    }
    if(tcy){
      wPhase -= PI;
      if(pV.y < .5){
        pG.add(new PVector(0,-1));
      } else {
        pG.add(new PVector(0,1));
      }
    }
    
    pV.x = (pV.x+0)%1-0;
    pV.y = (pV.y+0)%1-0;
    if(pV.x < 0){
      pV.x++;
    }
    if(pV.y < 0){
      pV.y++;
    }
  
    refreshWorld();
    
  }
}

void drawPlayer(){
  stroke(255);
  strokeWeight(4);
  fill(0,255,0);
  pushMatrix();
  translate(width/2,height/2);
  rotate(pDir+PI/2);
  image(pImg,-gScale/2,-gScale/2,gScale,gScale);
  popMatrix();
  
}


