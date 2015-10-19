void genRing(int x, int y, float w, float h, float weight, int b){
  float c = TWO_PI/floor(PI*max(w,h)*10);
  float r = 0;
  for(float i = 0; i < TWO_PI; i+=c){
    r = (w*h)/sqrt(sq(w*cos(i))+sq(h*sin(i)))-weight/2;
    for(float j = 0; j <= weight; j+=.2){
      aSS(wU,x+floor((r+j)*cos(i)),y+floor((r+j)*sin(i)),b);
    }
  }
}

void genCircle(float x, float y, float r, int b){
  PVector centerV = new PVector(x,y);
  for(int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      if(pointDistance(new PVector(i,j), centerV) < r){
        aSS(wU,i,j,b);
      }
    }
  }
}

void genLine(int x1, int y1, int x2, int y2, float weight, int b){
  int itt = ceil(10*pointDistance(new PVector(x1,y1), new PVector(x2,y2)));
  float rise = float(y2-y1)/itt;
  float run = float(x2-x1)/itt;
  float xOff = 0;
  float yOff = 0;
  for(float i = 0; i < itt; i+=1){
    for(float j = 0; j <= weight*10; j+=2){
      xOff = (j-weight*5)*rise;
      yOff = (j-weight*5)*-run;
      aSS(wU,floor(x1+xOff+i*run),floor(y1+yOff+i*rise),b);
    }
  }
}

void genRect(float x, float y, float w, float h, int b){
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

void genBox(float x, float y, float w, float h, float weight, int b){
  x = round(x); y = round(y); w = round(w); h = round(h); weight = round(weight);
  int hweight = round(weight/2);
  for(int j = 0; j <= weight; j++){
    for(int i = -hweight; i <= w+hweight; i++){
      aSS(wU,(int)x+i,(int)y-hweight+j,b);
      aSS(wU,(int)x+i,(int)(y+h)-hweight+j,b);
    }
    for(int i = -hweight; i <= h+hweight; i++){
      aSS(wU,(int)x-hweight+j,(int)y+i,b);
      aSS(wU,(int)(x+w)-hweight+j,(int)y+i,b);
    }
  }
}

void genRoundRect(float x, float y, float w, float h, float rounding, int b){
  x = round(x); y = round(y); w = round(w); h = round(h); rounding = round(rounding);
  genRect(x+rounding,y,w-rounding*2,h,b);
  genRect(x,y+rounding,w,h-rounding*2,b);
  genCircle(x+rounding,y+rounding,rounding,b);
  genCircle(x+w-rounding,y+rounding,rounding,b);
  genCircle(x+rounding,y+h-rounding,rounding,b);
  genCircle(x+w-rounding,y+h-rounding,rounding,b);
}

void genRandomProb(int from, int[] to, float[] prob){
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

void genFlood(float x, float y, int b){
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

void genReplace(int from, int to){
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == from){
        wU[i][j] = to;
      }
    }
  }
}

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

boolean genSpread(int num, int from, int to){
  int froms = 0;
  int tos = 0;
  int tx, ty;
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] == from){
        froms++;
      }
    }
  }
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
