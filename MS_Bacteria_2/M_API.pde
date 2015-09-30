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
