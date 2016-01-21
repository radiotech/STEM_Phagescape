
ArrayList sL = new ArrayList<Sound>();

void updateSound(){
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
  boolean display() {
    posV = pos2Screen(new PVector(x+offX,y+offY));
    noFill();
    stroke(config.baseColor,(config.rMax*gScale*wallMult-r*gScale)/(config.rMax*gScale*wallMult)*255);
    strokeWeight(max(0,(r/wSize*config.bandWidth+.6)*gScale));
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
  color baseColor=0;
  float bandWidth=0;
  int waveCount = 0;
  float waveLength = 0;
  float variance = 0;
  float wallEffect = 0;
  SoundConfig(float trSpeed, int trMax, float tdarkness, color tbaseColor, float tbandWidth, int twaveCount, float twaveLength, float tvariance, float twallEffect) {
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
