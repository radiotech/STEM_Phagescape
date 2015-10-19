/* Example Main Script */

void setup(){ //you need this
  size(700,700); //must be square
  M_Setup(); //you need this
} //you need this

void safePresetup(){ //you need this
  //anything you put in here will happen once at the begining of the game (world gen!)
} //you need this

void safeSetup(){ //you need this
  addGeneralBlock(0,color(0,0,0),true,1);
  addGeneralBlock(1,color(255,0,0),false,0);
  addGeneralBlock(2,color(0,255,0),true,1);
  addGeneralBlock(3,color(0,0,255),true,1);
  //You can add more
  
  //Place your world generation code here!
  genReplace(0,1);
  
  scaleView(100); //you need this
  centerView(wSize/2,wSize/2); //you need this
}

void safeAsync(int n){ //you need this
  if(n%25 == 0){ //every second
    println(frameRate); //print FPS each second
  }
  if(n%250 == 0){ //every ten seconds
  }
} //you need this

void safeUpdate(){ //you need this
  //Center view on player//centerView(player.x,player.y);
  //Center view on something//PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6);
  //Center view on something//PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2-2,maxAbs(0,float(mouseY-height/2)/50)+height/2-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);
  //Center view on something//if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX)-2,height/2+(pmouseY-mouseY)-2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);}
} //you need this

void safeDraw(){ //you need this
  
} //you need this

void mousePressed(){
  
}

void keyPressed(){ //you need this
  if(chatPushing){ //you need this
    if(key != CODED){ //you need this
      if(keyCode == BACKSPACE){ //you need this
        if(chatKBS.length() > 0){ //you need this
          chatKBS = chatKBS.substring(0,chatKBS.length()-1); //you need this
        } //you need this
      } else if(key == ESC) { //you need this
        chatPushing = false; //you need this
        chatKBS = ""; //you need this
      } else if(keyCode == ENTER) { //you need this
        if(chatKBS.length() > 0){ //you need this
          cL.add(new Chat(chatKBS)); //you need this
          chatKBS = ""; //you need this
          chatPushing = false; //you need this
          chatPush = 0; //you need this
        } //you need this
      } else { //you need this
        chatKBS = chatKBS+key; //you need this
      } //you need this
    } //you need this
  } else { //you need this
    if(key == 't' || key == 'T' || key == 'c' || key == 'C' || key == ENTER){ //you need this
      chatPushing = true; //you need this
    } //you need this
    player.moveEvent(0); //you need this
  } //you need this
  if(key == ESC) { //you need this
    key = 0; //you need this
  } //you need this
} //you need this

void keyReleased(){ //you need this
  player.moveEvent(1); //you need this
} //you need this
