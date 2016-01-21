/* @pjs preload="map.png,dark.png,player.png,shadowHUD.png,darkCloud.png,gradient.png,footprint.png,blood.png"; font=monofonto.ttf; */

SoundConfig s1airDie = new SoundConfig(true, .5, 60, 100, color(100,100), -.6, 1, 2, 0, 80);
SoundConfig s2airFire = new SoundConfig(true, .5, 60, 100, color(100,100), -.6, 1, 2, 0, 80);
SoundConfig s3airLive = new SoundConfig(true, .5, 60, 100, color(100,100), -.6, 1, 2, 0, 80);
SoundConfig s4blockSoft = new SoundConfig(false,1,60,0,0,0,0,0,0,50);
SoundConfig s5blockSolid = new SoundConfig(false,1,60,0,0,0,0,0,0,50);
SoundConfig s18blockItem = new SoundConfig(true, .8, 75, 100, color(255,150), -.6, 1, 1, 1, 50);
SoundConfig s6bulletAll = new SoundConfig(false,1,60,0,0,0,0,0,0,50);
SoundConfig s7daemonAll = new SoundConfig(true, .5, 55, 100, color(0), -.6, 3, 2, 0, 90);
SoundConfig s19daemonHit = new SoundConfig(true, .5, 55, 100, color(0), 0, 1, 2, 0, 90);
SoundConfig s20daemonDie = new SoundConfig(false,1,60,0,0,0,0,0,0,50);
SoundConfig s8deathAll = new SoundConfig(true, .5, 60, 100, color(100,100), -.6, 1, 2, 0, 80);
SoundConfig s9doorClose = new SoundConfig(false,1,60,0,0,0,0,0,0,50);
SoundConfig s10normdoorOpen = new SoundConfig(true, .8, 75, 100, color(255,150), 1, 1, 1, 1, 50);
SoundConfig s11specialdoorOpen = new SoundConfig(false,1,60,0,0,0,0,0,0,50);
AudioPlayer s12flashBlack;
AudioPlayer s13flashWhite;
AudioPlayer s14dead;
AudioPlayer s15music;
SoundConfig s16random = new SoundConfig(false,1,60,0,0,0,0,0,0,50);
AudioPlayer s17red;

boolean playingFlash = false;
boolean playingRed = false;
boolean monsterCaught = false;
PVector monsterSuckA = new PVector(0,0);
PVector monsterSuckV = new PVector(0,0);
PVector monsterSuckP = new PVector(0,0);
int musicStage = 0;
int cracking = -1;
boolean keys[] = new boolean[8];
int totalKeys = 0;
ArrayList<PVector> rays = new ArrayList();

Entity testEntity;
EConfig whiteCell;
EConfig airMonster;
EConfig deathMonster;
float tint = 0;
PImage darkCloudImage;
PImage bloodImage;
PImage tintColor;
PImage[] footprint = new PImage[10];
ArrayList footprints = new ArrayList<PVector>();
int flash = 0;
int deathFade = -1;

/*LOCK*/void setup(){
  size(700,700); //must be square
/*LOCK*/  M_Setup(); //call API setup
/*LOCK*/}

/*LOCK*/void safePreSetup(){} //first function called, in case you need to set some variables before anything else starts

/*LOCK*/void safeSetup(){ //called when world generation and entity placement is ready to begin
  
  //**print(PFont.list());  
  
  shadows = true;
  strokeColor = 0;
  
  minim = new Minim(this);
  
  for(int i = 1; i <= 10; i++){
    if(i<=4){s1airDie.sound.add(minim.loadFile("sounds/air-die"+str(i)+".mp3"));}
    if(i<=5){s2airFire.sound.add(minim.loadFile("sounds/air-fire"+str(i)+".mp3"));}
    if(i<=2){s3airLive.sound.add(minim.loadFile("sounds/air-live"+str(i)+".mp3"));}
    if(i<=3){s4blockSoft.sound.add(minim.loadFile("sounds/block-soft"+str(i)+".mp3"));}//block-soft
    if(i<=7){s5blockSolid.sound.add(minim.loadFile("sounds/block-solid"+str(i)+".mp3"));}
    if(i<=1){s18blockItem.sound.add(minim.loadFile("sounds/block-item"+str(i)+".mp3"));}
    if(i<=10){s6bulletAll.sound.add(minim.loadFile("sounds/bullet-all"+str(i)+".mp3"));}
    if(i<=10){s7daemonAll.sound.add(minim.loadFile("sounds/daemon-all"+str(i)+".mp3"));}
    if(i<=6){s19daemonHit.sound.add(minim.loadFile("sounds/daemon-hit"+str(i)+".mp3"));}
    if(i<=1){s20daemonDie.sound.add(minim.loadFile("sounds/daemon-die"+str(i)+".mp3"));}
    if(i<=5){s8deathAll.sound.add(minim.loadFile("sounds/death-all"+str(i)+".mp3"));}
    if(i<=1){s9doorClose.sound.add(minim.loadFile("sounds/door-close"+str(i)+".mp3"));}
    if(i<=1){s10normdoorOpen.sound.add(minim.loadFile("sounds/normdoor-open"+str(i)+".mp3"));}
    if(i<=1){s11specialdoorOpen.sound.add(minim.loadFile("sounds/specialdoor-open"+str(i)+".mp3"));}
    if(i<=1){s12flashBlack = minim.loadFile("sounds/flash-black"+str(i)+".mp3");}
    if(i<=1){s13flashWhite = minim.loadFile("sounds/flash-white"+str(i)+".mp3");}
    if(i<=1){s14dead = minim.loadFile("sounds/dead"+str(i)+".mp3");}
    if(i<=1){s15music = minim.loadFile("sounds/music"+str(i)+".mp3");}
    if(i<=5){s16random.sound.add(minim.loadFile("sounds/random"+str(i)+".mp3"));}
    if(i<=1){s17red = minim.loadFile("sounds/red"+str(i)+".mp3");}
  }
  
  s15music.loop();
  bulletEntity.DeathCommand = "sound _x_ _y_ 6";
  bulletEntity.BirthCommand = "sound _x_ _y_ 6";
  player.EC.DeathCommand = "sound _x_ _y_ 14";
  darkCloudImage = loadImage("darkCloud.png");
  bloodImage = loadImage("blood.png");
  tintColor = loadImage("gradient.png");
  PImage tempfootprint = loadImage("footprint.png");
  for(int i = 0; i < 10; i++){
    footprint[i] = tempfootprint.get(i*30,0,30,30);
  }
  
  CFuns.add(new CFun(0,"sound",3,false)); //add a function that adds a number, n, to the goal number for a type of bacteria, type, (id, function, argument #, can be used by the user directly? true/false)
  CFuns.add(new CFun(1,"key",3,false));
  CFuns.add(new CFun(2,"answer",1,false));
  
  //genReplace(0,1);
  //genReplace(2,1);
  //genReplace(3,2);
  //genReplace(4,1);
  
  //wU[50][48] = 4;
  
  /*
  genReplace(0,1);
  for(int i = 1; i < 10; i++){
    genRing(50,50,i*10,i*10,0,3);
  }
  
  int[] blocksArg = { 3, 5}; //create a set of blocks
  float[] probArg = { 20, 4 }; //create a list of probabilities for these blocks
  genRandomProb(3, blocksArg, probArg); //place these blocks in the world with their respective probabilities (the world, by default is all 0 and these random blocks replace 0 here)
  
  
  
  scaleView(10); //scale the view to fit the entire map
  centerView(wSize/2,wSize/2); //center the view in the middle of the world
  */
  
  whiteCell = new EConfig();
  whiteCell.Genre = 1;
  whiteCell.Img = loadImage("whiteCell.png");
  whiteCell.AISearchMode = 30;
  whiteCell.AITarget = -1;
  whiteCell.AITargetID = player.EC.ID;
  whiteCell.SMax = .05;
  whiteCell.TSMax = .1;
  whiteCell.TAccel = .03;
  whiteCell.TDrag = .01;
  whiteCell.Type = 1;
  whiteCell.HitboxScale = 0;
  whiteCell.GoalDist = .5; //Want to get this close
  whiteCell.ActDist = -1;
  whiteCell.HMax = 99;
  
  airMonster = new EConfig();
  airMonster.Genre = 1;
  airMonster.Img = loadImage("airMonster.png");
  airMonster.AISearchMode = 11;
  airMonster.AITarget = -1;
  airMonster.AITargetID = player.EC.ID;
  airMonster.SMax = .05;
  airMonster.TSMax = .1;
  airMonster.TAccel = .03;
  airMonster.TDrag = .01;
  airMonster.Type = 1;
  airMonster.GoalDist = 3; //Want to get this close
  airMonster.ActDist = 10;
  airMonster.HMax = 1;
  airMonster.myBulletEntity = new EConfig();
  airMonster.myBulletEntity.Size = .13;
  airMonster.myBulletEntity.SMax = .1;
  airMonster.myBulletEntity.Color = color(0,100);
  airMonster.BirthCommand = "sound _x_ _y_ 3";
  airMonster.DeathCommand = "sound _x_ _y_ 1";
  airMonster.myBulletEntity.BirthCommand = "sound _x_ _y_ 2";
  airMonster.myBulletEntity.DeathCommand = "sound _x_ _y_ 2";
  airMonster.FireDelay = 15;
  airMonster.AltColor = color(0,100);
  
  deathMonster = new EConfig();
  deathMonster.Genre = 1;
  deathMonster.Img = loadImage("deathMonster.png");
  deathMonster.AISearchMode = 11;
  deathMonster.AITarget = -1;
  deathMonster.AITargetID = player.EC.ID;
  deathMonster.SMax = .05;
  deathMonster.TSMax = .1;
  deathMonster.TAccel = .03;
  deathMonster.TDrag = .01;
  deathMonster.Type = 1;
  deathMonster.GoalDist = 3; //Want to get this close
  deathMonster.ActDist = 10;
  deathMonster.HMax = 17;
  deathMonster.myBulletEntity = new EConfig();
  deathMonster.myBulletEntity.Size = .13;
  deathMonster.myBulletEntity.SMax = .3;
  deathMonster.myBulletEntity.Color = color(0,100);
  deathMonster.BirthCommand = "sound _x_ _y_ 8";
  deathMonster.DeathCommand = "sound _x_ _y_ 8";
  deathMonster.myBulletEntity.BirthCommand = "sound _x_ _y_ 8";
  deathMonster.myBulletEntity.DeathCommand = "sound _x_ _y_ 8";
  deathMonster.FireDelay = 35;
  deathMonster.AltColor = color(0,100);
  
  
  defineBlocksColor();
  
  //addGeneralBlock(0,color(200,200,200),false,0); //inside
  
  
  //addGeneralBlock(3,color(100,100,100),true,-1); //wall
  
  //addGeneralBlock(4,color(170,170,170),true,-1); //door closed
  addActionSpecialBlock(4,46);
  addGeneralBlockBreak(4,7,"");
  //addGeneralBlock(7,color(200,200,200),false,-1); //door open
  addActionSpecialBlock(7,46);
  addGeneralBlockBreak(7,4,"");
  
  //addGeneralBlock(8,color(130,130,130),true,0); //door frame
  addActionSpecialBlock(8,46);
  addGeneralBlockBreak(8,9,"sound _x_ _y_ 10");
  //addGeneralBlock(9,color(130,130,130),true,0); //door frame2
  addActionSpecialBlock(9,46);
  addGeneralBlockBreak(9,8,"sound _x_ _y_ 9");
  
  //addGeneralBlock(30,color(130,130,130),true,0); //door frame (closet)
  addActionSpecialBlock(30,46);
  addGeneralBlockBreak(30,31,"sound _x_ _y_ 11");
  //addGeneralBlock(31,color(130,130,130),true,0); //door frame2 (closet)
  addActionSpecialBlock(31,46);
  addGeneralBlockBreak(31,30,"sound _x_ _y_ 9");
  
  //addGeneralBlock(10,color(50,50,50),true,2); //breakable block
  addGeneralBlockBreak(10,0,"sound _x_ _y_ 4");
  
  //addGeneralBlock(33,color(0,0,0),true,49); //breakable block core
  addGeneralBlockBreak(33,0,"sound _x_ _y_ 5");
  
  //addGeneralBlock(11,color(255,255,255),true,49); //key
  //addGeneralBlock(12,color(255,255,255),true,49); //key
  //addGeneralBlock(13,color(255,255,255),true,49); //key
  //addGeneralBlock(14,color(255,255,255),true,49); //key
  //addGeneralBlock(15,color(255,255,255),true,49); //key
  //addGeneralBlock(16,color(255,255,255),true,49); //key
  //addGeneralBlock(17,color(255,255,255),true,49); //key
  //addGeneralBlock(18,color(255,255,255),true,49); //key
  addGeneralBlockBreak(11,0,"key _x_ _y_ 11");
  addGeneralBlockBreak(12,0,"key _x_ _y_ 12");
  addGeneralBlockBreak(13,0,"key _x_ _y_ 13");
  addGeneralBlockBreak(14,0,"key _x_ _y_ 14");
  addGeneralBlockBreak(15,0,"key _x_ _y_ 15");
  addGeneralBlockBreak(16,0,"key _x_ _y_ 16");
  addGeneralBlockBreak(17,0,"key _x_ _y_ 17");
  addGeneralBlockBreak(18,0,"key _x_ _y_ 18");
  
  //addGeneralBlock(255,color(25,25,25),false,-1); //shadow
  
  //addGeneralBlock(50,color(255,255,255),true,0); //help
  addGeneralBlockBreak(50,50,""); //help break
  addTextSpecialBlock(50, "Right click this##block for help", 2);

  
  /*
  addImageSpecialBlock(7,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(0,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(5,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(6,loadImage("planks_birch.png"),0);
  addImageSpecialBlock(3,loadImage("a.png"),0); //
  addImageSpecialBlock(8,loadImage("log_birch_top.png"),0); //
  addImageSpecialBlock(9,loadImage("log_birch_top.png"),0); //
  addImageSpecialBlock(4,loadImage("log_birch.png"),0); //
  */
  
  //addTextSpecialBlock(4,"Hello World",11); //make block four display text when the player is near
  
  //int[] blocksArg = { 0, 1, 2, 3, 4 }; //create a set of blocks
  //float[] probArg = { 20, 14, 3, 2, 1 }; //create a list of probabilities for these blocks
  //genRandomProb(0, blocksArg, probArg); //place these blocks in the world with their respective probabilities (the world, by default is all 0 and these random blocks replace 0 here)

  
  genLoadMap(loadImage("map.png"));
  
  scaleView(10); //scale the view to fit the entire map
  centerView(wSize/2,wSize/2); //center the view in the middle of the world
  player.y = -1;
  player.x = 47;
  player.eDir = PI/2;
  
  player.eHealth = -2;
  entities.add(new Entity(player.x,player.y,bulletEntity,0));
  
  //player.EC.AIDoorBlock = 8; //this line will make doors auto open for the player
  //player.EC.AIDoorBlockClose = 9; //this line will make doors auto close for the player
  //entities.remove(player); //remove the player from the list of known entities so that it is not drawn on the screen and we only see the world
  //testEntity.destroy();
}

/*LOCK*/void safeAsync(){ //called 25 times each second with an increasing number, n (things that need to be timed correctly, like moveing something over time)
  if(monsterCaught == true){
    if(cracking == -1){
      float monsterSuckStrength = pointDistance(testEntity.eV,new PVector(50,50.5))/90;
      float monsterSuckDir = pointDir(testEntity.eV,new PVector(50,50.5));
      monsterSuckA = new PVector(monsterSuckStrength*cos(monsterSuckDir),monsterSuckStrength*sin(monsterSuckDir));
      monsterSuckV = new PVector(monsterSuckV.x*1.01+monsterSuckA.x+random(.1)-.05,monsterSuckV.y*1.01+monsterSuckA.y+random(.1)-.05);
      monsterSuckP = new PVector(monsterSuckP.x+monsterSuckV.x,monsterSuckP.y+monsterSuckV.y);
      if(pointDistance(new PVector(0,0), monsterSuckP) > 1){
        monsterSuckDir = pointDir(new PVector(0,0),monsterSuckP);
        monsterSuckP = new PVector(1*cos(monsterSuckDir),1*sin(monsterSuckDir));
        monsterSuckV = new PVector(monsterSuckV.x*.7,monsterSuckV.y*.7);
      }
    }
    testEntity.x = 50+monsterSuckP.x;
    testEntity.y = 50.5+monsterSuckP.y;
  }
  
  if(cracking != -1){
    if(cracking < 1000){
      cracking++;
    }
    if(random(100)<cracking){
      if(random(100)>cracking/8){
        particleEffect(testEntity.x-1,testEntity.y-1,2,2,4,color(255),color(255,150),.04);
      }
    }
    if(cracking < 250){
      if(random(100)<cracking/4){
        if(rays.size() < 200){
          rays.add(new PVector(random(1000), 0, random(TWO_PI)));
        }
      }
    } else if(rays.size() > 0){
      rays.clear();
    }
  }
  PVector tempRay;
  for(int i = 0; i < rays.size(); i++){
    tempRay = rays.get(i);
    
    float rayRSpeed = (tempRay.x%7)/7*(PI/25)-(PI/50);
    float rayCSpeed = (tempRay.x%17)/17+1;
    
    tempRay.y+=rayCSpeed;
    tempRay.z+=rayRSpeed;
  }
  
  if(fn % 3 == 0){
    if(deathFade >= 0 && deathFade < 255){
      deathFade++;
    } else {
      if(deathFade < -1){
        deathFade++;
      }
    }
    
    if(totalKeys > 0){
      for (int i = entities.size()-1; i >= 0; i--) {
        Entity tempE = (Entity) entities.get(i);
        if(tempE.ID==30){
          if(mDis(player.x,player.y,tempE.x,tempE.y)<gSize+2){
            particleEffect(tempE.x-.8,tempE.y-.8,1.6,1.6,2,color(255),color(255,150),.08);
          }
        } else if(tempE.EC.ID==airMonster.ID || tempE.EC.ID==deathMonster.ID){
          if(pointDistance(tempE.eV,player.eV)>gSize*.75){
            float tempDir = pointDir(player.eV,tempE.eV);
            tempE.x = player.x+gSize*.75*cos(tempDir);
            tempE.y = player.y+gSize*.75*sin(tempDir);
          }
        } else if(tempE.ID==31){
          tempE.eDir = pointDir(tempE.eV,player.eV);
        }
      }
      if(cracking == -1){
        if(mDis(player.x,player.y,testEntity.x,testEntity.y)<gSize+2){
          particleEffect(testEntity.x-.6,testEntity.y-.6,1.2,1.2,5,0,0,.1);
          if(monsterCaught == false){
            if(pointDistance(player.eV,testEntity.eV)<1){
              if(player.eHealth > -1){
                player.eHealth = -1;
                player.destroy();
                particleEffect(player.x-.5,player.y-.5,1,1,30,color(0,0,255),color(0,255,255),.1);
              }
            }
          }
        }
      }
    }
    
    if(totalKeys > 0 && testEntity.EC.AISearchMode == 11){
      tint+=.03; //red
      if(monsterCaught == false){
        if(random(100) < 1){
          if(random(100) < 80){
            flash = floor(random(35));
          } else {
            flash = 100+floor(random(35));
          }
        }
        
        if(playingRed == false){
          s17red.loop();
          playingRed = true;
        }
      
        if(totalKeys == 8){
          if(pointDistance(testEntity.eV,new PVector(50,50.5)) < 1){
            monsterCaught = true;
            s7daemonAll.drawWave = false;
            monsterSuckP = new PVector(testEntity.x-50,testEntity.y-50.5);
            testEntity.EC.HMax = 50;
            testEntity.eHealth = 50;
            testEntity.EC.HitCommand = "sound _x_ _y_ 19";
            s15music = minim.loadFile("sounds/music1.mp3");
            s15music.loop();
          }
        }
      }
      if(monsterCaught == true){
        if(playingRed){
          s17red.pause();
          playingRed = false;
        }
        if(cracking == -1){
          if(pointDistance(player.eV,new PVector(50,50.5)) < 1){
            monsterCaught = false;
            s7daemonAll.drawWave = true;
            testEntity.EC.HMax = -1;
            testEntity.EC.HitCommand = "";
            s15music.pause();
          }
        }
      }
      
    } else {
      tint-=.03; //blue
      if(monsterCaught == false){
        if(random(100) < .5){
          if(random(100) < 80){
            flash = 100+floor(random(25));
          } else {
            flash = floor(random(25));
          }
          if(totalKeys > 0){
            teleportMonster();
          }
        }
      }
      if(playingRed){
        s17red.pause();
        playingRed = false;
      }
    }
    tint = min(1,max(-1,tint));
    defineBlocksColor();
    
    if(flash != 100){
      flash--;
    }
    
  }
  if(totalKeys > 0){
    if(fn % 40 == 0){
      if(footprints.size() > 300){
        footprints.remove(0);
      }
    }
    if(fn % 80 == 0){
      footprints.add(new PVector(testEntity.x,testEntity.y,-1*(testEntity.eDir+2*PI)));
    }
    if(fn % 80 == 40){
      footprints.add(new PVector(testEntity.x,testEntity.y,1*(testEntity.eDir+2*PI)));
    }
    if(fn % 45 == 0){
      if(cracking == -1){
        sL.add(new Sound(testEntity.eV.x,testEntity.eV.y,s7daemonAll,0));
      }
    }
    
    if(fn % 250 == 0){
      if(testEntity.x < 0 || testEntity.y < 0 || testEntity.y > wSize || testEntity.y > wSize){
        testEntity.x = 50;
        testEntity.y = 50;
      }
    }
  }
  
  if(fn % 25 == 0){ //every second (the % means remainder, so if n is divisible by 25, do the following... since n goes up by 25 each second, it is divisible by 25 once each second)
    println(frameRate); //display the game FPS
    
    if(random(100) < 2){
      if(monsterCaught == false){
        sL.add(new Sound(player.x,player.y,s16random,0));
      }
    }
    
    if(totalKeys > 0 && cracking == -1){
      if(random(100) < 2*totalKeys){
        float tempLen = gSize*3/4+random(gSize);
        float tempDir = random(TWO_PI);
        int tempX = floor(player.x+tempLen*cos(tempDir));
        int tempY = floor(player.y+tempLen*sin(tempDir));
        if(rayCast(tempX,tempY,(int)player.x,(int)player.y)){
          if(gBIsSolid[aGS(wU,tempX,tempY)] == false){
            if(random(100) < 33){
              entities.add(new Entity(tempX,tempY,airMonster,pointDir(new PVector(tempX,tempY), player.eV)));
            } else if(random(100) < 50){
              entities.add(new Entity(tempX,tempY,deathMonster,pointDir(new PVector(tempX,tempY), player.eV)));
            } else {
              Entity tempEntity = new Entity(tempX,tempY,bulletEntity,pointDir(new PVector(tempX,tempY), player.eV));
              tempEntity.ID = 31;
              entities.add(tempEntity);
            }
          }
        }
      }
      
      for(int i = -2; i <= 2; i++){
        for(int j = -2; j <= 2; j++){
          if(aGS(wU,testEntity.x+i,testEntity.y+j) == 4){
            hitBlock(testEntity.x+i,testEntity.y+j,1);
            sL.add(new Sound(testEntity.x,testEntity.y,s5blockSolid,0));
          }
        }
      }
    }
  }
}

/*LOCK*/void safeUpdate(){ //called before anything has been drawn to the screen (update the world before it is drawn)
  centerView(player.x,player.y); //center the view on the player
  //PVector tempV2 = new PVector(mouseX,mouseY); tempV2 = screen2Pos(tempV2); centerView((player.x*5+tempV2.x)/6,(player.y*5+tempV2.y)/6); //center view on the player but pull toward the mouse slightly
  //PVector tempV2 = new PVector(maxAbs(0,float(mouseX-width/2)/50)+width/2,maxAbs(0,float(mouseY-height/2)/50)+height/2); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y); //move the view in the direction of the mouse
  //if(mousePressed){PVector tempV2 = new PVector(width/2+(pmouseX-mouseX),height/2+(pmouseY-mouseY)); tempV2 = screen2Pos(tempV2); centerView(tempV2.x,tempV2.y);} //drag the view around
}

void safePostUpdate(){
  PVector tempVec;
  PVector tempVec2;
  for(int i = 0; i < footprints.size(); i++){
    tempVec = (PVector)footprints.get(i);
    if(abs(tempVec.x-player.x) < gSize/2 && abs(tempVec.y-player.y) < gSize/2){
      //if(aGS(nmap,tempVec.x,tempVec.y) != 0){ //not working
      tempVec2 = pos2Screen(new PVector(tempVec.x,tempVec.y));
      pushMatrix();
      translate(tempVec2.x,tempVec2.y);
      rotate(abs(tempVec.z)+PI);
      if(tempVec.z<0){
        scale(1,-1);
      }
      image(footprint[floor(posMod(floor(tempVec2.x+tempVec2.y),10))],-15,-15,30,30);
      popMatrix();
      //}
    }
  }
  
  if(cracking > -1){
    testEntity.display();
  }
};

/*LOCK*/void safeDraw(){
  if(totalKeys > 0){
    if(pointDistance(player.eV,testEntity.eV) < 20){
      if(genTestPathExists((int)player.x,(int)player.y,(int)testEntity.x,(int)testEntity.y)){
        if(monsterCaught){
          fill(0,(20-pointDistance(player.eV,testEntity.eV))/20*128);
        } else {
          fill(0,(20-pointDistance(player.eV,testEntity.eV))/20*255);
        }
        noStroke();
        rect(0,0,width,height);
      }
    }
    
    PVector tempPos = pos2Screen(new PVector(testEntity.x,testEntity.y));
    if(monsterCaught == false){
      image(darkCloudImage,tempPos.x-300,tempPos.y-300);
    }
  }
  
  if(random(100)<70){
    if(flash > 100){
      if(playingFlash == false){
        s12flashBlack.play();
        playingFlash = true;
      }
      fill(0);
      noStroke();
      rect(0,0,width,height);
    } else if(flash > 0 && flash < 100) {
      if(playingFlash == false){
        s13flashWhite.play();
        playingFlash = true;
      }
      fill(tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+230]);
      noStroke();
      rect(0,0,width,height);
    }
  } else {
    if(playingFlash){
      s12flashBlack.pause();
      s13flashWhite.pause();
      playingFlash = false;
    }
  }
  
  PVector tempRay;
  for(int i = 0; i < rays.size(); i++){
    tempRay = rays.get(i);
    noStroke();
    
    float rayWidth = (tempRay.x%11)/11*(PI/20)+(PI/20);
    float rayAlpha = (tempRay.x%13)/13*155+100;
    float rayDir = tempRay.z;
    float rayLen = min(tempRay.y,pointDistance(testEntity.eV,player.eV)+gSize*.75);
    
    fill(255, rayAlpha);
    
    PVector tempVert1 = new PVector(testEntity.x,testEntity.y);
    PVector tempVert2 = new PVector(testEntity.x+rayLen*cos(rayDir),testEntity.y+rayLen*sin(rayDir));
    PVector tempVert3 = new PVector(testEntity.x+rayLen*cos(rayDir+rayWidth),testEntity.y+rayLen*sin(rayDir+rayWidth));
    
    tempVert1 = pos2Screen(tempVert1);
    tempVert2 = pos2Screen(tempVert2);
    tempVert3 = pos2Screen(tempVert3);
    
    triangle(tempVert1.x,tempVert1.y,tempVert2.x,tempVert2.y,tempVert3.x,tempVert3.y);
  }
  
} //called after everything else has been drawn on the screen (draw things on the game)
void safePostDraw(){
  if(deathFade >= 0){
    image(bloodImage,0,0,width,height);
    noStroke();
    fill(255,255-deathFade*15);
    rect(0,0,width,height);
    
    drawQuestion(255);
  } else if(deathFade < -1){
    noStroke();
    fill(255,-deathFade*15);
    rect(0,0,width,height);
  }
                            
  if(cracking > 150){
    noStroke();
    fill(255,(cracking-125)*5);
    rect(0,0,width,height);
  }
  
};
/*LOCK*/void safeKeyPressed(){} //called when a key is pressed
/*LOCK*/void safeKeyReleased(){} //called when a key is released
/*LOCK*/void safeMousePressed(){
  if(mouseButton == RIGHT){
    PVector tempV = screen2Pos(new PVector(mouseX,mouseY));
    player.fire(tempV);
  }
  //if(random(100)<20){
    //entities.add(new Entity(player.x,player.y,airMonster,0));
    
  //}
} //called when the mouse is pressed
void chatEvent(String source){};
void executeCommand(int index,String[] commands){
  switch(index){
    case 0:
      SoundConfig tempS = null;
      switch(int(commands[3])){
        case 1:
        tempS = s1airDie;
        break;
      case 2:
        tempS = s2airFire;
        break;
      case 3:
        tempS = s3airLive;
        break;
      case 4:
        tempS = s4blockSoft;
        break;
      case 5:
        tempS = s5blockSolid;
        break;
      case 6:
        tempS = s6bulletAll;
        break;
      case 7:
        tempS = s7daemonAll;
        break;
      case 19:
        tempS = s19daemonHit;
        break;
      case 20:
        tempS = s20daemonDie;
        cracking = 0;
        
        for(int i = entities.size()-1; i >= 0 ; i--){
          Entity tempEntity = (Entity) entities.get(i);
          if(tempEntity.ID != player.ID && tempEntity.ID != testEntity.ID &&  tempEntity.ID != 30){
            entities.remove(i);
          }
        }
        
        s12flashBlack.setGain(-35);
        s13flashWhite.setGain(-35);
        s14dead.setGain(-35);
        s15music.setGain(-35);
        s17red.setGain(-35);
        
        break;
      case 8:
        tempS = s8deathAll;
        break;
      case 9:
        tempS = s9doorClose;
        break;
      case 10:
        tempS = s10normdoorOpen;
        break;
      case 11:
        tempS = s11specialdoorOpen;
        if(totalKeys == 0){
          s15music.pause();
          if(HUDTfadeIn != 24){
            HUDText("Free the 8 cells", "Avoid the spirits of darkness", 58, 40, color(255), color(255), 24, 25, 12, 75);
          }
        }
        break;
      case 14:
        tempS = s7daemonAll;
        newQuestion("answer 1", "answer 0");
        deathFade = 0;
        s14dead.loop();
        break;
      }
      sL.add(new Sound(int(commands[1])+.5,int(commands[2])+.5,tempS,0));
      break;
    case 1:
      sL.add(new Sound(int(commands[1])+.5,int(commands[2])+.5,s18blockItem,0));
      keys[int(commands[3])-11] = true;
      totalKeys++;
      genReplace(int(commands[3]),33);
      HUDText(str(totalKeys)+" of 8 cells", "", 58, 40, color(255), color(255), 25, 25, 12, 75);
      if(totalKeys == 8){
        HUDText("All cells freed", "Lure the daemon", 58, 40, color(255), color(255), 25, 25, 12, 75);
      }
      genLine(46,2,53,2,0,3);
      genLine(46,98,53,98,0,3);
      if(totalKeys == 1){
        s15music.pause();
        s15music = minim.loadFile("sounds/music2.mp3");
        s15music.loop();
        
        testEntity = new Entity(95,95,new EConfig(),0);
        testEntity.EC.Genre = 1;
        testEntity.EC.Img = loadImage("dark.png");
        testEntity.EC.AISearchMode = 11;
        testEntity.EC.AITarget = -1;
        testEntity.EC.AITargetID = player.EC.ID;
        testEntity.EC.AIDoorBlock = 8;
        testEntity.EC.AIDoorBlockClose = 9;
        testEntity.AITargetPos = new PVector(wSize/2,wSize/2);
        testEntity.EC.SMax = .15;
        testEntity.EC.TSMax = .31;
        testEntity.EC.TAccel = .300;
        testEntity.EC.TDrag = 8;
        testEntity.EC.Type = 1;
        testEntity.EC.GoalDist = 0; //Want to get this close
        testEntity.EC.ActDist = -1;
        testEntity.EC.HMax = -1;
        testEntity.EC.DeathCommand = "sound _x_ _y_ 20";
        entities.add(testEntity);
      }
      if(totalKeys == 3){
        s15music.pause();
        s15music = minim.loadFile("sounds/music3.mp3");
        s15music.loop();
      }
      if(totalKeys == 5){
        s15music.pause();
        s15music = minim.loadFile("sounds/music4.mp3");
        s15music.loop();
      }
      if(totalKeys == 7){
        s15music.pause();
        s15music = minim.loadFile("sounds/music5.mp3");
        s15music.loop();
      }
      if(totalKeys == 8){
        s15music.pause();
      }
      Entity tempEntity2 = new Entity(int(commands[1])+.5,int(commands[2])+.5,whiteCell,random(TWO_PI));
      tempEntity2.AITargetPos = new PVector(50+1.5*cos(TWO_PI/8*totalKeys-TWO_PI/32)+random(.2)-.1, 50.5+1.5*sin(TWO_PI/8*totalKeys-TWO_PI/32)+random(.2)-.1);
      tempEntity2.ID = 30;
      entities.add(tempEntity2);
      break;
    case 2:
      switch(int(commands[1])){
        case 0:
          println("NEVER");
          break;
        case 1:
          player.eHealth = player.EC.HMax;
          entities.add(player);
          deathFade = -ceil(255/15);
          player.path.clear();
          player.path.add(new PVector(player.x,player.y));
          if(totalKeys > 0){
            if(pointDistance(player.eV,new PVector(96,96)) > pointDistance(player.eV,new PVector(3,4))){
              testEntity.x = 96;
              testEntity.y = 96;
            } else {
              testEntity.x = 3;
              testEntity.y = 4;
            }
          }
          for(int i = entities.size()-1; i >= 0 ; i--){
            Entity tempEntity = (Entity) entities.get(i);
            if(tempEntity.ID != player.ID && tempEntity.ID != testEntity.ID &&  tempEntity.ID != 30){
              entities.remove(i);
            }
          }
          s14dead.pause();
          sL.add(new Sound(player.x,player.y,s18blockItem,0));
          break;
      }
      break;
  }
}

/*LOCK*/void safeMouseClicked(){} //try not to use this, instead use if(mouseClicked){} in your code then set mouseClicked = false if you act upon the click
/*LOCK*/void safeKeyTyped(){} //may be added in the future
/*LOCK*/void safeMouseWheel(){} //may be added in the future
/*LOCK*/void safeMouseMoved(){} //may be added in the future
/*LOCK*/void safeMouseDragged(){} //may be added in the future



void defineBlocksColor(){
  int c;
  tintColor.loadPixels();
  c = 200; addGeneralBlock(0,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],false,0); //inside
  c = 100; addGeneralBlock(3,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],true,-1); //wall
  c = 170; addGeneralBlock(4,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],true,35); //door closed
  c = 200; addGeneralBlock(7,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],false,-1); //door open
  c = 130; addGeneralBlock(8,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],true,0); //door frame
  c = 130; addGeneralBlock(9,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],true,0); //door frame2
  c = 130; addGeneralBlock(30,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],true,0); //door frame (closet)
  c = 130; addGeneralBlock(31,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],true,0); //door frame2 (closet)
  c = 50; addGeneralBlock(10,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],true,2); //breakable block
  c = 0; addGeneralBlock(33,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],true,49); //breakable block core
  c = 255; addGeneralBlock(11,color(1*c,1*c,1*c),true,2); //key //49 for all
  c = 255; addGeneralBlock(12,color(1*c,1*c,1*c),true,2); //key
  c = 255; addGeneralBlock(13,color(1*c,1*c,1*c),true,2); //key
  c = 255; addGeneralBlock(14,color(1*c,1*c,1*c),true,2); //key
  c = 255; addGeneralBlock(15,color(1*c,1*c,1*c),true,2); //key
  c = 255; addGeneralBlock(16,color(1*c,1*c,1*c),true,2); //key
  c = 255; addGeneralBlock(17,color(1*c,1*c,1*c),true,2); //key
  c = 255; addGeneralBlock(18,color(1*c,1*c,1*c),true,2); //key
  c = 0; addGeneralBlock(255,tintColor.pixels[floor((tint+1)*99.5)*tintColor.width+c],false,-1); //shadow
  c = 255; addGeneralBlock(50,color(1*c,1*c,1*c),true,0); //help
}

void teleportMonster(){
  ArrayList<PVector> spotList = new ArrayList();
  for(int i = 0; i < wSize; i++){
    for(int j = 0; j < wSize; j++){
      if(wU[i][j] > 10 && wU[i][j] < 19){
        if(aGS(wU,i+1,j+1) == 0) {
          spotList.add(new PVector(i+1,j+1,pointDistance(new PVector(i,j), player.eV)));
        } else if(aGS(wU,i-1,j+1) == 0) {
          spotList.add(new PVector(i-1,j+1,pointDistance(new PVector(i,j), player.eV)));
        } else if(aGS(wU,i-1,j-1) == 0) {
          spotList.add(new PVector(i-1,j-1,pointDistance(new PVector(i,j), player.eV)));
        } else if(aGS(wU,i+1,j-1) == 0) {
          spotList.add(new PVector(i+1,j-1,pointDistance(new PVector(i,j), player.eV)));
        }
      }
    }
  }
  boolean working = true;
  PVector tempVec = new PVector(testEntity.x,testEntity.y);
  PVector tpPos = tempVec;
  while(working){
    if(spotList.size() > 0){
      int lowestID = 0;
      float lowestVal = wSize*2;
      for(int i = 0; i < spotList.size(); i++){
        tempVec = spotList.get(i);
        if(lowestVal > tempVec.z){
          lowestVal = tempVec.z;
          lowestID = i;
        }
      }
      tempVec = spotList.get(lowestID);
      spotList.remove(lowestID);
      if(!genTestPathExists(player.x,player.y,tempVec.x,tempVec.y)){
        tpPos = new PVector(tempVec.x,tempVec.y);
        working = false;
      }
    } else {
      tpPos = new PVector(tempVec.x,tempVec.y);
      working = false;
    }
  }
  if(pointDistance(tpPos,player.eV) < pointDistance(testEntity.eV,player.eV)){
    testEntity.x = tpPos.x+.5;
    testEntity.y = tpPos.y+.5;
  }
}

