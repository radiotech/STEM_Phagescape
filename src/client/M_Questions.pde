
String qText = "";
String[] qAnswerLabels = {"a. ", "b. ", "c. ", "d. ", "e. ", "f. ", "g. ", "h. ", "i. ", "J. "};
String[] qAnswers = new String[4];
int qCorrectAnswer = 0;
float qSize;
float qAnswerSize;
float qWidth;
float qHeight;
float qHoverPad = 7;
float qHover = -1;
String qGoodCallback;
String qBadCallback;
float qLastFade = -1;

void newQuestion(String goodCallback, String badCallback){
  qHover = -1;
  qSize = 45.5;
  qAnswerSize = 40;
  qWidth = width/10*9;
  qHeight = height/10*9;
  
  qCorrectAnswer = 2;
  
  String qTText = "Did you know, if you cut off your left arm, your right arm would be left? Don't worry though, you will (JUSTIN WAS HERE) be all right. [insert question here] The quick brown fox jumped over the lazy dog! When does 1+1 equal three? ";
  String qTAnswers_0 = "One pluse one equals three when you read 1984 by George Orwell";
  String qTAnswers_1 = "One pluse one equals three for large values of 1";
  String qTAnswers_2 = "One pluse one doesn't equal three";
  String qTAnswers_3 = "One pluse one equals three when a cop says it does. Stop resisting! I'm-a light you up!";
  
  boolean resize = true;
  while(resize){
    qText = simpleTextCrush(qTText,qSize,qWidth);
    qAnswers[0] = simpleTextCrush(qAnswerLabels[0]+qTAnswers_0,qAnswerSize,qWidth);
    qAnswers[1] = simpleTextCrush(qAnswerLabels[1]+qTAnswers_1,qAnswerSize,qWidth);
    qAnswers[2] = simpleTextCrush(qAnswerLabels[2]+qTAnswers_2,qAnswerSize,qWidth);
    qAnswers[3] = simpleTextCrush(qAnswerLabels[3]+qTAnswers_3,qAnswerSize,qWidth);
    
    float tempH = simpleTextHeight(qText, qSize) + qSize + qAnswerSize*float(qAnswers.length-1);
    for(int i = 0; i < qAnswers.length; i++){
      tempH += simpleTextHeight(qAnswers[i], qAnswerSize);
    }
    if(tempH > qHeight){
      qSize-=.5;
      qAnswerSize = qSize/5*4;
    } else {
      resize = false;
    }
  }
  
  qGoodCallback = goodCallback;
  qBadCallback = badCallback;
}

void clickQuestion(){
  if(mouseClicked){
    if(qHover > -1){
      if(qLastFade >= 255){
        if(qHover == qCorrectAnswer){
          tryCommand(qGoodCallback,"");
        } else {
          tryCommand(qBadCallback,"");
        }
        mouseClicked = false;
        qHover = -1;
      }
    }
  }
  
  
}

void drawQuestion(float fade){
  qLastFade = fade;
  float yPointer = (height-qHeight)/2 + qSize/2;
  
  textMarkup(qText, qSize, (width-qWidth)/2, yPointer, 255, fade, false);
  
  yPointer += simpleTextHeight(qText, qSize) + qSize/2 + qAnswerSize/2;
  
  qHover = -1;
  for(int i = 0; i < qAnswers.length; i++){
    if(mouseY > yPointer-qAnswerSize/2+qAnswerSize/5-qHoverPad){
      if(mouseY < yPointer-qAnswerSize/2+qAnswerSize/5+simpleTextHeight(qAnswers[i], qAnswerSize)+qHoverPad){
        if(mouseX > (width-qWidth)/2-qHoverPad){
          if(mouseX < (width-qWidth)/2+simpleTextWidth(qAnswers[i], qAnswerSize)+qHoverPad){
            qHover = i;
            fill(0,100);
            noStroke();
            rect((width-qWidth)/2-qHoverPad,yPointer-qAnswerSize/2+qAnswerSize/15-qHoverPad,simpleTextWidth(qAnswers[i], qAnswerSize)+qHoverPad*2,simpleTextHeight(qAnswers[i], qAnswerSize)+qHoverPad*2,qHoverPad);
          }
        }
      }
    }
    textMarkup(qAnswers[i], qAnswerSize, (width-qWidth)/2, yPointer, 255, fade, false);
    yPointer += simpleTextHeight(qAnswers[i], qAnswerSize) + qAnswerSize;
  }
  
  noFill();
  stroke(255);
  strokeWeight(3);
}
