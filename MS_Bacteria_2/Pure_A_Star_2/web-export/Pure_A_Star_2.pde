int[][] world;

PVector startV;
PVector endV;

void generateMap() {
  
  for ( int ix = 0; ix < width/16.0; ix+=1 ) {
    for ( int iy = 0; iy < height/16.0; iy+=1) {
      world[iy][ix] = -1;
      if (floor(random(5))!=0) {
        world[iy][ix] = 1;
      }
    }
  }
}

void nodeWorld(){
  int q;
  Node n2;
  for ( int ix = 0; ix < width/16.0; ix+=1 ) {
    for ( int iy = 0; iy < height/16.0; iy+=1) {
        if ((world[iy][ix] == 1 && distance(ix,iy,5,5)<28) || (ix == startV.x && iy == startV.y) || (ix == endV.x && iy == endV.y)) {
          
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

float distance(float x1,float y1,float x2,float y2) {
  return abs(y2-y1)+abs(x2-x1);
}
 
boolean astar(int iStart,int iEnd) {
  //A* Pathfinding Algorithm
  //Finds short path from node[iStart] to node[iEnd]
  //Works strictly off nodes, so not grid depended at all
  float endX,endY;
  endX = endV.x;//((Node)nodes.get(iEnd)).x;
  endY = endV.y;//((Node)nodes.get(iEnd)).y;
   
  openSet.clear();
  closedSet.clear();
  path.clear();
   
  //add initial node to openSet
  openSet.add( ((Node)nodes.get(iStart)) );
  ((Node)openSet.get(0)).p = -1;
  ((Node)openSet.get(0)).g = 0;
  ((Node)openSet.get(0)).h = distance( ((Node)openSet.get(0)).x, ((Node)openSet.get(0)).y, endX, endY );
   
  Node current;
  float tentativeGScore;
  boolean tentativeIsBetter;
  float lowest = 999999999;
  int lowId = -1;
   
  while( openSet.size()>0 ) {
    //find the node in openSet with the lowest f (g+h scores) and put its index in lowId
    lowest = 999999999;
    for ( int a = 0; a < openSet.size(); a++ ) {
      if ( ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h ) <= lowest ) {
        lowest = ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h );
        lowId = a;
      }
    }
    current = (Node)openSet.get(lowId);
    if ( (current.x == endX) && (current.y == endY) ) { //path found
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
      tentativeGScore = current.g + distance( current.x, current.y, ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y )*((Float)current.nCost.get(n));
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
        ((Node)current.nbors.get(n)).h = distance( ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y, endX, endY );
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
    nCost.add(cm);
  }
}








int[][] nmap;
int start = -1;
int end = -1;
 
ArrayList openSet;
ArrayList closedSet;
ArrayList nodes;
ArrayList path;
 
void setup() {
  size(480,320); //can be any dimensions as long as divisible by 16
  nmap = new int[height/16][width/16];
  world = new int[height/16][width/16];
  openSet = new ArrayList();
  closedSet = new ArrayList();
  nodes = new ArrayList();
  path = new ArrayList();
  
  
  
  
  generateMap();
  
  
  startV = new PVector(5,5);
  endV = new PVector(15,10);
  
  nodeWorld();
  
  
  start = nmap[int(startV.y)][int(startV.x)];
  end = nmap[int(endV.y)][int(endV.x)];
  println( astar(start,end) );
  
}
 
void draw() {
  background(0,255,0);
  Node t1,t2;
  for ( int i = 0; i < nodes.size(); i++ ) {
    t1 = (Node)nodes.get(i);
    if (i==start) {
      fill(0,255,0);
    }
    else if (i==end) {
      fill(255,0,0);
    }
    else {
      if (path.contains(t1)) {
        fill(255);
      }
      else {
        fill(150,150,150);
      }
    }
    noStroke();
    rect(t1.x*16,t1.y*16,16,16);
  }
}
 
void mousePressed() {
  
}


