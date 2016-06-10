//STEM Phagescape API v(see above)

/*
int wavePixels = 100;
int waveFrames = 60;
int waveHeight = 25;
int waveOffset = 13;
int waveStroke = 6;
PGraphics[] waveGraphics;
PImage[] waveImages;
int adder;
*/

void waveGrid(){
  gM = new int[ceil(gSize)*2+1][ceil(gSize)*2+1];
  wL.clear();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      
      if(aGS(gUShade,i,j) == 0){
        //gM[i*2+1][j*2+1] = -2;
      } else {
        gM[i*2+1][j*2+1] = aGS(gU,i,j);
      }
      
      
      //if(gUHUD[i][j] == false){gM[i*2+1][j*2+1] = 255;}
    }
  }
  for(int i = 0; i < gSize*2+1; i++){
    for(int j = 0; j < gSize*2+1; j++){
      if(i%2!=j%2){
        if(gBColor[gM[min(i+1,ceil(gSize)*2)][j]] != gBColor[gM[max(i-1,0)][j]]){
           wL.add(new Wave(i,j,0,1,(j+i)%4-2));
         }
        if(gBColor[gM[i][min(j+1,ceil(gSize)*2)]] != gBColor[gM[i][max(j-1,0)]]){
          wL.add(new Wave(i,j,1,0,(j+i+2)%4-2));
        }
      }
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

/*
void arcHeightV2(int tI){
  PVector v1 = new PVector(0,waveOffset-1);
  PVector v2 = new PVector(wavePixels,waveOffset-1);
  float h1 = -1*(wavePixels/10)*sin(float(tI)/(waveFrames-1)*PI/2);
  
  PVector v4 = PVector.sub(v2,v1); //vector between points
  PVector v3 = PVector.add(v2,v1); //find midpoint
  v3.div(2);
  float d1 = v4.mag(); //dis
  
  float h2 = (sq(h1)+sq(d1/2))/(2*h1)-h1;
  
  v4.div(v4.mag()/h2); //unit vector between points
  v3 = PVector.add(v3,new PVector(v4.y,-v4.x));
  float d2 = v3.dist(v1); //radius
  
  PVector v11 = PVector.sub(v1,v3);
  v11.div(d2/(h1*d2*2.5/wavePixels));
  PVector v1C = PVector.add(v1,new PVector(v11.y,-v11.x));
  
  PVector v12 = PVector.sub(v2,v3);
  v12.div(d2/(h1*d2*2.5/wavePixels));
  PVector v2C = PVector.add(v2,new PVector(-v12.y,v12.x));
  
  waveGraphics[tI].strokeWeight(waveStroke);
  waveGraphics[tI].noFill();
  waveGraphics[tI].stroke(255);
  waveGraphics[tI].bezier(v1.x, ceil(v1.y), v1C.x, v1C.y, v2C.x, v2C.y, v2.x, v2.y);
}
*/
class Wave {
  PVector a;
  PVector b;
  int amp;
  float shift;
  color c1;
  color c2;
  
  boolean wDir;
  Wave(int tx, int ty, int ta, int tb, int tAmp) {
    wDir = boolean(ta);
    a = new PVector(floor((tx+1-ta)/2),floor((ty+1-tb)/2));
    b = new PVector(floor((tx+1+ta)/2),floor((ty+1+tb)/2));
    amp = tAmp;
    shift = (tx+ty+(wView.x+wView.y)*2)*PI/30;
    c1 = aGS1D(gBColor,aGS(gM,tx-tb,ty+ta));
    c2 = aGS1D(gBColor,aGS(gM,tx+tb,ty-ta));
  }
  void display() {
    PVector ta = pos2Screen(grid2Pos(new PVector(a.x,a.y)));
    PVector tb = pos2Screen(grid2Pos(new PVector(b.x,b.y)));
    
    //float tH = -1*(wavePixels/10)*sin(posMod(amp*floor((wPhase+shift)*10),waveFrames*4)/(waveFrames-1)*PI/2);
    
    //strokeWeight(1);
    
    
    
    //gridBuffer.strokeWeight(gScale/15-3);
    //gridBuffer.stroke(strokeColor);
    
    int strokeWe = ceil((gScale/15-3)/2);
    rectL.add(new RectObj(ceil(ta.x)+ceil(gScale)-strokeWe,ceil(ta.y)+ceil(gScale)-strokeWe,ceil(tb.x)+ceil(gScale)-ceil(ta.x+ceil(gScale))+strokeWe,int(tb.y)+ceil(gScale)-int(ta.y+ceil(gScale))+strokeWe,color(255)));
    
    //gridBuffer.line(ta.x+ceil(gScale),ta.y+ceil(gScale),tb.x+ceil(gScale),tb.y+ceil(gScale));
    //gridBuffer.noStroke();
    //gridBuffer.fill(255);
    //ellipse(ta.x,ta.y,gScale/15-1-1,gScale/15-1-1);
    //ellipse(tb.x,tb.y,gScale/15-1-1,gScale/15-1-1);
    //waveFromImage(ta.x,ta.y,amp*floor((wPhase+shift)*10),wDir);
  }
}
/*
void updateWaveImages(){
  waveGraphics = new PGraphics[waveFrames*4];
  waveImages = new PImage[waveFrames*4];
  for(int i = 0; i < waveFrames; i++){
    waveGraphics[i] = createGraphics(wavePixels,waveHeight);
    waveGraphics[i].beginDraw();
    arcHeightV2(i);
    waveGraphics[i].endDraw();
    waveImages[i] = waveGraphics[i].get();
  }
  for(int i = waveFrames; i < waveFrames*2; i++){
    waveGraphics[i] = createGraphics(waveHeight,wavePixels);
    waveGraphics[i].beginDraw();
    waveGraphics[i].rotate(-PI/2);
    waveGraphics[i].translate(-wavePixels,0);
    
    waveGraphics[i].image(waveImages[i-waveFrames],0,0);
    waveGraphics[i].endDraw();
    waveImages[i] = waveGraphics[i].get();
  }
  for(int i = waveFrames*2; i < waveFrames*3; i++){
    waveGraphics[i] = createGraphics(wavePixels,waveHeight);
    waveGraphics[i].beginDraw();
    waveGraphics[i].scale(1,-1);
    waveGraphics[i].translate(0,-waveHeight);
    
    waveGraphics[i].image(waveImages[i-waveFrames*2],0,0);
    waveGraphics[i].endDraw();
    waveImages[i] = waveGraphics[i].get();
  }
  for(int i = waveFrames*3; i < waveFrames*4; i++){
    waveGraphics[i] = createGraphics(waveHeight,wavePixels);
    waveGraphics[i].beginDraw();
    waveGraphics[i].scale(-1,1);
    waveGraphics[i].translate(-waveHeight,0);
    
    waveGraphics[i].image(waveImages[i-waveFrames*2],0,0);
    waveGraphics[i].endDraw();
    waveImages[i] = waveGraphics[i].get();
  }
}


void waveFromImage(float tx, float ty, int tI, boolean tDir){
  int tNewIndex = floor(posMod(tI,waveFrames));
  int tActualPhase = floor(posMod(tI,waveFrames*4)/waveFrames);
  noStroke();
  fill(255);
  ellipse(tx,ty,waveStroke-.5,waveStroke-.5);
  if(tDir){
    ellipse(tx+wavePixels,ty,waveStroke-.5,waveStroke-.5);
    switch(tActualPhase){
      case 0:
        image(waveImages[tNewIndex], tx, ty-waveOffset);
        break;
      case 1:
        image(waveImages[waveFrames-tNewIndex-1], tx, ty-waveOffset);
        break;
      case 2:
        image(waveImages[tNewIndex+waveFrames*2], tx,ty-waveOffset);
        break;
      case 3:
        image(waveImages[waveFrames-tNewIndex-1+waveFrames*2], tx,ty-waveOffset);
        break;
    }
  } else {
    ellipse(tx,ty+wavePixels,waveStroke-.5,waveStroke-.5);
    switch(tActualPhase){
      case 0:
        image(waveImages[tNewIndex+waveFrames], tx-waveOffset, ty);
        break;
      case 1:
        image(waveImages[waveFrames-tNewIndex-1+waveFrames], tx-waveOffset, ty);
        break;
      case 2:
        image(waveImages[tNewIndex+waveFrames+waveFrames*2], tx-waveOffset, ty);
        break;
      case 3:
        image(waveImages[waveFrames-tNewIndex-1+waveFrames+waveFrames*2], tx-waveOffset, ty);
        break;
    }
  }
}
*/

//STEM Phagescape API v(see above)
