
int[][] grid = new int[30][30];
int row = 0;

void setup(){
  size(300);
  grid[0][15] = 1;
}

void draw(){
  for(int i = 0; i < 30; i++){
    for(int j = 0; j < 30; j++){
      rect(i*10+j*10,10,10);
    }
  }
}


