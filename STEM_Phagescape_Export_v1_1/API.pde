//STEM Phagescape API v1.0

//DO NOT MAKE ANY CHANGES TO THIS DOCUMENT. IF YOU NEED TO MAKE A CHANGE, CONTACT ME (AJ) - lavabirdaj@gmail.com
int wSize = 100; //blocks in the world (square)
float gSize = 10; //grid units displayed on the screen (blocks in view) (square)
//END OF CONFIGURATION, DO NOT CHANGE BELOW THIS LINE - WITH NO EXCEPTIONS
/*
********** Important Function and Variable Outline **********
//for each item please replace the '_VARIABLE_' including the _ characters with your function values
***** View Changes *****
centerView(_X_,_Y_) //set the center of the screen view to a world coordinate position, such as the player position
scaleView(_SIZE_)
moveToAnimate(new PVector(_X_,_Y_),_T_) //moves to a position over time in milliseconds
***** World Changes *****
setupWorld() //apply changes to world size (wSize) and clear the world
refreshWorld() //redraw the world after block changes have been made
aGS(wU,_X_,_Y_) //access a block at a position in the world - each block is represented by a general block ID
aSS(wU,_X_,_Y_,_BLOCK_ID_) //change a block at a position in the world
addGeneralBlock(_BLOCK_ID_,color(_R_,_G_,_B_),_IS_SOLID?_) //make this block ID represent a block with a certain color that is either solid (true) or not solid (false)
addImageSpecialBlock(_BLOCK_ID_,_IMAGE_,_IMAGE_MODE_) //make this block ID represent a block with an image (PImage) and an integer representing the drawing method (0 = no squish, 1 = squish, 2 = absolute position (like the cartoon Chowder))
addTextSpecialBlock(_BLOCK_ID_,_TEXT_,_TEXT_MODE_) //make this block ID represent a block with text (A string, ex. "hello there!") and an integer representing the drawing method (0 = always display text bubble, 1-10 = display buble at distances, 11-20 = send chat message at distances)

***** General Functions *****
pointDir(_POS1_,_POS2_)
turnWithSpeed(_FROM_,_TO_,_SPEED_)
angleDif(_ANGLE_1_,_ANGLE_2_)
angleDir(_ANGLE_1_,_ANGLE_2_)
posMod(_NUM_,_DEN_)
aSS(_2D_MAT_,_I_,_J_,_VAL_)
aGS(_2D_MAT_,_I_,_J_)
aGS(_1D_MAT_,_I_)
maxAbs(_NUM_1_,_NUM_2_)
minAbs(_NUM_1_,_NUM_2_)
*/
//These variables should not be changed
int[][] gU; //Grid unit - contains all blocks being drawn to the screen
int[][] gM; //Grid Mini - stores information regarding the position of block boundries and verticies for wave generation
int[][] wU; //World Unit - contains all blocks in the world
int[][] wUDamage;
boolean[][] wUText; //World Unit - contains all blocks in the world
float gScale; //the width and height of blocks being drawn to the screen in pixels
float wPhase = 0; //the current phase of all waves in the world (where they are in their animation)
ArrayList wL = new ArrayList<Wave>(); //Wave list - list of all waves in the world
PVector wView = new PVector(45,45); //current world position of the center of the viewing window
PVector wViewLast = new PVector(0,0); //previous world position of the center of the viewing window (last time draw was executed)
int[] pKeys = new int[4];
Entity player;
boolean menu = false;
ArrayList entities = new ArrayList<Entity>(); //Entity list - list of all entities in the world
color[] gBColor = new color[256];
boolean[] gBIsSolid = new boolean[256];
int[] gBStrength = new int[256];
boolean[] sBHasImage = new boolean[256];
PImage[] sBImage = new PImage[256];
int[] sBImageDrawType = new int[256];
boolean[] sBHasText = new boolean[256];
String[] sBText = new String[256];
int[] sBTextDrawType = new int[256];
PVector moveToAnimateStart;
PVector moveToAnimateEnd;
PVector moveToAnimateTime = new PVector(0,0);
PVector wViewCenter;

void M_Setup(){
  safePreSetup();
  frameRate(60);
  strokeCap(SQUARE);
  textAlign(LEFT,CENTER);
  textSize(20);
  setupWorld();
  setupEntities();
    scaleView(10);
  centerView(wSize/2,wSize/2);
  safeSetup();
  refreshWorld();
}


void draw(){
  
  animate();
  //drawWorld();//
  nodeDraw();
  if(!menu){
    updateWorld();
    
  }
  
  manageAsync();
  
  safeUpdate();
  
  
  drawWorld();
  
  drawEntities();
  
  safeDraw();
  
  drawChat();
}

void keyPressed(){
  keyPressedChat();
  
  if(key == ESC) {
    key = 0;
  }
  
  if(chatPushing == false){
    player.moveEvent(0);
  }
  
  safeKeyPressed();
}

void keyReleased(){
  player.moveEvent(1);
  safeKeyReleased();
}

void mousePressed(){
  safeMousePressed();
}

float pointDir(PVector v1,PVector v2){
  float tDir = atan((v2.y-v1.y)/(v2.x-v1.x));
  if(v1.x-v2.x > 0){
    tDir -= PI;
  }
  return tDir;
}

float pointDistance(PVector v1,PVector v2){
  return sqrt(sq(v1.x-v2.x)+sq(v1.y-v2.y));
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

void aSS(int[][] tMat, float tA, float tB, int tValue){ //array set safe
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

void aSS2DB(boolean[][] tMat, float tA, float tB, boolean tValue){ //array set safe
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

int aGS(int[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

int aGS1D(int[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

boolean aGS1DB(boolean[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

color aGS1DC(color[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

boolean aGS2DB(boolean[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

int[] aGAS(int[][] tMat, float tA, float tB){ //array get around safe
  return new int[]{aGS(tMat,tA,tB-1),aGS(tMat,tA+1,tB-1),aGS(tMat,tA+1,tB),aGS(tMat,tA+1,tB+1),aGS(tMat,tA,tB+1),aGS(tMat,tA-1,tB+1),aGS(tMat,tA-1,tB),aGS(tMat,tA-1,tB-1)};
}

float maxAbs(float tA, float tB){
  if(abs(tA)>abs(tB)){
    return tA;
  } else {
    return tB;
  }
}

float minAbs(float tA, float tB){
  if(abs(tA)>abs(tB)){
    return tB;
  } else {
    return tA;
  }
}

PImage resizeImage(PImage tImg, int tw, int th){
  PImage tImgNew = createImage(tw,th,ARGB);
  //tImgNew.loadPixels();
  //tImg.loadPixels();
  for(int i = 0; i < tw; i++){
    for(int j = 0; j < th; j++){
      //tImgNew.pixels[j*tw+i] = tImg.pixels[floor(float(j)/th*tImg.height)*tImg.width+floor(float(i)/tw*tImg.width)];
      tImgNew.set(i,j,tImg.get(5,5));
    }
  }
  //tImgNew.updatePixels();
  //tImg.updatePixels();
  return tImgNew;
}

int asyncC = 0;
int asyncT = 1000;
void manageAsync(){
  while(millis()-40>asyncT){
    asyncT += 40;
    asyncC++;
    safeAsync(asyncC);
    updateEntities(asyncC);
  }
}

float mDis(float x1,float y1,float x2,float y2) {
  return abs(y2-y1)+abs(x2-x1);
}

//STEM Phagescape API v(see above)

//STEM Phagescape API v(see above)

void setupWorld(){
  gScale = float(width)/(gSize-1);
  wU = new int[wSize][wSize];
  wUText = new boolean[wSize][wSize];
  wUDamage = new int[wSize][wSize];
  gU = new int[ceil(gSize)][ceil(gSize)];
}

void refreshWorld(){
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      gU[i][j] = aGS(wU,i+wView.x,j+wView.y);
    }
  }
  waveGrid();
}

void moveToAnimate(PVector tV, float tTime){
  if(millis() > moveToAnimateTime.y){
    moveToAnimateStart = new PVector(wViewCenter.x,wViewCenter.y,wViewCenter.z);
    moveToAnimateEnd = new PVector(tV.x-wViewCenter.x,tV.y-wViewCenter.y);
    moveToAnimateTime = new PVector(millis(), millis()+tTime);
  }
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
  gScale = float(width)/(gSize-1);
  gU = new int[ceil(gSize)][ceil(gSize)];
  refreshWorld();
}

void addGeneralBlock(int tIndex, color tColor, boolean tIsSolid, int tStrength){
  gBColor[tIndex] = tColor;
  gBIsSolid[tIndex] = tIsSolid;
  gBStrength[tIndex] = tStrength;
}

void addImageSpecialBlock(int tIndex, PImage tImage, int tImageDrawType){
  sBHasImage[tIndex] = true;
  if(tImageDrawType == 0){
    tImage.resize(ceil(gScale), ceil(gScale));
  } else if(tImageDrawType == 1){
    tImage.resize(ceil(gScale), ceil(gScale));
  } else {
    tImage.resize(width+ceil(gScale*2), height+ceil(gScale*2));
  }
  sBImage[tIndex] = tImage;
  sBImageDrawType[tIndex] = tImageDrawType;
}

void addTextSpecialBlock(int tIndex, String tText, int tTextDrawType){
  sBHasText[tIndex] = true;
  sBText[tIndex] = tText;
  sBTextDrawType[tIndex] = tTextDrawType;
}

void centerView(float ta, float tb){
  wViewCenter = new PVector(ta,tb,gSize);
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
  
  
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      noStroke();
      int thisBlock = gU[i][j];
      fill(aGS1D(gBColor,thisBlock));
      PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
      rect(floor(tempV.x),floor(tempV.y),ceil(gScale),ceil(gScale)); //-pV.x*gScale
      
      if(sBHasImage[thisBlock]){
        float tScale;
        if(sBImageDrawType[thisBlock] == 0){
          image(sBImage[thisBlock],tempV.x,tempV.y);
        } else if(sBImageDrawType[thisBlock] == 1) {
          image(sBImage[thisBlock],tempV.x,tempV.y);
        } else {
          tScale = width/sBImage[thisBlock].width;
          image(sBImage[thisBlock].get(floor(tempV.x+gScale),floor(tempV.y+gScale),ceil(gScale),ceil(gScale)),tempV.x,tempV.y);
        }
      }
      if(aGS1DB(gBIsSolid,thisBlock)){
        PVector tempV2 = grid2Pos(new PVector(i,j));
        if(aGS(wUDamage,tempV2.x,tempV2.y) > 0){
          if(aGS(wUDamage,tempV2.x,tempV2.y) > aGS1D(gBStrength,thisBlock)){
            aSS(wU,tempV2.x,tempV2.y,0);
            refreshWorld();
          } else {
            stroke(255);
            strokeWeight(gScale/15);
            float Crumble = float(aGS(wUDamage,tempV2.x,tempV2.y)-1)/(aGS1D(gBStrength,thisBlock)-1+.01)*gScale/2;
            line(tempV.x,tempV.y+gScale/2-Crumble,tempV.x+gScale,tempV.y+gScale/2+Crumble);
            line(tempV.x+gScale/2+Crumble,tempV.y,tempV.x+gScale/2-Crumble,tempV.y+gScale);
          }
        }
      }
    }
  }
  
  if(gSize < 30){
    for (Wave w : (ArrayList<Wave>) wL) {
      w.display();
    }
  }
  

  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      int thisBlock = gU[i][j];
      if(sBHasText[thisBlock]){
        PVector tempV = pos2Screen(grid2Pos(new PVector(i,j)));
        if(sBTextDrawType[thisBlock] == 0){
          drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock]);
        } else if(sBTextDrawType[thisBlock] <= 10) {
          if(pointDistance(new PVector(width/2-gScale/2,height/2-gScale/2),tempV) < sBTextDrawType[thisBlock]*gScale){
            drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock]);
          }
        } else if(sBTextDrawType[thisBlock] <= 20) {
          PVector tempV2 = grid2Pos(new PVector(i,j));
          if(pointDistance(new PVector(width/2-gScale/2,height/2-gScale/2),tempV) < (sBTextDrawType[thisBlock]-10)*gScale){
            if(aGS2DB(wUText,tempV2.x,tempV2.y) == false){
              cL.add(new Chat(sBText[thisBlock]));
              aSS2DB(wUText,tempV2.x,tempV2.y,true);
            }
          } else {
            aSS2DB(wUText,tempV2.x,tempV2.y,false);
          }
        }
      }
    }
  }
}

PVector screen2Pos(PVector tA){tA.div(gScale);tA.add(wView); return tA;}

PVector pos2Screen(PVector tA){tA.sub(wView); tA.mult(gScale); return tA;}

PVector grid2Pos(PVector tA){tA.add(new PVector(floor(wView.x),floor(wView.y))); return tA;}

//PVector pos2Grid(PVector tA){tA.sub(new PVector(floor(wView.x),floor(wView.y))); return tA;}

PVector moveInWorld(PVector tV, PVector tS, float tw, float th){
  PVector tV2 = new PVector(tV.x,tV.y);
  if(tS.x > 0){
    if(floor(tV.x+tw/2) != floor(tV.x+tw/2+tS.x)){
      if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y+th/2)) || aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y-th/2))){
        tS = new PVector(0,tS.y);
        tV2 = new PVector(floor(tV.x+tw/2+tS.x)+.999-tw/2,tV2.y);
      }
    }
  } else {
    if(floor(tV.x-tw/2) != floor(tV.x-tw/2+tS.x)){
      if(aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2+tS.x,tV.y+th/2)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2+tS.x,tV.y-th/2))){
        tS = new PVector(0,tS.y);
        tV2 = new PVector(floor(tV.x-tw/2+tS.x)+tw/2,tV2.y);
      }
    }
  }
  tV2 = new PVector(tV2.x+tS.x,tV2.y);
  
  if(tS.y > 0){
    if(floor(tV.y+th/2) != floor(tV.y+th/2+tS.y)){
      if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2,tV.y+th/2+tS.y)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2,tV.y+th/2+tS.y))){
        tS = new PVector(tS.x,0);
        tV2 = new PVector(tV2.x,floor(tV.y+th/2+tS.y)+.999-th/2);
      }
    }
  } else {
    if(floor(tV.y-th/2) != floor(tV.y-th/2+tS.y)){
      if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2,tV.y-th/2+tS.y)) || aGS1DB(gBIsSolid,aGS(wU,tV.x-tw/2,tV.y-th/2+tS.y))){
        tS = new PVector(tS.x,0);
        tV2 = new PVector(tV2.x,floor(tV.y-th/2+tS.y)+th/2);
      }
    }
  }
  tV2 = new PVector(tV2.x,tV2.y+tS.y);
  
  return tV2;
}

PVector blockNear(PVector eV,int tBlock, float tChance){
  float minDis = wSize*wSize;
  PVector tRV = new PVector(random(wSize),random(wSize));
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == tBlock){
        if(random(100)<tChance){
          if(pointDistance(eV, new PVector(i,j)) < minDis){
            tRV = new PVector(i,j);
            minDis = pointDistance(eV,tRV);
          }
        }
      }
    }
  }
  return tRV;
}

PVector blockNearCasting(PVector eV,int tBlock){
  float minDis = 25;
  PVector tRV = new PVector(eV.x,eV.y);
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == tBlock){
        if(pointDistance(eV, new PVector(i,j)) < minDis){
          if(rayCast(i,j,(int) eV.x,(int) eV.y)){
            tRV = new PVector(i,j);
            minDis = mDis(eV.x,eV.y, i,j);
          }
        }
      }
    }
  }
  return tRV;
}

boolean rayCast(int x0, int y0, int x1, int y1){
  boolean tClear = true;
  int itts = ceil(mDis(x0,y0,x1,y1)*5);
  float tempDispX = float(x1-x0)/itts;
  float tempDispY = float(y1-y0)/itts;
  for(int i = 0; i < itts; i++){
    if((round(x0+tempDispX*i) != round(x0) || round(y0+tempDispY*i+.105) != round(y0)) && (round(x0+tempDispX*i) != round(x1) || round(y0+tempDispY*i+.105) != round(y1))){
      if(gBIsSolid[aGS(wU,round(x0+tempDispX*i),round(y0+tempDispY*i+.105))]){
        tClear = false;
      }
    }
  }
  //println(tClear);
  return tClear;
}

//STEM Phagescape API v(see above)

//STEM Phagescape API v(see above)

void genRing(int x, int y, float w, float h, float weight, int b){
  genArc(0,TWO_PI,x,y,w,h,weight,b);
}

void genArc(float rStart, float rEnd, int x, int y, float w, float h, float weight, int b){
  if(rStart > rEnd){float rTemp = rStart; rStart = rEnd; rEnd = rTemp;}
  float dR = rEnd-rStart;
  float c = dR/floor(dR*max(w,h)*10); //dR is range -> range/(circumfrence of arc(radians * 2*max_radius *5 -> 20*radius -> 20 points per block)) -> gives increment value
  float r;
  for(float i = rStart; i < rEnd; i+=c){
    r = (w*h/2)/sqrt(sq(w*cos(i))+sq(h*sin(i)))-weight/2;
    for(float j = 0; j <= weight; j+=.2){
      aSS(wU,x+floor((r+j)*cos(i)),y+floor((r+j)*sin(i)),b);
    }
  }
}

void genCircle(float x, float y, float r, int b){
  PVector centerV = new PVector(x,y);
  for(int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      if(pointDistance(new PVector(i,j), centerV) < r){
        aSS(wU,i,j,b);
      }
    }
  }
}

void genLine(int x1, int y1, int x2, int y2, float weight, int b){
  int itt = ceil(10*pointDistance(new PVector(x1,y1), new PVector(x2,y2)));
  float rise = float(y2-y1)/itt;
  float run = float(x2-x1)/itt;
  float xOff = 0;
  float yOff = 0;
  for(float i = 0; i < itt; i+=1){
    for(float j = 0; j <= weight*10; j+=2){
      xOff = (j-weight*5)*rise;
      yOff = (j-weight*5)*-run;
      aSS(wU,floor(x1+xOff+i*run),floor(y1+yOff+i*rise),b);
    }
  }
}

void genRect(float x, float y, float w, float h, int b){
  w = round(w);
  h = round(h);
  x = round(x);
  y = round(y);
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      aSS(wU,(int)x+i,(int)y+j,b);
    }
  }
}

void genBox(float x, float y, float w, float h, float weight, int b){
  x = round(x); y = round(y); w = round(w); h = round(h); weight = round(weight);
  int hweight = round(weight/2);
  for(int j = 0; j <= weight; j++){
    for(int i = -hweight; i <= w+hweight; i++){
      aSS(wU,(int)x+i,(int)y-hweight+j,b);
      aSS(wU,(int)x+i,(int)(y+h)-hweight+j,b);
    }
    for(int i = -hweight; i <= h+hweight; i++){
      aSS(wU,(int)x-hweight+j,(int)y+i,b);
      aSS(wU,(int)(x+w)-hweight+j,(int)y+i,b);
    }
  }
}

void genRoundRect(float x, float y, float w, float h, float rounding, int b){
  x = round(x); y = round(y); w = round(w); h = round(h); rounding = round(rounding);
  genRect(x+rounding,y,w-rounding*2,h,b);
  genRect(x,y+rounding,w,h-rounding*2,b);
  genCircle(x+rounding,y+rounding,rounding,b);
  genCircle(x+w-rounding,y+rounding,rounding,b);
  genCircle(x+rounding,y+h-rounding,rounding,b);
  genCircle(x+w-rounding,y+h-rounding,rounding,b);
}

void genRandomProb(int from, int[] to, float[] prob){
  float totProb = 0;
  float tRand;
  int k;
  for(int i=0; i<prob.length; i++) {
    totProb += prob[i];
  }
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == from){
        tRand = random(totProb);
        k = 0;
        while(tRand > 0){
          tRand -= prob[k];
          k++;
        }
        wU[i][j] = to[k-1];
      }
    }
  }
}

void genFlood(float x, float y, int b){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    int tB = aGS(wU,x,y);
    if(tB != b){
      aSS(wU,x,y,b);  
      if(aGS(wU,x+1,y) == tB){genFlood(x+1,y,b);}
      if(aGS(wU,x-1,y) == tB){genFlood(x-1,y,b);}
      if(aGS(wU,x,y+1) == tB){genFlood(x,y+1,b);}
      if(aGS(wU,x,y-1) == tB){genFlood(x,y-1,b);}
    }
  }
}

void genReplace(int from, int to){
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == from){
        wU[i][j] = to;
      }
    }
  }
}

boolean genTestPathExists(float x1, float y1, float x2, float y2){
  nmap = new int[wSize][wSize];
  return genTestPathExistsLoop((int) x1, (int) y1, (int) x2, (int) y2);
}

boolean genTestPathExistsLoop(int x, int y, int x2, int y2){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
      if(aGS(nmap,x,y) == 0){
        if(abs(x-x2)+abs(y-y2) <= 1){
          return true;
        }
        aSS(nmap,x,y,1);  
        boolean bools = false;
        if(aGS1DB(gBIsSolid,aGS(wU,x+1,y)) == false){if(genTestPathExistsLoop(x+1,y,x2,y2)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x-1,y)) == false){if(genTestPathExistsLoop(x-1,y,x2,y2)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x,y+1)) == false){if(genTestPathExistsLoop(x,y+1,x2,y2)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x,y-1)) == false){if(genTestPathExistsLoop(x,y-1,x2,y2)){bools=true;}}
        return bools;
      }
  }
  return false;
}

boolean genSpread(int num, int from, int to){
  int froms = 0;
  int tos = 0;
  int tx, ty;
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == from){
        froms++;
      }
    }
  }
  if(froms <= num){
    genReplace(from, to);
    if(froms == num){
      return true;
    } else {
      return false;
    }
  }
  while(tos < num){
    tx = floor(random(wSize));
    ty = floor(random(wSize));
    if(wU[tx][ty] == from){
      wU[tx][ty] = to;
      tos++;
    }
  }
  return true;
}

int genCountBlock(int b){
  int count = 0;
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == b){
        count++;
      }
    }
  }
  return count;
}

//STEM Phagescape API v(see above)

//STEM Phagescape API v(see above)

float chatHeight = 40;
float chatPush = 0;
float chatPushSpeed = .07;
boolean chatPushing = false;
String chatKBS = "";
ArrayList cL = new ArrayList<Chat>();


void drawChat(){
  
  if(chatPushing){
    if(chatPush < 1){
      chatPush+=chatPushSpeed;
    } else {
      chatPush = 1;
    }
  } else {
    if(chatPush > 0){
      chatPush-=chatPushSpeed;
    } else {
      chatPush = 0;
    }
  }
  
  Chat tempChat;
  for(int i = 0; i < cL.size(); i++){
    tempChat = (Chat) cL.get(i);
    tempChat.display(cL.size()-i-1);
  }
  
  if(chatPush > 0){
    textAlign(LEFT,CENTER);
    textSize(20);
    stroke(255,220*chatPush);
    fill(0,200*chatPush);
    rect(0-10,floor(height-chatHeight),width/5*4+10,floor(chatHeight+10),0,100,0,0);
    fill(255,220*chatPush);
    text(chatKBS,chatHeight/5,height-chatHeight/2);
  }
}


class Chat{
  String content;
  int time;
  
  Chat(String tContent) {
    content = tContent;
    time = millis();
  }
  
  void display(int i){
    if(i < height/chatHeight+2){
      if(time+5000>millis() || chatPush > 0){
        float fadeOut = float(millis()-(time+4000))/1000;
        fadeOut = min(max(fadeOut,0),1);
        if(chatPush > 0){
          fadeOut -= chatPush;
        }
        fadeOut = min(max(fadeOut,0),1);
        
        
        noStroke();
      
        fill(0,100+100*chatPush-255*fadeOut);
        rect(0-10,height-chatHeight-chatHeight*i-chatHeight*chatPush,textWidth(content)+chatHeight,chatHeight,0,100,100,0);
        fill(255,170+50*chatPush-255*fadeOut);
        text(content,chatHeight/5,height-chatHeight/2-chatHeight*i-chatHeight*chatPush);
      }
    }
  }
  
}

void drawTextBubble(float tx, float ty, String tText){
  float tw = textWidth(tText)+chatHeight;
  float td = chatHeight;
  
  float tx2 = tx-(tx-width/2)/(width/2)*tw/2*1.5;
  float ty2 = -abs(ty-(td+chatHeight/2))/(ty-(td+chatHeight/2))*td+ty;
  
  stroke(255,100);
  strokeWeight(7);
  fill(255);
  triangle(tx,ty,tx2-chatHeight/2+(tx-width/2)/(width/2)*tw/4,ty2,tx2+chatHeight/2+(tx-width/2)/(width/2)*tw/4,ty2);
  rect(tx2-tw/2,ty2-chatHeight/2,tw,chatHeight,chatHeight/10);
  fill(0);
  text(tText,tx2-tw/2+chatHeight/2,ty2);
}

void keyPressedChat(){
  if(chatPushing){
    if(key != CODED){
      if(keyCode == BACKSPACE){
        if(chatKBS.length() > 0){
          chatKBS = chatKBS.substring(0,chatKBS.length()-1);
        }
      } else if(key == ESC) {
        chatPushing = false;
        chatKBS = "";
      } else if(keyCode == ENTER) {
        if(chatKBS.length() > 0){
          cL.add(new Chat(chatKBS));
          chatKBS = "";
          chatPushing = false;
          chatPush = 0;
        }
      } else {
        if(textWidth(chatKBS+key) < width/5*4-chatHeight/5*2){
          chatKBS = chatKBS+key;
        }
      }
    }
  } else {
    if(key == 't' || key == 'T' || key == 'c' || key == 'C' || key == ENTER){
      chatPushing = true;
    }
  }
}

//STEM Phagescape API v(see above)

//STEM Phagescape API v(see above)

EConfig bulletEntity = new EConfig();

void setupEntities(){
  bulletEntity.Size = .1; //TO BE REMOVED
  player = new Entity(wSize/2,wSize/2,new EConfig(),0);
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

//STEM Phagescape API v(see above)

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
      gM[i*2+1][j*2+1] = gU[i][j];
    }
  }
  for(int i = 0; i < gSize*2+1; i++){
    for(int j = 0; j < gSize*2+1; j++){
      if(i%2!=j%2){
        if((gM[min(i+1,ceil(gSize)*2)][j] != -2 && gM[max(i-1,0)][j] != -2) && gM[min(i+1,ceil(gSize)*2)][j] != gM[max(i-1,0)][j]){
          wL.add(new Wave(i,j,0,1,(j+i)%4-2));
        }
        if((gM[i][min(j+1,ceil(gSize)*2)] != -2 && gM[i][max(j-1,0)] != -2) && gM[i][min(j+1,ceil(gSize)*2)] != gM[i][max(j-1,0)]){
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
    
    
    
    strokeWeight(gScale/15);
    stroke(255);
    line(ta.x,ta.y,tb.x,tb.y);
    noStroke();
    fill(255);
    ellipse(ta.x,ta.y,gScale/15-1,gScale/15-1);
    ellipse(tb.x,tb.y,gScale/15-1,gScale/15-1);
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

//STEM Phagescape API v(see above)

void nodeWorld(PVector startV, int targetBlock, int vision){
  int q;
  Node n2;
  for ( int ix = 0; ix < wSize; ix+=1 ) {
    for ( int iy = 0; iy < wSize; iy+=1) {
      if ((gBIsSolid[wU[ix][iy]] == false && mDis(ix,iy,startV.x,startV.y)<vision) || (ix == floor(startV.x) && iy == floor(startV.y)) || wU[ix][iy] == targetBlock) {
        nodes.add(new Node(ix,iy));
        nmap[iy][ix] = nodes.size()-1;
        if (ix>0) {
          if (nmap[iy][ix-1]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy][ix-1]),cost);
            ((Node)nodes.get(nmap[iy][ix-1])).addNbor(n2,cost);
          }
        }
        if (iy>0) {
          if (nmap[iy-1][ix]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy-1][ix]),cost);
            ((Node)nodes.get(nmap[iy-1][ix])).addNbor(n2,cost);
          }
        }
      } else {
        nmap[iy][ix] = -1;
      }
    }
  }
}
 
boolean astar(int iStart, int targetBlock) {
  float endX,endY;
   
  openSet.clear();
  closedSet.clear();
  path.clear();
   
  //add initial node to openSet
  openSet.add( ((Node)nodes.get(iStart)) );
  ((Node)openSet.get(0)).p = -1;
  ((Node)openSet.get(0)).g = 0;
  PVector tVec = blockNear(new PVector(((Node)openSet.get(0)).x,((Node)openSet.get(0)).y), targetBlock, 100);
  ((Node)openSet.get(0)).h = mDis( ((Node)openSet.get(0)).x, ((Node)openSet.get(0)).y, tVec.x, tVec.y );
   
  Node current;
  float tentativeGScore;
  boolean tentativeIsBetter;
  float lowest = 999999999;
  int lowId = -1;
  while( openSet.size()>0 ) {
    lowest = 999999999;
    for ( int a = 0; a < openSet.size(); a++ ) {
      if ( ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h ) <= lowest ) {
        lowest = ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h );
        lowId = a;
      }
    }
    current = (Node)openSet.get(lowId);
    if ( aGS(wU,current.x,current.y) == targetBlock) { //path found
      //follow parents backward from goal
      Node d = (Node)openSet.get(lowId);
      while( d.p != -1 ) {
        path.add( d );
        d = (Node)nodes.get(d.p);
      }
      return true;
    }
    closedSet.add( (Node)openSet.get(lowId) );
    openSet.remove( lowId );
    for ( int n = 0; n < current.nbors.size(); n++ ) {
      if ( closedSet.contains( (Node)current.nbors.get(n) ) ) {
        continue;
      }
      tentativeGScore = current.g + mDis( current.x, current.y, ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y )*((Float)current.nCost.get(n));
      if ( !openSet.contains( (Node)current.nbors.get(n) ) ) {
        openSet.add( (Node)current.nbors.get(n) );
        tentativeIsBetter = true;
      }
      else if ( tentativeGScore < ((Node)current.nbors.get(n)).g ) {
        tentativeIsBetter = true;
      }
      else {
        tentativeIsBetter = false;
      }
       
      if ( tentativeIsBetter ) {
        ((Node)current.nbors.get(n)).p = nodes.indexOf( (Node)closedSet.get(closedSet.size()-1) ); //!!!!
        ((Node)current.nbors.get(n)).g = tentativeGScore;
        tVec = blockNear(new PVector(((Node)current.nbors.get(n)).x,((Node)current.nbors.get(n)).y), targetBlock, 100);
        ((Node)current.nbors.get(n)).h = mDis( ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y, tVec.x, tVec.y );
      }
    }
  }
  //no path found
  return false;
}

class Node {
  float x,y;
  float g,h;
  int p;
  ArrayList nbors; //array of node objects, not indecies
  ArrayList nCost; //cost multiplier for each corresponding
  Node(float _x,float _y) {
    x = _x;
    y = _y;
    g = 0;
    h = 0;
    p = -1;
    nbors = new ArrayList();
    nCost = new ArrayList();
  }
  void addNbor(Node _node,float cm) {
    nbors.add(_node);
    nCost.add(cm);
  }
}

int[][] nmap;
int start = -1;
 
ArrayList openSet;
ArrayList closedSet;
ArrayList nodes = new ArrayList();
ArrayList path = new ArrayList();
 
ArrayList searchWorld(PVector startV, int targetBlock, int vision) {
  //size(480,320); //can be any dimensions as long as divisible by 16
  nmap = new int[wSize][wSize];
  openSet = new ArrayList();
  closedSet = new ArrayList();
  nodes = new ArrayList();
  path = new ArrayList();
  
  //generateMap(targetBlock);
  

  nodeWorld(startV, targetBlock, vision);
  
  
  int start = aGS(nmap,startV.y,startV.x);
  boolean tempB = false;
  if(start > -1){
    tempB = astar(start,targetBlock);
  }
  
  if(tempB == false){
    path = new ArrayList();
  }
  
  return path;
}

void nodeDraw() {
  Node t1;
  for ( int i = 0; i < nodes.size(); i++ ) {
    t1 = (Node)nodes.get(i);
    if (i==start) {
      fill(0,255,0);
    }
    else {
      if (path.contains(t1)) {
        fill(255);
        if(((Node)path.get(path.size()-1)).x == t1.x && ((Node)path.get(path.size()-1)).y == t1.y){
          fill(0,0,255);
        }
      }
      else {
        fill(150,150,150);
      }
    }
    noStroke();
    PVector tVec = pos2Screen(new PVector(t1.x,t1.y));
    rect(tVec.x+gScale/4,tVec.y+gScale/4,+gScale/2,+gScale/2);
  }
}

//STEM Phagescape API v(see above)
