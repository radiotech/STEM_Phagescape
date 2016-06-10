//STEM Phagescape API v(see above)
int[][] nmap;
boolean genTestPathExists(float x1, float y1, float x2, float y2){
  nmap = new int[wSize][wSize];
  return genTestPathExistsLoop((int) x1, (int) y1, (int) x2, (int) y2);
}

boolean genTestPathExistsLoop(int x, int y, int x2, int y2){
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

boolean genTestPathExistsDis(float x1, float y1, float x2, float y2, float dis){
  nmap = new int[wSize][wSize];
  return genTestPathExistsDisLoop((int) x1, (int) y1, (int) x2, (int) y2, (int) dis);
}

boolean genTestPathExistsDisLoop(int x, int y, int x2, int y2, int dis){
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

boolean genSpread(int num, int from, int to){
  int froms = 0;
  int tos = 0;
  int tx, ty;
  froms = genCountBlock(from);
  if(froms <= num){
    //genReplace(from, to);
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

int genCountBlock(int b){
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

boolean genLoadMap(PImage thisImage){
  if(thisImage.width == wSize && thisImage.height == wSize){
    thisImage.loadPixels();
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        wU[i][j] = int(blue(thisImage.pixels[i+j*wSize]));
      }
    }
  }
  return false;
}

void genRotateMap(int deg){
  if(deg == 1 || deg == 2 || deg == 3){
    int[][] tempWU = new int[wSize][wSize];
    if(deg == 1){
      for(int i = 0; i < wSize; i++){
        for(int j = 0; j < wSize; j++){
          tempWU[wSize-1-j][i] = wU[i][j];
        }
      }
    }
    if(deg == 2){
      for(int i = 0; i < wSize; i++){
        for(int j = 0; j < wSize; j++){
          tempWU[wSize-1-i][wSize-1-j] = wU[i][j];
        }
      }
    }
    if(deg == 3){
      for(int i = 0; i < wSize; i++){
        for(int j = 0; j < wSize; j++){
          tempWU[j][wSize-1-i] = wU[i][j];
        }
      }
    }
    for(int i = 0; i < wSize; i++){
      for(int j = 0; j < wSize; j++){
        wU[i][j] = tempWU[i][j];
      }
    }
  } 
}

void genSpreadClump(int n, int from, int to, int seeds, int[] falloff){
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
    //genReplace(from, to);
  }
}

void pinDistanceMatrix(int x, int y, int d){
  if(aGS(distanceMatrix,x,y)>d){
    aSS(distanceMatrix,x,y,d);
    if(aGS(distanceMatrix,x+1,y)>d+1){pinDistanceMatrix(x+1,y,d+1);}
    if(aGS(distanceMatrix,x-1,y)>d+1){pinDistanceMatrix(x-1,y,d+1);}
    if(aGS(distanceMatrix,x,y+1)>d+1){pinDistanceMatrix(x,y+1,d+1);}
    if(aGS(distanceMatrix,x,y-1)>d+1){pinDistanceMatrix(x,y-1,d+1);}
  }
  
}

//STEM Phagescape API v(see above)
