int gSelected = 1; //current selected 

void safeSetup(){ 
  /* recommended order of events: add required world blocks, generate the world */
  
  addGeneralBlock(0,color(0,0,0),false);
  addGeneralBlock(1,color(255,0,0),true);
  addGeneralBlock(2,color(0,255,0),true);
  addGeneralBlock(3,color(0,0,255),true);
  addGeneralBlock(4,color(0,255,255),true);
  addGeneralBlock(5,color(255,0,255),true);
  addGeneralBlock(6,color(255,255,0),true);
  addGeneralBlock(7,color(255,255,255),true);
  addGeneralBlock(8,color(100,100,100),true);
  addGeneralBlock(9,color(200,200,200),true);
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wU[i][j] = 0;
      if(random(100)<40){
        wU[i][j] = floor(random(7));
      }
    }
  }
}

float tempZooms = 0;
void safeUpdate(){
  /* recommended order of events: make changes to the world and entities, change the view */
  //scaleWorld(float(mouseX)/50);
  
  //println(frameRate);
  /*
  //tempZooms+=99;
  if(tempZooms < 100){
    centerView(10,10);
    scaleView(7);
  } else {
    if(tempZooms < 1100){
      
      
    } else {
      //centerView(90,90);
      //float temp2 = 1/(1+pow(9000,(-(tempZooms-100)/1000+.5)));
      //centerView(10+temp2*80,10+temp2*80);
      //scaleWorld(7);
    }
  }
  */
  
  
  
  
  
  centerView(player.x,player.y);
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6);
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2-2,maxAbs(0,float(mouseY-height/2)/50)+height/2-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX)-2,height/2+(pmouseY-mouseY)-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);}
}

void safeDraw(){
  /* recommended order of events: draw things over the world (if needed) */
  
}

void mousePressed(){
  if(!menu){
    if(mouseButton == RIGHT){
      PVector tempPosS = screen2Pos(new PVector(mouseX,mouseY));
      aSS(wU,tempPosS.x,tempPosS.y,gSelected);
      //wU[min(wSize-1,max(0,(int)tempPosS.x))][min(wSize-1,max(0,floor(float(mouseY)/gScale+pV.y)+round(pG.y)))] = gSelected;
    }
    refreshWorld();
  } else {
    if(bEdit){
      mousePressedBEdit();
    }
  }
}

void keyPressed(){
  player.moveEvent(0);
}
void keyReleased(){
  player.moveEvent(1);
}
//THIS IS THE ONLY PLACE IN THE M_FILES THAT YOU SHOULD EVER CHANGE (WITH ONE EXCEPTION), IF YOU NEED TO MAKE A CHANGE ELSEWARE IN THE M_FILES, CONTACT AJ FIRST - lavabirdaj@gmail.com
int sSize = 700; //Must be same as the numbers in the size() function on the first line of your draw() loop
int wSize = 100; //blocks in the world (square)
float gSize = 8; //grid units displayed on the screen (blocks in view) (square)
//END OF CONFIGURATION, DO NOT CHANGE BELOW THIS LINE - ONE EXCEPTION ON THE FIRST LINE OF THE SETUP FUCTION
/*
********** Important Function and Variable Outline **********
//for each item please replace the '_VARIABLE_' including the _ characters with your function values
***** View Changes *****
centerView(_X_,_Y_) //set the center of the screen view to a world coordinate position, such as the player position
scaleView(_SIZE_)
moveToAnimate(new PVector(_X_,_Y_), int t) //moves to a position over time (t) in milliseconds
***** World Changes *****
setupWorld() //apply changes to world size (wSize) and clear the world
refreshWorld() //redraw the world after block changes have been made
aGS(wU,_X_,_Y_) //access a block at a position in the world - each block is represented by a general block ID
aSS(wU,_X_,_Y_,_BLOCK_ID_) //change a block at a position in the world
addGeneralBlock(_BLOCK_ID_,color(_R_,_G_,_B_),_IS_SOLID?_) //make this block ID represent a block with a certain color that is either solid (true) or not solid (false)
addSpecialBlock(_BLOCK_ID_,_HAS_IMAGE?_,_IMAGE_,_IMAGE_MODE_,_HAS_TEXT?_,_TEXT_,_TEXT_MODE_) //make this block ID represent a block that has (true) or does not have (false) an image and has or does not have text
//_BLOCK_ID_ is the block that is being updated, _HAS_IMAGE?_ is a boolean (true/false) statement, _IMAGE_ is a PImage (you may look this up), _IMAGE_MODE_ is an integer representing the drawing method (0 = no squish, 1 = squish, 2 = absolute position (like the cartoon Chowder))
//_HAS_TEXT?_ is a boolean (true/false) statement, _TEXT_ is a string of characters, like 'hello there!', _TEXT_MODE_ is an integer representing the drawing method (0 = always display text bubble, 1-10 = display buble at distances 1-10, 11-20 = send chat message at distances 1-10)
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
float gScale; //the width and height of blocks being drawn to the screen in pixels
float wPhase = 0; //the current phase of all waves in the world (where they are in their animation)
ArrayList wL = new ArrayList<Wave>(); //Wave list - list of all waves in the world
PVector wView = new PVector(45,45); //current world position of the center of the viewing window
PVector wViewLast = new PVector(0,0); //previous world position of the center of the viewing window (last time draw was executed)
int[] pKeys = new int[4];
Entity player;
boolean menu = false;
ArrayList entities = new ArrayList<Entity>(); //Entity list - list of all entities in the world
color[] gBColor;
boolean[] gBIsSolid;
boolean[] sBHasImage;
PImage[] sBImage;
int[] sBImageDrawType;
boolean[] sBHasText;
String[] sBText;
int[] sBTextDrawType;
PVector moveToAnimateStart;
PVector moveToAnimateEnd;
PVector moveToAnimateTime = new PVector(0,0);
PVector wViewCenter;

void setup(){
  size(700,700); //Must be same as sSize above (square) //YOU MUST CHANGE THIS LINE IF YOU CHANGE THE SIZE ABOVE
  frameRate(25);
  smooth(1);
  strokeCap(SQUARE);
  setupWorld();
  setupEntities();
  safeSetup();
  refreshWorld();
}

void draw(){
  animate();
  
  if(!menu){
    updateWorld();
    updateEntities();
  }
  
  safeUpdate();
  
  
  drawWorld();
  drawEntities();
  
  safeDraw();
  
  if(bEdit){
    drawBEdit();
  }
}

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

void aSS(int[][] tMat, float tA, float tB, int tValue){ //array set safe
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

int aGS(int[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

int aGS(int[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
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

