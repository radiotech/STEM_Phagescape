int sSize = 700;
boolean menu = false;

void setup(){
  size(700,700);
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
  
  
  
  pV.add(pG);
  //pV = moveInWorld(pV, new PVector(pSpeed*cos(pDir),pSpeed*sin(pDir)),.5,.5);
  PVector tempPosSS = pos2Screen(((new PVector(pV.x,pV.y)))); noFill(); stroke(255,0,0); line(tempPosSS.x,tempPosSS.y,width/2,height/2);
  pV.sub(pG);
  
}

void mousePressed(){
  if(!menu){
    if(mouseButton == RIGHT){
      PVector tempPosS = pos2Block(screen2Pos(new PVector(mouseX,mouseY)));
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
*/
float pointDir(PVector v1,PVector v2){
  float tDir = atan((v2.y-v1.y)/(v2.x-v1.x));
  if(v1.x-v2.x > 0){
    tDir -= PI;
    
  }
  return tDir;
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
    return 1;
  }
  return (tB-tA)/abs(tB-tA);
}

float posMod(float tA, float tB){
  float myReturn = tA%tB;
  if(myReturn < 0){
    myReturn+=tB;
  }
  return myReturn;
}

int aGS(int[][] tMat, int tA, int tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,tA))][max(0,min(tMat[0].length-1,tB))];
}

int[] aGAS(int[][] tMat, int tA, int tB){ //array get around safe
  return new int[]{aGS(tMat,tA,tB-1),aGS(tMat,tA+1,tB-1),aGS(tMat,tA+1,tB),aGS(tMat,tA+1,tB+1),aGS(tMat,tA,tB+1),aGS(tMat,tA-1,tB+1),aGS(tMat,tA-1,tB),aGS(tMat,tA-1,tB-1)};
}
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


int[][] gU; //Grid unit
int[][] gM; //Grid Mini
int[][] wU; //World Unit
int gSize = 7;
int gScale;
int wSize = 100;
float wPhase = 0;
int gSelected = 1;
ArrayList wL = new ArrayList<Wave>(); //Wave list

void setupWorld(){
  gScale = floor(float(sSize)/(gSize-1));
  
  wU = new int[wSize][wSize];
  gU = new int[gSize][gSize];
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wU[i][j] = 0;
      if(random(100)<40){
        wU[i][j] = floor(random(7));
      }
    }
  }
  
  refreshWorld();
}

void updateWorld(){
  wPhase += .03;
}

void drawWorld(){
  background(0);
  
  noStroke();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      if(gU[i][j] != 0){
        fill(blockColor(gU[i][j]));
        rect(floor(i*gScale-pV.x*gScale),floor(j*gScale-pV.y*gScale),gScale,gScale);
      }
    }
  }
  
  for (Wave w : (ArrayList<Wave>) wL) {
    w.display();
  }
}

void refreshWorld(){
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      gU[i][j] = wU[min(wSize-1,max(0,i+round(pG.x)))][min(wSize-1,max(0,j+round(pG.y)))];
    }
  }
  waveGrid();
}

void waveGrid(){
  gM = new int[gSize*2+1][gSize*2+1];
  wL = new ArrayList<Wave>();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      gM[i*2+1][j*2+1] = gU[i][j];
    }
  }
  for(int i = 0; i < gSize*2+1; i++){
    for(int j = 0; j < gSize*2+1; j++){
      if(i%2!=j%2){
        if( (gM[min(i+1,gSize*2)][j] != -2 && gM[max(i-1,0)][j] != -2) && gM[min(i+1,gSize*2)][j] != gM[max(i-1,0)][j]){
            //gM[i][j] = -1;
            wL.add(new Wave(i,j,0,1,(j+i)%4-2));
        }
        if( (gM[i][min(j+1,gSize*2)] != -2 && gM[i][max(j-1,0)] != -2) && gM[i][min(j+1,gSize*2)] != gM[i][max(j-1,0)]){
            //gM[i][j] = -1;
            wL.add(new Wave(i,j,1,0,(j+i+2)%4-2));
        }
      } //else if(i%2==0) {
        //gM[i][j] = -2;
      //}
    }
  }
}

void arcHeightV(PVector v1,PVector v2,float h1, color c1, color c2){
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
  bezier(floor(v1.x-pV.x*gScale), floor(v1.y-pV.y*gScale), v1C.x-pV.x*gScale, v1C.y-pV.y*gScale, v2C.x-pV.x*gScale, v2C.y-pV.y*gScale, floor(v2.x-pV.x*gScale), floor(v2.y-pV.y*gScale));
  noStroke();
  fill(255);
  ellipse((.5-1/2)+v1.x-pV.x*gScale,(.5-1/2)+v1.y-pV.y*gScale,4,4);
  ellipse((.5-1/2)+v2.x-pV.x*gScale,(.5-1/2)+v2.y-pV.y*gScale,4,4);
}

color blockColor(int intC){
  switch(intC){
    case 0:
      return color(0);
    case 1:
      return color(255,255,0);
    case 2:
      return color(0,255,0);
    case 3:
      return color(0,255,255);
    case 4:
      return color(0,0,255);
    case 5:
      return color(255,0,255);
    case 6:
      return color(255,0,0);
    default:
      return color(0);
  }
}
class Wave {
  PVector a;
  PVector b;
  int amp;
  float shift;
  color c1;
  color c2;
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

PVector screen2Pos(PVector tA){tA.div(gScale);tA.add(pV);tA.add(pG); return tA;}

PVector pos2Screen(PVector tA){tA.sub(pG); tA.sub(pV); tA.mult(gScale); return tA;}



PVector pos2Block(PVector tA){return new PVector(floor(tA.x), floor(tA.y));}

PVector moveInWorld(PVector tV, PVector tS, float tw, float th){
  PVector tV2 = new PVector(tV.x,tV.y);
  tV.add(tS);
  tV = pos2Block(tV);
  if(wU[(int)tV.x][(int)tV.y] != 0){
    tS.div(3);
  }
  tV2.add(tS);
  return tV2;
}

//PVector block2Pos(PVector tA){return new PVector(0,0);} //not needed





























