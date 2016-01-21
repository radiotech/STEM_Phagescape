
int[][] grid = new int[100][100];
int wSize = 100;
int row = 0;

void setup(){
  size(1000,1000);
  grid[0][wSize/2] = 1;
}

void draw(){
  
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      
      fill(0);
      if(grid[i][j] == 1){
        fill(255);
      }
      if(grid[i][j] == 2){
        fill(255,255,0);
      }
      rect(i*10,j*10,10,10);
      
    }
  }
  
}

void mousePressed(){
  int counter = 0;
  for(int i = 0; i < wSize; i++){
    counter += grid[row][i];
    if(grid[row][i] == 1){
      grid[row+1][i+1]++;
      grid[row+1][i-1]++;
    }
  }
  println(counter);
  row++;
}
