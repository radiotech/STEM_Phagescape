/* @ DISABLED pjs font=/D/monofonto.ttf; */

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
int pid = -1;

int server = -1;
int conn = 0;
String connData = "";
int movePacketId = 1;
int movePacketResponseId = -5;
ArrayList<SnapInput> movePackets = new ArrayList();
String mobSyncs;

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
  
  //CFuns.add(new CFun(0,"door",1,false));
  
  //genLoadMap(loadImage(aj.D()+"Lobby/dimension0.png"));
  
  if(!aj.isWeb()){
    println("Resize");
    //frame.setResizable(true);
    //frame.setSize(1300,1300);
    size(1300,1300);
  }
  
  //addHUDItem(new HUDItem(width/2,height/2,width/4,height/4,10));
  //addHUDItem(new HUDItem(width/3,height/3,width/4,height/4,100));
  
  aj.hud("setupChat");
  
  splash("http://atextures.com/wp-content/uploads/2014/08/Nature-Leaves-Background-4-625x468.jpg","Loading","",0,0,0,0,1000,0,true);
  //String ajx = aj.hud("add","#chat","inputBox");
  //aj.hud("class",ajx,"chat");
  //aj.hud("input",ajx);
  //aj.hud("class",ajx,"chatInput");
  
  
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
  temp += mobSyncs;
  mobSyncs = "";
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
    String u;
    for(int itt = 0; itt < updates.length; itt++){ //each update
      u = updates[itt];
      String[] parts = split(u,":");
      if(parts[0].equals("NOCONN")){
        splash(getBG(),"Connection Lost","Trying to reconnect to the server...",0,0,0,200,2000,4000,true);
        conn = 0;
        pid = -1;
        mimics.clear();
        mimics.add(player);
        maxMimicID = -1;
        mimicIDs = new Mimic[0];
        println("CONN IS NOW 0");
        connData = "";
        movePackets.clear();
        movePacketId = 1;
        movePacketResponseId = -5;
      } else if(parts[0].equals("CONN")){
        conn = 1;
        println("CONN IS NOW 1");
      } else if(parts[0].equals("MYCHAT")){
        println("CHAT: "+parts[1]);
        connData = connData + "[\"CHAT\",\""+parts[1]+"\"],";
      } else if(parts[0].equals("CHAT")){
        println("CHAT: "+parts[1]);
        parts[1] = parts[1].replaceAll("\\\\a",":");
        parts[1] = parts[1].replaceAll("\\\\b",";");
        parts[1] = parts[1].replaceAll("\\\\\\\\","\\");
        aj.hud("chat",parts[1]);
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
        println("CONN IS NOW 5");
      } else if(parts[0].equals("MOB")){
        //println(parts[1]);
        Mimic mob = getMimic(int(parts[1]));
        if(mob.isNew){
          mob.isNew = false;
          mob.snap.v.x = float(parts[3]);
          mob.snap.v.y = float(parts[4]);
          mob.snap.dir = float(parts[5]);
          mob.snap.health = int(parts[6]);
        }
        MimicDes PendingDes = new MimicDes(int(parts[2]),float(parts[3]),float(parts[4]),float(parts[5]),int(parts[6]));
        PendingDes.bulls = floor((parts.length-7)/2);
        PendingDes.bullV = new PVector[PendingDes.bulls];
        for(int i = 0; i < PendingDes.bulls; i++){
          PendingDes.bullV[i] = new PVector(float(parts[7+i*2]),float(parts[8+i*2]));
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
              //println("ERROR!!");
              Msource = new MimicDes(-1,mob.snap.v.x,mob.snap.v.y,mob.snap.dir,mob.snap.health);
            } else {
              Msource = mob.MimicDess.get(0);
            }
            
            
            float interpol;
            int frames = min(newMoves-mob.moves,6);
            MimicDes tempMD;
            for(int i = 0; i < frames; i++){
              interpol = float(i+1)/(frames+1);
              tempMD = new MimicDes(mob.moves+i,Msource.val[0]*(1-interpol)+Mtarget.val[0]*interpol,Msource.val[1]*(1-interpol)+Mtarget.val[1]*interpol,Msource.val[2]*(1-interpol)+Mtarget.val[2]*interpol,int(Mtarget.val[3]));
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
      } else if(parts[0].equals("TIPS")){
        int limit = floor((parts.length-1)/5);
        tips = new Tip[limit];
        for(int i = 0; i < limit; i++){
          tips[i] = new Tip(float(parts[i*5+1]),float(parts[i*5+2]),float(parts[i*5+3]),parts[i*5+4],float(parts[i*5+5]));
          //println(int(parts[i*6+1]));
        }
      } else if(parts[0].equals("PID")){
        pid = int(parts[1]);
      } else if(parts[0].equals("BHITM")){
        Mimic bull = getMimic(int(parts[1]));
        Mimic mob = getMimic(int(parts[3]));
        if(bull.snap.bullets.length > int(parts[2])){
          if(pointDistance(bull.snap.bullets[int(parts[2])].v,mob.snap.v) < 1.5){
            color[] cols = {-1,mob.col,bull.bullColor};
            float[] sizes = {-1,.1,.05};
            float[] speeds = {-1,.02,.005};
            int[] shapes = {0,1};
            int[] lifespans = {-1,20,30};
            particleEffectLine(bull.snap.bullets[int(parts[2])].v,mob.snap.v,5,10,5,.2,.2,cols,sizes,speeds,shapes,lifespans);
          }
        }
      } else if(parts[0].equals("MOBSYNC")){
        Mimic mob = getMimic(int(parts[1]));
        if(mob.MimicDess.size() > 0 && ((MimicDes)mob.MimicDess.get(0)).id >= int(parts[2])){
          updates = append(updates,parts[3].replaceAll("%%%",":")+";");
          //println(parts[3].replaceAll("%%%",":"));
        } else {
          mobSyncs += "MOBSYNC:"+parts[1]+":"+parts[2]+":"+parts[3]+";";
        }
      } else if(parts[0].equals("PEFFECT")){
        String[] tempS;
        tempS = split(parts[7],",");
        color[] cols = new color[floor(tempS.length/3)];
        for(int i = 0; i < floor(tempS.length/3); i++){
          if(int(tempS[i*3]) != -1){
            cols[i] = color(int(tempS[i*3]),int(tempS[i*3+1]),int(tempS[i*3+2]));
          } else {
            cols[i] = -1;
          }
        }
        tempS = split(parts[8],",");
        float[] sizes = new float[tempS.length];
        for(int i = 0; i < tempS.length; i++){
          sizes[i] = float(tempS[i]);
        }
        tempS = split(parts[9],",");
        float[] speeds = new float[tempS.length];
        for(int i = 0; i < tempS.length; i++){
          speeds[i] = float(tempS[i]);
        }
        tempS = split(parts[10],",");
        int[] shapes = new int[tempS.length];
        for(int i = 0; i < tempS.length; i++){
          shapes[i] = int(tempS[i]);
        }
        tempS = split(parts[11],",");
        int[] lifespans = new int[tempS.length];
        for(int i = 0; i < tempS.length; i++){
          lifespans[i] = int(tempS[i]);
        }
        particleEffect(int(parts[1]),int(parts[2]),float(parts[3]),float(parts[4]),float(parts[5]),float(parts[6]),cols,sizes,speeds,shapes,lifespans);
      } else if(parts[0].equals("PROPS")){
        noSplash(true);
        //println("Recieved Props");
        String[] components;
        for(int i = 1; i < parts.length; i++){
          components = split(parts[i],"=");
          if(components.length > 1){
            if(int(components[0]) < 100){
              //println("Proper Format");
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
        //println("REVIEVED RESET");
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
          //println("updated response id to "+parts[1]);
          float wasX = player.snap.v.x;
          float wasY = player.snap.v.y;
          
          movePacketResponseId = int(parts[1]);
          player.snap.v.x = float(parts[2]);
          player.snap.v.y = float(parts[3]);
          player.snap.speed = float(parts[4]);
          player.snap.dir = float(parts[5]);
          player.snap.tSpeed = float(parts[6]);
          player.snap.stamina = float(parts[7]);
          if(int(parts[8]) == 0){
            if(player.snap.health != 0){
              deathParticles(player.snap);
            }
          }
          player.snap.health = int(parts[8]);
          //println(u);
          player.snap.hSteps = int(parts[9]);
          player.snap.fireCoolDown = float(parts[10]);
          player.snap.bullets = new SnapBullet[0];
          int bulls = floor((parts.length-9)/4);
          for(int i = 0; i < bulls; i++){
            player.snap.bullets = (SnapBullet[])append(player.snap.bullets,new SnapBullet(new PVector(float(parts[11+i*4]),float(parts[12+i*4])),float(parts[13+i*4]),float(parts[14+i*4])));
          }
          SnapInput pack;
          for (int i = 0; i < movePackets.size(); i++) {
            pack = (SnapInput) movePackets.get(i);
            if(pack.id > movePacketResponseId){
              player.snap = player.snap.simulate(1,pack.val,false);
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
  
  if(fn%25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    //println(frameRate); //display the game FPS
  }
  if(fn%100 == 0){
    if(random(100) < .1){
      splash(getBG(),"Hiii!!!!","This is an anoying popup!",0,0,0,1000,1000,1000,false);
    } else {
      noSplash(false);
    }
  
    //println("Beat");
    
  } //every ten seconds (similar idea applies here)
}

String getBG(){
  return "http://www.hdwallpaperbackgrounds.net/wp-content/uploads/2016/06/Cool-Background-"+str(floor(random(15)+1))+".jpg";
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
/*LOCK*/void safePostDraw(){} //called after everything else has been drawn on the screen (draw things on the screen)

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
