//STEM Phagescape API v(see above)

float chatHeight = 40;
float chatPush = 0;
float chatPushSpeed = .07;
boolean chatPushing = false;
String chatKBS = "";
ArrayList cL = new ArrayList<Chat>();


void drawChat(){
  
  if(chatPushing){
    if(chatPush < 1){
      chatPush+=chatPushSpeed;
    } else {
      chatPush = 1;
    }
  } else {
    if(chatPush > 0){
      chatPush-=chatPushSpeed;
    } else {
      chatPush = 0;
    }
  }
  
  Chat tempChat;
  for(int i = 0; i < cL.size(); i++){
    tempChat = (Chat) cL.get(i);
    tempChat.display(cL.size()-i-1);
  }
  
  if(chatPush > 0){
    textAlign(LEFT,CENTER);
    textSize(20);
    stroke(255,220*chatPush);
    fill(0,200*chatPush);
    rect(0-10,floor(height-chatHeight),width/5*4+10,floor(chatHeight+10),0,100,0,0);
    fill(255,220*chatPush);
    text(chatKBS,chatHeight/5,height-chatHeight/2);
  }
}


class Chat{
  String content;
  int time;
  
  Chat(String tContent) {
    content = tContent;
    time = millis();
  }
  
  void display(int i){
    if(i < height/chatHeight+2){
      if(time+5000>millis() || chatPush > 0){
        float fadeOut = float(millis()-(time+4000))/1000;
        fadeOut = min(max(fadeOut,0),1);
        if(chatPush > 0){
          fadeOut -= chatPush;
        }
        fadeOut = min(max(fadeOut,0),1);
        
        
        noStroke();
      
        fill(0,100+100*chatPush-255*fadeOut);
        rect(0-10,height-chatHeight-chatHeight*i-chatHeight*chatPush,textWidth(content)+chatHeight,chatHeight,0,100,100,0);
        fill(255,170+50*chatPush-255*fadeOut);
        text(content,chatHeight/5,height-chatHeight/2-chatHeight*i-chatHeight*chatPush);
      }
    }
  }
  
}

void drawTextBubble(float tx, float ty, String tText){
  float tw = textWidth(tText)+chatHeight;
  float td = chatHeight;
  
  float tx2 = tx-(tx-width/2)/(width/2)*tw/2*1.5;
  float ty2 = -abs(ty-(td+chatHeight/2))/(ty-(td+chatHeight/2))*td+ty;
  
  stroke(255,100);
  strokeWeight(7);
  fill(255);
  triangle(tx,ty,tx2-chatHeight/2+(tx-width/2)/(width/2)*tw/4,ty2,tx2+chatHeight/2+(tx-width/2)/(width/2)*tw/4,ty2);
  rect(tx2-tw/2,ty2-chatHeight/2,tw,chatHeight,chatHeight/10);
  fill(0);
  text(tText,tx2-tw/2+chatHeight/2,ty2);
}

void keyPressedChat(){
  if(chatPushing){
    if(key != CODED){
      if(keyCode == BACKSPACE){
        if(chatKBS.length() > 0){
          chatKBS = chatKBS.substring(0,chatKBS.length()-1);
        }
      } else if(key == ESC) {
        chatPushing = false;
        chatKBS = "";
      } else if(keyCode == ENTER) {
        if(chatKBS.length() > 0){
          cL.add(new Chat(chatKBS));
          chatKBS = "";
          chatPushing = false;
          chatPush = 0;
        }
      } else {
        if(textWidth(chatKBS+key) < width/5*4-chatHeight/5*2){
          chatKBS = chatKBS+key;
        }
      }
    }
  } else {
    if(key == 't' || key == 'T' || key == 'c' || key == 'C' || key == ENTER){
      chatPushing = true;
    }
  }
}

//STEM Phagescape API v(see above)
