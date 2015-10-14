void nodeWorld(PVector startV, int targetBlock){
  int q;
  Node n2;
  for ( int ix = 0; ix < wSize; ix+=1 ) {
    for ( int iy = 0; iy < wSize; iy+=1) {

        if ((gBIsSolid[wU[ix][iy]] == false && mDis(ix,iy,startV.x,startV.y)<28) || (ix == floor(startV.x) && iy == floor(startV.y)) || wU[ix][iy] == targetBlock) {
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

float mDis(float x1,float y1,float x2,float y2) {
  return abs(y2-y1)+abs(x2-x1);
}
 
boolean astar(int iStart, int targetBlock) {
  float endX,endY;
   
  openSet.clear();
  closedSet.clear();
  path.clear();
   
  //add initial node to openSet
  openSet.add( ((Node)nodes.get(iStart)) );
  ((Node)openSet.get(0)).p = -1;
  ((Node)openSet.get(0)).g = 0;
  PVector tVec = blockNear(new PVector(((Node)openSet.get(0)).x,((Node)openSet.get(0)).y), targetBlock, 100);
  ((Node)openSet.get(0)).h = mDis( ((Node)openSet.get(0)).x, ((Node)openSet.get(0)).y, tVec.x, tVec.y );
   
  Node current;
  float tentativeGScore;
  boolean tentativeIsBetter;
  float lowest = 999999999;
  int lowId = -1;
  while( openSet.size()>0 ) {
    lowest = 999999999;
    for ( int a = 0; a < openSet.size(); a++ ) {
      if ( ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h ) <= lowest ) {
        lowest = ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h );
        lowId = a;
      }
    }
    current = (Node)openSet.get(lowId);
    if ( aGS(wU,current.x,current.y) == targetBlock) { //path found
      //follow parents backward from goal
      Node d = (Node)openSet.get(lowId);
      while( d.p != -1 ) {
        path.add( d );
        d = (Node)nodes.get(d.p);
      }
      return true;
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
        tVec = blockNear(new PVector(((Node)current.nbors.get(n)).x,((Node)current.nbors.get(n)).y), targetBlock, 100);
        ((Node)current.nbors.get(n)).h = mDis( ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y, tVec.x, tVec.y );
      }
    }
  }
  //no path found
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
    nCost.add(new Float(cm));
  }
}



int[][] nmap;
int start = -1;
 
ArrayList openSet;
ArrayList closedSet;
ArrayList nodes;
ArrayList path;
 
ArrayList searchWorld(PVector startV, int targetBlock) {
  //size(480,320); //can be any dimensions as long as divisible by 16
  nmap = new int[wSize][wSize];
  openSet = new ArrayList();
  closedSet = new ArrayList();
  nodes = new ArrayList();
  path = new ArrayList();
  
  //generateMap(targetBlock);
  

  nodeWorld(startV, targetBlock);
  
  
  int start = nmap[floor(startV.y)][floor(startV.x)];
  astar(start,targetBlock);
  
  return path;
}
 
void nodeDraw() {
  Node t1;
  for ( int i = 0; i < nodes.size(); i++ ) {
    t1 = (Node)nodes.get(i);
    if (i==start) {
      fill(0,255,0);
    }
    else {
      if (path.contains(t1)) {
        fill(255);
        if(((Node)path.get(path.size()-1)).x == t1.x && ((Node)path.get(path.size()-1)).y == t1.y){
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
