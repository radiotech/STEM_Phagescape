void setupWorld(){
  gScale = float(sSize)/(gSize-1);
  
  wU = new int[wSize][wSize];
  gU = new int[ceil(gSize)][ceil(gSize)];
  
  gBColor = new color[256];
  gBIsSolid = new boolean[256];
  sBHasImage = new boolean[256];
  sBImage = new PImage[256];
  sBImageDrawType = new int[256];
  sBHasText = new boolean[256];
  sBText = new String[256];
  sBTextDrawType = new int[256];
  
  refreshWorld();
}

void moveToAnimate(PVector tV, float tTime){
  moveToAnimateStart = new PVector(wViewCenter.x,wViewCenter.y,wViewCenter.z);
  moveToAnimateEnd = new PVector(tV.x-wViewCenter.x,tV.y-wViewCenter.y);
  moveToAnimateTime = new PVector(millis(), millis()+tTime);
}

void animate(){
  if(millis() <= moveToAnimateTime.y){
    float temp1 = (millis()-moveToAnimateTime.x)/(moveToAnimateTime.y-moveToAnimateTime.x);
    float temp2 = sin(temp1*PI);
    float temp3 = (-cos(temp1*PI)+1)/2;
    centerView(moveToAnimateStart.x+temp3*moveToAnimateEnd.x,moveToAnimateStart.y+temp3*moveToAnimateEnd.y);
    scaleView(moveToAnimateStart.z+temp2*10);
  }
}

void scaleView(float tGSize){
  gSize = tGSize;
  gScale = float(sSize)/(gSize-1);
  
  gU = new int[ceil(gSize)][ceil(gSize)];
  
  refreshWorld();
}

void addGeneralBlock(int tIndex, color tColor, boolean tIsSolid){
  gBColor[tIndex] = tColor;
  gBIsSolid[tIndex] = tIsSolid;
}

void addSpecialBlock(int tIndex, boolean tHasImage, PImage tImage, int tImageDrawType, boolean tHasText, String tText, int tTextDrawType){
  sBHasImage[tIndex] = tHasImage;
  sBImage[tIndex] = tImage;
  sBImageDrawType[tIndex] = tImageDrawType;
  sBHasText[tIndex] = tHasText;
  sBText[tIndex] = tText;
  sBTextDrawType[tIndex] = tTextDrawType;
}

void centerView(float ta, float tb){
  wViewCenter = new PVector(ta,tb,gSize);
  println(wViewCenter);
  wView = new PVector(ta-(gSize-1)/2,tb-(gSize-1)/2);
  if(floor(wViewLast.x) != floor(wView.x)){
    refreshWorld();
    wPhase -= PI;
  }
  if(floor(wViewLast.y) != floor(wView.y)){
    refreshWorld();
    wPhase -= PI;
  }
  wViewLast = new PVector(wView.x,wView.y);
}

void updateWorld(){
  wPhase += .09;
}

void drawWorld(){
  background(0);
  
  noStroke();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      if(gU[i][j] != 0){
        fill(aGS(gBColor,gU[i][j]));
        PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
        rect(floor(tempV.x),floor(tempV.y),ceil(gScale),ceil(gScale)); //-pV.x*gScale
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
      gU[i][j] = aGS(wU,i+wView.x,j+wView.y);
    }
  }
  waveGrid();
}

void waveGrid(){
  gM = new int[ceil(gSize)*2+1][ceil(gSize)*2+1];
  wL = new ArrayList<Wave>();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      gM[i*2+1][j*2+1] = gU[i][j];
    }
  }
  for(int i = 0; i < gSize*2+1; i++){
    for(int j = 0; j < gSize*2+1; j++){
      if(i%2!=j%2){
        if( (gM[min(i+1,ceil(gSize)*2)][j] != -2 && gM[max(i-1,0)][j] != -2) && gM[min(i+1,ceil(gSize)*2)][j] != gM[max(i-1,0)][j]){
            //gM[i][j] = -1;
            wL.add(new Wave(i,j,0,1,(j+i)%4-2));
        }
        if( (gM[i][min(j+1,ceil(gSize)*2)] != -2 && gM[i][max(j-1,0)] != -2) && gM[i][min(j+1,ceil(gSize)*2)] != gM[i][max(j-1,0)]){
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
    stroke(c2);
  } else {
    stroke(c1);
  }
  strokeWeight(2);
  line(v1.x,v1.y,v2.x,v2.y);
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
  bezier(v1.x, ceil(v1.y), v1C.x, v1C.y, v2C.x, v2C.y, v2.x, v2.y);
  noStroke();
  fill(255);
  ellipse((.5-1/2)+v1.x,(.5-1/2)+v1.y,4,4);
  ellipse((.5-1/2)+v2.x,(.5-1/2)+v2.y,4,4);
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
    a = new PVector(floor((tx+1-ta)/2),floor((ty+1-tb)/2));
    b = new PVector(floor((tx+1+ta)/2),floor((ty+1+tb)/2));
    amp = tAmp;
    shift = (tx+ty+(wView.x+wView.y)*2)*PI/30;
    c1 = aGS(gBColor,aGS(gM,tx-tb,ty+ta));
    c2 = aGS(gBColor,aGS(gM,tx+tb,ty-ta));
  }
  void display() {
    PVector ta = pos2Screen(grid2Pos(new PVector(a.x,a.y)));
    PVector tb = pos2Screen(grid2Pos(new PVector(b.x,b.y)));
    arcHeightV(ta,tb,amp*(gScale/10)*sin(wPhase+shift),c1,c2);
  }
}

PVector screen2Pos(PVector tA){tA.div(gScale);tA.add(wView); return tA;}

PVector pos2Screen(PVector tA){tA.sub(wView); tA.mult(gScale); return tA;}

PVector grid2Pos(PVector tA){tA.add(new PVector(floor(wView.x),floor(wView.y))); return tA;}

PVector moveInWorld(PVector tV, PVector tS, float tw, float th){
  PVector tV2 = new PVector(tV.x,tV.y);
  if(tS.x > 0){
    if(floor(tV.x+tw/2) != floor(tV.x+tw/2+tS.x)){
      if(aGS(wU,tV.x+tw/2+tS.x,tV.y+th/2) != 0 || aGS(wU,tV.x+tw/2+tS.x,tV.y-th/2) != 0){
        tS = new PVector(0,tS.y);
        tV2 = new PVector(floor(tV.x+tw/2+tS.x)+.999-tw/2,tV2.y);
      }
    }
  } else {
    if(floor(tV.x-tw/2) != floor(tV.x-tw/2+tS.x)){
      if(aGS(wU,tV.x-tw/2+tS.x,tV.y+th/2) != 0 || aGS(wU,tV.x-tw/2+tS.x,tV.y-th/2) != 0){
        tS = new PVector(0,tS.y);
        tV2 = new PVector(floor(tV.x-tw/2+tS.x)+tw/2,tV2.y);
      }
    }
  }
  tV2 = new PVector(tV2.x+tS.x,tV2.y);
  
  if(tS.y > 0){
    if(floor(tV.y+th/2) != floor(tV.y+th/2+tS.y)){
      if(aGS(wU,tV.x+tw/2,tV.y+th/2+tS.y) != 0 || aGS(wU,tV.x-tw/2,tV.y+th/2+tS.y) != 0){
        tS = new PVector(tS.x,0);
        tV2 = new PVector(tV2.x,floor(tV.y+th/2+tS.y)+.999-th/2);
      }
    }
  } else {
    if(floor(tV.y-th/2) != floor(tV.y-th/2+tS.y)){
      if(aGS(wU,tV.x+tw/2,tV.y-th/2+tS.y) != 0 || aGS(wU,tV.x-tw/2,tV.y-th/2+tS.y) != 0){
        tS = new PVector(tS.x,0);
        tV2 = new PVector(tV2.x,floor(tV.y-th/2+tS.y)+th/2);
      }
    }
  }
  tV2 = new PVector(tV2.x,tV2.y+tS.y);
  
  return tV2;
}


