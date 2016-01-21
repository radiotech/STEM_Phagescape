import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MS_Bacteria_2 extends PApplet {

/* @pjs preload="face.png"; */

Entity testEntity;
SoundConfig doorSound = new SoundConfig( 3, 200, 255, color(100,100,255), 10, 1, 15, 2, 0);
SoundConfig entitySound = new SoundConfig( .2f, 55, 100, color(0), -1, 3, 2, 0, 90);

/*LOCK*/public void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/public void safePreSetup(){} //first function called, in case you need to set some variables before anything else starts

/*LOCK*/public void safeSetup(){ //called when world generation and entity placement is ready to begin
  
  //shadows = true;
  
  
  bulletEntity.Size = .1f;
  
  for(int i = 0; i < 1; i++){
    testEntity = new Entity(51,51,new EConfig(),0);
    testEntity.EC.Genre = 1;
    testEntity.EC.Img = loadImage("face.png");
    testEntity.EC.AISearchMode = 11;
    testEntity.EC.AITarget = -1;
    testEntity.EC.AITargetID = player.EC.ID;
    testEntity.EC.AIDoorBlock = 8;
    testEntity.AITargetPos = new PVector(wSize/2,wSize/2);
    testEntity.EC.SMax = .15f;
    testEntity.EC.TSMax = .31f;
    testEntity.EC.TAccel = .300f;
    testEntity.EC.TDrag = 8;
    testEntity.EC.Type = 1;
    testEntity.EC.GoalDist = 0; //Want to get this close
    testEntity.EC.ActDist = 1;
    entities.add(testEntity);
    
  }
  
  CFuns.add(new CFun(0,"door",2,false)); //add a function that adds a number, n, to the goal number for a type of bacteria, type, (id, function, argument #, can be used by the user directly? true/false)
  
  //genReplace(0,1);
  //genReplace(2,1);
  //genReplace(3,2);
  //genReplace(4,1);
  
  //wU[50][48] = 4;
  
  /*
  genReplace(0,1);
  for(int i = 1; i < 10; i++){
    genRing(50,50,i*10,i*10,0,3);
  }
  
  int[] blocksArg = { 3, 5}; //create a set of blocks
  float[] probArg = { 20, 4 }; //create a list of probabilities for these blocks
  genRandomProb(3, blocksArg, probArg); //place these blocks in the world with their respective probabilities (the world, by default is all 0 and these random blocks replace 0 here)
  
  
  
  scaleView(10); //scale the view to fit the entire map
  centerView(wSize/2,wSize/2); //center the view in the middle of the world
  */
  
  
  
  addGeneralBlock(0,color(120,12,0),false,0); //inside
  addGeneralBlock(5,color(120,12,0),false,0); //inside
  addGeneralBlock(6,color(120,12,0),false,0); //inside
  
  
  addGeneralBlock(1,color(100,100,120),false,0); //outside
  
  addGeneralBlock(2,color(100,100,120),false,1); //safety
  
  addGeneralBlock(3,color(50,0,0),true,-1); //wall
  
  addGeneralBlock(4,color(255,30,30),true,-1); //door closed
  addActionSpecialBlock(4,46);
  addGeneralBlockBreak(4,7,"door _x_ _y_");
  addGeneralBlock(7,color(120,12,0),false,-1); //door open
  addActionSpecialBlock(7,46);
  addGeneralBlockBreak(7,4,"door _x_ _y_");
  
  addGeneralBlock(8,color(200,180,30),true,0); //door frame
  addActionSpecialBlock(8,46);
  addGeneralBlockBreak(8,9,"door _x_ _y_");
  addGeneralBlock(9,color(0,180,30),true,0); //door frame2
  addActionSpecialBlock(9,46);
  addGeneralBlockBreak(9,8,"door _x_ _y_");
  
  addGeneralBlock(30,color(200,180,30),true,0); //door frame (closet)
  addActionSpecialBlock(30,46);
  addGeneralBlockBreak(30,31,"door _x_ _y_");
  addGeneralBlock(31,color(200,180,30),true,0); //door frame2 (closet)
  addActionSpecialBlock(31,46);
  addGeneralBlockBreak(31,30,"door _x_ _y_");
  
  addGeneralBlock(10,color(0,0,0),true,0); //block
  
  /*
  addImageSpecialBlock(7,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(0,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(5,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(6,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(3,loadImage("a.png"),0); //
  addImageSpecialBlock(8,loadImage("log_birch_top.png"),0); //
  addImageSpecialBlock(9,loadImage("log_birch_top.png"),0); //
  addImageSpecialBlock(4,loadImage("log_birch.png"),0); //
  */
  
  //addTextSpecialBlock(4,"Hello World",11); //make block four display text when the player is near
  
  //int[] blocksArg = { 0, 1, 2, 3, 4 }; //create a set of blocks
  //float[] probArg = { 20, 14, 3, 2, 1 }; //create a list of probabilities for these blocks
  //genRandomProb(0, blocksArg, probArg); //place these blocks in the world with their respective probabilities (the world, by default is all 0 and these random blocks replace 0 here)

  
  genLoadMap(loadImage("map.png"));
  
  scaleView(100); //scale the view to fit the entire map
  centerView(wSize/2,wSize/2); //center the view in the middle of the world
  //player.y = -3;
  
  //entities.remove(player); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  
  
  
  //entities.remove(player); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  //testEntity.destroy();
}

/*LOCK*/public void safeAsync(int n){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  if(n%25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    println(frameRate); //display the game FPS
  }
  if(n%150 == 1){
    sL.add(new Sound(testEntity.eV.x,testEntity.eV.y,entitySound,0));
  }
  if(n%250 == 0){} //every ten seconds (similar idea applies here)
}

/*LOCK*/public void safeUpdate(){ //called before anything has been drawn to the screen (update the world before it is drawn)
  centerView(player.x,player.y); //center the view on the player
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6); //center view on the player but pull toward the mouse slightly
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2,maxAbs(0,float(mouseY-height/2)/50)+height/2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y); //move the view in the direction of the mouse
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX),height/2+(pmouseY-mouseY)); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);} //drag the view around
}

/*LOCK*/public void safeDraw(){
  ellipse(testEntity.eV.x/100*width,testEntity.eV.y/100*width,10,10);
  
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(testEntity.AIMap[i][j] > 0){
        fill(0,0,255,testEntity.AIMap[i][j]*40);
      } else {
        fill(0,255,0,-testEntity.AIMap[i][j]*40);
      }
      noStroke();
      rect(i*width/wSize-wView.x*gScale,j*height/wSize-wView.y*gScale,width/wSize,height/wSize);
    }
  }
  
} //called after everything else has been drawn on the screen (draw things on the game)
public void safePostDraw(){};
/*LOCK*/public void safeKeyPressed(){} //called when a key is pressed
/*LOCK*/public void safeKeyReleased(){} //called when a key is released
/*LOCK*/public void safeMousePressed(){
  if(mouseButton == RIGHT){
    PVector tempV = screen2Pos(new PVector(mouseX,mouseY));
    player.fire(tempV);
  }
  
} //called when the mouse is pressed
public void chatEvent(String source){};
public void executeCommand(int index,String[] commands){
  switch(index){
    case 0:
      sL.add(new Sound(PApplet.parseInt(commands[1])+.5f,PApplet.parseInt(commands[2])+.5f,doorSound,0));
      break;
  }
}

/*LOCK*/public void safeKeyTyped(){} //may be added in the future
/*LOCK*/public void safeMouseWheel(){} //may be added in the future
/*LOCK*/public void safeMouseClicked(){} //may be added in the future
/*LOCK*/public void safeMouseMoved(){} //may be added in the future
/*LOCK*/public void safeMouseDragged(){} //may be added in the future

//STEM Phagescape API v(see above)

public void nodeWorld(PVector startV, int targetBlock, int vision){
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
            float cost = random(0.25f,2);
            n2.addNbor((Node)nodes.get(nmap[iy][ix-1]),cost);
            ((Node)nodes.get(nmap[iy][ix-1])).addNbor(n2,cost);
          }
        }
        if (iy>0) {
          if (nmap[iy-1][ix]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25f,2);
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

public void nodeWorldPos(PVector startV, PVector targetBlock, int vision){
  int q;
  Node n2;
  
  
  
  for ( int ix = 0; ix < wSize; ix+=1 ) {
    for ( int iy = 0; iy < wSize; iy+=1) {
      if ((gBIsSolid[wU[ix][iy]] == false && mDis(ix,iy,startV.x,startV.y)<vision) || (ix == floor(startV.x) && iy == floor(startV.y)) || (ix == floor(targetBlock.x) && iy == floor(targetBlock.y))) {
        
        nodes.add(new Node(ix,iy));
        nmap[iy][ix] = nodes.size()-1;
        if (ix>0) {
          if (nmap[iy][ix-1]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25f,2);
            n2.addNbor((Node)nodes.get(nmap[iy][ix-1]),cost);
            ((Node)nodes.get(nmap[iy][ix-1])).addNbor(n2,cost);
          }
        }
        if (iy>0) {
          if (nmap[iy-1][ix]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25f,2);
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
 
public boolean astar(int iStart, int targetBlock, PVector endV) {
  
  println("d");
  
  openSet.clear();
  closedSet.clear();
  Apath.clear();
   
  //add initial node to openSet
  openSet.add( ((Node)nodes.get(iStart)) );
  ((Node)openSet.get(0)).p = -1;
  ((Node)openSet.get(0)).g = 0;
  PVector tVec;
  if(targetBlock != -1){
    tVec = blockNear(new PVector(((Node)openSet.get(0)).x,((Node)openSet.get(0)).y), targetBlock, 100);
  } else {
    tVec = new PVector(endV.x,endV.y);
  }
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
    if(targetBlock != -1){
      if ( aGS(wU,current.x,current.y) == targetBlock) { //path found
        //follow parents backward from goal
        Node d = (Node)openSet.get(lowId);
        while( d.p != -1 ) {
          Apath.add( d );
          d = (Node)nodes.get(d.p);
        }
        return true;
      }
    } else {
      if ( abs(current.x-endV.x) < .5f && abs(current.y-endV.y) < .5f ) { //path found
        //follow parents backward from goal
        Node d = (Node)openSet.get(lowId);
        while( d.p != -1 ) {
          Apath.add(d);
          d = (Node)nodes.get(d.p);
        }
        return true;
      }
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
        if(targetBlock != -1){
          tVec = blockNear(new PVector(((Node)current.nbors.get(n)).x,((Node)current.nbors.get(n)).y), targetBlock, 100);
        } else {
          tVec = new PVector(endV.x,endV.y);
        }
        
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
  public void addNbor(Node _node,float cm) {
    nbors.add(_node);
    nCost.add(cm);
  }
}

int[][] nmap;
int start = -1;
 
ArrayList openSet;
ArrayList closedSet;
ArrayList nodes = new ArrayList();
ArrayList Apath = new ArrayList();
 
public ArrayList searchWorld(PVector startV, int targetBlock, int vision) {
  //size(480,320); //can be any dimensions as long as divisible by 16
  nmap = new int[wSize][wSize];
  openSet = new ArrayList();
  closedSet = new ArrayList();
  nodes = new ArrayList();
  Apath = new ArrayList();
  
  //generateMap(targetBlock);
  

  nodeWorld(startV, targetBlock, vision);
  
  
  int start = aGS(nmap,startV.y,startV.x);
  boolean tempB = false;
  if(start > -1 && targetBlock > -1){
    tempB = astar(start,targetBlock,null);
  }
  
  if(tempB == false){
    Apath = new ArrayList();
  }
  
  return Apath;
}

public ArrayList searchWorldPos(PVector startV, PVector endV, int vision) {
  //size(480,320); //can be any dimensions as long as divisible by 16
  nmap = new int[wSize][wSize];
  openSet = new ArrayList();
  closedSet = new ArrayList();
  nodes = new ArrayList();
  Apath = new ArrayList();
  
  //generateMap(targetBlock);
  

  nodeWorldPos(startV, endV, vision);
  
  
  int start = aGS(nmap,startV.y,startV.x);
  boolean tempB = false;
  if(start > -1){
    tempB = astar(start,-1,endV);
  }
  
  if(tempB == false){
    Apath = new ArrayList();
  }
  
  return Apath;
}

public void nodeDraw() {
  Node t1;
  for ( int i = 0; i < nodes.size(); i++ ) {
    t1 = (Node)nodes.get(i);
    if (i==start) {
      fill(0,255,0);
    }
    else {
      if (Apath.contains(t1)) {
        fill(255);
        if(((Node)Apath.get(Apath.size()-1)).x == t1.x && ((Node)Apath.get(Apath.size()-1)).y == t1.y){
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
int[][] gU; //Grid unit - contains all blocks being drawn to the screen
boolean[][] gUHUD;
int[][] gM; //Grid Mini - stores information regarding the position of block boundries and verticies for wave generation
int[][] wU; //World Unit - contains all blocks in the world
int[][] wUP; //past
int[][] wUC; //current
int[][] wUDamage;
boolean[][] wUText; //
int[][] wUUpdate; //
float gScale; //the width and height of blocks being drawn to the screen in pixels
float wPhase = 0; //the current phase of all waves in the world (where they are in their animation)
ArrayList wL = new ArrayList<Wave>(); //Wave list - list of all waves in the world
PVector wView = new PVector(45,45); //current world position of the center of the viewing window
PVector wViewLast = new PVector(0,0); //previous world position of the center of the viewing window (last time draw was executed)
int[] pKeys = new int[4];
Entity player;
boolean menu = false;
ArrayList entities = new ArrayList<Entity>(); //Entity list - list of all entities in the world
int[] gBColor = new int[256];
boolean[] gBIsSolid = new boolean[256];
int[] gBStrength = new int[256];
int[] gBBreakType = new int[256];
String[] gBBreakCommand = new String[256];
boolean[] sBHasImage = new boolean[256];
PImage[] sBImage = new PImage[256];
int[] sBImageDrawType = new int[256];
boolean[] sBHasText = new boolean[256];
String[] sBText = new String[256];
int[] sBTextDrawType = new int[256];
boolean[] sBHasAction = new boolean[256];
int[] sBAction = new int[256];
PVector moveToAnimateStart;
PVector moveToAnimateEnd;
PVector moveToAnimateTime = new PVector(0,0);
PVector wViewCenter;
PFont fontNorm;
PFont fontBold;
int[][] distanceMatrix = new int[300][300];
boolean shadows = false; //are there shadows?
int lightStrength = 10;
boolean registeredMouseClick = false;
boolean mouseClicked = false;

public void M_Setup(){
  fontNorm = loadFont("Monospaced.norm-23.vlw");
  fontBold = loadFont("Monospaced.bold-23.vlw");
  frameRate(60);
  strokeCap(SQUARE);
  textAlign(LEFT,CENTER);
  textSize(20);
  safePreSetup();

  setupWorld();
  setupEntities();
  scaleView(10);
  centerView(wSize/2,wSize/2);
  safeSetup();
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUP[i][j] = wU[i][j];
    }
  }
  refreshWorld();
}


public void draw(){
  if(mouseClicked == true) {registeredMouseClick = true;}
  
  animate();
  //drawWorld();//
  nodeDraw();
  //if(!menu){
    
  //}
  
  manageAsync();
  
  safeUpdate();
  
  
  drawWorld();
  
  drawEntities();
  
  safeDraw();
  
  drawChat();
  
  updateSound();
  
  safePostDraw();
  
  if(registeredMouseClick == true){mouseClicked = false; registeredMouseClick=false;}
}

public void keyPressed(){
  keyPressedChat();
  
  if(key == ESC) {
    key = 0;
  }
  
  if(chatPushing == false){
    player.moveEvent(0);
  }
  
  safeKeyPressed();
}

public void keyReleased(){
  player.moveEvent(1);
  safeKeyReleased();
}

public void mousePressed(){
  safeMousePressed();
}

public void mouseClicked(){
  mouseClicked = true;
  safeMouseClicked();
}

public float pointDir(PVector v1,PVector v2){
  if((v2.x-v1.x) != 0){
    float tDir = atan((v2.y-v1.y)/(v2.x-v1.x));
    if(v1.x-v2.x > 0){
      tDir -= PI;
    }
    return tDir;
  } else {
    return random(2*PI);
  }
}

public float pointDistance(PVector v1,PVector v2){
  return sqrt(sq(v1.x-v2.x)+sq(v1.y-v2.y));
}


public float turnWithSpeed(float tA, float tB, float tSpeed){
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

public float angleDif(float tA, float tB){
  tA = posMod(tA,PI*2);
  tB = posMod(tB,PI*2);
  if(tA<tB-PI){tA+=PI*2;}
  if(tB<tA-PI){tB+=PI*2;}
  return tB-tA;
}

public float angleDir(float tA, float tB){
  tA = posMod(tA,PI*2);
  tB = posMod(tB,PI*2);
  if(tA<tB-PI){tA+=PI*2;}
  if(tB<tA-PI){tB+=PI*2;}
  if(tB == tA){
    return 1;
  }
  return (tB-tA)/abs(tB-tA);
}

public float posMod(float tA, float tB){
  float myReturn = tA%tB;
  if(myReturn < 0){
    myReturn+=tB;
  }
  return myReturn;
}

public void aSS(int[][] tMat, float tA, float tB, int tValue){ //array set safe
  //println(tValue);
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

public void aSS2DB(boolean[][] tMat, float tA, float tB, boolean tValue){ //array set safe
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

public int aGS(int[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

public int aGS1D(int[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

public boolean aGS1DB(boolean[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

public String aGS1DS(String[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

public int aGS1DC(int[] tMat, float tA){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))];
}

public boolean aGS2DB(boolean[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}

public int[] aGAS(int[][] tMat, float tA, float tB){ //array get around safe
  return new int[]{aGS(tMat,tA,tB-1),aGS(tMat,tA+1,tB-1),aGS(tMat,tA+1,tB),aGS(tMat,tA+1,tB+1),aGS(tMat,tA,tB+1),aGS(tMat,tA-1,tB+1),aGS(tMat,tA-1,tB),aGS(tMat,tA-1,tB-1)};
}

public float maxAbs(float tA, float tB){
  if(abs(tA)>abs(tB)){
    return tA;
  } else {
    return tB;
  }
}

public float minAbs(float tA, float tB){
  if(abs(tA)>abs(tB)){
    return tB;
  } else {
    return tA;
  }
}

public int mode(int[] array) {
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

public PImage resizeImage(PImage tImg, int tw, int th){
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
public void manageAsync(){
  while(millis()-40>asyncT){
    asyncT += 40;
    asyncC++;
    safeAsync(asyncC);
    updateWorld();
    updateEntities(asyncC);
    if(asyncC % 25 == 0){
      updateSpecialBlocks();
      updateSpawners();
    }
    if(asyncC % 125 == 0){
      healEntities();
    }
  }
}

public float mDis(float x1,float y1,float x2,float y2) {
  return abs(y2-y1)+abs(x2-x1);
}

//STEM Phagescape API v(see above)
//STEM Phagescape API v(see above)

boolean isHoverText = false;
String hoverText = "";

float chatHeight = 40;
float chatPush = 0;
float chatPushSpeed = .07f;
boolean chatPushing = false;
String chatKBS = "";
int totalChatWidth = 0;
int lastChatCount = 0;
ArrayList cL = new ArrayList<Chat>();


ArrayList CFuns = new ArrayList<CFun>();


public void drawChat(){
  
  if(lastChatCount!=cL.size()){
    chatEvent("");
  }
  lastChatCount = cL.size();
  
  
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
    strokeWeight(3);
    fill(0,200*chatPush);
    rect(0-10,floor(height-chatHeight),width/5*4+10,floor(chatHeight+10),0,100,0,0);
    totalChatWidth = textMarkup(chatKBS,chatHeight/5,height-chatHeight/2,color(255),220*chatPush,true);
    //text(chatKBS,chatHeight/5,height-chatHeight/2);
  }
  
  if(isHoverText){
    if(chatPush > .5f){drawTextBubble(mouseX,mouseY,hoverText,127);} else {drawTextBubble(mouseX,mouseY,hoverText,90);}
    isHoverText = false;
  }
}

public int textMarkup(String text, float x, float y, int defCol, float alpha, boolean showMarks){
  textFont(fontBold,23);
  fill(defCol,alpha);
  noStroke();
  int pointer = 0;
  int lastColor = defCol;
  boolean tUL = false;
  boolean tST = false;
  boolean rURL = false;
  String tREF = "";
  for(int i = 0; i < text.length(); i++){
    if(text.charAt(i) == '*'){
      if(showMarks){
        fill(200,0,255,alpha);
        text(text.charAt(i),x+pointer*14,y);
        pointer++;
      }
      if(text.length() > i+1){
        if(showMarks){
          text(text.charAt(i+1),x+pointer*14,y);
          pointer++;
        }
        if(text.charAt(i+1) == 'r'){fill(255,0,0,alpha); lastColor=color(255,0,0);}  
        if(text.charAt(i+1) == 'o'){fill(255,150,0,alpha); lastColor=color(255,150,0);}
        if(text.charAt(i+1) == 'y'){fill(255,255,0,alpha); lastColor=color(255,255,0);}
        if(text.charAt(i+1) == 'g'){fill(0,255,0,alpha); lastColor=color(0,255,0);}
        if(text.charAt(i+1) == 'c'){fill(0,255,255,alpha); lastColor=color(0,255,255);}
        if(text.charAt(i+1) == 'b'){fill(0,0,255,alpha); lastColor=color(0,0,255);}
        if(text.charAt(i+1) == 'p'){fill(225,0,255,alpha); lastColor=color(225,0,255);}  
        if(text.charAt(i+1) == 'm'){fill(255,0,255,alpha); lastColor=color(255,0,255);}
        if(text.charAt(i+1) == 'w'){fill(255,255,255,alpha); lastColor=color(255,255,255);}
        if(text.charAt(i+1) == 'k'){fill(0,0,0,alpha); lastColor=color(0,0,0);}
        if(text.charAt(i+1) == 'i'){textFont(fontNorm,23);}
        if(text.charAt(i+1) == 'n'){fill(defCol,alpha); lastColor=defCol; textFont(fontBold,23); tUL = false; tST = false;}
        if(text.charAt(i+1) == 'u'){tUL = true;}
        if(text.charAt(i+1) == 's'){tST = true;}
        if(text.charAt(i+1) == 'a'){
          tREF = "";
          while(text.length() > i+2 && (text.charAt(i+1) != '!' || text.charAt(i) != '!')){
            if(showMarks){
              text(text.charAt(i+2),x+pointer*14,y);
              pointer++;
            }
            tREF = tREF + text.charAt(i+2);
            i++;
          }
          if(tREF.indexOf("!!") > -1){
            tREF = tREF.substring(0,tREF.length()-2);
            if(tREF.indexOf("::") > -1){
              String[] tREF2 = split(tREF,"::");
              if(tREF2.length == 2){
                for(int j = 0; j < tREF2[1].length(); j++){
                  text(tREF2[1].charAt(j),x+pointer*14,y);
                  pointer++;
                }
                //rect(,y-chatHeight/4,tREF2[1].length()*14,chatHeight/2);
                if(mouseX > x+(pointer-tREF2[1].length())*14 && mouseX < x+pointer*14){
                  if(mouseY > y-chatHeight/4 && mouseY < y+chatHeight/4){
                    if(tREF2[0].indexOf("\"\"") > -1){
                      String[] tREF3 = split(tREF2[0],"\"\"");
                      if(tREF3.length == 2){
                        isHoverText = true;
                        hoverText = tREF3[1];
                        if(mouseClicked){
                          tryCommand(tREF3[0],"");
                        }
                      }
                    }
                  }
                }
              }
            }
            fill(lastColor,alpha);
          }
        }
      }
      i++;
    } else {
      text(text.charAt(i),x+pointer*14,y);
      pointer++;
      if(tUL){
        rect(x+pointer*14-14,y+10,14,1);
      }
      if(tST){
        rect(x+pointer*14-14,y,14,1);
      }
    }
    
  }
  return pointer;
}

class Chat{
  String content;
  int time;
  int totalChatWidthL;
  
  Chat(String tContent) {
    content = tContent;
    time = millis();
    totalChatWidthL = width*2;
  }
  
  public void display(int i){
    if(i < height/chatHeight+2){
      if(time+5000>millis() || chatPush > 0){
        float fadeOut = PApplet.parseFloat(millis()-(time+4000))/1000;
        fadeOut = min(max(fadeOut,0),1);
        if(chatPush > 0){
          fadeOut -= chatPush;
        }
        fadeOut = min(max(fadeOut,0),1);
        
        noStroke();
      
        fill(0,100+100*chatPush-255*fadeOut);
        rect(0-10,height-chatHeight-chatHeight*i-chatHeight*chatPush,14*totalChatWidthL+chatHeight,chatHeight,0,100,100,0);
        totalChatWidthL = textMarkup(content,chatHeight/5,height-chatHeight/2-chatHeight*i-chatHeight*chatPush,color(255),100+100*chatPush-255*fadeOut,false);
      }
    }
  }
}

public void drawTextBubble(float tx, float ty, String tText, float opacity){
  if(tText != ""){
    String[] textFragments = split(tText,"##");
    float tw = 0;
    for(int i = 0; i < textFragments.length; i++){
      tw = max(textFragments[i].length()*14+chatHeight,tw);
    }
    
    float td = chatHeight+(textFragments.length-1)*chatHeight*2/3;
    
    float tx2 = abs(width-tx-tw+.5f)/(width-tx-tw+.5f)*tw/2+tx;
    if(tx2-tw/2 < 0){tx2 = tw/2; if(tw>width){tx2 = width/2;}}
    float ty2 = -abs(ty-(td+chatHeight/2)+.5f)/(ty-(td+chatHeight/2)+.5f)*(td-chatHeight*2/3*(textFragments.length-1)/2)+ty;
    
    noStroke();
    
    int fliph=1;
    int flipv=1;
    if(tx2<tx){fliph=-1;}
    if(ty2>ty){flipv=-1;}
    
    fill(255,opacity/2);
    triangle(tx,ty,tx-3*fliph,ty-(chatHeight/2-3)*flipv,tx+(chatHeight/3+3)*fliph,ty-(chatHeight/2-3)*flipv);
    rect(tx2-tw/2-3-chatHeight/10,ty2-chatHeight/2-3-chatHeight*2/3*(textFragments.length-1)/2,tw+6+chatHeight/5,td+6,chatHeight/10);
    
    fill(255,opacity);
    triangle(tx,ty,tx,ty-chatHeight/2*flipv,tx+chatHeight/3*fliph,ty-chatHeight/2*flipv);
    rect(tx2-tw/2-chatHeight/10,ty2-chatHeight/2-chatHeight*2/3*(textFragments.length-1)/2,tw+chatHeight/5,td,chatHeight/10);
    
    for(int i = 0; i < textFragments.length; i++){
      textMarkup(textFragments[i],tx2-tw/2+chatHeight/2,ty2-chatHeight*2/3*(textFragments.length-1)/2+chatHeight*2/3*i,color(0),opacity*2,false);
    }
  }
}

public void keyPressedChat(){
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
          if(chatKBS.charAt(0) == '/'){
            tryCommand(chatKBS.substring(1,chatKBS.length()),"player");
          } else {
            cL.add(new Chat(chatKBS));
          }
          chatKBS = "";
          chatPushing = false;
          chatPush = 0;
        }
      } else {
        if(14*totalChatWidth < width/5*4-chatHeight/5*2){
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

public void tryCommand(String command, String source) {
  
  String[] commands = split(command," ");
  int args = commands.length-1;
  commands[0] = commands[0].toLowerCase();
  
  Boolean didNone = true;
  for(int i = 0; i < CFuns.size(); i++){
    CFun tempFun = (CFun)CFuns.get(i);
    if(tempFun.name.toLowerCase().equals(commands[0])){
      didNone = false;
      if(source.equals("") || tempFun.free){
        if(tempFun.args == args){
          executeCommand(tempFun.ID,commands);
        } else {
          cL.add(new Chat("*o/*i*o"+commands[0]+"*n*o requires *s*o"+str(tempFun.args)+"*c*o arguments, you provided *s*o"+str(args)));
        }
      } else {
        cL.add(new Chat("*oYou need permission to use /*i*o"+commands[0]+"*n"));
      }
    }

  }
  
  if(commands[0].length()!=0){
    if(didNone){
      cL.add(new Chat("*o/*i*o"+commands[0]+"*n*o was not recognized as a command"));
    }
  }
}



class CFun{
  int ID;
  String name;
  int args;
  boolean free;
  CFun(int tID, String tName, int tArgs, boolean tFree){
    ID = tID;
    name = tName;
    args = tArgs;
    free = tFree;
  }
}




//STEM Phagescape API v(see above)
//STEM Phagescape API v(see above)

boolean[][] smap;

EConfig bulletEntity = new EConfig();

public void setupEntities(){
  
  bulletEntity.Size = .1f; //TO BE REMOVED
  player = new Entity(wSize/2,wSize/2,new EConfig(),0);
  player.EC.Genre = 1;
  player.EC.Img = loadImage("player.png");
  entities.add(player);
}

public void updateEntities(int cycle){
  for (int i = entities.size()-1; i >= 0; i--) {
    Entity tempE = (Entity) entities.get(i);
    tempE.moveAI(cycle);
  }
  if((floor(player.eV.x) != floor(player.eVLast.x)) || (floor(player.eV.y) != floor(player.eVLast.y))){
    updateSpecialBlocks();
  }
}

public void healEntities(){
  for (int i = entities.size()-1; i >= 0; i--) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.eHealth < tempE.EC.HMax){
      tempE.eHealth++;
    } else {
      tempE.eHealth = tempE.EC.HMax;
    }
  }
}

public void drawEntities(){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    tempE.display();
  }
}

class Entity {
  float ID = random(1000);
  
  int trail = 20;
  ArrayList path = new ArrayList<PVector>();
  
  int thisI;
  EConfig EC;
  float x;
  float y;
  PVector eV;
  float eDir = 0;
  PVector eD;
  int eHealth;
  float eSpeed = 0; //Player speed
  float eTSpeed = 0; //Player turn speed
  boolean eMove = false;
  
  PVector eVLast;
  
  float eFade = 0; //Particle fade
  
  int eID;
  
  PVector AITargetPos = new PVector(-1,-1);
  int AIDir = 1;
  boolean AIFollowSide = false;
  int[][] AIMap = new int[100][100];
  
  Entity(float tx, float ty, EConfig tEC, float tDir) {
    x = tx;
    y = ty;
    eDir = tDir;
    eD = new PVector(tx+cos(tDir),ty+sin(tDir));
    EC = tEC;
    eVLast = new PVector(x,y);
    eV = new PVector(x,y);
    eID = floor(random(2147483.647f))*1000;
    eHealth = EC.HMax;
    path.add(new PVector(eV.x, eV.y));
  }
  
  public void moveEvent(int eventID){
    
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
  
  public void moveAI(int cycle){
    eV = new PVector(x,y);
    if(EC.Genre == 0){
      if(x>wSize || x<0 || y>wSize || y<0 || aGS1DB(gBIsSolid,aGS(wU,x,y))){
        if(aGS1DB(gBIsSolid,aGS(wU,x,y))){
          EConfig tempConfig;
          particleEffect(x-.5f,y-.5f,1,1,5,aGS1DC(gBColor,aGS(wU,x,y)),EC.Color,EC.SMax/5);
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
          if(EC.AISearchMode < 10){
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
                if(pointDistance(entityNearID(AITargetPos,EC.AITargetID,30,100),AITargetPos)>.2f){
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
                if(Apath.size()>0){
                  eD = new PVector(((Node)Apath.get(Apath.size()-1)).x+.5f,((Node)Apath.get(Apath.size()-1)).y+.5f);
                } else {
                  if(cycle % 25 == 0){
                    if(pointDistance(eVLast,eV)<EC.Drag){
                      AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);
                    }
                  }
                }
              }
            }
          } else {
            if(EC.AISearchMode == 11 || EC.AISearchMode == 12){
              if(EC.AIDoorBlock > -1){
                for(int i = -4; i < 5; i++){
                  for(int j = -4; j < 5; j++){
                    if(aGS(wU,x+i,y+j)==EC.AIDoorBlock){aSS(wU,x+i,y+j,gBBreakType[EC.AIDoorBlock]);}
                  }
                }
              }
            }
            if(EC.AISearchMode == 11){
              if(pointDistance(eV,AITargetPos)>EC.GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y))==false){
                eMove = true;
              }
              if(cycle % 25 == 0){
                setAITarget();
              }
            } else if(EC.AISearchMode == 12){
              eMove = true;
              if(cycle % 250 == 0){
                AITargetPos = new PVector(eV.x,eV.y);
              }
              if(pointDistance(eV,AITargetPos) < .5f){
                setAITarget();
              }
            }
            
            if(EC.AISearchMode == 21 || EC.AISearchMode == 22){
              if(EC.AIDoorBlock > -1){
                for(int i = -4; i < 5; i++){
                  for(int j = -4; j < 5; j++){
                    if(aGS(wU,x+i,y+j)==EC.AIDoorBlock){aSS(wU,x+i,y+j,gBBreakType[EC.AIDoorBlock]);}
                  }
                }
              }
            }
            if(EC.AISearchMode == 21){
              if(pointDistance(eV,AITargetPos)>EC.GoalDist || rayCast(floor(AITargetPos.x),floor(AITargetPos.y),floor(eV.x),floor(eV.y))==false){
                eMove = true;
              }
              if(cycle % 35 == 0){
                setAITarget();
              }
            } else if(EC.AISearchMode == 22){
              eMove = true;
              if(cycle % 300 == 0){
                for(int i = 0; i < wSize; i++){
                  for(int j = 0; j < wSize; j++){
                    if(aGS(AIMap,i,j) > 1){aSS(AIMap,i,j,aGS(AIMap,i,j)-1);}
                    if(aGS(AIMap,i,j) < -1){aSS(AIMap,i,j,aGS(AIMap,i,j)+1);}
                  }
                }
              }
              if(cycle % 10 == 0){
                for(int i = -6; i < 7; i++){
                  for(int j = -6; j < 7; j++){
                    aSS(AIMap,x+i,y+j,min(aGS(AIMap,x+i,y+j)+1,6));
                  }
                }
                
                for (int k = 0; k < entities.size(); k++) {
                  Entity tempE = (Entity) entities.get(k);
                  if(tempE.EC.ID == EC.AITargetID){
                    for(int i = -6; i < 7; i++){
                      for(int j = -6; j < 7; j++){
                        aSS(AIMap,tempE.x+i,tempE.y+j,max(aGS(AIMap,tempE.x+i,tempE.y+j)-1,-6));
                      }
                    }
                  }
                }
                
              }
              if(cycle % 25 == 0){
                AITargetPos = new PVector(eV.x,eV.y);
              }
              if(pointDistance(eV,AITargetPos) < 1.5f){
                setAITarget();
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
      eV = moveInWorld(eV, new PVector(eSpeed*cos(eDir),eSpeed*sin(eDir)),EC.Size-.5f,EC.Size-.5f);
      
      if(floor(eV.x) != floor(eVLast.x) || floor(eV.y) != floor(eVLast.y)){
        path.add(new PVector(eV.x, eV.y));
        if(path.size() > trail){
          path.remove(0);
        }
      } else {
        PVector tempPV = (PVector)path.get(path.size()-1);
        tempPV.x = eV.x;
        tempPV.y = eV.y;
      }
      
      if(isEntityNearGenreSpecial(eV, 0, EC.Size/3)) {
        Entity te = entityNearGenreSpecial(eV, 0, EC.Size/3);
        te.destroy();
        eHealth--;
        if(eHealth <= 0){
          destroy();
          particleEffect(x-.5f,y-.5f,1,1,30,color(0,0,255),color(0,255,255),.1f);
          if(EC.DeathCommand != ""){
            tryCommand((EC.DeathCommand).replaceAll("_x_",str(x)).replaceAll("_y_",str(y)),"");
          }
        }
      }
  
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
  
  public void setAITarget(){
    if(EC.AISearchMode == 0){
      if(EC.AITarget > -1){AITargetPos = blockNear(eV,EC.AITarget,100);} else {AITargetPos = entityNearID(eV,EC.AITargetID,30,100);}
    } else if(EC.AISearchMode == 1){
      if(EC.AITarget > -1){AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);} else {AITargetPos = entityNearID(eV,EC.AITargetID,30,random(90)+10);}
    } else if(EC.AISearchMode == 2){
      AITargetPos = blockNearCasting(eV,EC.AITarget);
      if(aGS(wU,AITargetPos.x,AITargetPos.y) != EC.AITarget){
        AITargetPos = blockNear(eV,EC.AITarget,random(90)+10);
      }
    } else if(EC.AISearchMode == 3){
      
      if(aGS(wU,eV.x,eV.y) != EC.AITarget){
        searchWorld(eV,EC.AITarget,(int)EC.Vision/10);
        
        if(Apath.size()>0){
          AITargetPos = new PVector(((Node)Apath.get(0)).x,((Node)Apath.get(0)).y);
        }
      }
      
    } else if(EC.AISearchMode == 11){
      //follow path (line of sight)
      //test line of sight, if none, change mode, call again
      PVector tempTarget = rayCastAllPathsID(eV,EC.AITargetID,30);
      if(tempTarget != null){
        AITargetPos = tempTarget;
        println("a");
      } else {
        EC.AISearchMode = 12;
        setAITarget();
        return;
      }
    } else if(EC.AISearchMode == 12){
      //Strange (no line > 10)
      //test line of sight, change mode, call again

      if(rayCastAllPathsID(eV,EC.AITargetID,30) == null){
        AITargetPos.x = floor(AITargetPos.x)+.5f;
        AITargetPos.y = floor(AITargetPos.y)+.5f;
        
        boolean Side = false;
        boolean Front = false;
        boolean LastSide = false;
        boolean[] BlocksAround = getSolidAround(AITargetPos,AIDir,AIFollowSide);
        
        boolean SlideForward = true;
        
        Side = BlocksAround[2];
        Front = BlocksAround[0];
        LastSide = BlocksAround[3];
        if(Side){
          if(Front){
            //turn left
            SlideForward = false;
            if(AIFollowSide){
              AIDir++;
            } else {
              AIDir--;
            }
          } else {
            
          }
        } else {
          if(LastSide){
            //turn right and move into side
            if(AIFollowSide){
              AIDir--;
            } else {
              AIDir++;
            }
          } else {
            if(Front){
              //turn left and start following wall
              SlideForward = false;
              if(AIFollowSide){
                AIDir++;
              } else {
                AIDir--;
              }
            } else {
              //continue streight
            }
          }
        }
        
        if(random(50)<1 && BlocksAround[6] == false){
          if(AIFollowSide){
            AIDir++;
          } else {
            AIDir--;
          }
          AIFollowSide = false;
          if(random(100)<50){
            AIFollowSide = true;
          }
        }
        
        AIDir = (int)posMod(AIDir,4);
        if(SlideForward){
          if(AIDir == 0){
            AITargetPos.y--;
          } else if(AIDir == 1){
            AITargetPos.x++;
          } else if(AIDir == 2){
            AITargetPos.y++;
          } else if(AIDir == 3){
            AITargetPos.x--;
          }
        }
        
        
            
        println("c");
      } else {
        EC.AISearchMode = 11;
        setAITarget();
        return;
      }
      
    } else if(EC.AISearchMode == 21){
      //follow path (line of sight)
      //test line of sight, if none, change mode, call again
      PVector tempTarget = rayCastAllPathsID(eV,EC.AITargetID,30);
      if(tempTarget != null){
        AITargetPos = tempTarget;
        println("aa");
      } else {
        EC.AISearchMode = 22;
        setAITarget();
        return;
      }
    } else if(EC.AISearchMode == 22){
      //Strange (no line > 10)
      //test line of sight, change mode, call again

      if(rayCastAllPathsID(eV,EC.AITargetID,30) == null){
        
        PVector[] tPoints = new PVector[30];
        for(int i = 0; i < 30; i++){
          int tx = (int) (x+random(20)-10);
          int ty = (int) (y+random(20)-10);
          tPoints[i] = new PVector(tx,ty,aGS(AIMap,tx,ty));
        }
        for(int i = 0; i < 30; i++){
          int smallest = 256;
          int smallestIndex = 0;
          for(int j = 0; j < 30; j++){
            if(tPoints[j].z<smallest){
              smallest = (int) tPoints[j].z;
              smallestIndex = j;
            }
          }
          tPoints[smallestIndex].z = 999;
          if(rayCast((int)tPoints[smallestIndex].x,(int)tPoints[smallestIndex].y,(int)x,(int)y)){
            AITargetPos = new PVector(tPoints[smallestIndex].x,tPoints[smallestIndex].y);
            i = 1000;
          }
        }
        
        //set point:
        //pick 10 points around
        //sort based upon weight value
        //pick lowest weight that is line of sight
        
        
        println("cc");
      } else {
        EC.AISearchMode = 21;
        setAITarget();
        return;
      }
      
    }
    if(EC.AITarget > -1){
      AITargetPos = new PVector(AITargetPos.x+.5f,AITargetPos.y+.5f);
    }
    eD = new PVector(AITargetPos.x,AITargetPos.y);
  }
  
  public void fire(PVector tempV){
    float tempDir = pointDir(eV,tempV);
    entities.add(new Entity(x+EC.Size/2*cos(tempDir),y+EC.Size/2*sin(tempDir),bulletEntity,tempDir));
  }
  
  public void display() {
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
      
      if(eHealth < EC.HMax && eHealth < 1000000){
        float tempFade = PApplet.parseFloat(eHealth)/EC.HMax;
        noFill();
        strokeWeight(gScale/15);
        stroke(255,255-tempFade*150);
        arc(tempV.x,tempV.y,gScale*(EC.Size+.1f),gScale*(EC.Size+.1f),-HALF_PI,-HALF_PI+TWO_PI*tempFade);
        stroke((1-tempFade)*510,tempFade*510,0,255-tempFade*150);
        arc(tempV.x,tempV.y,gScale*(EC.Size+.1f),gScale*(EC.Size+.1f),-HALF_PI,-HALF_PI+TWO_PI*tempFade);
      }
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
  
  public void destroy(){
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
  
  int Color = color(0);
  String DeathCommand = "";
  
  int HMax = 20;
  float Size = 1;
  float SMax = .15f;
  
  float Accel = .040f;
  float Drag = .008f;
  float TAccel = .030f;
  float TSMax = .20f;
  float TDrag = .016f;
  PImage Img;
  int Type = 0;
  
  int AISearchMode = -1;
  int AITarget = -1;
  float AITargetID = -1;
  float AIActionMode = -1;
  int AIDoorBlock = -1;
  
  float FadeRate = .1f;
  float Vision = 100; //100 is generaly a good number... be careful with this and AI mode 3+... if > 140 and no target is near lag is created
  float GoalDist = 3; //Want to get this close
  float ActDist = 10; //Will start acting at this dis
  
  EConfig() {}
}

public void particleEffect(float x, float y, float w, float h, int num, int c1, int c2, float ts){
  for(int i = 0; i <num; i++){
    EConfig ECParticle = new EConfig();
    ECParticle.Genre = 2;
    ECParticle.Size = .1f;
    ECParticle.FadeRate = random(.1f)+.05f;
    ECParticle.Type = floor(random(3));
    ECParticle.SMax = random(ts);
    if(random(100)<50){
      ECParticle.Color = c1;
    } else {
      ECParticle.Color = c2;
    }
    entities.add(new Entity(x+random(w),y+random(h),ECParticle,random(TWO_PI)));
  }
}

public PVector entityNearID(PVector eV,float tEID, float tDis, float tChance){
  float minDis = tDis;
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

public boolean isEntityNearID(PVector eV,float tEID, float tDis){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.EC.ID == tEID){
      if(pointDistance(eV, tempE.eV) < tDis){
        return true;
      }
    }
  }
  return false;
}
/*
boolean spreadSmell(int x, int y, int dis){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    if(aGS2DB(smap,x,y) == false){
      aSS2DB(smap,x,y,true);
      if(dis<1){
        return false;
      }
      boolean bools = false;
      if(aGS1DB(gBIsSolid,aGS(wU,x+1,y)) == false || aGS(wU,x+1,y)==8){if(spreadSmell(x+1,y,dis-1)){bools=true;}}
      if(aGS1DB(gBIsSolid,aGS(wU,x-1,y)) == false || aGS(wU,x-1,y)==8){if(spreadSmell(x-1,y,dis-1)){bools=true;}}
      if(aGS1DB(gBIsSolid,aGS(wU,x,y+1)) == false || aGS(wU,x,y+1)==8){if(spreadSmell(x,y+1,dis-1)){bools=true;}}
      if(aGS1DB(gBIsSolid,aGS(wU,x,y-1)) == false || aGS(wU,x,y-1)==8){if(spreadSmell(x,y-1,dis-1)){bools=true;}}
      return bools;
    }
  }
  return false;
}
*/
/*
boolean isEntityNearIDSmell(PVector eV,float tEID, float tDis){
  smap = new boolean[wSize][wSize];
  spreadSmell((int)eV.x,(int)eV.y,(int)tDis);
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.EC.ID == tEID){
      //if(pointDistance(eV, tempE.eV) < tDis){
        if(aGS2DB(smap,tempE.eV.x,tempE.eV.y)){
          return true;
        }
      //}
    }
  }
  return false;
}
*/
public boolean isEntityNearGenreSpecial(PVector eV,float tEGenre, float tDis){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.EC.Genre == tEGenre){
      if(max(abs(eV.x-tempE.eV.x), abs(eV.y-tempE.eV.y)) < tDis){
        return true;
      }
    }
  }
  return false;
}

public Entity entityNearGenreSpecial(PVector eV,float tEGenre, float tDis){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.EC.Genre == tEGenre){
      if(max(abs(eV.x-tempE.eV.x), abs(eV.y-tempE.eV.y)) < tDis){
        return tempE;
      }
    }
  }
  return null;
}


public PVector rayCastAllPathsID(PVector eV,float tEID, float tDis){
  for (int i = 0; i < entities.size(); i++) {
    Entity tempE = (Entity) entities.get(i);
    if(tempE.EC.ID == tEID){
      if(pointDistance(eV, tempE.eV) < tDis){
        int tempInt = rayCastPath(tempE.path, (int)eV.x, (int)eV.y);
        if(tempInt > -1){
          PVector tempPV = (PVector)tempE.path.get(tempInt);
          return new PVector(tempPV.x,tempPV.y);
        }
      }
    }
  }
  return null;
}

//STEM Phagescape API v(see above)

public void drawHUD(){
  
}

public void refreshHUD(){
  HUDAddLight(PApplet.parseInt(player.x),PApplet.parseInt(player.y),1);
  if(shadows == true){
    HUDAddLight(PApplet.parseInt(player.x),PApplet.parseInt(player.y),lightStrength);
  }
}

public void HUDAddLight(int x1, int y1, int strength){
  nmap = new int[wSize][wSize];
  HUDAddLightLoop(x1,y1,strength);
}

public void HUDAddLightLoop(int x, int y, int dist){
  if(aGS(nmap,x,y) < dist){
    aSS(nmap,x,y,dist);
    if(aGS1DB(gBIsSolid,aGS(wU,x,y)) == false){
      HUDAddLightLoop(x+1,y,dist-1);
      HUDAddLightLoop(x-1,y,dist-1);
      HUDAddLightLoop(x,y+1,dist-1);
      HUDAddLightLoop(x,y-1,dist-1);
    }
  }
}

ArrayList sL = new ArrayList<Sound>();

public void updateSound(){
  Sound tempS;
  for (int i = 0; i < sL.size(); i++){
    tempS = (Sound) sL.get(i);
    if(tempS.display()){
      sL.remove(i);
      i--;
    }
  }
}

class Sound {
  float x;
  float y;
  PVector posV;
  SoundConfig config;
  float r = 0;
  int index = 100;
  float offX;
  float offY;
  float wallMult = 1;
  
  Sound(float tx, float ty, SoundConfig tconfig, int tindex) {
    x = tx;
    y = ty;
    index = tindex;
    config = tconfig;
    offX = random(config.variance*2)-config.variance;
    offY = random(config.variance*2)-config.variance;
    
    if(config.wallEffect > 0){
      if(rayCast((int) x, (int) y, (int) wViewCenter.x, (int) wViewCenter.y)){
        wallMult = (100-max(config.wallEffect-100,0))/100;
      } else if(genTestPathExists( x, y, wViewCenter.x, wViewCenter.y)){
        wallMult = (200-config.wallEffect)/200;
      } else {
        wallMult = (100-config.wallEffect)/100;
      }
    }
  }
  public boolean display() {
    posV = pos2Screen(new PVector(x+offX,y+offY));
    noFill();
    stroke(config.baseColor,(config.rMax*gScale*wallMult-r*gScale)/(config.rMax*gScale*wallMult)*255);
    strokeWeight(max(0,(r/wSize*config.bandWidth+.6f)*gScale));
    ellipse(posV.x,posV.y,r*2*gScale,r*2*gScale);
    r+=config.rSpeed;
    
    
    if(index < config.waveCount-1){
      if(r > config.waveLength){
        sL.add(new Sound(x,y,config,index+1));
        index = 999;
      }
    }
    
    if(r>config.rMax*wallMult){
      return true;
    } else {
      return false;
    }
  }
}

class SoundConfig {
  float rSpeed=1;
  int rMax=0;
  float darkness=255;
  int baseColor=0;
  float bandWidth=0;
  int waveCount = 0;
  float waveLength = 0;
  float variance = 0;
  float wallEffect = 0;
  SoundConfig(float trSpeed, int trMax, float tdarkness, int tbaseColor, float tbandWidth, int twaveCount, float twaveLength, float tvariance, float twallEffect) {
    rSpeed=trSpeed;
    rMax=trMax;
    darkness=tdarkness;
    baseColor=tbaseColor;
    bandWidth=tbandWidth;
    waveCount = twaveCount;
    waveLength = twaveLength;
    variance = tvariance;
    wallEffect = twallEffect;
  }
}
//STEM Phagescape API v(see above)

public void genRing(float x, float y, float w, float h, float weight, int b){
  genArc(0,TWO_PI,x,y,w,h,weight,b);
}

public void genArc(float rStart, float rEnd, float x, float y, float w, float h, float weight, int b){
  if(rStart > rEnd){float rTemp = rStart; rStart = rEnd; rEnd = rTemp;}
  float dR = rEnd-rStart;
  float c = dR/floor(dR*max(w,h)*10); //dR is range -> range/(circumfrence of arc(radians * 2*max_radius *5 -> 20*radius -> 20 points per block)) -> gives increment value
  float r;
  for(float i = rStart; i < rEnd; i+=c){
    r = (w*h/2)/sqrt(sq(w*cos(i))+sq(h*sin(i)))-weight/2;
    for(float j = 0; j <= weight; j+=.2f){
      aSS(wU,round(x+(r+j)*cos(i)),round(y+(r+j)*sin(i)),b);
    }
  }
}

public void genCircle(float x, float y, float r, int b){
  PVector centerV = new PVector(x,y);
  for(int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      if(pointDistance(new PVector(i,j), centerV) < r){
        aSS(wU,i,j,b);
      }
    }
  }
}

public void genLine(float x1, float y1, float x2, float y2, float weight, int b){
  int itt = ceil(10*pointDistance(new PVector(x1,y1), new PVector(x2,y2)));
  float rise = (y2-y1)/itt;
  float run = (x2-x1)/itt;
  float xOff = 0;
  float yOff = 0;
  for(float i = 0; i < itt-1; i+=1){
    for(float j = 0; j <= weight*10; j+=2){
      xOff = (j-weight*5)*rise;
      yOff = (j-weight*5)*-run;
      aSS(wU,floor(x1+xOff+i*run),floor(y1+yOff+i*rise),b);
    }
  }
  aSS(wU,floor(x1),floor(y1),b);
  aSS(wU,floor(x2),floor(y2),b);
}

public void genRect(float x, float y, float w, float h, int b){
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

public void genBox(float x, float y, float w, float h, float weight, int b){
  genLine(x,y,x+w-1,y,weight,b);
  genLine(x,y,x,y+h-1,weight,b);
  genLine(x,y+h-1,x+w-1,y+h-1,weight,b);
  genLine(x+w-1,y,x+w-1,y+h-1,weight,b);
}

public void genRoundRect(float x, float y, float w, float h, float rounding, int b){
  x = round(x); y = round(y); w = round(w); h = round(h); rounding = round(rounding);
  genRect(x+rounding,y,w-rounding*2,h,b);
  genRect(x,y+rounding,w,h-rounding*2,b);
  genCircle(x+rounding,y+rounding,rounding,b);
  genCircle(x+w-rounding,y+rounding,rounding,b);
  genCircle(x+rounding,y+h-rounding,rounding,b);
  genCircle(x+w-rounding,y+h-rounding,rounding,b);
}

public void genRandomProb(int from, int[] to, float[] prob){
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

public void genFlood(float x, float y, int b){
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

public void genReplace(int from, int to){
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == from){
        wU[i][j] = to;
        wUP[i][j] = to;
        wUC[i][j] = to;
      }
    }
  }
}

public boolean genTestPathExists(float x1, float y1, float x2, float y2){
  nmap = new int[wSize][wSize];
  return genTestPathExistsLoop((int) x1, (int) y1, (int) x2, (int) y2);
}

public boolean genTestPathExistsLoop(int x, int y, int x2, int y2){
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

public boolean genTestPathExistsDis(float x1, float y1, float x2, float y2, float dis){
  nmap = new int[wSize][wSize];
  return genTestPathExistsDisLoop((int) x1, (int) y1, (int) x2, (int) y2, (int) dis);
}

public boolean genTestPathExistsDisLoop(int x, int y, int x2, int y2, int dis){
  println(millis());
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
      if(aGS(nmap,x,y) == 0){
        if(abs(x-x2)+abs(y-y2) <= 1){
          return true;
        }
        aSS(nmap,x,y,1);  
        boolean bools = false;
        if(aGS1DB(gBIsSolid,aGS(wU,x+1,y)) == false){if(genTestPathExistsDisLoop(x+1,y,x2,y2,dis)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x-1,y)) == false){if(genTestPathExistsDisLoop(x-1,y,x2,y2,dis)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x,y+1)) == false){if(genTestPathExistsDisLoop(x,y+1,x2,y2,dis)){bools=true;}}
        if(aGS1DB(gBIsSolid,aGS(wU,x,y-1)) == false){if(genTestPathExistsDisLoop(x,y-1,x2,y2,dis)){bools=true;}}
        return bools;
      }
  }
  return false;
}

public boolean genSpread(int num, int from, int to){
  int froms = 0;
  int tos = 0;
  int tx, ty;
  froms = genCountBlock(from);
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

public int genCountBlock(int b){
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

public boolean genLoadMap(PImage thisImage){
  if(thisImage.width == wSize && thisImage.height == wSize){
    thisImage.loadPixels();
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        wU[i][j] = PApplet.parseInt(blue(thisImage.pixels[i+j*wSize]));
      }
    }
  }
  return false;
}

public void genSpreadClump(int n, int from, int to, int seeds, int[] falloff){
  int total = 0;
  if(genCountBlock(from)>=n){
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        if(aGS(wU,i,j) == from){
          distanceMatrix[i][j] = 6;
        } else {
          distanceMatrix[i][j] = 0;
        }
      }
    }
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        if(aGS(distanceMatrix,i,j) == 6){
          if(aGS(wU,i+1,j) == to || aGS(wU,i-1,j) == to || aGS(wU,i,j+1) == to || aGS(wU,i,j-1) == to){
            distanceMatrix[i][j] = 1;
          }
        }
      }
    }
    
    while(total < seeds){
      int x = floor(random(wSize));
      int y = floor(random(wSize));
      if(aGS(wU,x,y) == from){
        aSS(wU,x,y,to);
        pinDistanceMatrix(x,y,0);
        total++;
      }
    }
    while(total < n){
      int x = floor(random(wSize));
      int y = floor(random(wSize));
      if(aGS(distanceMatrix,x,y)<6){
        int tempDis = aGS(distanceMatrix,x,y);
        if(tempDis > 0){
          if(random(100)<falloff[tempDis-1]){
            aSS(wU,x,y,to);
            pinDistanceMatrix(x,y,0);
            total++;
          }
        }
      }
    }
    
  } else {
    genReplace(from, to);
  }
}

public void pinDistanceMatrix(int x, int y, int d){
  if(aGS(distanceMatrix,x,y)>d){
    aSS(distanceMatrix,x,y,d);
    if(aGS(distanceMatrix,x+1,y)>d+1){pinDistanceMatrix(x+1,y,d+1);}
    if(aGS(distanceMatrix,x-1,y)>d+1){pinDistanceMatrix(x-1,y,d+1);}
    if(aGS(distanceMatrix,x,y+1)>d+1){pinDistanceMatrix(x,y+1,d+1);}
    if(aGS(distanceMatrix,x,y-1)>d+1){pinDistanceMatrix(x,y-1,d+1);}
  }
  
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

public void waveGrid(){
  gM = new int[ceil(gSize)*2+1][ceil(gSize)*2+1];
  wL.clear();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      gM[i*2+1][j*2+1] = aGS(gU,i,j);
      //if(gUHUD[i][j] == false){gM[i*2+1][j*2+1] = 255;}
    }
  }
  for(int i = 0; i < gSize*2+1; i++){
    for(int j = 0; j < gSize*2+1; j++){
      if(i%2!=j%2){
        if((gM[min(i+1,ceil(gSize)*2)][j] != -2 && gM[max(i-1,0)][j] != -2) && gBColor[gM[min(i+1,ceil(gSize)*2)][j]] != gBColor[gM[max(i-1,0)][j]]){
           wL.add(new Wave(i,j,0,1,(j+i)%4-2));
         }
        if((gM[i][min(j+1,ceil(gSize)*2)] != -2 && gM[i][max(j-1,0)] != -2 && gBColor[gM[i][min(j+1,ceil(gSize)*2)]] != gBColor[gM[i][max(j-1,0)]])){
          wL.add(new Wave(i,j,1,0,(j+i+2)%4-2));
        }
      }
    }
  }
}

public void arcHeightV(PVector v1,PVector v2,float h1, int c1, int c2){
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
  v11.div(d2/(h1*d2*2.5f/gScale));
  PVector v1C = PVector.add(v1,new PVector(v11.y,-v11.x));
  
  PVector v12 = PVector.sub(v2,v3);
  v12.div(d2/(h1*d2*2.5f/gScale));
  PVector v2C = PVector.add(v2,new PVector(-v12.y,v12.x));
  
  strokeWeight(5);
  stroke(255);
  bezier(v1.x, ceil(v1.y), v1C.x, v1C.y, v2C.x, v2C.y, v2.x, v2.y);
  noStroke();
  fill(255);
  ellipse((.5f-1/2)+v1.x,(.5f-1/2)+v1.y,4,4);
  ellipse((.5f-1/2)+v2.x,(.5f-1/2)+v2.y,4,4);
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
  int c1;
  int c2;
  
  boolean wDir;
  Wave(int tx, int ty, int ta, int tb, int tAmp) {
    wDir = PApplet.parseBoolean(ta);
    a = new PVector(floor((tx+1-ta)/2),floor((ty+1-tb)/2));
    b = new PVector(floor((tx+1+ta)/2),floor((ty+1+tb)/2));
    amp = tAmp;
    shift = (tx+ty+(wView.x+wView.y)*2)*PI/30;
    c1 = aGS1D(gBColor,aGS(gM,tx-tb,ty+ta));
    c2 = aGS1D(gBColor,aGS(gM,tx+tb,ty-ta));
  }
  public void display() {
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

public void setupWorld(){
  gScale = PApplet.parseFloat(width)/(gSize-1);
  wU = new int[wSize][wSize];
  wUP = new int[wSize][wSize];
  wUC = new int[wSize][wSize];
  wUText = new boolean[wSize][wSize];
  wUDamage = new int[wSize][wSize];
  gU = new int[ceil(gSize)][ceil(gSize)];
  gUHUD = new boolean[ceil(gSize)][ceil(gSize)];
  wUUpdate = new int[wSize][wSize];
}

public void refreshWorld(){
  refreshHUD();
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      if(aGS(nmap,i+wView.x,j+wView.y)>0 || shadows == false){
        gU[i][j] = aGS(wU,i+wView.x,j+wView.y);
      } else {
        gU[i][j] = 255;
      }
      
    }
  }
  waveGrid();
}

public void moveToAnimate(PVector tV, float tTime){
  if(millis() > moveToAnimateTime.y){
    moveToAnimateStart = new PVector(wViewCenter.x,wViewCenter.y,wViewCenter.z);
    moveToAnimateEnd = new PVector(tV.x-wViewCenter.x,tV.y-wViewCenter.y);
    moveToAnimateTime = new PVector(millis(), millis()+tTime);
  }
}

public void animate(){
  if(millis() <= moveToAnimateTime.y){
    float temp1 = (millis()-moveToAnimateTime.x)/(moveToAnimateTime.y-moveToAnimateTime.x);
    float temp2 = sin(temp1*PI);
    float temp3 = (-cos(temp1*PI)+1)/2;
    centerView(moveToAnimateStart.x+temp3*moveToAnimateEnd.x,moveToAnimateStart.y+temp3*moveToAnimateEnd.y);
    scaleView(moveToAnimateStart.z+temp2*10);
  }
}

public void scaleView(float tGSize){
  gSize = tGSize;
  gScale = PApplet.parseFloat(width)/(gSize-1);
  gU = new int[ceil(gSize)][ceil(gSize)];
  gUHUD = new boolean[ceil(gSize)][ceil(gSize)];
  refreshWorld();
}

public void addGeneralBlock(int tIndex, int tColor, boolean tIsSolid, int tStrength){
  gBColor[tIndex] = tColor;
  gBIsSolid[tIndex] = tIsSolid;
  gBStrength[tIndex] = tStrength;
}

public void addGeneralBlockBreak(int tIndex, int tBreakType, String tBreakCommand){
  gBBreakType[tIndex] = tBreakType;
  if(tBreakCommand != ""){
    gBBreakCommand[tIndex] = tBreakCommand;
  }
}

public void addImageSpecialBlock(int tIndex, PImage tImage, int tImageDrawType){
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

public void addTextSpecialBlock(int tIndex, String tText, int tTextDrawType){
  sBHasText[tIndex] = true;
  sBText[tIndex] = tText;
  sBTextDrawType[tIndex] = tTextDrawType;
}

public void addActionSpecialBlock(int tIndex, int tAction){
  sBHasAction[tIndex] = true;
  sBAction[tIndex] = tAction;
}

public void centerView(float ta, float tb){
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

public void updateWorld(){
  //println("..");
  //wPhase += .09;
  boolean anyBlockChanges = false;
  boolean theseBlockChanges = true;
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUUpdate[i][j] = 0;
    }
  }
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUC[i][j] = wU[i][j];
    }
  }
  while(theseBlockChanges){
    theseBlockChanges = false;
    
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        if(wUUpdate[i][j] == 20){
          wUUpdate[i][j] = -1;
          updateBlock(i,j,0,0);
          theseBlockChanges = true;
        }
        if(wUUpdate[i][j] == 21){
          wUUpdate[i][j] = 20;
          theseBlockChanges = true;
        }
      }
    }
    
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        if(wUC[i][j] != wUP[i][j]){
          if(aGS1D(gBBreakType,wUP[i][j]) == wUC[i][j]){
            if(aGS1DS(gBBreakCommand,wUP[i][j]) != null){
              //entities.add(new Entity(i+.5,j+.5, gBBreakEntity[wUP[i][j]],random(TWO_PI)));
              tryCommand((aGS1DS(gBBreakCommand,wUP[i][j])).replaceAll("_x_",str(i)).replaceAll("_y_",str(j)),"");//aGS1DS(gBBreakCommand,wUP[i][j])
            }
            int tempC = aGS1DC(gBColor,aGS(wUP,i,j));
            particleEffect(i,j,1,1,15,tempC,tempC,.01f);
          }
          
          //if(wUUpdate[i][j] == 0){wUUpdate[i+1][j] = 20;}
          if(wUUpdate[i][j] == 0){wUUpdate[i][j] = -1;}
          if(i+1<wSize){if(wUUpdate[i+1][j] == 0){wUUpdate[i+1][j] = 21;}}
          if(i-1>=0){if(wUUpdate[i-1][j] == 0){wUUpdate[i-1][j] = 21;}}
          if(j+1<wSize){if(wUUpdate[i][j+1] == 0){wUUpdate[i][j+1] = 21;}}
          if(j-1>=0){if(wUUpdate[i][j-1] == 0){wUUpdate[i][j-1] = 21;}}
          theseBlockChanges = true;
          
          wUP[i][j] = wUC[i][j];
          wU[i][j] = wUC[i][j];
        }
      }
    }
    if(theseBlockChanges){
      anyBlockChanges = true;
    }
  }
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUP[i][j] = wU[i][j];
    }
  }
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wU[i][j] = wUC[i][j];
    }
  }
  
  if(anyBlockChanges){
    refreshWorld();
  }
}

public void updateBlock(int x, int y, int xs, int ys){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    int tempBT = aGS(wUC,x,y);
    if(aGS1DB(sBHasAction,tempBT)){
      int tAction = sBAction[tempBT];
      if(tAction == 0){
        if(aGS(wUP,x+xs,y+ys) == aGS(wU,x,y))
        aSS(wUC,x,y,aGS1D(gBBreakType,tempBT));
      }
      if(tAction == 46){
        if(aGS(wUP,x,y) == tempBT){
          aSS(wUC,x,y,aGS1D(gBBreakType,tempBT));
        }
      }
    }
  }
}

public void updateSpecialBlocks(){
  boolean updateAgain = false;
  int iTo = (int)player.x+10;
  int jTo = (int)player.y+10;
  for(int i = (int)player.x-10; i < iTo; i++){
    for(int j = (int)player.y-10; j < jTo; j++){
      if(aGS1DB(sBHasAction,aGS(wU,i,j))){
        int thisBlock = aGS(wU,i,j);
        int tAction = sBAction[thisBlock];
        
        if(tAction >= 1 && tAction <= 10){
          if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<tAction){
            aSS(wU,i,j,aGS1D(gBBreakType,thisBlock));
          }
        }
        if(tAction >= 11 && tAction <= 20){
          if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<tAction-10){
            if(genTestPathExists(player.x,player.y,i,j)){
              aSS(wU,i,j,aGS1D(gBBreakType,thisBlock));
              updateAgain = true;
            }
          }
        }
        if(tAction >= 21 && tAction < 30){
          if(pointDistance(new PVector((int)player.x,(int)player.y), new PVector(i,j))<=tAction-20){
            if(genTestPathExists(player.x,player.y,i,j)){
              if(rayCast(i,j,(int)player.x,(int)player.y)){
                aSS(wU,i,j,aGS1D(gBBreakType,thisBlock));
                updateAgain = true;
              }
            }
          }
        }
      }
    }
  }
  if(updateAgain){
    updateSpecialBlocks();
  }
}

/*
void updateBlockLight(int x, int y){
  if(x >= 0 && y >= 0 && x < wSize && y < wSize){
    wUCovers[x][y] = wU[x][y];
    int tempBT = aGS(wU,x,y);
    if(aGS1DB(sBHasAction,tempBT)){
      int tAction = sBAction[tempBT];
      if(tAction == 51){
        
        int[] array1 = new int[8];
        int tempCounter = 0;
        if(aGS(wU,x+1,y) != tempBT && gBIsSolid[aGS(wU,x+1,y)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x+1,y); tempCounter++;}
        if(aGS(wU,x+1,y+1) != tempBT && gBIsSolid[aGS(wU,x+1,y+1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x+1,y+1); tempCounter++;}
        if(aGS(wU,x,y+1) != tempBT && gBIsSolid[aGS(wU,x,y+1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x,y+1); tempCounter++;}
        if(aGS(wU,x-1,y+1) != tempBT && gBIsSolid[aGS(wU,x-1,y+1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x-1,y+1); tempCounter++;}
        if(aGS(wU,x-1,y) != tempBT && gBIsSolid[aGS(wU,x-1,y)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x-1,y); tempCounter++;}
        if(aGS(wU,x-1,y-1) != tempBT && gBIsSolid[aGS(wU,x-1,y-1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x-1,y-1); tempCounter++;}
        if(aGS(wU,x,y-1) != tempBT && gBIsSolid[aGS(wU,x,y-1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x,y-1); tempCounter++;}
        if(aGS(wU,x+1,y-1) != tempBT && gBIsSolid[aGS(wU,x+1,y-1)] == gBIsSolid[tempBT]){array1[tempCounter] = aGS(wU,x+1,y-1); tempCounter++;}
        int[] array2 = new int[tempCounter];
        arrayCopy(array1,array2,tempCounter);
        int newCover = tempBT;
        if(tempCounter > 0){
          newCover = mode(array2);
        }
        wUCovers[x][y] = newCover;
        
      }
    }
  }
}
*/

public void updateSpawners(){
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(aGS1DB(sBHasAction,wU[i][j])){
        int tempBlock = wU[i][j];
        int tempAction = aGS1D(sBAction,tempBlock);
        if(tempAction >= 31 && tempAction <= 45){
          int tempVal = (int)sq(tempAction-30);
          if(random(tempVal)<=1){
            entities.add(new Entity(i+.5f,j+.5f, testEntity.EC,random(TWO_PI)));
          }
        }
      }
    }
  }
}

public void drawWorld(){
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
          image(sBImage[thisBlock],floor(tempV.x),floor(tempV.y));
        } else if(sBImageDrawType[thisBlock] == 1) {
          image(sBImage[thisBlock],floor(tempV.x),floor(tempV.y));
        } else {
          tScale = width/sBImage[thisBlock].width;
          image(sBImage[thisBlock].get(floor(tempV.x+gScale),floor(tempV.y+gScale),ceil(gScale),ceil(gScale)),floor(tempV.x),floor(tempV.y));
        }
      }
      
      thisBlock = aGS(wU,i+wView.x,j+wView.y);
      
      if(aGS1DB(gBIsSolid,thisBlock)){
        PVector tempV2 = grid2Pos(new PVector(i,j));
        if(aGS1D(gBStrength,thisBlock) > -1){
          if(aGS(wUDamage,tempV2.x,tempV2.y) > 0){
            if(aGS(wUDamage,tempV2.x,tempV2.y) > aGS1D(gBStrength,thisBlock)){
              aSS(wU,tempV2.x,tempV2.y,aGS1D(gBBreakType,thisBlock));
              aSS(wUDamage,tempV2.x,tempV2.y,0);
              
            } else {
              stroke(255);
              strokeWeight(gScale/15);
              float Crumble = PApplet.parseFloat(aGS(wUDamage,tempV2.x,tempV2.y))/(aGS1D(gBStrength,thisBlock)-.01f);
              //line(tempV.x,tempV.y+gScale/2-Crumble,tempV.x+gScale,tempV.y+gScale/2+Crumble);
              //line(tempV.x+gScale/2+Crumble,tempV.y,tempV.x+gScale/2-Crumble,tempV.y+gScale);
              //println(Crumble);
              arc(tempV.x+gScale/2,tempV.y+gScale/2,gScale*2/3,gScale*2/3,HALF_PI,HALF_PI+TWO_PI*Crumble);
            }
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
          drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock],255);
        } else if(sBTextDrawType[thisBlock] <= 10) {
          if(pointDistance(new PVector(width/2-gScale/2,height/2-gScale/2),tempV) < sBTextDrawType[thisBlock]*gScale){
            drawTextBubble(tempV.x+gScale/2,tempV.y+gScale/2,sBText[thisBlock],255);
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

public PVector screen2Pos(PVector tA){tA.div(gScale);tA.add(wView); return tA;}

public PVector pos2Screen(PVector tA){tA.sub(wView); tA.mult(gScale); return tA;}

public PVector grid2Pos(PVector tA){tA.add(new PVector(floor(wView.x),floor(wView.y))); return tA;}

//PVector pos2Grid(PVector tA){tA.sub(new PVector(floor(wView.x),floor(wView.y))); return tA;}

public PVector moveInWorld(PVector tV, PVector tS, float tw, float th){
  PVector tV2 = new PVector(tV.x,tV.y);
  if(tS.x > 0){
    if(floor(tV.x+tw/2) != floor(tV.x+tw/2+tS.x)){
      if(aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y+th/2)) || aGS1DB(gBIsSolid,aGS(wU,tV.x+tw/2+tS.x,tV.y-th/2))){
        tS = new PVector(0,tS.y);
        tV2 = new PVector(floor(tV.x+tw/2+tS.x)+.999f-tw/2,tV2.y);
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
        tV2 = new PVector(tV2.x,floor(tV.y+th/2+tS.y)+.999f-th/2);
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

public boolean[] getSolidAround(PVector pos, int dir, boolean clockwise){ //array get safe
  //dir = posMod(dir);
  boolean[] tempBool = new boolean[8];
  if(clockwise == false){
    tempBool[(int)posMod(0-dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y-1)];
    tempBool[(int)posMod(1-dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y-1)];
    tempBool[(int)posMod(2-dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y)];
    tempBool[(int)posMod(3-dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y+1)];
    tempBool[(int)posMod(4-dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y+1)];
    tempBool[(int)posMod(5-dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y+1)];
    tempBool[(int)posMod(6-dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y)];
    tempBool[(int)posMod(7-dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y-1)];
  } else {
    tempBool[(int)posMod(0+dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y-1)];
    tempBool[(int)posMod(7+dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y-1)];
    tempBool[(int)posMod(6+dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y)];
    tempBool[(int)posMod(5+dir*2,8)] = gBIsSolid[aGS(wU,pos.x+1,pos.y+1)];
    tempBool[(int)posMod(4+dir*2,8)] = gBIsSolid[aGS(wU,pos.x,pos.y+1)];
    tempBool[(int)posMod(3+dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y+1)];
    tempBool[(int)posMod(2+dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y)];
    tempBool[(int)posMod(1+dir*2,8)] = gBIsSolid[aGS(wU,pos.x-1,pos.y-1)];
  }
  return tempBool;
}

public PVector blockNear(PVector eV,int tBlock, float tChance){
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

public PVector blockNearCasting(PVector eV,int tBlock){
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

public boolean rayCast(int x0, int y0, int x1, int y1){
  boolean tClear = true;
  int itts = ceil(mDis(x0,y0,x1,y1)*5);
  float tempDispX = PApplet.parseFloat(x1-x0)/itts;
  float tempDispY = PApplet.parseFloat(y1-y0)/itts;
  for(int i = 0; i < itts; i++){
    if((round(x0+tempDispX*i) != round(x0) || round(y0+tempDispY*i+.105f) != round(y0)) && (round(x0+tempDispX*i) != round(x1) || round(y0+tempDispY*i+.105f) != round(y1))){
      if(gBIsSolid[aGS(wU,round(x0+tempDispX*i),round(y0+tempDispY*i+.105f))]){
        return false;
      }
    }
  }
  //println(tClear);
  return true;
}

public int rayCastPath(ArrayList a, int x1, int y1){
  PVector tempPV;
  for(int i = a.size()-1; i >= 0; i--){
    tempPV = (PVector)a.get(i);
    if(rayCast((int)tempPV.x, (int)tempPV.y, x1, y1)){
      //if(gBIsSolid[aGS(wU,tempPV.x,tempPV.y)]){
      //  a.clear();
      //  a.add(new PVector(50,50));
      //  return -1;
      //}
      return i;
    }
  }
  return -1;
}

//STEM Phagescape API v(see above)
/*

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
*//*

*/
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MS_Bacteria_2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
