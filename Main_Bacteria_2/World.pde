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




























