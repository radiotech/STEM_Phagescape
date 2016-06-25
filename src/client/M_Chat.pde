//STEM Phagescape API v(see above)

float charWidth = 9;
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
    textSize(18);
    stroke(255,220*chatPush);
    strokeWeight(3);
    fill(0,200*chatPush);
    rect(0-10,floor(height-chatHeight),width/5*4+10,floor(chatHeight+10),0,100,0,0);
    totalChatWidth = textMarkup(chatKBS,18,chatHeight/5,height-chatHeight/2,color(255),220*chatPush,true);
    simpleText(chatKBS,chatHeight/5,height-chatHeight/2);
  }
  
  if(isHoverText){
    if(chatPush > .5){drawTextBubble(mouseX,mouseY,hoverText,127);} else {drawTextBubble(mouseX,mouseY,hoverText,90);}
    isHoverText = false;
  }
}

void simpleText(String a, float x, float y){
  text(a,x,y);
}

int textMarkup(String text, float size, float x, float y, color defCol, float alpha, boolean showMarks){
  size = size/18;
  
  textFont(fontBold);
  
  textSize(size*18);
  fill(defCol,alpha);
  noStroke();
  int pointer = 0;
  color lastColor = defCol;
  boolean tUL = false;
  boolean tST = false;
  boolean rURL = false;
  String tREF = "";
  String tempStr;
  String tempStr2;
  for(int i = 0; i < text.length(); i++){
    //println(text.charAt(i));
    tempStr = text.charAt(i)+"";
    if(tempStr.equals("*")){
      if(showMarks){
        fill(200,0,255,alpha);
        simpleText(text.charAt(i)+"",x+pointer*charWidth*size,y);
        pointer++;
      }
      if(text.length() > i+1){
        if(showMarks){
          simpleText(text.charAt(i+1)+"",x+pointer*charWidth*size,y);
          pointer++;
        }
        tempStr = text.charAt(i+1)+"";
        if(tempStr.equals("r")){fill(255,0,0,alpha); lastColor=color(255,0,0);}  //red
        if(tempStr.equals("o")){fill(255,150,0,alpha); lastColor=color(255,150,0);} //orange
        if(tempStr.equals("y")){fill(255,255,0,alpha); lastColor=color(255,255,0);} //yellow
        if(tempStr.equals("g")){fill(0,255,0,alpha); lastColor=color(0,255,0);} //green
        if(tempStr.equals("c")){fill(0,255,255,alpha); lastColor=color(0,255,255);} //cyan
        if(tempStr.equals("b")){fill(0,0,255,alpha); lastColor=color(0,0,255);} //blue
        if(tempStr.equals("p")){fill(225,0,255,alpha); lastColor=color(225,0,255);} //purple
        if(tempStr.equals("m")){fill(255,0,255,alpha); lastColor=color(255,0,255);} //magenta
        if(tempStr.equals("w")){fill(255,255,255,alpha); lastColor=color(255,255,255);} //white
        if(tempStr.equals("l")){fill(255,255,255,alpha); lastColor=color(200,200,200);} //light grey
        if(tempStr.equals("d")){fill(255,255,255,alpha); lastColor=color(100,100,100);} //dark grey
        if(tempStr.equals("k")){fill(0,0,0,alpha); lastColor=color(0,0,0);} //black (key)
        if(tempStr.equals("i")){/*textFont(fontNorm);*/}
        if(tempStr.equals("n")){fill(defCol,alpha); lastColor=defCol; /*textFont(fontBold);*/ tUL = false; tST = false;}
        if(tempStr.equals("u")){tUL = true;}
        if(tempStr.equals("s")){tST = true;}
        if(tempStr.equals("a")){
          tREF = "";
          tempStr = text.charAt(i+1)+"";
          tempStr2 = text.charAt(i)+"";
          while(text.length() > i+2 && ((!tempStr.equals("!")) || (!tempStr2.equals("!")))){
            if(showMarks){
              simpleText(text.charAt(i+2)+"",x+pointer*charWidth*size,y);
              pointer++;
            }
            tREF = tREF + text.charAt(i+2);
            i++;
            tempStr = text.charAt(i+1)+"";
            tempStr2 = text.charAt(i)+"";
          }
          if(tREF.indexOf("!!") > -1){
            tREF = tREF.substring(0,tREF.length()-2);
            if(tREF.indexOf("::") > -1){
              String[] tREF2 = split(tREF,"::");
              if(tREF2.length == 2){
                for(int j = 0; j < tREF2[1].length(); j++){
                  simpleText(tREF2[1].charAt(j)+"",x+pointer*charWidth*size,y);
                  pointer++;
                }
                if(mouseX > x+(pointer-tREF2[1].length())*charWidth*size && mouseX < x+pointer*charWidth*size){
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
        tempStr = text.charAt(i+1)+"";
        if(tempStr.equals("#")){ textMarkup(text.substring(i+2,text.length()), size*18, x, y+size*18, defCol, alpha, showMarks); i = text.length(); }
      }
      i++;
    } else {
      simpleText(text.charAt(i)+"",x+pointer*charWidth*size,y);
      pointer++;
      if(tUL){
        rect(x+pointer*charWidth*size-charWidth*size,y+10,charWidth*size,1);
      }
      if(tST){
        rect(x+pointer*charWidth*size-charWidth*size,y,charWidth*size,1);
      }
    }
    
  }
  return pointer;
}

float simpleTextWidth(String str, float size){
  if(str.indexOf("*#") == -1){
    return str.length()*charWidth*size/18;
  } else {
    int pos = str.indexOf("*#");
    return max(pos*charWidth*size/18,simpleTextWidth(str.substring(pos+2,str.length()),size));
  }
}

float simpleTextHeight(String str, float size){
  int lines = 1;
  int nextIndex = str.indexOf("*#");
  while(nextIndex != -1){
    lines++;
    nextIndex = str.indexOf("*#",nextIndex+1);
  }
  return lines*size;
}

String simpleTextCrush(String str, float size, float w){
  String[] lines = new String[100];
  int nextLine = 1;
  int pointer = 0;
  String tempStr;
  lines[0] = StringReplaceAll(str,"*#"," ");
  
  while(nextLine < 99 && simpleTextWidth(lines[nextLine-1],size) > w){
    pointer = floor(w/(charWidth*size/18));
    tempStr = lines[nextLine-1].charAt(pointer) + "";
    while(pointer > 0 && !tempStr.equals(" ")){
      pointer--;
      tempStr = lines[nextLine-1].charAt(pointer) + "";
    }
    if(pointer > 0){
      lines[nextLine] = lines[nextLine-1].substring(pointer+1,lines[nextLine-1].length());
    } else {
      pointer = ceil(w/(charWidth*size/18));
      lines[nextLine] = lines[nextLine-1].substring(pointer,lines[nextLine-1].length());
    }
    lines[nextLine-1] = lines[nextLine-1].substring(0,pointer);
    if(nextLine > 1){
      str = str + "*#" + lines[nextLine-1];
    } else {
      str = lines[0];
    }
    nextLine++;
  }
  if(nextLine > 1){
    str = str + "*#" + lines[nextLine-1];
  }
  return str;
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
        rect(0-10,height-chatHeight-chatHeight*i-chatHeight*chatPush,charWidth*totalChatWidthL+chatHeight,chatHeight,0,100,100,0);
        totalChatWidthL = textMarkup(content,18,chatHeight/5,height-chatHeight/2-chatHeight*i-chatHeight*chatPush,color(255),100+100*chatPush-255*fadeOut,false);
      }
    }
  }
}

void drawTextBubble(float tx, float ty, String tText, float opacity){
  if(tText != ""){
    String[] textFragments = split(tText,"##");
    float tw = 0;
    for(int i = 0; i < textFragments.length; i++){
      tw = max(textFragments[i].length()*charWidth+chatHeight,tw);
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
      textMarkup(textFragments[i],18,tx2-tw/2+chatHeight/2,ty2-chatHeight*2/3*(textFragments.length-1)/2+chatHeight*2/3*i,color(0),opacity*2,false);
    }
  }
}

void keyPressedChat(){
  println(key);
  println(keyCode);
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
        if(charWidth*totalChatWidth < width/5*4-chatHeight/5*2){
          chatKBS = chatKBS+str(key);
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
