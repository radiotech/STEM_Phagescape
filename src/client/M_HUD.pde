
Tip[] tips = new Tip[0];

float HUDStaminaSize = 10;

PImage HUDImage;

boolean showBars = true;
boolean showMiniMap = true;
boolean loadMiniMap = true;
boolean lockMinimapToCamera = true;
int[][] miniMap;
ArrayList miniMapEntities = new ArrayList();
int miniMapScale = 2;
int miniMapZoom = 6;
int viewCX = 50;
int viewCY = 50;

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
    int wBlocks = ceil(float(miniMapScale)/(miniMapScale+miniMapZoom)*wSize);
    
  }
  
  if(drawHUDSoftEdge){
    image(HUDImage,0,0);
  }
  
  
}

void setupMinimap(){
  int wBlocks = ceil(float(miniMapScale)/(miniMapScale+miniMapZoom)*wSize);
  aj.hud("setupMinimap",str(wBlocks));
}

void updateMinimap(){
  int wBlocks = ceil(float(miniMapScale)/(miniMapScale+miniMapZoom)*wSize);
  int tempOffX = viewCX-floor(float(wBlocks)/2);
  int tempOffY = viewCY-floor(float(wBlocks)/2);
  if(lockMinimapToCamera){
    viewCX = min(wSize-ceil(float(wBlocks)/2),max(floor(float(wBlocks)/2),floor(wViewCenter.x)));
    viewCY = min(wSize-ceil(float(wBlocks)/2),max(floor(float(wBlocks)/2),floor(wViewCenter.y)));  
  }
  String pass = "[";
  float alpha;
  int c;
  for(int i = 0; i < wBlocks; i++){
    for(int j = 0; j < wBlocks; j++){
      c = miniMap[tempOffX+i][tempOffY+j];
      if(red(c) == 0 && green(c) == 0 && blue(c) == 0){
        alpha = .3;
      } else {
        alpha = 1;
      }
      pass += "\"rgba("+str(red(c))+","+str(green(c))+","+str(blue(c))+","+str(alpha)+")\",";
    }
  }
  pass = pass.substring(0,pass.length()-1)+"]";
  aj.hud("map",pass,str(wBlocks));
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
  updateMinimap();
}

void splash(String url, String title, String sub, int d1, int d2, int d3, int f1, int f2, int f3, boolean override){
  if(conn == 5 || override){
    aj.hud("splash",url,title,sub,str(d1),str(d2),str(d3),str(f1),str(f2),str(f3));
    isLeft = false;
    isRight = false;
  }
}

void noSplash(boolean override){
  if(conn == 5 || override){
    aj.hud("splash");
  }
}

void updateTips(){
  for(int i = tips.length-1; i >= 0; i--){
    tips[i].display();
  }
}

PVector MID_SCREEN;
class Tip{
  PVector sv;
  PVector v;
  float r;
  String text;
  float fade;
  boolean active = true;
  String id = "tip"+str(floor(random(10000)));
  Tip(float x, float y, float tr, String ttext, float tfade) {
    v = new PVector(x,y);
    r = tr; text = ttext; fade = tfade;
    MID_SCREEN = new PVector(width/2,-height*10);
  }
  void display(){
    sv = pos2Screen(new PVector(v.x,v.y));
    if(pointDistance(v,player.snap.v) < r){
      aj.hud("tip",id,str(pointDir(MID_SCREEN, sv)),str(sv.x),str(sv.y),text,str(fade));
    }
  }
}
