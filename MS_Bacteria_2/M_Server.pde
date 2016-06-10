String serverURL = "http://harvway.com/BetaBox/STEMPhagescape/testing.php?id=";
ArrayList segments = new ArrayList<Segment>();
ArrayList packets = new ArrayList<Packet>();
ArrayList packetThreads = new ArrayList<PacketThread>();
int packetCycle = 0;
int packetIDCycle = 1;
AudioPlayer serverCastAP;
AudioMetaData serverCastMeta;
int[] buildups = new int[10];
int eventIDCycle = 0;
Boolean[][] eventIDs = new Boolean[100][0];
int maxEventID = 0;


int Rplayers = 0;
int Rhost = 1;
int Rgenerated = 0;

boolean worldDownloaded = false;

boolean online = false;
boolean offline = false;
boolean sentPackets = false;

void setupServer(){
  
  try{
    serverCastAP = minim.loadFile("block-solid1.mp3");
    serverCastMeta = serverCastAP.getMetaData();
  } catch(Throwable e){}
  
  
  updateWorldColumn(0);
  buildPackets();
  
  /*
  String builtString = serverURL;
  for(int k = 0; k < 20; k++){
    builtString = serverURL;
    for(int i = 0; i < 5; i++){
      builtString = builtString + "LWC" + str(i) + "=" + str(k*5+i) + ";";
      for(int j = 0; j < 100; j++){
        if(j > 0){
          builtString = builtString + "|";
        }
        builtString = builtString + wU[k*5+i][j];
      }
      builtString = builtString + "&";
    }
    println(builtString.length());
    //loadStrings(builtString);
  }
  */
}

void updateWorldColumn(int i){
  String worldC = "=" + str(i) + ";";
  int running = 0;
  for(int j = 0; j < 100; j++){
    if(j == 99 || wU[i][min(j+1,100)] != wU[i][j]){
      if(running > 0){
        worldC = worldC + "|";
      }
      if(j-running == 0){
        worldC = worldC + wU[i][j];//print one value
      } else {
        worldC = worldC + wU[i][j] + "x" + str(j-running+1);//print multiple value
      }
      running = j+1;
    }
  }
  worldC = worldC + "&";
  segments.add(new Segment(worldC, 1));
}

void updateEntityData(){
  String entityD;
  for(Entity tempE: (ArrayList<Entity>)entities){ //each entity
    if(tempE.EC < 256){
      entityD = "=" + str(tempE.ID*100+playerID) + ";x;"+str(tempE.x)+"&";
      segments.add(new Segment(entityD, 3));
      entityD = "=" + str(tempE.ID*100+playerID) + ";y;"+str(tempE.y)+"&";
      segments.add(new Segment(entityD, 3));
      entityD = "=" + str(tempE.ID*100+playerID) + ";dir;"+str(tempE.eDir)+"&";
      segments.add(new Segment(entityD, 3));
      entityD = "=" + str(tempE.ID*100+playerID) + ";EC;"+str(tempE.EC)+"&";
      segments.add(new Segment(entityD, 3));
    }
  }
  
}

void updateServer(){
  
  try{
    String packetResponse = serverCastMeta.fileName(); //*checkPacketCallbacks* 
    if(!packetResponse.equals("")){
      
      String[] response = split(packetResponse,"<br>");
      println(response);
      packetRecievedCallback(response);

    }
  } catch(Throwable e){}
  
  if(fn % 10 == 0){
    
    if(packets.size() == 0){
      if(online){
        //updateWorldColumn(packetCycle % 100);
        //sometimes request a world update
        
        //updateEntityData();
        if(worldDownloaded){
          updateEntityData();
        } else if(Rgenerated == 1){
          segments.add(new Segment("GETW=1&", 0));
        } else if(playerID == Rhost){
          for(int k = 1; k < 100; k++){
            updateWorldColumn(k);
          }
          segments.add(new Segment("GETW=1&", 0));
        } else {
          segments.add(new Segment("PING", 0));
        }
        
      }
      buildPackets();
      
    } else if((sentPackets == true && online == false) && offline==false) {
      packets.clear();
    }
    println(str(packets.size())+" packets");
    if(packets.size() > 0){
      sentPackets = true;
      Packet tempPacket = (Packet)packets.get(packetCycle % packets.size());
      println(tempPacket.content);
      
      try {
        PacketThread tempPacketThread = new PacketThread(this,tempPacket.content);
        tempPacketThread.start();
        packetThreads.add(tempPacketThread);
      } catch(Throwable e) {
        //println("FAIL");
        try {
          minim.loadSample(tempPacket.content); //*requestPacket*
          println("called load sample on "+tempPacket.content);
        } catch(Throwable ee) {
          println("ERROR");
        }
      }
      if(offline){
        packets.clear();
      }
    }
    packetCycle++;
  }
  
}

void packetRecievedCallback(String[] response){
  Packet tempPacket;
  println(response[0]);
  if(int(response[0]) > 0){
    if(int(response[0]) == 100){
      processResponse(response);
    } else {
      for(int i = packets.size()-1; i >= 0; i--){
        tempPacket = (Packet)packets.get(i);
        if(tempPacket.id == int(response[0])){
          packets.remove(i);
          processResponse(response);
          break;
        }
      }
    }
  }
}

void processResponse(String[] response){
  int mode = -1;
  int submode = -1;
  
  String tKey = "";
  int tPlayer = 0;
  Mimic tMimic = null;
  
  segments.add(new Segment("="+response[0]+"&", 4));
  
  String[] tempStrA;
  for(int i = 1; i < response.length; i++){
    if(response[i].equals("{[END]}")){mode = -1; submode=-1;} else
    if(response[i].equals("{[BREAK]}")){submode = -1; tKey="";} else
    if(mode == 0){
      tempStrA = split(response[i],";");
      if(tempStrA.length == 3){
        if(aGS(wU,int(tempStrA[0]),int(tempStrA[1])) != int(tempStrA[2])){
          aSS(wU,int(tempStrA[0]),int(tempStrA[1]),int(tempStrA[2]));
          wViewLast.x = -1;
        }
      }
    } else
    if(mode == 1){
      tempStrA = split(response[i],";");
      if(tempStrA.length == 2){
        if(tempStrA[0].equals("PID")){
          online = true;
          packets.clear();
          playerID = int(tempStrA[1]);
        } else
        if(tempStrA[0].equals("WGET")){
          worldDownloaded = true;
        } else
        if(tempStrA[0].equals("P#")){Rplayers = int(tempStrA[1]);} else
        if(tempStrA[0].equals("HOST")){Rhost = int(tempStrA[1]);} else
        if(tempStrA[0].equals("GENERATED")){Rgenerated = int(tempStrA[1]);}
      }
    } else if(mode == 2){
      if(submode == -1){
        submode = int(response[i]);
        tPlayer = submode % 100;
        if(tPlayer == playerID){
          submode = -2;
        } else {
          submode = floor(submode/100);
          if(maxMimicID < submode){
            maxMimicID = submode;
            reloadMimicIDs();
            tMimic = new Mimic(submode, tPlayer);
            mimicIDs[tPlayer-1][submode] = tMimic;
            mimics.add(tMimic);
          } else if(mimicIDs[tPlayer-1][submode] == null){
            if(response[i+1].equals("dead") || response[i+1].equals("exp")){
              submode = -2;
            } else {
              tMimic = new Mimic(submode, tPlayer);
              mimicIDs[tPlayer-1][submode] = tMimic;
              mimics.add(tMimic);
            }
          } else {
            tMimic = mimicIDs[tPlayer-1][submode];
          }
          println("MIMIC REGISTERED" + submode*100+tPlayer);
        }
      } else if(submode != -2) {
        if(tKey.equals("")){
          tKey = response[i];
        } else {
          if(tKey.equals("x")){
            tMimic.x = float(response[i]);
          } else if(tKey.equals("y")){
            tMimic.y = float(response[i]);
          } else if(tKey.equals("dir")){
            tMimic.eDir = float(response[i]);
          } else if(tKey.equals("EC")){
            tMimic.EC = int(response[i]);
          } else if(tKey.equals("dead") || tKey.equals("exp")){
            Mimic ttMimic;
            for(int j = 0; j < mimics.size(); j++){
              ttMimic = (Mimic)mimics.get(j);
              if(ttMimic.ID == tMimic.ID && ttMimic.playerID == tMimic.playerID){
                mimics.remove(j);
                break;
              }
            }
            reloadMimicIDs();
          }
          tKey = "";
        }
      }
    } else
    if(mode == 3){
      tempStrA = split(response[i],",");
      if(tempStrA.length > 1){
        tPlayer = int(tempStrA[0])%100;
        if(tPlayer != playerID){
          submode = floor(int(tempStrA[0])/100);
          if(submode >= eventIDs[tPlayer].length){
            eventIDs[tPlayer] = (Boolean[])expand(eventIDs[tPlayer],submode+1);
            for(int k = 0; k < eventIDs.length; k++){
              for(int j = 0; j < eventIDs[k].length; j++){
                if(eventIDs[k][j] == null){
                  eventIDs[k][j] = false;
                }
              }
            }
          }
          if(eventIDs[tPlayer][submode] == false){
            eventIDs[tPlayer][submode] = true;
            if(tempStrA[1].equals("HB")){
              if(aGS(wU,int(tempStrA[2]),int(tempStrA[3])) == int(tempStrA[4])){
                hitBlock(int(tempStrA[2]),int(tempStrA[3]),int(tempStrA[5]),true);
              }
            } else
            if(tempStrA[1].equals("HE")){
              
            } //end else
          }
        }
      }
    } else
    if(response[i].equals("{[WORLD_UPDATES]}")){mode = 0;} else
    if(response[i].equals("{[GLOBAL_VARS]}")){mode = 1;} else
    if(response[i].equals("{[ENTITY_DATA]}")){mode = 2;} else 
    if(response[i].equals("{[UPDATE_DATA]}")){mode = 3;}
  }
}

void buildPackets(){
  if(segments.size() > 0){
    buildups = new int[buildups.length];
    Segment tempSeg = (Segment)segments.get(0);
    String builtString = tempSeg.buildSegment();
    buildups[tempSeg.type]++;
    if(segments.size() > 1){
      for(int i = 1; i < segments.size(); i++){
        tempSeg = (Segment)segments.get(i);
        if(builtString.length() + (tempSeg.buildSegment()).length() < 2080){
          builtString = builtString + tempSeg.buildSegment();
          buildups[tempSeg.type]++;
        } else {
          packets.add(new Packet(builtString));
          buildups = new int[buildups.length];
          builtString = tempSeg.buildSegment();
          buildups[tempSeg.type]++;
        }
      }
    }
    packets.add(new Packet(builtString));
    eventIDCycle += buildups[5];
  }
  segments.clear();
}

class Packet {
  String content;
  int id;
  Packet(String tContent) {
    id = packetIDCycle*100+playerID;
    packetIDCycle++;
    content = serverURL + str(id) + "&" + "rand=" + str(floor(random(1000))) + "&" + tContent;
  }
}

class Segment {
  String content;
  int type;
  Segment(String tContent, int tType) {
    content = tContent;
    type = tType;
  }
  String buildSegment(){
    if(type == 0){ //general
      return content;
    }
    if(type == 1){ //load world column
      return "LWC"+str(buildups[type])+content;
    }
    if(type == 2){ //load world unit
      return "WU"+str(buildups[type])+content;
    }
    if(type == 3){ //load entity data
      return "MOB"+str(buildups[type])+content;
    }
    if(type == 4){ //packet reciept
      return "GOT"+str(buildups[type])+content;
    }
    if(type == 5){ //packet reciept
      return "EV"+str(buildups[type])+"="+str((eventIDCycle+buildups[type])*100+playerID)+";"+content+"&";
    }
    return "";
  }
}



public class PacketThread implements Runnable {
  Thread thread;
  String packetContent;
  
  public PacketThread(PApplet parent, String tPacketContent){
    parent.registerDispose(this);
    packetContent = tPacketContent;
  }

  public void start(){
    thread = new Thread(this);
    thread.start();
  }

  public void run(){
    String[] primaryResponse = loadStrings(packetContent);
    String[] response = split(primaryResponse[0],"<br>");
    println(response);
    packetRecievedCallback(response);
  }

  public void stop(){
    thread = null;
  }

  // this will magically be called by the parent once the user hits stop 
  // this functionality hasn't been tested heavily so if it doesn't work, file a bug 
  public void dispose() {
    stop();
  }
} 









class Mimic {
  float x = -100;
  float y = -100;
  float eDir = 0;
  int EC = EC_BULLET;
  int ID;
  int playerID;
  boolean expired = false;
  boolean dead = false;
  
  Mimic(int tID, int tPlayerID) {
    ID = tID;
    playerID = tPlayerID;
  }
  
  void update(){
    x+=random(.1)-.05;
    y+=random(.1)-.05;
  }
  
  void display(){
    PVector tempV = pos2Screen(new PVector(x,y));
    //println(ID*100+playerID);
    noStroke();
    fill(0,255,0);
    if(expired){fill(255,200,0);}
    if(dead){fill(255,0,0);}
    ellipse(tempV.x,tempV.y,gScale/2,gScale/2);
  }
  
}

void disconnect(){
  online = false;
  offline = true;
  packets.clear();
  segments.add(new Segment("DIS", 5));
  buildPackets();
}
