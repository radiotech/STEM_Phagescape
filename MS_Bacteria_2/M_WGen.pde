/*
Ring
Circle
Round Rect
Rect
Line
Labrynth Level
RandomProb
Fuzzize
fill
replace
*/

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

void genRandomProb(int[] from, int[] to, int[] prob){
  
}
