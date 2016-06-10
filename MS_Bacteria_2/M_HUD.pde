
PImage HUDImage;

String HUDTtext = "";
String HUDTsubText = "";
float HUDTtextSize = 10;
float HUDTsubTextSize = 10;
color HUDTtextColor = 0;
color HUDTsubTextColor = 0;
int HUDTfadeIn = 0;
int HUDTfadeOut = 0;
int HUDTsubTextDelay = 0;
int HUDTdisplayTime = 0;
int HUDTstage = 0;
float HUDTtextWidth = 0;
float HUDTsubTextWidth = 0;

float HUDStaminaSize = 12;

int HUDSstage = 0;
int HUDSfade = 10;
float HUDSradius = float(1)/3;

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
    float tFade = min(player.eStamina/100,1);
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
  
    
    Entity tempE;
    float tx, ty;
    for (int i = miniMapEntities.size()-1; i >= 0; i--) {
      tempE = (Entity) miniMapEntities.get(i);
      tx = tempE.x-tempOffX;
      ty = tempE.y-tempOffY;
      if(tx > .5 && ty > .5 && tx < wBlocks-.5 && ty < wBlocks-.5){ // is on map
        fill(EConfigs[tempE.EC].Color);
        ellipse(tempX+(tx)*tempScale,tempY+(ty)*tempScale,tempScale,tempScale);
      }
    }
    fill(255);
    ellipse(tempX+((int)player.x-tempOffX+.5)*tempScale+.5,tempY+((int)player.y-tempOffY+.5)*tempScale+.5,tempScale,tempScale);
    
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
  
  if(HUDTstage < HUDTfadeIn+HUDTdisplayTime+HUDTfadeOut){
    float tempAlpha = 255;
    float tempAlpha2 = 255;
    float mainOffset = height/15;
    if(HUDTstage < HUDTfadeIn){
      tempAlpha = float(HUDTstage)/HUDTfadeIn*255;
    }
    if(HUDTstage < HUDTfadeIn+HUDTsubTextDelay){
      tempAlpha2 = float(HUDTstage-HUDTsubTextDelay)/HUDTfadeIn*255;
    }
    if(HUDTstage > HUDTfadeIn+HUDTdisplayTime){
      tempAlpha = 255-float(HUDTstage-(HUDTfadeIn+HUDTdisplayTime))/HUDTfadeOut*255;
      tempAlpha2 = min(tempAlpha2,tempAlpha);
    }
    
    if(HUDTsubText.equals("")){
      mainOffset = +HUDTtextSize/2;
    }
    textMarkup(HUDTtext, HUDTtextSize, (width-HUDTtextWidth)/2, height/2-mainOffset, HUDTtextColor, tempAlpha, false);
    if(!HUDTsubText.equals("")){
      textMarkup(HUDTsubText, HUDTsubTextSize, (width-HUDTsubTextWidth)/2, height/2+mainOffset, HUDTsubTextColor, tempAlpha2, false);
    }
  }
  
  if(HUDSstage != 0){
    
    int items = 35;
    float tempFade = float(abs(HUDSstage))/HUDSfade*255;
    float sliceSize = TWO_PI/items;
    
    if(mouseX != width/2 && pointDistance(new PVector(width/2,height/2), new PVector(mouseX,mouseY)) < width*HUDSradius){
      fill(0,255,0,tempFade*4/5);
      noStroke();
      float mousePlace = float(floor((pointDir(new PVector(width/2,height/2), new PVector(mouseX,mouseY))+PI/2)/sliceSize)+0)*sliceSize-PI/2;
      arc(width/2,height/2,width*HUDSradius*2,width*HUDSradius*2,mousePlace,mousePlace+sliceSize);
    }
    
    stroke(255,tempFade);
    strokeWeight(width*HUDSradius/30);
    fill(200,tempFade*4/5);
    ellipse(width/2,height/2,width*HUDSradius*2,width*HUDSradius*2);
    ellipse(width/2,height/2,width*HUDSradius/30,width*HUDSradius/30);
    float dir = -PI/2;
    fill(100,tempFade);
    
    for(int i = 0; i < items; i++){
      line(width/2,height/2,width/2+width*HUDSradius*cos(dir),height/2+width*HUDSradius*sin(dir));
      
      textAlign(CENTER,CENTER);
      textSize(20);
      if(i < 10){
        text(str((i+1)%10),width/2+(width*HUDSradius-18)*cos(dir+.08),height/2+(width*HUDSradius-18)*sin(dir+.08));
      }
      textAlign(CENTER,LEFT);
      
      dir += sliceSize;
    }
    
    stroke(0,255,0);
    
  }
}

void refreshHUD(){
  if(shadows == true){
    HUDAddLight(int(player.x),int(player.y),lightStrength);
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

void updateHUD(){
  if(HUDTstage < HUDTfadeIn+HUDTdisplayTime+HUDTfadeOut){
    HUDTstage++;
  }
  
  if(HUDSstage != 0){
    if(HUDSstage > 0 && HUDSstage < HUDSfade){
      HUDSstage++;
    }
    if(HUDSstage < 0 && HUDSstage < 0){
      HUDSstage++;
    }
    
    noStroke();
    fill(255,float(abs(HUDSstage))/HUDSfade*255);
    ellipse(width/2,height/2,width*HUDSradius*2,width*HUDSradius*2);
  }  
}

void HUDText(String ttext, String tsubText, float ttextSize, float tsubTextSize, color ttextColor, color tsubTextColor, int tfadeIn, int tfadeOut, int tsubTextDelay, int tdisplayTime){
  HUDTtext = ttext;
  HUDTsubText = tsubText;
  HUDTtextSize = ttextSize;
  HUDTsubTextSize = tsubTextSize;
  HUDTtextColor = ttextColor;
  HUDTsubTextColor = tsubTextColor;
  HUDTfadeIn = tfadeIn;
  HUDTfadeOut = tfadeOut;
  HUDTsubTextDelay = tsubTextDelay;
  HUDTdisplayTime = tdisplayTime;
  HUDTstage = 0;
  
  HUDTtextWidth = simpleTextWidth(HUDTtext, HUDTtextSize);
  HUDTsubTextWidth =simpleTextWidth(HUDTsubText, HUDTsubTextSize);
}
