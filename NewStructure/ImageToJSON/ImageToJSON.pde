String source = "images/Hall3.png";
String prefix = "mapLobby";
int wSize = 100;
int[] wU = new int[100*100];

int num = -1;
int run;

void setup() {
  genLoadMap(loadImage(source));
  exit();
}

boolean genLoadMap(PImage thisImage) {
  if (thisImage.width == wSize && thisImage.height == wSize) {
    print("var "+prefix+source.substring(source.indexOf("/")+1, source.length()-4)+" = [");
    thisImage.loadPixels();
    for (int j = 0; j < wSize; j++) {
      for (int i = 0; i < wSize; i++) {
        if (int(blue(thisImage.pixels[i+j*wSize])) == num) {
          run++;
        } else {
          if (num != -1) {
            print("["+str(num)+","+str(run)+"],");
          }
          run = 1;
          num = int(blue(thisImage.pixels[i+j*wSize]));
        }
      }
    }
    print("["+str(num)+","+str(run)+"]];");
  }
  return false;
}
