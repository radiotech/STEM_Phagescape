int[][] wU = new int[50][50];
int wSize = 50;
float gScale;

PVector start = new PVector(5,5);
PVector stop = new PVector(45,45);

ArrayList closedset;    // The set of nodes already evaluated.
ArrayList openset;    // The set of tentative nodes to be evaluated, initially containing the start node
ArrayList came_from;    // The map of navigated nodes.

void setup(){
  size(500,500);
  closedset = new ArrayList();
  openset = new ArrayList();
  came_from = new ArrayList();
  
  gScale = float(width)/wSize;
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(random(100)<20){
        wU[i][j] = 1;
      }
    }
  }
  aSS(wU,start.x,start.y,0);
  aSS(wU,stop.x,stop.y,0);
}

void draw(){
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      fill(255);
      if(wU[i][j] == 1){
        fill(0);
      } else if(i == start.x && j == start.y){
        fill(0,255,0);
      } else if(i == stop.x && j == stop.y){
        fill(255,0,0);
      }
      rect(i*gScale,j*gScale,gScale,gScale);
    }
  }
  
  
}


void aStar(PVector start,PVector goal)
    closedset := the empty set    // The set of nodes already evaluated.
    openset := {start}    // The set of tentative nodes to be evaluated, initially containing the start node
    came_from := the empty map    // The map of navigated nodes.
 
    g_score := map with default value of Infinity
    g_score[start] := 0    // Cost from start along best known path.
    // Estimated total cost from start to goal through y.
    f_score = map with default value of Infinity
    f_score[start] := g_score[start] + heuristic_cost_estimate(start, goal)
     
    while openset is not empty
        current := the node in openset having the lowest f_score[] value
        if current = goal
            return reconstruct_path(came_from, goal)
         
        remove current from openset
        add current to closedset
        for each neighbor in neighbor_nodes(current)
            if neighbor in closedset
                continue
 
            tentative_g_score := g_score[current] + dist_between(current,neighbor)

            if tentative_g_score < g_score[neighbor] 
                came_from[neighbor] := current
                g_score[neighbor] := tentative_g_score
                f_score[neighbor] := g_score[neighbor] + heuristic_cost_estimate(neighbor, goal)
                if neighbor not in openset
                    add neighbor to openset
 
    return failure

function reconstruct_path(came_from,current)
    total_path := [current]
    while current in came_from:
        current := came_from[current]
        total_path.append(current)
    return total_path
    }

void aSS(int[][] tMat, float tA, float tB, int tValue){ //array set safe
  tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))] = tValue;
}

int aGS(int[][] tMat, float tA, float tB){ //array get safe
  return tMat[max(0,min(tMat.length-1,(int)tA))][max(0,min(tMat[0].length-1,(int)tB))];
}
