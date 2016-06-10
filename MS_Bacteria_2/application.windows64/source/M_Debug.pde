PImage debugGraph;
ArrayList debugWave = new ArrayList<PVector>();
ArrayList debugEvents = new ArrayList<PVector>();

void setupDebug(){
  debugGraph = new PImage(width/2,height/3);
  debugWave.add(new PVector(width/2-1,0));
}

void debugLog(int argColor){
  debugEvents.add(new PVector(argColor,0));
}

void updateDebug(){
  
  int bar = int(height/3-(1000/frameRateGoal));
  
  PVector tempPointer = (PVector)debugWave.get(debugWave.size()-1);
  debugWave.add(new PVector((tempPointer.x+1)%(width/2),min(millis()-lastMillis,height/3-1-15*debugEvents.size())));
  if(debugWave.size() > 10){
    debugWave.remove(0);
  }
  tempPointer = (PVector)debugWave.get(debugWave.size()-1);
  
  debugGraph.loadPixels();
  for(int i = 0; i < height/3; i++){
    if(i == bar){
      debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(0,255,0);
    } else {
      debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(0);
    }
  }
  for(int j = debugEvents.size()-1; j >= 0; j--){
    PVector eventColor = (PVector) debugEvents.get(j);
    for(int i = 1; i < 16; i++){
      debugGraph.pixels[int(min(tempPointer.x,width/2-1))+(min(i+15*j,height/3-1))*(width/2)] = int(eventColor.x);
    }
  }
  debugEvents.clear();
  for(int i = floor((height/3)-tempPointer.y); i < height/3; i++){
    if(i == bar){
      debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(0,255,0);
    } else {
      debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(255,0,0);
    }
  }
  for(int j = debugWave.size()-2; j >= 0; j--){
    tempPointer = (PVector)debugWave.get(j);
    for(int i = floor((height/3)-tempPointer.y); i < height/3; i++){
      if(i == bar){
        debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(0,255,0);
      } else {
        debugGraph.pixels[int(tempPointer.x)+i*(width/2)] = color(150+j*10,0,0);
      }
      
    }
  }
  debugGraph.updatePixels();
  image(debugGraph,width/2,height/3*2);
  
  lastMillis = millis();
}
