//STEM Phagescape API v(see above)
/*
int Astart = -1;

void AIWander(Entity e, int AIradius, int AItestDelay, int AItestChance){ //Total behavior function
  float disToD = pointDistance(e.eV,e.eD);
  if(fn % AItestDelay == 0){
    if(random(100) < AItestChance || disToD > wSize-10){
      int loopingC = 0;
      while(loopingC < 100){
        e.eD = new PVector(e.x+random(AIradius*2)-AIradius,e.y+random(AIradius*2)-AIradius);
        if(rayCast(e.x,e.y,e.eD.x,e.eD.y,false)){
          loopingC = 101;
        }
        loopingC++;
        println(loopingC);
      }
      if(loopingC == 100){
        e.eD = new PVector(e.x,e.y);
      }
    }
  }
  if(disToD > 2){
    e.eMove = true;
  }
}




void nodeWorld(PVector startV, int targetBlock, int vision){
  int q;
  Node n2;
  for ( int ix = 0; ix < wSize; ix+=1 ) {
    for ( int iy = 0; iy < wSize; iy+=1) {
      if ((gBIsSolid[wU[ix][iy]] == false && mDis(ix,iy,startV.x,startV.y)<vision) || (ix == floor(startV.x) && iy == floor(startV.y)) || wU[ix][iy] == targetBlock) {
        nodes.add(new Node(ix,iy));
        nmap[iy][ix] = nodes.size()-1;
        if (ix>0) {
          if (nmap[iy][ix-1]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy][ix-1]),cost);
            ((Node)nodes.get(nmap[iy][ix-1])).addNbor(n2,cost);
          }
        }
        if (iy>0) {
          if (nmap[iy-1][ix]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy-1][ix]),cost);
            ((Node)nodes.get(nmap[iy-1][ix])).addNbor(n2,cost);
          }
        }
      } else {
        nmap[iy][ix] = -1;
      }
    }
  }
}

void nodeWorldPos(PVector startV, PVector targetBlock, int vision){
  int q;
  Node n2;
  
  
  for ( int ix = 0; ix < wSize; ix+=1 ) {
    for ( int iy = 0; iy < wSize; iy+=1) {

      
      if ((gBIsSolid[wU[ix][iy]] == false && mDis(ix,iy,startV.x,startV.y)<vision) || (ix == floor(startV.x) && iy == floor(startV.y)) || (ix == floor(targetBlock.x) && iy == floor(targetBlock.y))) {
        //entities.add(new Entity(ix+.5,iy+.5,0,0));
        
        nodes.add(new Node(ix,iy));
        nmap[iy][ix] = nodes.size()-1;
        if (ix>0) {
          if (nmap[iy][ix-1]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy][ix-1]),cost);
            ((Node)nodes.get(nmap[iy][ix-1])).addNbor(n2,cost);
          }
        }
        if (iy>0) {
          if (nmap[iy-1][ix]!=-1) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0.25,2);
            n2.addNbor((Node)nodes.get(nmap[iy-1][ix]),cost);
            ((Node)nodes.get(nmap[iy-1][ix])).addNbor(n2,cost);
          }
        }
      } else {
        nmap[iy][ix] = -1;
      }
    }
  }
}
 
boolean astar(int iStart, int targetBlock, PVector endV) {
  
  println("d");
  
  openSet.clear();
  closedSet.clear();
  Apath.clear();
   
  //add initial node to openSet
  openSet.add( ((Node)nodes.get(iStart)) );
  ((Node)openSet.get(0)).p = -1;
  ((Node)openSet.get(0)).g = 0;
  PVector tVec;
  if(targetBlock != -1){
    tVec = blockNear(new PVector(((Node)openSet.get(0)).x,((Node)openSet.get(0)).y), targetBlock, 100);
  } else {
    tVec = new PVector(endV.x,endV.y);
  }
  ((Node)openSet.get(0)).h = mDis( ((Node)openSet.get(0)).x, ((Node)openSet.get(0)).y, tVec.x, tVec.y );
   
  Node current;
  float tentativeGScore;
  boolean tentativeIsBetter;
  float lowest = 999999999;
  int lowId = -1;
  
  println("NOa");
  
  while( openSet.size()>0 ) {
    println("NOb");
    lowest = 999999999;
    for ( int a = 0; a < openSet.size(); a++ ) {
      if ( ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h ) <= lowest ) {
        lowest = ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h );
        lowId = a;
      }
    }
    current = (Node)openSet.get(lowId);
    if(targetBlock != -1){
      if ( aGS(wU,current.x,current.y) == targetBlock) { //path found
        //follow parents backward from goal
        Node d = (Node)openSet.get(lowId);
        while( d.p != -1 ) {
          Apath.add( d );
          println("NOc");
          d = (Node)nodes.get(d.p);
        }
          println("NO1");
        return true;
      }
    } else {
      if ( abs(current.x-endV.x) <= .5 && abs(current.y-endV.y) <= .5 ) { //path found
        //follow parents backward from goal
        Node d = (Node)openSet.get(lowId);
        while( d.p != -1 ) {
          Apath.add(d);
          println("NOd");
          d = (Node)nodes.get(d.p);
        }
          println("NO2");
        return true;
      }
    }
    closedSet.add( (Node)openSet.get(lowId) );
    openSet.remove( lowId );
    for ( int n = 0; n < current.nbors.size(); n++ ) {
      if ( closedSet.contains( (Node)current.nbors.get(n) ) ) {
        continue;
      }
      tentativeGScore = current.g + mDis( current.x, current.y, ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y )*((Float)current.nCost.get(n));
      if ( !openSet.contains( (Node)current.nbors.get(n) ) ) {
        openSet.add( (Node)current.nbors.get(n) );
        tentativeIsBetter = true;
      }
      else if ( tentativeGScore < ((Node)current.nbors.get(n)).g ) {
        tentativeIsBetter = true;
      }
      else {
        tentativeIsBetter = false;
      }
       
      if ( tentativeIsBetter ) {
        ((Node)current.nbors.get(n)).p = nodes.indexOf( (Node)closedSet.get(closedSet.size()-1) ); //!!!!
        ((Node)current.nbors.get(n)).g = tentativeGScore;
        if(targetBlock != -1){
          tVec = blockNear(new PVector(((Node)current.nbors.get(n)).x,((Node)current.nbors.get(n)).y), targetBlock, 100);
        } else {
          tVec = new PVector(endV.x,endV.y);
        }
        
        ((Node)current.nbors.get(n)).h = mDis( ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y, tVec.x, tVec.y );
      }
    }
  }
  //no path found
  println("noz");
  return false;
}

class Node {
  float x,y;
  float g,h;
  int p;
  ArrayList nbors; //array of node objects, not indecies
  ArrayList nCost; //cost multiplier for each corresponding
  Node(float _x,float _y) {
    x = _x;
    y = _y;
    g = 0;
    h = 0;
    p = -1;
    nbors = new ArrayList();
    nCost = new ArrayList();
  }
  void addNbor(Node _node,float cm) {
    nbors.add(_node);
    nCost.add(cm);
  }
}

int[][] nmap;
int start = -1;
 
ArrayList openSet;
ArrayList closedSet;
ArrayList nodes = new ArrayList();
ArrayList Apath = new ArrayList();
 
ArrayList searchWorld(PVector startV, int targetBlock, int vision) {
  //size(480,320); //can be any dimensions as long as divisible by 16
  nmap = new int[wSize][wSize];
  openSet = new ArrayList();
  closedSet = new ArrayList();
  nodes = new ArrayList();
  Apath = new ArrayList();
  
  //generateMap(targetBlock);
  

  nodeWorld(startV, targetBlock, vision);
  
  
  Astart = aGS(nmap,startV.y,startV.x);
  boolean tempB = false;
  if(Astart > -1 && targetBlock > -1){
    tempB = astar(Astart,targetBlock,null);
  }
  
  if(tempB == false){
    //Apath = new ArrayList();
  }
  
  return Apath;
}

ArrayList searchWorldPos(PVector startV, PVector endV, int vision) {
  //size(480,320); //can be any dimensions as long as divisible by 16
  nmap = new int[wSize][wSize];
  openSet = new ArrayList();
  closedSet = new ArrayList();
  nodes = new ArrayList();
  Apath = new ArrayList();
  
  //generateMap(targetBlock);

  nodeWorldPos(startV, endV, vision);
  
  
  Astart = aGS(nmap,startV.y,startV.x);
  boolean tempB = false;
  if(Astart > -1){
    tempB = astar(Astart,-1,endV);
  }
  
  if(tempB == false){
    Apath = new ArrayList();
  }
  
  return Apath;
}

void nodeDraw() {
  Node t1;
  for ( int i = 0; i < nodes.size(); i++ ) {
    t1 = (Node)nodes.get(i);
    if (i==Astart) {
      fill(0,255,0);
    } else {
      if (Apath.contains(t1)) {
        fill(255);
        if(((Node)Apath.get(Apath.size()-1)).x == t1.x && ((Node)Apath.get(Apath.size()-1)).y == t1.y){
          fill(0,0,255);
        }
      }
      else {
        fill(150,150,150);
      }
    }
    noStroke();
    PVector tVec = pos2Screen(new PVector(t1.x,t1.y));
    rect(tVec.x+gScale/4,tVec.y+gScale/4,+gScale/2,+gScale/2);
  }
}
*/
//STEM Phagescape API v(see above)
