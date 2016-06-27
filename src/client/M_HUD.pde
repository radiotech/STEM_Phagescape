
float HUDStaminaSize = 100;

PImage HUDImage;

boolean showBars = true;
boolean showMiniMap = true;
boolean loadMiniMap = true;
boolean lockMinimapToCamera = true;
int[][] miniMap;
ArrayList miniMapEntities = new ArrayList();
int miniMapScale = 2;
int miniMapZoomSmall = 6;
int miniMapZoomLarge = 18; //18 is equal
int miniMapZoom;
int miniMapX = 30;
int miniMapY = 30;
int viewCX = 50;
int viewCY = 50;




void setupHUD(){
  miniMapX = width-floor(HUDStaminaSize)-miniMapScale*wSize;
  miniMapY = height-floor(HUDStaminaSize)-miniMapScale*wSize;
}

void drawHUD(){
  
  miniMapScale = 2;
  
  if(showBars){
    noStroke();
    fill(0);
    rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize,miniMapScale*wSize,HUDStaminaSize);
    float tFade = min(player.snap.stamina/100,1);
    //fill(255-255*tFade,255,0);
    fill((1-tFade)*(255*2),tFade*(255*2),0);
    rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize,miniMapScale*wSize*tFade,HUDStaminaSize);
    stroke(255);
    strokeWeight(2);
    noFill();
    rect(width-miniMapScale*wSize-HUDStaminaSize,HUDStaminaSize,miniMapScale*wSize,HUDStaminaSize);
  }
  
  if(showMiniMap){
    if(keyPressed && key == 'm'){
      miniMapScale = 6;
      miniMapX = (width-miniMapScale*wSize)/2;
      miniMapY = (height-miniMapScale*wSize)/2;
      miniMapZoom = miniMapZoomLarge;
    } else {
      miniMapScale = 2;
      miniMapX = width-floor(HUDStaminaSize)-miniMapScale*wSize;
      miniMapY = height-floor(HUDStaminaSize)-miniMapScale*wSize;
      miniMapZoom = miniMapZoomSmall;
    }
    
    int wBlocks = ceil(float(miniMapScale)/(miniMapScale+miniMapZoom)*wSize);
    if(lockMinimapToCamera){
      viewCX = min(wSize-ceil(float(wBlocks)/2),max(floor(float(wBlocks)/2),floor(wViewCenter.x)));
      viewCY = min(wSize-ceil(float(wBlocks)/2),max(floor(float(wBlocks)/2),floor(wViewCenter.y)));
    }
    
    int tempScale = miniMapScale+miniMapZoom;
    int tempOffX = viewCX-floor(float(wBlocks)/2);
    int tempOffY = viewCY-floor(float(wBlocks)/2);
    int tempX = miniMapX-tempScale*wBlocks+wSize*miniMapScale;
    int tempY = miniMapY-tempScale*wBlocks+wSize*miniMapScale;
    
    noStroke();
    fill(red(gBColor[0]),green(gBColor[0]),blue(gBColor[0]));
    if(keyPressed && key == 'm'){ //if large scale mini map
      rect(tempX,tempY,6*wSize,6*wSize);
    } else {
      rect(tempX,tempY,2*wSize,2*wSize);
    }
    
    noStroke();
    for(int i = 0; i < wBlocks; i++){
      for(int j = 0; j < wBlocks; j++){
        fill(miniMap[tempOffX+i][tempOffY+j]);
        rect(tempX+tempScale*i,tempY+tempScale*j,tempScale,tempScale);
      }
    }
  
    
    Mimic tempE;
    float tx, ty;
    for (int i = miniMapEntities.size()-1; i >= 0; i--) {
      tempE = (Mimic) miniMapEntities.get(i);
      tx = tempE.snap.v.x-tempOffX;
      ty = tempE.snap.v.y-tempOffY;
      if(tx > .5 && ty > .5 && tx < wBlocks-.5 && ty < wBlocks-.5){ // is on map
        fill(tempE.col);
        ellipse(tempX+(tx)*tempScale,tempY+(ty)*tempScale,tempScale,tempScale);
      }
    }
    fill(255);
    ellipse(tempX+((int)player.snap.v.x-tempOffX+.5)*tempScale+.5,tempY+((int)player.snap.v.y-tempOffY+.5)*tempScale+.5,tempScale,tempScale);
    
    noFill();
    stroke(255);
    if(keyPressed && key == 'm'){ //if large scale mini map
      rect(tempX,tempY,6*wSize,6*wSize);
    } else {
      rect(tempX,tempY,2*wSize,2*wSize);
    }
  
    miniMapScale = 2;
  }
  
  if(drawHUDSoftEdge){
    image(HUDImage,0,0);
  }
  
  
}

void refreshHUD(){
  if(shadows == true){
    HUDAddLight(int(player.snap.v.x),int(player.snap.v.y),lightStrength);
  } else {
    nmapShade = new int[wSize][wSize];
    for(int i = 0; i < 100; i++){
      for(int j = 0; j < 100; j++){
        nmapShade[i][j] = 10;
      }
    }
  }
}

void HUDAddLight(int x1, int y1, int strength){
  nmapShade = new int[wSize][wSize];
  HUDAddLightLoop(max(0,min(wSize,x1)),max(0,min(wSize,y1)),strength);
}

void HUDAddLightLoop(int x, int y, int dist){
  if(aGS(nmapShade,x,y) < dist){
    aSS(nmapShade,x,y,dist);
    if(aGS1DB(gBIsSolid,aGS(wU,x,y)) == false){
      HUDAddLightLoop(x+1,y,dist-1);
      HUDAddLightLoop(x-1,y,dist-1);
      HUDAddLightLoop(x,y+1,dist-1);
      HUDAddLightLoop(x,y-1,dist-1);
    }
  }
}




void fillMiniMap(){
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      miniMap[i][j] = gBColor[wU[i][j]];
    }
  }
}
