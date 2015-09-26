int sSize = 700; //Must be same as numbers in size() below
void setup(){
  size(700,700); //Must be same as sSize above
  smooth(1);
  strokeCap(SQUARE);
  
  setupPlayer();
  setupWorld();
  setupBEdit();
}

void draw(){
  if(!menu){
    updateWorld();
    updatePlayer();
  }
  
  drawWorld();
  drawPlayer();
  
  if(bEdit){
    drawBEdit();
  }
  
  
  
  //pV.add(pG);
  //pV = moveInWorld(pV, new PVector(pSpeed*cos(pDir),pSpeed*sin(pDir)),.5,.5);
  //PVector tempPosSS = pos2Screen(((new PVector(pV.x,pV.y)))); noFill(); stroke(255,0,0); line(tempPosSS.x,tempPosSS.y,width/2,height/2);
  //pV.sub(pG);
  
}

void mousePressed(){
  if(!menu){
    if(mouseButton == RIGHT){
      PVector tempPosS = screen2Pos(new PVector(mouseX,mouseY));
      wU[min(wSize-1,max(0,(int)tempPosS.x))][min(wSize-1,max(0,floor(float(mouseY)/gScale+pV.y)+round(pG.y)))] = gSelected;
    }
    refreshWorld();
  } else {
    if(bEdit){
      mousePressedBEdit();
    }
  }
  
  
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      pKeys[0] = 1;
    }
    if(keyCode == DOWN){
      pKeys[1] = 1;
    }
    if(keyCode == LEFT){
      pKeys[2] = 1;
    }
    if(keyCode == RIGHT){
      pKeys[3] = 1;
    }
  } else {
    if (key >= '0' && key <= '9') {
      gSelected = int(str(key));
    }
    if (key == 'e' || key == 'E'){
      if(bEdit == false){bEdit = true; menu = true;}else{bEdit = false; menu = false;}
    }
  }
}

void keyReleased(){
  if(key == CODED){
    if(keyCode == UP){
      pKeys[0] = 0;
    }
    if(keyCode == DOWN){
      pKeys[1] = 0;
    }
    if(keyCode == LEFT){
      pKeys[2] = 0;
    }
    if(keyCode == RIGHT){
      pKeys[3] = 0;
    }
  }
}
