//STEM Phagescape API v(see above)

void waveGrid(){
  gM = new int[ceil(gSize)*2+1][ceil(gSize)*2+1];
  for(int i = 0; i < gSize; i++){
    for(int j = 0; j < gSize; j++){
      if(aGS(gUShade,i,j) != 0){
        gM[i*2+1][j*2+1] = aGS(gU,i,j);
      } else {
        gM[i*2+1][j*2+1] = 99;
      }
    }
  }
  for(int i = 1; i < gSize*2; i++){
    for(int j = 1; j < gSize*2; j++){
      if(i%2!=j%2){
        if(gBColor[gM[min(i+1,ceil(gSize)*2)][j]] != gBColor[gM[max(i-1,0)][j]]){
          PVector ta = pos2Screen(grid2Pos(new PVector(floor((i+1)/2),floor((j)/2))));
          PVector tb = pos2Screen(grid2Pos(new PVector(floor((i+1)/2),floor((j+2)/2))));
          int strokeWe = ceil((gScale/15-3)/2);
          rectL.add(new RectObj(ceil(ta.x)+ceil(gScale)-strokeWe,ceil(ta.y)+ceil(gScale)-strokeWe,ceil(tb.x)+ceil(gScale)-ceil(ta.x+ceil(gScale))+strokeWe,int(tb.y)+ceil(gScale)-int(ta.y+ceil(gScale))+strokeWe,color(255)));

        }
        if(gBColor[gM[i][min(j+1,ceil(gSize)*2)]] != gBColor[gM[i][max(j-1,0)]]){
          PVector ta = pos2Screen(grid2Pos(new PVector(floor((i)/2),floor((j+1)/2))));
          PVector tb = pos2Screen(grid2Pos(new PVector(floor((i+2)/2),floor((j+1)/2))));
          int strokeWe = ceil((gScale/15-3)/2);
          rectL.add(new RectObj(ceil(ta.x)+ceil(gScale)-strokeWe,ceil(ta.y)+ceil(gScale)-strokeWe,ceil(tb.x)+ceil(gScale)-ceil(ta.x+ceil(gScale))+strokeWe,int(tb.y)+ceil(gScale)-int(ta.y+ceil(gScale))+strokeWe,color(255)));

        }
      }
    }
  }
}

//STEM Phagescape API v(see above)
