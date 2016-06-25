//STEM Phagescape API v(see above)

//EConfig[] EConfigs = new EConfig[356];

boolean[][] smap;
//int entityIDCycle = 0;
//ArrayList entities = new ArrayList<Entity>(); //Entity list - list of all entities in the world
PImage arrowImg;

class Particle{
  float x;
  float y;
  float dx;
  float dy;
  color col;
  float size;
  int shape;
  int life;
  float strokeSize;
  int fadeStart;
  int delay;
  Particle(float tx, float ty, float speed, float dir, int tdelay, color tcol, float tsize, int tshape, int tlife) {
    x = tx;
    y = ty;
    dx = cos(dir)*speed*25/frameRate;
    dy = sin(dir)*speed*25/frameRate;
    delay = tdelay;
    col = color(red(tcol),green(tcol),blue(tcol));
    size = tsize;
    shape = tshape;
    life = ceil(float(tlife)/25*frameRate);
    strokeSize = size/5;
    fadeStart = floor(float(min(20,life/2))/25*frameRate);
  }
  void display(){
    if(delay > 0){
      delay--;
    } else {
      if(life < fadeStart){
        float alpha = float(life)/fadeStart;
        fill(col,alpha*255);
        stroke(strokeColor,alpha*255);
      } else {
        fill(col);
        stroke(strokeColor);
      }
      float realSize = size*gScale;
      switch(shape){
        case 0:
          ellipse((x-wView.x)*gScale,(y-wView.y)*gScale,realSize,realSize);
          break;
        case 1:
          float realHalfSize = realSize/2;
          rect((x-wView.x)*gScale-realHalfSize,(y-wView.y)*gScale-realHalfSize,realSize,realSize);
          break;
      }
      x += dx;
      y += dy;
      life -= 1;
    }
  }
}
void deathParticles(Snap s){
  color[] cols = {s.dad.col};
  
  float[] sizes = {-1,.1,.05};
  float[] speeds = {-1,.005,.002};
  int[] shapes = {0,1};
  int[] lifespans = {-1,40,60};
  particleEffect(20,3,s.v.x,s.v.y,s.dad.size,s.dad.size,cols,sizes,speeds,shapes,lifespans);
  particleEffect(20,3,s.v.x,s.v.y,s.dad.size/2,s.dad.size/2,cols,sizes,speeds,shapes,lifespans);
}
void bulletParticles(Snap s, int j){
  if(random(100)<30){
    color[] cols = {s.dad.bullColor};
    float[] sizes = {-1,.05,.01};
    float[] speeds = {-1,.02,.005};
    int[] shapes = {0,1};
    int[] lifespans = {-1,20,30};
    particleEffect(2,10,s.bullets[j].v.x,s.bullets[j].v.y,.1,.1,cols,sizes,speeds,shapes,lifespans);
  }
}
void particleEffectLine(PVector v1,PVector v2,int spread,int num,int emittime,float areax, float areay,color[] cols, float[] sizes, float[] speeds, int[] shapes, int[] lifespans){
  for(int i = 0; i < spread; i++){
    float fade = float(i)/(spread-1);
    particleEffect(floor(num/spread),emittime,v1.x*(1-fade)+v2.x*fade,v1.y*(1-fade)+v2.y*fade,areax,areay,cols,sizes,speeds,shapes,lifespans);
  }
}
void particleEffect(int num, int emittime, float posx, float posy, float areax, float areay, color[] cols, float[] sizes, float[] speeds, int[] shapes, int[] lifespans){
  float fade;
  float speed;
  color tcol;
  float tsize;
  int tshape;
  int tlife;
  for(int i = 0; i < num; i++){
    if(speeds[0] == -1){
      fade = random(speeds.length-2);
      speed = speeds[floor(fade)+1]*(1-fade%1)+speeds[ceil(fade)+1]*(fade%1);
    } else {
      speed = speeds[floor(random(speeds.length))];
    }
    if(cols[0] == -1){
      fade = random(cols.length-2);
      tcol = color(red(cols[floor(fade)+1])*(1-fade%1)+red(cols[ceil(fade)+1])*(fade%1),green(cols[floor(fade)+1])*(1-fade%1)+green(cols[ceil(fade)+1])*(fade%1),blue(cols[floor(fade)+1])*(1-fade%1)+blue(cols[ceil(fade)+1])*(fade%1));
    } else {
      tcol = cols[floor(random(cols.length))];
    }
    if(speeds[0] == -1){
      fade = random(sizes.length-2);
      tsize = sizes[floor(fade)+1]*(1-fade%1)+sizes[ceil(fade)+1]*(fade%1);
    } else {
      tsize = sizes[floor(random(sizes.length))];
    }
    tshape = shapes[floor(random(shapes.length))];
    if(lifespans[0] == -1){
      fade = random(lifespans.length-2);
      tlife = round(lifespans[floor(fade)+1]*(1-fade%1)+lifespans[ceil(fade)+1]*(fade%1));
    } else {
      tlife = lifespans[floor(random(sizes.length))];
    }
    particles.add(new Particle(posx+random(areax)-areax/2,posy+random(areay)-areay/2,speed,random(TWO_PI),floor(random(emittime)),tcol,tsize,tshape,tlife));
  }
}

void drawParticles(){
  Particle tempP;
  strokeWeight(ceil((gScale/15-3)/2));
  for (int i = particles.size() - 1; i >= 0; i--) {
    tempP = (Particle) particles.get(i);
    tempP.display();
    if(tempP.life < 0){
      particles.remove(i);
    }
  }
}
//STEM Phagescape API v(see above)
