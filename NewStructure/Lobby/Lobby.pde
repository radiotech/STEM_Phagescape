/* @pjs font=/D/monofonto.ttf; */

//Entity testEntity;
int lLevel = 0;
PVector lCheckPoint = new PVector(0,0);
PVector lCheckPoint2 = new PVector(0,0);
int lDimension = 0;
PVector lDimensionOffset = new PVector(0,0);
PVector lDimensionOffset2 = new PVector(0,0);
int lWing = -1;
int lHall = -1;
int lRoom = -1;

int server = -1;
int conn = 0;
String connData = "";
int movePacketId = 0;
int movePacketResponseId = -1;
ArrayList<SnapInput> movePackets = new ArrayList();

//data to send in world properties
/*
Zoom Level
scaleView(x);
Fill Mini Map on World Load?
fillOnLoad = x;
Show Mini Map?
showMiniMap = x;
Show Darkness?
shadows = x;
Show Chat?

*/
boolean fillOnLoad = false;
boolean showChat = true;







/*LOCK*/void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/void safePreSetup(){} //first function called, in case you need to set some variables before anything else starts

/*LOCK*/void safeSetup(){ //called when world generation and entity placement is ready to begin
  
  CFuns.add(new CFun(0,"door",1,false));
  
  //genLoadMap(loadImage(aj.D()+"Lobby/dimension0.png"));
  
  scaleView(10); //scale the view to fit the entire map
  
  shadows = false;
  centerView(player.snap.v.x,player.snap.v.y); //center the view in the middle of the world
  
  wU[50][50] = 5;
  
  //println(aj.openWebsocket());
}

PVector ballPos = new PVector(0,0);

//boolean skip = false;
void processServerOutput(){
  String temp = aj.checkServer();
  /*if(random(20)<1){
    temp = "";
    if(skip == true){
      println("Double Skip");
    }
    println("Skip"+str(getMimic(int(0)).MimicDess.size()));
    skip = true;
  } else {
    skip = false;
  }*/
  if(!temp.equals("")){
    //println("Server: "+temp);
    String[] updates = split(temp,";");
    for(String u: updates){ //each update
      String[] parts = split(u,":");
      if(parts[0].equals("NOCONN")){
        conn = 0;
      } else if(parts[0].equals("CONN")){
        conn = 1;
      } else if(parts[0].equals("WORLD")){
        int skips = 0;
        int tempInt = 0;
        int newWSize = int(parts[1]);
        for(int i = 0; i < newWSize; i++){
          for(int j = 0; j < newWSize; j++){
            tempInt = int(parts[3+j+i*newWSize+skips]);
            if(tempInt > -1){
              aSS(wU,i,j,tempInt);
            } else {
              skips++;
              j--;
              aSS(wUDamage,i,j,-tempInt);
            }
          }
        }
        refreshWorld();
        if(fillOnLoad){
          fillMiniMap();
        }
        if(conn == 0){conn++;}
      } else if(parts[0].equals("READY")){
        conn = 5;
      } else if(parts[0].equals("MOB")){
        Mimic mob = getMimic(int(parts[1]));
        if(mob.isNew){
          mob.isNew = false;
          mob.snap.v.x = float(parts[3]);
          mob.snap.v.y = float(parts[4]);
          mob.snap.dir = float(parts[5]);
        }
        MimicDes PendingDes = new MimicDes(int(parts[2]),float(parts[3]),float(parts[4]),float(parts[5]));
        PendingDes.bulls = floor((parts.length-6)/2);
        PendingDes.bullV = new PVector[PendingDes.bulls];
        for(int i = 0; i < PendingDes.bulls; i++){
          PendingDes.bullV[i] = new PVector(float(parts[6+i*2]),float(parts[7+i*2]));
        }
        if(PendingDes.id == mob.moves){
          mob.MimicDess.add(PendingDes);
          mob.moves++;
        } else {
          mob.PendingDess.add(PendingDes);
        }
        if(mob.PendingDess.size() > 0){
          if(mob.MimicDess.size() <= 1){
            int newMoves = PendingDes.id+1000;
            MimicDes Mtarget = null;
            for(MimicDes d: mob.PendingDess){ //each update
              if(d.id < newMoves){
                newMoves = d.id;
                Mtarget = d;
              }
            }
            MimicDes Msource;
            if(mob.MimicDess.size() == 0){
              println("ERROR!!");
              Msource = new MimicDes(-1,mob.snap.v.x,mob.snap.v.y,mob.snap.dir);
            } else {
              Msource = mob.MimicDess.get(0);
            }
            
            
            float interpol;
            int frames = min(newMoves-mob.moves,6);
            MimicDes tempMD;
            for(int i = 0; i < frames; i++){
              interpol = float(i+1)/(frames+1);
              tempMD = new MimicDes(mob.moves+i,Msource.val[0]*(1-interpol)+Mtarget.val[0]*interpol,Msource.val[1]*(1-interpol)+Mtarget.val[1]*interpol,Msource.val[2]*(1-interpol)+Mtarget.val[2]*interpol);
              if(Msource.bulls == Mtarget.bulls){
                tempMD.bulls = Msource.bulls;
                tempMD.bullV = new PVector[tempMD.bulls];
                for(int j = 0; j < tempMD.bulls; j++){
                  tempMD.bullV[j] = new PVector(Msource.bullV[j].x*(1-interpol)+Mtarget.bullV[j].x*interpol,Msource.bullV[j].y*(1-interpol)+Mtarget.bullV[j].y*interpol);
                }
              }
              mob.MimicDess.add(tempMD);
            }
            
            mob.moves = newMoves;
          }
          boolean looping = true;
          while(looping){
            looping = false;
            for (int i = mob.PendingDess.size()-1; i >= 0; i--) {
              MimicDes d = (MimicDes) mob.PendingDess.get(i);
              if(d.id == mob.moves){
                looping = true;
                mob.moves++;
                mob.MimicDess.add(d);
                mob.PendingDess.remove(i);
              }
            }
          }
        }
        
        
        mob.type = "otherPlayer";
      } else if(parts[0].equals("GB")){
        int limit = floor((parts.length-1)/6);
        for(int i = 0; i < limit; i++){
          gBIsSolid[int(parts[i*6+1])] = boolean(parts[i*6+2]);
          gBColor[int(parts[i*6+1])] = color(int(parts[i*6+3]),int(parts[i*6+4]),int(parts[i*6+5]));
          gBStrength[int(parts[i*6+1])] = int(parts[i*6+6]);
          //println(int(parts[i*6+1]));
        }
      } else if(parts[0].equals("PROPS")){
        println("Recieved Props");
        String[] components;
        for(int i = 1; i < parts.length; i++){
          components = split(parts[i],"=");
          if(components.length > 1){
            if(int(components[0]) < 100){
              println("Proper Format");
              switch(int(components[0])){
                case 0: scaleView(float(components[1])); break;
                case 1: fillOnLoad = boolean(int(components[1])); break;
                case 2: showMiniMap = boolean(int(components[1])); break;
                case 3: shadows = boolean(int(components[1])); break;
                case 4: showChat = boolean(int(components[1])); break;
              }
            }
          }
        }
      } else if(parts[0].equals("BLOCK")){
        aSS(wU,int(parts[1]),int(parts[2]),int(parts[3]));
        aSS(wUDamage,int(parts[1]),int(parts[2]),int(parts[4]));
        if(mDis(player.snap.v.x,player.snap.v.y,int(parts[1]),int(parts[2]))<gSize*2){
          refreshWorld();
        }
      } else if(parts[0].equals("MOB_DIE")){
        killMimic(int(parts[1]));
      } else if(parts[0].equals("RESET")){
        println("REVIEVED RESET");
        wUDamage = new int[wSize][wSize];
        gBColor = new color[256];
        gBIsSolid = new boolean[256];
        gBStrength = new int[256];
        mimics = new ArrayList<Mimic>();
        mimicIDs = new Mimic[0];
        maxMimicID = -1;
        mimics.add(player);
      } else if(parts[0].equals("MOVED")){
        
        if(int(parts[1]) >= movePacketResponseId){
          float wasX = player.snap.v.x;
          float wasY = player.snap.v.y;
          
          movePacketResponseId = int(parts[1]);
          player.snap.v.x = float(parts[2]);
          player.snap.v.y = float(parts[3]);
          player.snap.speed = float(parts[4]);
          player.snap.dir = float(parts[5]);
          player.snap.tSpeed = float(parts[6]);
          player.snap.stamina = float(parts[7]);
          player.snap.fireCoolDown = float(parts[8]);
          player.snap.bullets = new SnapBullet[0];
          int bulls = floor((parts.length-9)/4);
          for(int i = 0; i < bulls; i++){
            player.snap.bullets = (SnapBullet[])append(player.snap.bullets,new SnapBullet(new PVector(float(parts[9+i*4]),float(parts[10+i*4])),float(parts[11+i*4]),float(parts[12+i*4])));
          }
          SnapInput pack;
          for (int i = 0; i < movePackets.size(); i++) {
            pack = (SnapInput) movePackets.get(i);
            if(pack.id > movePacketResponseId){
              player.snap = player.snap.simulate(1,pack.val);
            }
          }
          /*
          if(wasX != player.snap.v.x || wasY != player.snap.v.y){
            //if(pointDistance(player.snap.v,new PVector(wasX,wasY)) > 1){
              //println(pointDistance(player.snap.v,new PVector(wasX,wasY)));
            //}
          } else {
            //println("Same");
          }
          */
        }
      }
      
    }
  }
}

/*LOCK*/void safeAsync(){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  
  try{
    aj.forceUpdateServer();
  }catch(Throwable e){}
  
  if(fn%3 == 0){
    if(conn == 5){
      
      
      
      //println("MOVE");
      if(connData != ""){
        //println("Server: "+"["+connData.substring(0,connData.length()-1)+"]");
        /**/aj.sendData("["+connData.substring(0,connData.length()-1)+"]");/**/
        
        connData = "";
      }
      processServerOutput();
    } else if(fn%10 == 0){
      processServerOutput();
      switch(conn){
        case 0:
          /**/aj.sendData(str(0));/**/
          break;
        case 1:
          //println("[[\"USER\",\""+"player"+floor(random(10000))+"\"]]");
          /**/aj.sendData("[[\"USER\",\""+"player"+floor(random(10000))+"\"]]");/**/
          break;
      }
    }
  }

  if(fn%10 == 0){
    
  }
  
  if(fn%25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    //println(frameRate); //display the game FPS
  }
  if(fn%100 == 0){
    
    //println("Beat");
    
  } //every ten seconds (similar idea applies here)
}

/*LOCK*/void safeUpdate(){ //called before anything has been drawn to the screen (update the world before it is drawn)
  centerView(player.snap.v.x,player.snap.v.y); //center the view on the player
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.snap.v.x*5+tempV2.x)/6,(player.snap.v.y*5+tempV2.y)/6); //center view on the player but pull toward the mouse slightly
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2,maxAbs(0,float(mouseY-height/2)/50)+height/2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y); //move the view in the direction of the mouse
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX),height/2+(pmouseY-mouseY)); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);} //drag the view around
}

void safePostUpdate(){}
/*
void safePluginAI(Entity e){
  
  Control the AI of an entity e
  This function is called 25 times each second
  Input: all data associated with entity such as position, EC (basic entity type), speed, direction, AI variables, etc.
  Output: fire() usage with direction to fire a bullet, eMove value, eD destination value
  
}
*/
/*LOCK*/void safeDraw(){} //called after everything else has been drawn on the screen (draw things on the game)
/*LOCK*/void safePostDraw(){
  if(chatPush != 0){
    stroke(255,chatPush*500);
    strokeWeight(2);
    fill(0,chatPush*500);
    rect(-10,height-chatHeight-2,width+20,100);
    fill(0,255,0);
    stroke(255);
    
    
    //textMarkup(chatKBS,chatHeight/5,height-chatHeight/2,color(255),220*chatPush,true);
  }
} //called after everything else has been drawn on the screen (draw things on the screen)

/*LOCK*/void safeKeyPressed(){
  if(key == '0'){
    conn = 0;
  }
} //called when a key is pressed
/*LOCK*/void safeKeyReleased(){} //called when a key is released
/*LOCK*/void safeMousePressed(){
  if(mouseButton == RIGHT){
    PVector tempV = screen2Pos(new PVector(mouseX,mouseY));
    //player.fire(tempV);
    //connData = connData + "[\"FIRE\","+player.snap.v.x+","+player.snap.v.y+","+pointDir(player.eV,tempV)+"],";
  }
  
} //called when the mouse is pressed

/*LOCK*/void chatEvent(String source){
} //called when a chat message is created

void executeCommand(int index, String[] commands){
  switch(index){
    case 0: //function id stated above
      break;
  }
}

void safeMouseReleased(){}
/*LOCK*/void safeKeyTyped(){} //may be added in the future
/*LOCK*/void safeMouseWheel(){} //may be added in the future
/*LOCK*/void safeMouseClicked(){} //may be added in the future
/*LOCK*/void safeMouseMoved(){} //may be added in the future
/*LOCK*/void safeMouseDragged(){} //may be added in the future
