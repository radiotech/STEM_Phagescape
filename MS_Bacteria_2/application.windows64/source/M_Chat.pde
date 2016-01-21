//STEM Phagescape API v(see above)

boolean isHoverText = false;
String hoverText = "";

float chatHeight = 40;
float chatPush = 0;
float chatPushSpeed = .07;
boolean chatPushing = false;
String chatKBS = "";
int totalChatWidth = 0;
int lastChatCount = 0;
ArrayList cL = new ArrayList<Chat>();


ArrayList CFuns = new ArrayList<CFun>();


void drawChat(){
  
  if(lastChatCount!=cL.size()){
    chatEvent("");
  }
  lastChatCount = cL.size();
  
  
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
    strokeWeight(3);
    fill(0,200*chatPush);
    rect(0-10,floor(height-chatHeight),width/5*4+10,floor(chatHeight+10),0,100,0,0);
    totalChatWidth = textMarkup(chatKBS,chatHeight/5,height-chatHeight/2,color(255),220*chatPush,true);
    //text(chatKBS,chatHeight/5,height-chatHeight/2);
  }
  
  if(isHoverText){
    if(chatPush > .5){drawTextBubble(mouseX,mouseY,hoverText,127);} else {drawTextBubble(mouseX,mouseY,hoverText,90);}
    isHoverText = false;
  }
}

int textMarkup(String text, float x, float y, color defCol, float alpha, boolean showMarks){
  textFont(fontBold,23);
  fill(defCol,alpha);
  noStroke();
  int pointer = 0;
  color lastColor = defCol;
  boolean tUL = false;
  boolean tST = false;
  boolean rURL = false;
  String tREF = "";
  for(int i = 0; i < text.length(); i++){
    if(text.charAt(i) == '*'){
      if(showMarks){
        fill(200,0,255,alpha);
        text(text.charAt(i),x+pointer*14,y);
        pointer++;
      }
      if(text.length() > i+1){
        if(showMarks){
          text(text.charAt(i+1),x+pointer*14,y);
          pointer++;
        }
        if(text.charAt(i+1) == 'r'){fill(255,0,0,alpha); lastColor=color(255,0,0);}  
        if(text.charAt(i+1) == 'o'){fill(255,150,0,alpha); lastColor=color(255,150,0);}
        if(text.charAt(i+1) == 'y'){fill(255,255,0,alpha); lastColor=color(255,255,0);}
        if(text.charAt(i+1) == 'g'){fill(0,255,0,alpha); lastColor=color(0,255,0);}
        if(text.charAt(i+1) == 'c'){fill(0,255,255,alpha); lastColor=color(0,255,255);}
        if(text.charAt(i+1) == 'b'){fill(0,0,255,alpha); lastColor=color(0,0,255);}
        if(text.charAt(i+1) == 'p'){fill(225,0,255,alpha); lastColor=color(225,0,255);}  
        if(text.charAt(i+1) == 'm'){fill(255,0,255,alpha); lastColor=color(255,0,255);}
        if(text.charAt(i+1) == 'w'){fill(255,255,255,alpha); lastColor=color(255,255,255);}
        if(text.charAt(i+1) == 'k'){fill(0,0,0,alpha); lastColor=color(0,0,0);}
        if(text.charAt(i+1) == 'i'){textFont(fontNorm,23);}
        if(text.charAt(i+1) == 'n'){fill(defCol,alpha); lastColor=defCol; textFont(fontBold,23); tUL = false; tST = false;}
        if(text.charAt(i+1) == 'u'){tUL = true;}
        if(text.charAt(i+1) == 's'){tST = true;}
        if(text.charAt(i+1) == 'a'){
          tREF = "";
          while(text.length() > i+2 && (text.charAt(i+1) != '!' || text.charAt(i) != '!')){
            if(showMarks){
              text(text.charAt(i+2),x+pointer*14,y);
              pointer++;
            }
            tREF = tREF + text.charAt(i+2);
            i++;
          }
          if(tREF.indexOf("!!") > -1){
            tREF = tREF.substring(0,tREF.length()-2);
            if(tREF.indexOf("::") > -1){
              String[] tREF2 = split(tREF,"::");
              if(tREF2.length == 2){
                for(int j = 0; j < tREF2[1].length(); j++){
                  text(tREF2[1].charAt(j),x+pointer*14,y);
                  pointer++;
                }
                //rect(,y-chatHeight/4,tREF2[1].length()*14,chatHeight/2);
                if(mouseX > x+(pointer-tREF2[1].length())*14 && mouseX < x+pointer*14){
                  if(mouseY > y-chatHeight/4 && mouseY < y+chatHeight/4){
                    if(tREF2[0].indexOf("\"\"") > -1){
                      String[] tREF3 = split(tREF2[0],"\"\"");
                      if(tREF3.length == 2){
                        isHoverText = true;
                        hoverText = tREF3[1];
                        if(mouseClicked){
                          tryCommand(tREF3[0],"");
                        }
                      }
                    }
                  }
                }
              }
            }
            fill(lastColor,alpha);
          }
        }
      }
      i++;
    } else {
      text(text.charAt(i),x+pointer*14,y);
      pointer++;
      if(tUL){
        rect(x+pointer*14-14,y+10,14,1);
      }
      if(tST){
        rect(x+pointer*14-14,y,14,1);
      }
    }
    
  }
  return pointer;
}

class Chat{
  String content;
  int time;
  int totalChatWidthL;
  
  Chat(String tContent) {
    content = tContent;
    time = millis();
    totalChatWidthL = width*2;
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
        rect(0-10,height-chatHeight-chatHeight*i-chatHeight*chatPush,14*totalChatWidthL+chatHeight,chatHeight,0,100,100,0);
        totalChatWidthL = textMarkup(content,chatHeight/5,height-chatHeight/2-chatHeight*i-chatHeight*chatPush,color(255),100+100*chatPush-255*fadeOut,false);
      }
    }
  }
}

void drawTextBubble(float tx, float ty, String tText, float opacity){
  if(tText != ""){
    String[] textFragments = split(tText,"##");
    float tw = 0;
    for(int i = 0; i < textFragments.length; i++){
      tw = max(textFragments[i].length()*14+chatHeight,tw);
    }
    
    float td = chatHeight+(textFragments.length-1)*chatHeight*2/3;
    
    float tx2 = abs(width-tx-tw+.5)/(width-tx-tw+.5)*tw/2+tx;
    if(tx2-tw/2 < 0){tx2 = tw/2; if(tw>width){tx2 = width/2;}}
    float ty2 = -abs(ty-(td+chatHeight/2)+.5)/(ty-(td+chatHeight/2)+.5)*(td-chatHeight*2/3*(textFragments.length-1)/2)+ty;
    
    noStroke();
    
    int fliph=1;
    int flipv=1;
    if(tx2<tx){fliph=-1;}
    if(ty2>ty){flipv=-1;}
    
    fill(255,opacity/2);
    triangle(tx,ty,tx-3*fliph,ty-(chatHeight/2-3)*flipv,tx+(chatHeight/3+3)*fliph,ty-(chatHeight/2-3)*flipv);
    rect(tx2-tw/2-3-chatHeight/10,ty2-chatHeight/2-3-chatHeight*2/3*(textFragments.length-1)/2,tw+6+chatHeight/5,td+6,chatHeight/10);
    
    fill(255,opacity);
    triangle(tx,ty,tx,ty-chatHeight/2*flipv,tx+chatHeight/3*fliph,ty-chatHeight/2*flipv);
    rect(tx2-tw/2-chatHeight/10,ty2-chatHeight/2-chatHeight*2/3*(textFragments.length-1)/2,tw+chatHeight/5,td,chatHeight/10);
    
    for(int i = 0; i < textFragments.length; i++){
      textMarkup(textFragments[i],tx2-tw/2+chatHeight/2,ty2-chatHeight*2/3*(textFragments.length-1)/2+chatHeight*2/3*i,color(0),opacity*2,false);
    }
  }
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
          if(chatKBS.charAt(0) == '/'){
            tryCommand(chatKBS.substring(1,chatKBS.length()),"player");
          } else {
            cL.add(new Chat(chatKBS));
          }
          chatKBS = "";
          chatPushing = false;
          chatPush = 0;
        }
      } else {
        if(14*totalChatWidth < width/5*4-chatHeight/5*2){
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

void tryCommand(String command, String source) {
  
  String[] commands = split(command," ");
  int args = commands.length-1;
  commands[0] = commands[0].toLowerCase();
  
  Boolean didNone = true;
  for(int i = 0; i < CFuns.size(); i++){
    CFun tempFun = (CFun)CFuns.get(i);
    if(tempFun.name.toLowerCase().equals(commands[0])){
      didNone = false;
      if(source.equals("") || tempFun.free){
        if(tempFun.args == args){
          executeCommand(tempFun.ID,commands);
        } else {
          cL.add(new Chat("*o/*i*o"+commands[0]+"*n*o requires *s*o"+str(tempFun.args)+"*c*o arguments, you provided *s*o"+str(args)));
        }
      } else {
        cL.add(new Chat("*oYou need permission to use /*i*o"+commands[0]+"*n"));
      }
    }

  }
  
  if(commands[0].length()!=0){
    if(didNone){
      cL.add(new Chat("*o/*i*o"+commands[0]+"*n*o was not recognized as a command"));
    }
  }
}



class CFun{
  int ID;
  String name;
  int args;
  boolean free;
  CFun(int tID, String tName, int tArgs, boolean tFree){
    ID = tID;
    name = tName;
    args = tArgs;
    free = tFree;
  }
}




//STEM Phagescape API v(see above)
