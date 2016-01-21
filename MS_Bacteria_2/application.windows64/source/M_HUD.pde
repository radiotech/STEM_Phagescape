
void drawHUD(){
  
}

void refreshHUD(){
  HUDAddLight(int(player.x),int(player.y),1);
  if(shadows == true){
    HUDAddLight(int(player.x),int(player.y),lightStrength);
  }
}

void HUDAddLight(int x1, int y1, int strength){
  nmap = new int[wSize][wSize];
  HUDAddLightLoop(x1,y1,strength);
}

void HUDAddLightLoop(int x, int y, int dist){
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
