/* @pjs preload="D/face.png,D/ship1.png"; */

Entity testEntity;
int bgColor = 0;
int[] EC_ITEM = new int[100];
boolean mySide = true;
boolean zoomed = false;
int[][] wUOtherSide;

ArrayList bubbles = new ArrayList();
ArrayList otherBubbles = new ArrayList();

int viewingHealth = 0;

int pans;
int[][] panCount;
int[][] panHealthMax;
int[][] panHealth;
Entity selectedE = null;
int attachCap = 25;
int workers = 0;
int food = 0;

float tArrowOff = 50;
float tArrowW = 30;
float tArrowH = 60;

int EC_WORKER;

int[] blockC = {#FFFFFF/*1, 51 - White*/
,#000000/*2, 52 - Black*/
,#C91111/*3, 53 - Red*/
,#A32E12/*4, 54 - Maroon*/
,#943F07/*5, 55 - Brown*/
,#BF6A1F/*6, 56 - Light Brown*/
,#D84E09/*7, 57 - Red Orange*/
,#FED8B1/*8, 58 - Light Orange*/
,#FF8000/*9, 59 - Orange*/
,#FD9800/*10, 60 - Yellow Orange*/
,#FFC800/*11, 61 - Mango*/
,#E2B631/*12, 62 - Harvest Gold*/
,#A78B00/*13, 63 - Bronze Yellow*/
,#F6E120/*14, 64 - Golden Yellow*/
,#F6EB20/*15, 65 - Yellow*/
,#F4FA9F/*16, 66 - Lemon Yellow*/
,#51C201/*17, 67 - Yellow Green*/
,#6EEB6E/*18, 68 - Lime Green*/
,#1C8E0D/*19, 69 - Green*/
,#7E9156/*20, 70 - Jade Green*/
,#5BD2C0/*21, 71 - Aqua Green*/
,#007872/*22, 72 - Pine Green*/
,#098FAB/*23, 73 - Green Blue*/
,#0086A7/*24, 74 - Teal*/
,#17BFDD/*25, 75 - Turquoise*/
,#006A93/*26, 76 - Cerulean*/
,#00003B/*27, 77 - Navy Blue*/
,#2862B9/*28, 78 - Blue*/
,#0070FF/*29, 79 - Baby Blue*/
,#83AFDB/*30, 80 - Light Blue*/
,#09C5F4/*31, 81 - Sky Blue*/
,#A6AAAE/*32, 82 - Silver*/
,#7C7C99/*33, 83 - Slate*/
,#808080/*34, 84 - Gray*/
,#514E49/*35, 85 - Dark Brown*/
,#7E44BC/*36, 86 - Violet (Purple)*/
,#DCCCD7/*37, 87 - Pale Rose*/
,#B99685/*38, 88 - Taupe*/
,#CC99BA/*39, 89 - Mauve*/
,#BC6CAC/*40, 90 - Orchid*/
,#AA0570/*41, 91 - Raspberry*/
,#F863CB/*42, 92 - Magenta*/
,#FCA8CC/*43, 93 - Pink*/
,#FFC1CC/*44, 94 - Bubble Gum*/
,#FFD3CB/*45, 95 - Salmon*/
,#F5D4B4/*46, 96 - Peach*/
,#EBE1C2/*47, 97 - Sand*/
,#CC8454/*48, 98 - Tan*/
,#B44848/*49, 99 - Mahogany*/};

int[] systemC = {#000000 //control
,#FF5672 //consumption
,#FF0000 //targeted
,#E55B00 //general
,#FFA705 //movement
,#03E500 //health
,#0026FF //defense
,#AD00E2}; //bacteria

PVector[][] systemCenters;
int[] systemCenterCount;

/*LOCK*/void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/void safePreSetup(){} //first function called, in case you need to set some variables before anything else starts


/*LOCK*/void safeSetup(){ //called when world generation and entity placement is ready to begin
  
  loadMiniMap = false;
  lockMinimapToCamera = false;
  miniMapZoomSmall = 1;
  miniMapZoomLarge = 0;
  wUOtherSide = new int[wSize][wSize];
  
  
  
  int[] bgColors = {17,13,1,2,37,6,42,36,48,34,35,31,49};//
  int tcol = bgColors[floor(random(bgColors.length))];
  println(tcol);
  bgColor = blockC[tcol-1];
  
  pans = systemC.length;
  systemCenters = new PVector[pans][10];  
  systemCenterCount = new int[pans];
  panCount = new int[2][pans];
  panHealthMax = new int[2][pans];
  panHealth = new int[2][pans];

  EC_WORKER = EC_NEXT();
  EConfigs[EC_WORKER] = new EConfig();
  EConfigs[EC_WORKER].Genre = 1;
  EConfigs[EC_WORKER].Img = loadImage(aj.D()+"face.png");
  EConfigs[EC_WORKER].AISearchMode = 11;
  EConfigs[EC_WORKER].AITarget = -1;
  EConfigs[EC_WORKER].AITargetID = EConfigs[player.EC].ID;
  EConfigs[EC_WORKER].SMax = .05;
  EConfigs[EC_WORKER].TSMax = .1;
  EConfigs[EC_WORKER].TAccel = .03;
  EConfigs[EC_WORKER].TDrag = .01;
  EConfigs[EC_WORKER].Type = 1;
  EConfigs[EC_WORKER].GoalDist = 3; //Want to get this close
  EConfigs[EC_WORKER].ActDist = -1;
  EConfigs[EC_WORKER].HMax = 100;
  EConfigs[EC_WORKER].AltColor = color(0,100);
  EConfigs[EC_WORKER].Team = -3;
  
  
  
  addGeneralBlock(0,color(red(bgColor),green(bgColor),blue(bgColor),0),false,0); //background
  addGeneralBlock(50,color(red(bgColor),green(bgColor),blue(bgColor),0),false,0); //background
  
  for(int i = 0; i < 49; i++){
    addGeneralBlock(1+i,blockC[i],false,-1); //empty
    addGeneralBlock(51+i,blockC[i],true,-1); //solid
  }
  
  for(int i = 0; i < pans; i++){
    for(int j = 0; j < 10; j++){
      addGeneralBlock(100+i*10+j,systemC[i],true,100); //solid
    }
  }
  
  
  genLoadMap(loadImage(aj.D()+"ship1.png"));
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      wUOtherSide[99-i][j] = wU[i][j];
      if(wU[i][j] >= 100){
        int tempID = floor((wU[i][j]-100)/10);
        systemCenters[tempID][systemCenterCount[tempID]] = new PVector(i+.5,j+.5,-1);
        systemCenterCount[tempID]++;
      }
    }
  }
  
  
  for(int i = 0; i < pans; i++){
    int tracking = 0;
    for(int j = 0; j < systemCenterCount[i]; j++){
      if(systemCenters[i][j].z == -1){
        systemCenters[i][j].z = tracking++;
      }
      for(int k = j+1; k < systemCenterCount[i]; k++){
        if(pointDistance(systemCenters[i][j],systemCenters[i][k]) < 7){
          systemCenters[i][k].z = systemCenters[i][j].z;
        }
      }
    }
  }
  for(int i = 0; i < pans; i++){
    for(int j = 0; j < systemCenterCount[i]; j++){
      PVector centerAvg = new PVector(0,0);
      int avgC = 0;
      for(int k = 0; k < systemCenterCount[i]; k++){
        if(systemCenters[i][k].z == j){
          centerAvg.add(systemCenters[i][k]);
          avgC++;
        }
      }
      if(avgC > 0){
        centerAvg.div(avgC);
        systemCenters[i][j] = new PVector(centerAvg.x,centerAvg.y,0);
      } else {
        systemCenters[i][j] = new PVector(-1,-1,-1);
      }
    }
  }
  
  for(int i = 0; i < pans; i++){
    for(int j = systemCenterCount[i]-1; j >= 0; j--){
      if(systemCenters[i][j].x == -1){
        systemCenters[i][j] = null;
        systemCenterCount[i]--;
      }
    }
  }
  
  for(int i = 0; i < 5; i++){
    PVector tempPV = systemCenters[7][floor(random(systemCenterCount[7]))];
    workers++;
    entities.add(new Entity(tempPV.x,tempPV.y,EC_WORKER,random(TWO_PI)));
    ((Entity)entities.get(entities.size()-1)).AITargetPos = new PVector(floor(tempPV.x+random(1)-.5)+.5,floor(tempPV.y+random(1)-.5)+.5);
  }
  
  scaleView(100); //scale the view to fit the entire map
  
  player.eDir = random(2*PI);
  shadows = false;
  centerView(player.x,player.y); //center the view in the middle of the world
  
  
  
  
  showBars = false;
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] >= 100){
        panCount[0][floor((wU[i][j]-100)/10)]++;
      }
      if(wUOtherSide[i][j] >= 100){
        panCount[1][floor((wUOtherSide[i][j]-100)/10)]++;
      }
    }
  }
  
  for(int p = 0; p < 2; p++){
    for(int i = 0; i < pans; i++){
      panHealthMax[p][i] = floor((1000+random(500))/panCount[p][i])*panCount[p][i];
      panHealth[p][i] = panHealthMax[p][i];
      if(p == 0){
        for(int j = 0; j < 10; j++){
          gBStrength[100+i*10+j] = panHealthMax[p][i]/panCount[p][i];
        }
      }
    }
  }
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] >= 100){
        wUDamage[i][j] = gBStrength[wU[i][j]];
      }
    }
  }
  
  removeEntity(player,-1); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  
  for(int i = 0; i < 1200; i++){
    fn++;
    stepBubbles();
  }
  //testEntity.destroy();
  
  
}

/*LOCK*/void safeAsync(){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  stepBubbles();
}

/*LOCK*/void safeUpdate(){ //called before anything has been drawn to the screen (update the world before it is drawn)
  //centerView(player.x,player.y); //center the view on the player
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6); //center view on the player but pull toward the mouse slightly
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2,maxAbs(0,float(mouseY-height/2)/50)+height/2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y); //move the view in the direction of the mouse
  if(zoomed){
    if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX),height/2+(pmouseY-mouseY)); tempV2 = screen2Pos(tempV2); centerView(min(wSize-8,max(8,tempV2.x)),min(wSize-8,max(8,tempV2.y)));} //drag the view around
  }
  background(bgColor);
  
  for (Bubble te : (ArrayList<Bubble>) bubbles) {
    te.display();
  }
  
}

void safePostUpdate(){
  
}

void safePluginAI(Entity e){
  /*
  Control the AI of an entity e
  This function is called 25 times each second
  Input: all data associated with entity such as position, EC (basic entity type), speed, direction, AI variables, etc.
  Output: fire() usage with direction to fire a bullet, eMove value, eD destination value
  */
  if(e.EC == EC_WORKER){
    float disToD = pointDistance(e.eV,e.AITargetPos);
    if(e.AITargetPos.x > 0){
      if(e.pathing != null && e.pathing.size() > 0){
        e.eMove = true;
        Node tn = (Node) e.pathing.get(e.pathing.size()-1);
        e.eD = new PVector(tn.x+.5, tn.y+.5);
        
        if(pointDistance(e.eD,e.eV) < .5){
          e.pathing.remove(e.pathing.size()-1);
        }
      } else {
        e.blockSet.clear();
        for(int i = -5; i < 6; i++){
          for(int j = -5; j < 6; j++){
            if(aGS(wU,e.AITargetPos.x+i,e.AITargetPos.y+j) >= 100){
              if(pointDistance(new PVector(i,j), new PVector(0,0)) < 2.75){
                if(e.blockSet.size() == 0 || pointDistance((PVector)e.blockSet.get(0), e.AITargetPos) > pointDistance(new PVector(i,j), new PVector(0,0))){
                  int tCount = 0;
                  for(Entity te : (ArrayList<Entity>) entities){
                    if(te.ID != e.ID){
                      for(PVector tpv : (ArrayList<PVector>) te.blockSet){
                        if(floor(aGS(wU,tpv.x,tpv.y)/10) == floor(aGS(wU,e.AITargetPos.x+i,e.AITargetPos.y+j)/10)){
                          tCount++;
                        }
                      }
                    }
                  }
                  if(tCount < attachCap){
                    e.blockSet.clear();
                    e.blockSet.add(new PVector(e.AITargetPos.x+i,e.AITargetPos.y+j));
                  }
                }
              }
            }
          }
        }
        
        
        e.AITargetPos = new PVector(-1*floor(random(50)),-1);
      }
    } else {
      if(fn % 50 == (int)e.AITargetPos.x*-1){
        workerWork(e,3);
      }
    }
    
  }
}



/*LOCK*/void safeDraw(){
  
  boolean overlap = false;
  
  if(selectedE != null){
    stroke(200,0,0);
    noFill();
    strokeWeight(4);
    PVector tempPos2 = pos2Screen(new PVector(selectedE.x,selectedE.y));
    ellipse(tempPos2.x,tempPos2.y,gScale*1.3,gScale*1.3);
  }
  
  noFill();
  strokeWeight(.2*gScale);
  for(int i = 0; i < pans; i++){
    stroke(systemC[i]);
    for(int j = 0; j < systemCenterCount[i]; j++){
      PVector tempPV = new PVector(systemCenters[i][j].x,systemCenters[i][j].y);
      tempPV = pos2Screen(tempPV);
      arc(tempPV.x,tempPV.y,gScale*1.7,gScale*1.7,-HALF_PI,-HALF_PI+systemCenters[i][j].z/100*TWO_PI);
    }
  }
  
  if(!overlap){
    PVector tempPos = screen2Pos(new PVector(mouseX,mouseY));
    ArrayList tempAL = aGSAL(wUEntities,tempPos.x,tempPos.y);
    if(tempAL.size() > 0){
      
      for (Entity te : (ArrayList<Entity>) tempAL) {
        if(te.EC == EC_WORKER){
          if(pointDistance(te.eV,tempPos)<EConfigs[te.EC].Size/2){
            PVector tempPos2 = pos2Screen(new PVector(te.x,te.y));
            noFill();
            strokeWeight(4);
            
            if(selectedE == null || selectedE.ID != te.ID){
              stroke(200,100,100);
              ellipse(tempPos2.x,tempPos2.y,gScale*1.3,gScale*1.3);
            }
            
            
            if(mouseClicked){
              if(selectedE != null){
                if(selectedE.ID == te.ID){
                  selectedE = null;
                } else {
                  selectedE = te;
                }
              } else {
                selectedE = te;
              }
            }
            overlap = true;
            break;
          }
        }
      }
    }
    
  }
  
    
  if(selectedE != null){
    strokeWeight(10);
    if(selectedE.AITargetPos.x <= 0){
      PVector tPV = pos2Screen(new PVector(selectedE.x,selectedE.y));
      if(!overlap){
        PVector tPos2 = screen2Pos(new PVector(mouseX,mouseY));
        if(aGS(wU,tPos2.x,tPos2.y) != 0 && !gBIsSolid[aGS(wU,tPos2.x,tPos2.y)]){
          tPos2.x = floor(tPos2.x)+.5; tPos2.y = floor(tPos2.y)+.5;
          
          if(mouseClicked){
            selectedE.AITargetPos = new PVector(tPos2.x,tPos2.y);
            selectedE.pathing = searchWorldPos(selectedE.eV,new PVector(selectedE.AITargetPos.x-.5,selectedE.AITargetPos.y-.5),75);
            mouseClicked = false;
          }
          
          tPos2 = pos2Screen(tPos2);
          stroke(200,100,100);
          ellipse(tPos2.x,tPos2.y,gScale/2,gScale/2);
        }
      }
      
      stroke(100,255,100,80+abs(fn%80-40)*3);
      ellipse(tPV.x,tPV.y,gScale*5.5,gScale*5.5);
      strokeCap(ROUND);
      PVector tempPV;
      for(int i = selectedE.blockSet.size()-1; i >= 0; i--){
        tempPV = (PVector)selectedE.blockSet.get(i);
        tempPV = pos2Screen(new PVector(tempPV.x,tempPV.y));
        line(tPV.x,tPV.y,tempPV.x,tempPV.y);
      }
      strokeCap(SQUARE);
    } else {
      PVector tPos2 = pos2Screen(new PVector(selectedE.AITargetPos.x,selectedE.AITargetPos.y));
      
      Node tn;
      PVector tpv;
      if(selectedE.pathing != null){
        for(int i = selectedE.pathing.size()-1; i >= 1; i--){
          tn = (Node)selectedE.pathing.get(i);
          tpv = pos2Screen(new PVector(tn.x+.5,tn.y+.5));
          noStroke();
          fill(0,255,0,100);
          ellipse(tpv.x,tpv.y,gScale/4,gScale/4);
        }
        noFill();
      }
      
      if(abs(mouseX-tPos2.x)<gScale/2 && abs(mouseY-tPos2.y)<gScale/2){
        if(!overlap && mouseClicked){
          selectedE.AITargetPos = new PVector(floor(selectedE.x+random(1)-.5)+.5,floor(selectedE.y+random(1)-.5)+.5);
          selectedE.pathing = null;
          
          
          mouseClicked = false;
        }
      }
      stroke(200,0,0);
      ellipse(tPos2.x,tPos2.y,gScale/2,gScale/2);
    }
    
    
  }
  
  stroke(255);
  strokeWeight(4);
  
  if(zoomed){
    if(!overlap & mouseY < tArrowOff+tArrowW/2){
      fill(0,0,255);
      if(mouseClicked){
        mouseClicked = false;
        zoomed = false;
        scaleView(100);
        centerView(50,50);
      }
    } else {
      fill(150,150,255);
    }
    ellipse(width/2,tArrowOff-tArrowW/2,tArrowW,tArrowW);
    line(width/2-tArrowW*1/4,tArrowOff-tArrowW/2,width/2+tArrowW*1/4+1,tArrowOff-tArrowW/2);
  } else {
    if(!overlap & mouseY > height-tArrowOff-tArrowW/2){
      fill(0,0,255);
      if(mouseClicked){
        mouseClicked = false;
        zoomed = true;
        scaleView(15);
        centerView(50,50);
      }
    } else {
      fill(150,150,255);
    }
    ellipse(width/2,height-tArrowOff+tArrowW/2,tArrowW,tArrowW);
    line(width/2-tArrowW*1/4,height-tArrowOff+tArrowW/2,width/2+tArrowW*1/4+1,height-tArrowOff+tArrowW/2);
    line(width/2,height-tArrowOff+tArrowW/2-tArrowW*1/4,width/2,height-tArrowOff+tArrowW/2+tArrowW*1/4+1);
  }
  refreshMinimap();
  
} //called after everything else has been drawn on the screen (draw things on the game)
/*LOCK*/void safePostDraw(){
  /*
  stroke(255);
  strokeWeight(2);
  for(int i = -5; i <= 5; i++){
    for(int j = -5; j <= 5; j++){
      PVector tempPV = new PVector(floor(player.x)+i+.5,floor(player.y)+j+.5);
      
      PVector tempPV2 = pos2Screen(new PVector(tempPV.x,tempPV.y));
      
      ArrayList tempAL = aGSAL(wUEntities,tempPV.x,tempPV.y);
      
      for(int k = 0; k < tempAL.size(); k++){
        if(((Entity)tempAL.get(k)).ID == player.ID){
          fill(0,100,255);
        } else if(EConfigs[((Entity)tempAL.get(k)).EC].Genre == 3){
          fill(0,255,0);
        } else {
          fill(255,0,100);
        }
        ellipse(tempPV2.x+gScale/10*k,tempPV2.y,10,10);
      }
      //text(.size(),tempPV2.x,tempPV2.y);
      
    }
  }
  */
  
  
  noStroke();
  fill(255);
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize,miniMapScale*wSize,HUDStaminaSize);
  float tFade = min(float(total(panHealth[0]))/total(panHealthMax[0]),1);
  fill((1-tFade)*(255*2),tFade*(255*2),0);
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize,miniMapScale*wSize*tFade,HUDStaminaSize);  
  stroke(255);
  strokeWeight(2);
  noFill();
  rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize,miniMapScale*wSize,HUDStaminaSize);
  
  if(mouseX < width-HUDStaminaSize && mouseY > HUDStaminaSize && mouseX > width-miniMapScale*wSize-HUDStaminaSize && mouseY<HUDStaminaSize*2+viewingHealth*HUDStaminaSize*(1.3*pans+1)){
    viewingHealth = 1;
    noStroke();
    fill(255);
    for(int i = 0; i < pans; i++){
      rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*(3+i*1.3),miniMapScale*wSize,HUDStaminaSize);
    }
    for(int i = 0; i < pans; i++){
      fill(gBColor[100+i*10]); rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*(3+i*1.3),miniMapScale*wSize*(float(panHealth[0][i])/panHealthMax[0][i]),HUDStaminaSize);
    }
    stroke(255);
    strokeWeight(2);
    noFill();
    for(int i = 0; i < pans; i++){
      rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize*(3+i*1.3),miniMapScale*wSize,HUDStaminaSize);
    }
  } else {
    viewingHealth = 0;
  }
  
  if(true){
    noStroke();
    fill(255);
    rect(miniMapX-miniMapScale*wSize-HUDStaminaSize,miniMapY+HUDStaminaSize,miniMapScale*wSize,HUDStaminaSize);
    tFade = min(float(total(panHealth[1]))/total(panHealthMax[1]),1);
    fill((1-tFade)*(255*2),tFade*(255*2),0);
    rect(miniMapX-miniMapScale*wSize-HUDStaminaSize,miniMapY+HUDStaminaSize,miniMapScale*wSize*tFade,HUDStaminaSize);  
    stroke(255);
    strokeWeight(2);
    noFill();
    rect(miniMapX-miniMapScale*wSize-HUDStaminaSize,miniMapY+HUDStaminaSize,miniMapScale*wSize,HUDStaminaSize);


    noStroke();
    fill(255);
    for(int i = 0; i < pans; i++){
      rect(miniMapX-miniMapScale*wSize-HUDStaminaSize,miniMapY+HUDStaminaSize*(3+i*1.3),miniMapScale*wSize,HUDStaminaSize);
    }
    for(int i = 0; i < pans; i++){
      fill(gBColor[100+i*10]); rect(miniMapX-miniMapScale*wSize-HUDStaminaSize,miniMapY+HUDStaminaSize*(3+i*1.3),miniMapScale*wSize*(float(panHealth[1][i])/panHealthMax[1][i]),HUDStaminaSize);
    }
    stroke(255);
    strokeWeight(2);
    noFill();
    for(int i = 0; i < pans; i++){
      rect(miniMapX-miniMapScale*wSize-HUDStaminaSize,miniMapY+HUDStaminaSize*(3+i*1.3),miniMapScale*wSize,HUDStaminaSize);
    }
  }
  

  
  if(chatPush != 0){
    stroke(255,chatPush*500);
    strokeWeight(2);
    fill(0,chatPush*500);
    rect(-10,height-chatHeight-2,width+20,100);
    //textMarkup(chatKBS,chatHeight/5,height-chatHeight/2,color(255),220*chatPush,true);
  }
  
} //called after everything else has been drawn on the screen (draw things on the screen)
/*LOCK*/void safeKeyPressed(){} //called when a key is pressed
/*LOCK*/void safeKeyReleased(){} //called when a key is released
/*LOCK*/void safeMousePressed(){
  
} //called when the mouse is pressed

PVector systemCenterNear(PVector eV, int type){
  int bi = 0;
  float closeDis = wSize*10;
  for(int i = 0; i < systemCenterCount[type]; i++){
    if(pointDistance(systemCenters[type][i],eV) < closeDis){
      closeDis = pointDistance(systemCenters[type][i],eV);
      bi = i;
    }
  }
  return new PVector(type,bi);
}

void addToSystemCenter(PVector eV, int num){
  systemCenters[(int)eV.x][(int)eV.y].z += num;
  if(systemCenters[(int)eV.x][(int)eV.y].z >= 100){
    systemCenters[(int)eV.x][(int)eV.y].z -= 100;
    switch((int)eV.x){
      case 0:
        //distribute resources to remove effects
        break;
      case 1:
        //while there is food left to digest, digest one unit of food, decrese progress by 1, randomly distribute 2 units of progress to bacteria targets
        systemCenters[(int)eV.x][(int)eV.y].z += 100;
        println(food);
        Entity te;
        PVector tpv;
        int tb;
        while(food > 0 && systemCenters[(int)eV.x][(int)eV.y].z > 0 && random(100) > .1){
          te = (Entity)entities.get(floor(random(entities.size())));
          if(te.blockSet.size() > 0 && te.AITargetPos.x <= 0){
            tpv = (PVector)te.blockSet.get(0);
            tb = aGS(wU,tpv.x,tpv.y);
            if(tb <110 || tb >= 120 && workerWork(te,2)){
              food--;
              systemCenters[(int)eV.x][(int)eV.y].z--;
            }
          }
        }
        break;
      case 2:
        //fire at a targeted thing
        break;
      case 3:
        //fire general
        break;
      case 4:
        //move to evade general attacks
        break;
      case 5:
        //heal everything that needs it
        break;
      case 6:
        //remove all specific effects
        break;
      case 7:
        //spawn a bacteria
        if(workers < attachCap*pans/4){
          workers++;
          entities.add(new Entity(systemCenters[(int)eV.x][(int)eV.y].x,systemCenters[(int)eV.x][(int)eV.y].y,EC_WORKER,random(TWO_PI)));
          ((Entity)entities.get(entities.size()-1)).AITargetPos = new PVector(floor(systemCenters[(int)eV.x][(int)eV.y].x)+.5,floor(systemCenters[(int)eV.x][(int)eV.y].y)+.5);
        } else {
          systemCenters[(int)eV.x][(int)eV.y].z = 100;
        }
        break;
    }
  } else if(systemCenters[(int)eV.x][(int)eV.y].z < 0){
    systemCenters[(int)eV.x][(int)eV.y].z = 0;
  }
}

void refreshMinimap(){
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      miniMap[i][j] = gBColor[wUOtherSide[i][j]];
    }
  }
}

/*LOCK*/void chatEvent(String source){} //called when a chat message is created

void executeCommand(int index, String[] commands){}

void safeMouseReleased(){}
/*LOCK*/void safeKeyTyped(){} //may be added in the future
/*LOCK*/void safeMouseWheel(){} //may be added in the future
/*LOCK*/void safeMouseClicked(){} //may be added in the future
/*LOCK*/void safeMouseMoved(){} //may be added in the future
/*LOCK*/void safeMouseDragged(){} //may be added in the future

boolean workerWork(Entity e, int quantity){
  if(e.blockSet.size() > 0){
    PVector sc = (PVector)e.blockSet.get(floor(random(e.blockSet.size())));
    sc = systemCenterNear(e.eV,floor((aGS(wU,sc.x,sc.y)-100)/10));
    if(systemCenters[(int)sc.x][(int)sc.y].z < 100){
      particleEffect(e.x-.5, e.y-.5, 1, 1, 10, 0, 0, .01);
      addToSystemCenter(sc,quantity);
      return true;
    } else {
      addToSystemCenter(sc,0);
    }
  }
  return false;
}

void stepBubbles(){
  
  
  panHealth[0][floor(random(pans))]-=1;
  panHealth[1][floor(random(pans))]-=1;
  
  
  if(fn % 10 == 0){
    int flip = 1;
    if(!mySide){
      flip = -1;
    }
    
    int tempOne = 1;
    if(random(100)<35){
      for(int j = 0; j < 8; j++){
        tempOne += floor(random(5));
      }
    } else {
      tempOne = 16+floor(random(3));
    }
    bubbles.add(new Bubble(50+50*flip+10*flip,random(wSize+20)-10,1+random(5),blockC[tempOne]));
    bubbles.add(new Bubble(50+50*flip*-1+10*flip*-1,random(wSize+20)-10-200,1+random(5),blockC[tempOne]));
  }
  
  
  Bubble te;
  for (int i = bubbles.size()-1; i >= 0; i--) {
    te = (Bubble)bubbles.get(i);
    
    int flip = 1;
    int fCenter = 50;
    if(!mySide){
      flip = -1;
    }
    if(te.y < -50){
      flip = -flip;
      fCenter -= 200;
    }
    
    te.x-=.1*flip;
    if((te.y-fCenter) < 35 && (te.x - 50)*flip > 0){
      
      if(te.y == fCenter){
        te.y += .0001;
      }
      if(abs(te.y-fCenter) < 13.5){
        te.y = te.y - abs(te.y-fCenter)/(te.y-fCenter)*.1*pow(1.01,-sq(te.x-(50+30*flip)))*pow(1.01,-sq(abs(te.y-fCenter)-15))*8;
        te.x-=max(0,.5*(1-(te.x-50)/50*flip))*flip;
      } else {
        te.y = te.y + abs(te.y-fCenter)/(te.y-fCenter)*.1*pow(1.01,-sq(te.x-(50+30*flip)))*pow(1.01,-sq(abs(te.y-fCenter)-15))*8;
      }
      
      if(aGS(wU,te.x,te.y) != 0){
        int tb = aGS(wU,te.x,te.y);
        if(tb < 50){
          bubbles.remove(i);
          //inside cell, cause damage
        } else if(tb >= 110 && tb < 120){
          bubbles.remove(i);
          food+=ceil(sq(te.size));
        }
      }
      
    }
    if(te.x < -10 || te.x > wSize+10){
      bubbles.remove(i);
    }
  }
}

class Bubble{
  int col;
  float size,x,y;
  Bubble(float tx, float ty, float tsize, int tcol){
    x = tx;
    y = ty;
    size = tsize;
    col = tcol;
  }
  void display(){
    stroke(255);
    strokeWeight(3);
    fill(col);
    PVector tempPos = pos2Screen(new PVector(x,y));
    ellipse(tempPos.x,tempPos.y,size*gScale,size*gScale);
  }
}
