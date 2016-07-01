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
import ddf.minim.*;
import harvway.ajio.*;
//import ddf.minim.*;
Minim minim;
AJ aj;

float wPhase = 0; //the current phase of all waves in the world (where they are in their animation)
PVector wView = new PVector(45,45); //current world position of the center of the viewing window
PVector wViewLast = new PVector(0,0); //previous world position of the center of the viewing window (last time draw was executed)
int[] pKeys = new int[4];
Mimic player;
boolean menu = false;

ArrayList mimics = new ArrayList<Mimic>();
ArrayList particles = new ArrayList<Particle>();
color strokeColor = color(255);



color[] gBColor = new color[256];
boolean[] gBIsSolid = new boolean[256];
int[] gBStrength = new int[256];



int[] gBBreakType = new int[256];
String[] gBBreakCommand = new String[256];
boolean[] sBHasAction = new boolean[256];
int[] sBAction = new int[256];
PVector moveToAnimateStart;
PVector moveToAnimateEnd;
PVector moveToAnimateTime = new PVector(0,0);
PVector wViewCenter = new PVector(50,50);
PFont fontNorm;
PFont fontBold;
int[][] distanceMatrix = new int[300][300];
boolean shadows = false; //are there shadows?
int lightStrength = 10;
boolean mouseClicked = false;
boolean drawHUDSoftEdge = false;
int fn = 0;
int frameRateGoal = 45;

boolean clicking = true;
PVector clickPos = new PVector(-1,-1);
boolean isLeft;
boolean isRight;
boolean isI;

void M_Setup(){
  minim = new Minim(this);
  aj = new AJ();
  try{
    aj.Setup(dataPath("")+"\\D\\");
    println("DONE WITH SETUP!");
  }catch(Throwable e){}
  fontNorm = createFont(aj.D()+"monofontolight.ttf",18);//"Monospaced.norm-23.vlw"
  fontBold = createFont(aj.D()+"monofonto.ttf",18);//"Monospaced.bold-23.vlw"
  HUDImage = loadImage(aj.D()+"shadowHUD.png");
  arrowImg = loadImage(aj.D()+"arrow.png");
  frameRate(frameRateGoal);
  strokeCap(SQUARE);
  textAlign(LEFT,CENTER);
  textSize(20);
  safePreSetup();
  
  setupWorld();
  setupDebug();
  setupMimics();
  scaleView(10);
  centerView(wSize/2,wSize/2);
  safeSetup();
  
  refreshWorld();
  
  wView.x -= .1; wView.y -= .1; refreshWorld(); wView.x += .1; wView.y += .1; // prefrence for positive blocks rendering on minimap
  
  refreshWorld();
}


void draw(){
  if(clicking){
    if(pointDistance(clickPos,new PVector(mouseX,mouseY)) > 5){
      clicking = false;
    } else if(mousePressed == false){
      mouseClicked = true;
      safeMouseClicked();
      clicking = false;
    }
  }
  
    
    animate();
  
    //nodeDraw();
  
  manageAsync();
  
  safeUpdate();
  
  drawWorld();
  
    safePostUpdate();
    
    drawEntities();
    drawParticles();
  
    drawSound();
  
  safeDraw();
  
    drawHUD();
  
    safePostDraw();
  
  mouseClicked = false;
  
  
  //updateDebug();
  
}

void keyPressed(){
  keyPressedChat();
  
  if(key == ESC) {
    key = 0;
  }
  
  if(key == 'i' || key == 'I'){
    isI = true;
  }
  
  if(key == '+') {
    if(miniMapZoom < 20){
      miniMapZoom++;
    }
    updateMinimap();
  }
  if(key == '-') {
    if(miniMapZoom > 0){
      miniMapZoom--;
    }
    updateMinimap();
  }
  if(key == 'M' || key == 'm'){
    miniMapScale = 6;
    updateMinimap();
    aj.hud("mapScale","1");
  }
  
  safeKeyPressed();
}

void keyReleased(){
  player.moveEvent(1);
  safeKeyReleased();
  if(key == 'i' || key == 'I'){
    isI = false;
  }
  if(key == 'M' || key == 'm'){
    miniMapScale = 2;
    updateMinimap();
    aj.hud("mapScale","0");
  }
  
}

void mousePressed(){
  clicking = true;
  if(mouseButton == RIGHT){
    isRight = true;
  } else if(mouseButton == LEFT){
    isLeft = true;
  }
  clickPos = new PVector(mouseX,mouseY);
  
  safeMousePressed();
}

void mouseReleased(){
  
  if(mouseButton == RIGHT){
    isRight = false;
    //println("Right");
  } else if(mouseButton == LEFT){
    isLeft = false;
    //println("Left");
  }
  
  safeMouseReleased();
}

float pointDir(PVector v1,PVector v2){
  if((v2.x-v1.x) != 0){
    float tDir = atan((v2.y-v1.y)/(v2.x-v1.x));
    if(v1.x-v2.x > 0){
      tDir -= PI;
    }
    return tDir;
  } else {
    if((v2.y-v1.y) != 0){
      if(v2.y > v1.y){
        return PI/2;
      } else {
        return PI/2*3;
      }
    } else {
      return random(2*PI);
    }
  }
}

float pointDistance(PVector v1,PVector v2){
  return sqrt(sq(v1.x-v2.x)+sq(v1.y-v2.y));
}
/*
SnapBullet[] arrayRemove(SnapBullet[] array, int item) {
  SnapBullet[] outgoing = new SnapBullet[array.length - 1];
  System.arraycopy(array, 0, outgoing, 0, item);
  System.arraycopy(array, item+1, outgoing, item, array.length - (item + 1));
  return outgoing;
}
*/
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
    return 0;
  }
  return (tB-tA)/abs(tB-tA);
}

int total(int[] list){
  int myReturn = 0;
  for(int i = 0; i < list.length; i++){
    myReturn += list[i];
  }
  return myReturn;
}

float posMod(float tA, float tB){
  float myReturn = tA%tB;
  if(myReturn < 0){
    myReturn+=tB;
  }
  return myReturn;
}

void aSS(int[][] tMat, float tA, float tB, int tValue){ //array set safe
  //println(tValue);
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

void aSS2DB(boolean[][] tMat, float tA, float tB, boolean tValue){ //array set safe
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

int aGS(int[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

ArrayList aGSAL(ArrayList[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

int aGS1D(int[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

void aSS1D(int[] tMat, float tA, int tValue){ //array set safe
  //println(tValue);
  tMat[max(0,min(tMat.length-1,(int)tA))] = tValue;
}

boolean aGS1DB(boolean[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

String aGS1DS(String[] tMat, float tA){ //array get safe
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

float runAvg(float curAvg, float newVal, int pastValNum){
  return (curAvg*pastValNum+newVal)/float(pastValNum+1);
}

int mode(int[] array) {
    int[] modeMap = new int [255];
    int maxEl = array[0];
    int maxCount = 1;

    for (int i = 0; i < array.length; i++) {
        int el = array[i];
        if (modeMap[el] == 0) {
            modeMap[el] = 1;
        }
        else {
            modeMap[el]++;
        }

        if (modeMap[el] > maxCount) {
            maxEl = el;
            maxCount = modeMap[el];
        }
    }
    return maxEl;
}

boolean boxHitsBlocks(float x, float y, float w, float h){
  if(gBIsSolid[aGS(wU,x-w/2,y-h/2)]){
    return true;
  }
  if(gBIsSolid[aGS(wU,x+w/2,y-h/2)]){
    return true;
  }
  if(gBIsSolid[aGS(wU,x-w/2,y+h/2)]){
    return true;
  }
  if(gBIsSolid[aGS(wU,x+w/2,y+h/2)]){
    return true;
  }
  return false;
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

int lastMillis = 0;
int asyncT = 1000;
void manageAsync(){
  while(millis()-40>asyncT){
    if(millis()-1000 > asyncT){ asyncT = millis(); }
    asyncT += 40;
    fn++;
    safeAsync();
    debugLog(color(0,255,0));
    updateWorld();
    updateEntities();
    updateSound();
    updateTips();
    if(fn % 13 == 0){
      updateSpawners();
    }
    if(fn % 125 == 0){
      //healEntities();
    }
    //updateServer();
  }
}

float mDis(float x1,float y1,float x2,float y2) {
  return abs(y2-y1)+abs(x2-x1);
}

String StringReplaceAll(String str, String from, String to){
  int index = str.indexOf(from);
  while(index != -1){
    str = str.substring(0,index) + to + str.substring(index+from.length(),str.length());
    index = str.indexOf(from);
  }
  return str;
}

PImage toughRect(PImage canvas, int x, int y, int w, int h, int col){
  int xCap = min(max(x+w,0),canvas.width-1);
  int yCap = min(max(y+h,0),canvas.width-1);
  for(int i = min(max(x,0),canvas.width-1); i < xCap; i++){
    for(int j = min(max(y,0),canvas.width-1); j < yCap; j++){
      canvas.pixels[j*canvas.width+i] = col;
    }
  }
  return canvas;
}


