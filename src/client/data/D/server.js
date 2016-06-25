"use strict";

var upload = 0;
var download = 0;
var outputText = [];
var outputTick = [];
var globalE;

var game = [ {} ];
game[0].setup = function(w) {
    var g = game[0];
    w.level = 0;
    w.dimension = w.id % 100;
    w.wing = Math.floor(w.id / 100 - 1) % 7;
    if (w.wing > -1) {
        w.level = 1;
    }
    w.hall = Math.floor((w.id - 100) / 700 - 1) % 14;
    w.room = -1;
    if (w.hall > -1) {
        w.room = Math.floor((w.id - 800) / 9800) % 100;
        w.level = 2;
    } else {
        w.hall = -1;
    }

    addGeneralBlock(w, 0, [ 100, 0, 0 ], false, 0); // background

    addGeneralBlock(w, 1, [ 255, 255, 190 ], true, -1); // bone1
    addGeneralBlock(w, 2, [ 255, 255, 170 ], true, -1); // bone2
    addGeneralBlock(w, 3, [ 255, 255, 210 ], true, -1); // bone3

    addGeneralBlock(w, 6, [ 230, 0, 0 ], true, 5); // rock1
    addGeneralBlock(w, 5, [ 200, 0, 0 ], true, 7); // rock2
    addGeneralBlock(w, 4, [ 260, 0, 0 ], true, 3); // rock3

    addGeneralBlock(w, 10, [ 0, 255, 0 ], true, 10); // question

    addGeneralBlock(w, 15, [ 100, 0, 0 ], false, 0); // broken

    addGeneralBlock(w, 18, [ 150, 250, 100 ], false, 0); // door
    addGeneralBlock(w, 19, [ 255, 150, 150 ], true, -1); // door frame

    addGeneralBlock(w, 20, [ 150, 50, 50 ], false, 0); // spawn area

    addGeneralBlock(w, 99, [ 0, 0, 0 ], false, 0); // darkness

    addGeneralBlock(w, 100, [ 0, 0, 250 ], false, 0); // game 0
    addGeneralBlock(w, 101, [ 0, 50, 200 ], false, 0); // game 1
    addGeneralBlock(w, 102, [ 0, 100, 150 ], false, 0); // game 2
    addGeneralBlock(w, 103, [ 0, 150, 100 ], false, 0); // game 3
    addGeneralBlock(w, 104, [ 0, 200, 50 ], false, 0); // game 4
    addGeneralBlock(w, 105, [ 0, 250, 0 ], false, 0); // game 5

    g.setupLobby(w);
    genRandomProb(w, 15, [ 4, 6, 15, 5, 10 ], [ 8, 4, 200, 1, 1 ]);

    w.props = [ 10, 1, 1, 0, 1 ];
    // aSS(w.wU,0,0,1);
};
game[0].exitRoom = function(player, w) {
    var g = game[0];
    var checkPoint = {
        "x" : 0,
        "y" : 0
    };
    var dimensionOffset = {
        "x" : 0,
        "y" : 0
    };
    var dimensionOffset2 = {
        "x" : 0,
        "y" : 0
    };
    if (w.level == 0) {
        var wing = posMod(Math.round(pointDir(50, 50, player.snap.v.x, player.snap.v.y) / (Math.PI * 2) * 8), 8);
        dimensionOffset.x = (63 - (wing % 2 * 10)) * Math.round(Math.cos(wing * (Math.PI / 4)));
        dimensionOffset.y = (63 - (wing % 2 * 10)) * Math.round(Math.sin(wing * (Math.PI / 4)));
        player.listJumps.push("s.v.x -= " + dimensionOffset.x + "; s.v.y -= " + dimensionOffset.y + "; goToWorldId(w," + g.getLobbyId(w.dimension, wing, -1, -1) + ",mob.src);");
    } else if (w.level == 1) {
        dimensionOffset.x = (63 - (w.wing % 2 * 10)) * Math.round(Math.cos(w.wing * (Math.PI / 4)));
        dimensionOffset.y = (63 - (w.wing % 2 * 10)) * Math.round(Math.sin(w.wing * (Math.PI / 4)));
        checkPoint.x = 50 - 1050 * Math.round(dimensionOffset.x / Math.abs(dimensionOffset.x + .01));
        checkPoint.y = 50 - 1050 * Math.round(dimensionOffset.y / Math.abs(dimensionOffset.y + .01));
        var hall;
        if (w.wing % 2 == 0) {
            hall = Math.round((pointDistance(checkPoint.x, checkPoint.y, player.snap.v.x, player.snap.v.y) - 1009) / 13 - 0.25);
        } else {
            hall = Math.round((pointDistance(checkPoint.x, checkPoint.y, player.snap.v.x, player.snap.v.y) - 1433) / 14.1667 - 0.25);
        }
        if (hall != -1) {
            var temp = Math.ceil(posMod(pointDir(checkPoint.x, checkPoint.y, player.snap.v.x, player.snap.v.y), (Math.PI * 2)) - (Math.PI / 4) * w.wing);
            if (temp > 2) {
                temp = 0;
            }
            hall = hall * 2 + temp;

            if (w.wing % 2 == 0) {
                dimensionOffset2.x = (Math.floor(hall / 2) - 3) * 13 * Math.cos(w.wing * (Math.PI / 4));
                dimensionOffset2.y = (Math.floor(hall / 2) - 3) * 13 * Math.sin(w.wing * (Math.PI / 4));
            } else {
                dimensionOffset2.x = (Math.floor(hall / 2) - 3) * 10 * Math.round(Math.cos(w.wing * (Math.PI / 4)));
                dimensionOffset2.y = (Math.floor(hall / 2) - 3) * 10 * Math.round(Math.sin(w.wing * (Math.PI / 4)));
            }
            player.listJumps.push("s.v.x -= " + dimensionOffset2.x + "; s.v.y -= " + dimensionOffset2.y + "; goToWorldId(w," + g.getLobbyId(w.dimension, w.wing, hall, 0) + ",mob.src);");
        } else {
            player.listJumps.push("s.v.x += " + dimensionOffset.x + "; s.v.y += " + dimensionOffset.y + "; goToWorldId(w," + g.getLobbyId(w.dimension, -1, -1, -1) + ",mob.src);");
        }
    } else if (w.level == 2) {
        var room;
        var hall = w.hall;
        if (pointDistance(50 - 8 * Math.cos((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1), 50 - 8 * Math.sin((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1), player.snap.v.x, player.snap.v.y) > 15) {
            room = w.room + 1;
            if (w.wing % 2 == 0) {
                player.listJumps.push("s.v.x += " + 24 * Math.cos((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1) + "; s.v.y += " + 24 * Math.sin((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1) + ";");
            } else {
                player.listJumps.push("s.v.x += " + 20 * Math.round(Math.cos((w.wing - 2) * (Math.PI / 4))) * (w.hall % 2 * 2 - 1) + "; s.v.y += " + 20 * Math.round(Math.sin((w.wing - 2) * (Math.PI / 4))) * (w.hall % 2 * 2 - 1) + ";");
            }
        } else if (w.room > 0) {
            room = w.room - 1;
            if (w.wing % 2 == 0) {
                player.listJumps.push("s.v.x -= " + 24 * Math.cos((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1) + "; s.v.y -= " + 24 * Math.sin((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1) + ";");
            } else {
                player.listJumps.push("s.v.x -= " + 20 * Math.round(Math.cos((w.wing - 2) * (Math.PI / 4))) * (w.hall % 2 * 2 - 1) + "; s.v.y -= " + 20 * Math.round(Math.sin((w.wing - 2) * (Math.PI / 4))) * (w.hall % 2 * 2 - 1) + ";");
            }
        } else {
            if (w.wing % 2 == 0) {
                dimensionOffset2.x = (Math.floor(w.hall / 2) - 3) * 13 * Math.cos(w.wing * (Math.PI / 4));
                dimensionOffset2.y = (Math.floor(w.hall / 2) - 3) * 13 * Math.sin(w.wing * (Math.PI / 4));
            } else {
                dimensionOffset2.x = (Math.floor(w.hall / 2) - 3) * 10 * Math.round(Math.cos(w.wing * (Math.PI / 4)));
                dimensionOffset2.y = (Math.floor(w.hall / 2) - 3) * 10 * Math.round(Math.sin(w.wing * (Math.PI / 4)));
            }
            player.listJumps.push("s.v.x += " + dimensionOffset2.x + "; s.v.y += " + dimensionOffset2.y + ";");
            hall = -1;
            room = -1;
        }
        player.listJumps.push("goToWorldId(w," + g.getLobbyId(w.dimension, w.wing, hall, room) + ",mob.src);");
    }
}
game[0].setupLobby = function(w) {
    if (w.level == 0) {
        genLoadMap(w, mapLobbyDimension[0]);
    } else if (w.level == 1) {
        genLoadMap(w, mapLobbyWing[w.wing % 2]);
        genRotateMap(w, Math.floor(w.wing / 2));
    } else if (w.level == 2) {
        genLoadMap(w, mapLobbyHall[w.wing % 2 + w.hall % 2 * 2]);
        genRotateMap(w, Math.floor(w.wing / 2));
    }
}
game[0].getLobbyId = function(dim, wing, hall, room) {
    if (wing > -1) {
        dim += wing * 100 + 100;
    }
    if (hall > -1) {
        dim += hall * 700 + 700 + room * 9800;
    }
    return dim;
}
game[0].update = function(w) {
    var g = game[0];
    w.entities.forEach(function(mob) {
        if (mob.type == "player") {
            if (mob.inNewBlock) {
                if (aGS(w.wU, mob.snap.v.x, mob.snap.v.y) == 99) {
                    g.exitRoom(mob, w);
                }
            }
        }
    });
};
exports.getData = function(w, data, src) {
    download += bits(data, 10);
    var dataItems = JSON.parse(data);
    dataItems.forEach(function(item) {
        if (item[0] == "MOVE") {

            item.forEach(function(input) {
                if (input != "MOVE") {
                    if (input[0] > src.playerE.recievedMovePacketId) {
                        // console.log(input[1]+1-1);
                        // console.log(input[2]+1-1);
                        src.playerE.listInput.push([ input[1], input[2], input[3], input[4] ]);
                    }
                }
            })
            src.playerE.recievedMovePacketId = item[1][0];
        } else if (item[0] == "NEWCONN") { // NEWCONN,world
            // console.log("NEW CONN");
            var e = w;
            if (src.userId == undefined) {
                output("New User!");
                src.userId = Math.floor(Math.random() * 10000);
                src.updates = "";
                src.worldID = item[1];
                e.users[src.userId] = src;

                var worldExists = false;
                e.worlds.forEach(function(world) {
                    if (world == src.worldID) {
                        worldExists = true;
                    }
                });
                if (!worldExists) {
                    new e.World(src.worldID);
                }

                e[src.worldID].users.push(src.userId);

                src.playerE = new Entity(e[src.worldID], 50, 50, "player", 0, 0, src);
                e[src.worldID].mobEnter(src.playerE);

                out("MOVED:0:" + src.playerE.snap.v.x + ":" + src.playerE.snap.v.y + ":" + src.playerE.snap.speed + ":" + src.playerE.snap.dir + ":" + src.playerE.snap.tSpeed + ":" + src.playerE.snap.stamina + ":" + src.playerE.snap.health + ":" + src.playerE.snap.hSteps + ":" + src.playerE.snap.fireCoolDown + ";", src, -1);
                out(outWorldProp(e[src.worldID]), src, -1);
                out(outWorld(e[src.worldID]), src, -1);
                out(outWorldMobs(e[src.worldID], src.playerE.id), src, -1);
                out("PID:" + src.playerE.id + ";", src, -1);
            }
        } else if (item[0] == "DISCONN") {
            var e = w;
            if (src.playerE != undefined) {

                out("MOB_DIE:" + src.playerE.id + ";", -1, e[src.worldID]);
                // delete src.playerE;

                // println("TESTED "+src.playerE.snap.bullets.length);
                e[src.worldID].mobExit(src.playerE);
                if (!(src.userId == undefined)) {
                    e[src.worldID].users.splice(e[src.worldID].users.indexOf(src.userId), 1);
                    delete e.users[src.userId];
                    // delete src.worldID;
                    // delete src.updates;
                    // delete src.userId;
                }
            }
        } else if (item[0] == "USER") {
            out("READY:", src, -1);
        } else {
            output("UNRECOGNIZED USER COMMAND!!! - " + item[0]);
        }
    });
}
exports.createEnv = function() {
    var e = new Env();
    e.fps = 25;
    e.run = (function() {
        var loops = 0;
        var skipTicks = 1000 / e.fps;
        var maxFrameSkip = 10;
        var nextGameTick = (new Date).getTime();
        return function() {
            loops = 0;
            while ((new Date).getTime() > nextGameTick && loops < maxFrameSkip) {
                e.update();
                nextGameTick += skipTicks;
                loops++;
            }
        };
    })();
    return e;
}
function Env() {
    var e = this;
    globalE = e;
    e.users = {};
    e.usernames = [];
    e.worlds = [];
    e.tick = 0;
    e.update = function() {
        e.tick++;
        e.worlds.forEach(function(w) {
            update(e[w]);
            if (e.tick % 3 == 0) {
                e[w].users.forEach(function(username) {
                    if (e.users[username].updates != "") {
                        e.users[username].emit("text", e.users[username].updates);
                        upload += bits(e.users[username].updates, 6);
                        e.users[username].updates = "";
                    }
                });
            }
            if (e.tick % 25 == 0) {
                if (e[w].lastActiveTick + 1500 < e.tick) {
                    e[w] = undefined;
                    e.worlds.splice(e.worlds.indexOf(w), 1);
                }
            }
        });
        if (e.tick % 25 == 0) {
            
            println(0,true);
            println("[SERVER CONSOLE]");
            println("Upload: "+Math.ceil(upload*0.001)+" kbps");upload = 0;
            println("Download: "+Math.ceil(download*0.001)+" kbps");download = 0;
            println("Users: "+Object.keys(e.users).length);
            println("Worlds: "+e.worlds.length);
            if(outputText.length > 0){
                println("");
                println("[SERVER OUTPUT]");
                outputText.forEach(function(text,i){
                	println(text);
                	if(e.tick > outputTick[i]){
                		outputText.splice(i,1);
                		outputTick.splice(i,1);
                	}
                });
            }
            
            /*
             * if(e[0] != undefined){ e[0].eU.forEach(function(wL,ln){ if(ln > 30 && ln < 70){ var thisL = ""; wL.forEach(function(wD,dn){ if(dn > 30 && dn < 70){ thisL += Math.min(wD.length,9)+" "; } }); println(thisL); } }); }
             */
        }
    };
    e.World = function(id) {
        var w = this;
        w.lastActiveTick = e.tick;
        w.id = id;
        e.worlds.push(id);
        e[id] = w;
        w.gb = {};
        w.parent = e;
        w.users = [];
        w.entityIdCounter = 0;
        w.wSize = 100;
        w.wU = [];
        w.eU = [];
        w.wUDamage = [];
        w.entities = [];
        // w.gb.isSolid = new Array(256).fill(-1);
        w.gb.isSolid = [];
        fillArray(w.gb.isSolid, 256, -1);
        w.gb.color = [];
        w.gb.strength = [];
        // w.gb.breakType = new Array(256).fill(0);
        w.gb.breakType = [];
        fillArray(w.gb.breakType, 256, 0);
        for (var i = 0; i < w.wSize; i++) {
            // w.wU[i] = new Array(w.wSize).fill(0);
            w.wU[i] = [];
            fillArray(w.wU[i], w.wSize, 0);
            // w.wUDamage[i] = new Array(w.wSize).fill(0);
            w.wUDamage[i] = [];
            fillArray(w.wUDamage[i], w.wSize, 0);
            w.eU[i] = []; // fillArray(w.eU[i],w.wSize,[]);
            for (var j = 0; j < w.wSize; j++) {
                w.eU[i][j] = [];
            }
        }
        e.World.prototype.mobEnter = function(mob) {
            w = this;
            w.entities.push(mob);
            addEntityToGridArea(w, mob.snap.v.x - mob.size * mob.hitboxScale / 2, mob.snap.v.y - mob.size * mob.hitboxScale / 2, mob.snap.v.x + mob.size * mob.hitboxScale / 2, mob.snap.v.y + mob.size * mob.hitboxScale / 2, mob);
        }
        e.World.prototype.mobExit = function(mob) {
            w = this;
            w.entities.splice(w.entities.indexOf(mob), 1);
            removeEntityFromGridArea(w, mob.pv.x - mob.size * mob.hitboxScale / 2, mob.pv.y - mob.size * mob.hitboxScale / 2, mob.pv.x + mob.size * mob.hitboxScale / 2, mob.pv.y + mob.size * mob.hitboxScale / 2, mob.id);
        }
        setup(w);
    }
}
var Entity = function(w, tX, tY, tType, tSpeed, tDir, tSrc) {
    checkArgs(arguments);
    var mob = this;

    mob.lastActiveTick = w.parent.tick;
    mob.id = w.entityIdCounter++; // unique mob id for this world
    mob.type = tType; // mob type - player, ...
    if (mob.type == "player") {
        mob.src = tSrc;
    }
    mob.changes = {}; // tracks major changes to mobs to properly output them
    // (likely to be removed)
    mob.changes.any = false; // any changes
    mob.changes.die = false; // die change
    mob.recievedMovePacketId = -1; // tracks the last move packet received from
    // the player
    mob.moves = 0; // tracks the number of moves sent to users

    mob.pv = {}; // previous position vector
    mob.pv.x = 50.1; // set previous x
    mob.pv.y = 50.1; // set previous y
    mob.inMotion = true; // is the entity currently in motion
    mob.inNewBlock = true; // is the entity currently in a new block

    mob.listInput = [];
    mob.listJumps = [];

    mob.bulletSpeed = .14;
    mob.drag = .008;
    mob.tAccel = .03;
    mob.accel = .04;
    mob.tSMax = .2;
    mob.sMax = .15;
    mob.tDrag = .016;
    mob.hitboxScale = 1;
    mob.staminaRate = 1;
    mob.fireDelay = 10;
    mob.size = 1;

    mob.hMax = 20;
    mob.hSteps = 100;

    mob.bull = {};
    mob.bull.col = [ 0, 0, 0 ];
    mob.bull.size = .1;

    mob.snap = new Snap(mob); // controls movement and position, NOT safe to
    // change x and y values of this (use listJumps)
}
Entity.prototype.changed = function(str) {
    this.changes.any = true;
    this.changes[str] = true;
}
Entity.prototype.update = function(w, mob) {
    if (mob.type == "player") {
        if (mob.listInput.length > 0 || mob.listJumps.length > 0) {
            if (mob.listJumps.length > 0) {
                var s = mob.snap;
                mob.listJumps.forEach(function(jump) {
                    eval(jump);
                })
                if (mob.src != undefined) {
                    w = w.parent[mob.src.worldID];
                }

                out(outMob(mob), mob.src, w);
                mob.listJumps = []; // may be improved with something like
                // array.clear although I wrote this code
                // without web access for reference..
            }
            if (mob.listInput.length > 0) {
                mob.listInput.forEach(function(input) {
                    mob.snap = mob.snap.simulate(w, 1, input);
                    out(outMob(mob), mob.src, w);
                })
                mob.listInput = []; // may be improved with something like
                // array.clear although I wrote this code
                // without web access for reference..
                mob.lastActiveTick = w.parent.tick;
                w.lastActiveTick = w.parent.tick;
            }
            var tempOut = "MOVED:" + mob.recievedMovePacketId + ":" + mob.snap.v.x + ":" + mob.snap.v.y + ":" + mob.snap.speed + ":" + mob.snap.dir + ":" + mob.snap.tSpeed + ":" + mob.snap.stamina + ":" + mob.snap.health + ":" + mob.snap.hSteps + ":" + mob.snap.fireCoolDown + ":";
            mob.snap.bullets.forEach(function(bull) {
                tempOut += bull.v.x + ":" + bull.v.y + ":" + bull.speed + ":" + bull.dir + ":";
            })
            out(tempOut.substring(0, tempOut.length - 1) + ";", mob.src, -1);
        }
        if (w.parent.tick % 25 == 0) {
            if (mob.lastActiveTick + 250 < w.parent.tick) {
                exports.getData(w.parent, "[[\"DISCONN\"]]", mob.src);
            }
        }
    }
    // if(mob.x)
    // mob.changed("move");
}
Entity.prototype.remove = function(w) {
    w.mobExit(this);
    this.changed("die");
}
function goToWorldId(w, worldID, src) {
    w.mobExit(src.playerE);
    w.users.splice(w.users.indexOf(src.userId), 1);
    src.worldID = worldID;

    if (src.playerE.snap.bullets.length > 0) {
        if (w.entities.length > 0) {
            src.playerE.snap.bullets.forEach(function(bull) {
                w.entities[0].snap.bullets.push(bull);
            });
        } else {
            var modSnap = src.playerE.snap;
            var limitLoops = 0;
            while (modSnap.bullets.length > 0 && limitLoops < 1000) {
                modSnap = modSnap.simulate(w, 1, [ 0, 0, 0, 0 ]);
                limitLoops++;
            }
        }
        src.playerE.snap.bullets = [];
    }

    var worldExists = false;
    w.parent.worlds.forEach(function(world) {
        if (world == worldID) {
            worldExists = true;
        }
    });
    if (!worldExists) {
        new w.parent.World(worldID);
    }

    w.parent[worldID].users.push(src.userId);
    w.parent[worldID].mobEnter(src.playerE);
    out("MOB_DIE:" + src.playerE.id + ";", src, w);
    out("RESET:0;", src, -1);
    out(outWorldProp(w.parent[worldID]), src, -1);
    out(outWorld(w.parent[worldID]), src, -1);
    out(outWorldMobs(w.parent[worldID], src.playerE.id), src, -1);
}
function addGeneralBlock(w, i, col, solid, hard) {
    checkArgs(arguments);
    w.gb.isSolid[i] = solid;
    w.gb.color[i] = col;
    w.gb.strength[i] = hard;
}
function hitMob(w, mob, pow, src, ind) {
    if (mob.hMax >= 0 || pow >= 999) {
        mob.snap.health -= pow;
        if (src != undefined) {
            out(outBullHitMob(src, ind, mob), -1, w);
        }
        mob.snap.health = Math.max(Math.min(mob.snap.health, mob.hMax), 0);
        if (mob.snap.health == 0) {
            // if(aGS1DS(gBBreakCommand,aGS(wU,x,y)) != null){
            // tryCommand(StringReplaceAll(StringReplaceAll(aGS1DS(gBBreakCommand,aGS(wU,x,y)),"_x_",str(int(x))),"_y_",str(int(y))),"");//aGS1DS(gBBreakCommand,wUP[i][j])
            // }

            // MOB DIES

            // aSS(w.wU,x,y,aGS1DB(w.gb.breakType,aGS(w.wU,x,y)));
            // var pe = particleEffect(15,5,[Math.floor(x)+.5,Math.floor(y)+.5],[1,1],[aGS1DB(w.gb.color,aGS(w.wU,x,y))],[-1,.1,.05],[-1,.02,.005],[0,1],[-1,20,30]);
            // syncToMobWrap(w,mob,pe,true);

            // particleEffect(x,y,1,1,15,tempC,aGS1DC(gBColor,aGS(wU,x,y)),.01);

        }
        out(outMob(mob), mob.src, w);
    }
}
function outBullHitMob(src, ind, mob) {
    return "BHITM:" + src.id + ":" + ind + ":" + mob.id + ";";
}
function hitBlock(w, x, y, pow,/* OPTIONAL */mob) {
    checkArgs(arguments);
    if (aGS1DB(w.gb.strength, aGS(w.wU, x, y)) >= 0 || pow >= 999) {
        aSS(w.wUDamage, x, y, aGS(w.wUDamage, x, y) + pow);
        if (aGS(w.wUDamage, x, y) > aGS1DB(w.gb.strength, aGS(w.wU, x, y))) {
            // if(aGS1DS(gBBreakCommand,aGS(wU,x,y)) != null){
            // tryCommand(StringReplaceAll(StringReplaceAll(aGS1DS(gBBreakCommand,aGS(wU,x,y)),"_x_",str(int(x))),"_y_",str(int(y))),"");//aGS1DS(gBBreakCommand,wUP[i][j])
            // }

            var pe = particleEffect(15, 5, [ Math.floor(x) + .5, Math.floor(y) + .5 ], [ 1, 1 ], [ aGS1DB(w.gb.color, aGS(w.wU, x, y)) ], [ -1, .1, .05 ], [ -1, .02, .005 ], [ 0, 1 ], [ -1, 20, 30 ]);
            syncToMobWrap(w, mob, pe, true);
            aSS(w.wU, x, y, aGS1DB(w.gb.breakType, aGS(w.wU, x, y)));
            // particleEffect(x,y,1,1,15,tempC,aGS1DC(gBColor,aGS(wU,x,y)),.01);

            aSS(w.wUDamage, x, y, 0);
        } else if (aGS(w.wUDamage, x, y) < 0) {
            aSS(w.wUDamage, x, y, 0);
        }
        syncToMobWrap(w, mob, outBlock(w, x, y), true);
    }
}
var Snap = function(mom) {
    var s = this;
    s.dad = mom;
    s.bullets = [];
    s.type = 0;
    s.v = {
        "x" : 50,
        "y" : 50
    };
    s.speed = 0;

    s.dir = 0;
    s.tSpeed = 0;
    s.stamina = 0;
    s.health = s.dad.hMax;
    s.hSteps = 0;
    s.fireCoolDown = 0;
    s.simulate = function(w, reps, input) {
        s.newS = new Snap(s.dad);
        s.newS.type = s.type;
        switch (s.type) {
            case 0:// player simulation
                s.bullets.forEach(function(bull, ind) {
                    s.newS.bullets[ind] = {
                        "v" : {
                            "x" : bull.v.x,
                            "y" : bull.v.y
                        },
                        "speed" : bull.speed,
                        "dir" : bull.dir,
                        "src" : [ bull.src[0], bull.src[1], bull.src[2] ]
                    };
                })
                s.newS.stamina = Math.min(s.stamina + 1, 110);
                s.newS.health = s.health;
                s.newS.hSteps = s.hSteps;
                s.newS.v.x = s.v.x;
                s.newS.v.y = s.v.y;
                // console.log(s.v.x);
                s.newS.speed = s.speed;
                s.newS.tSpeed = s.tSpeed;
                s.newS.dir = s.dir;
                s.newS.fireCoolDown = s.fireCoolDown;

                for (var i = 0; i < reps; i++) {

                    s.newS.bullets.forEach(function(bull, index) {
                        bull.v.x += bull.speed * Math.cos(bull.dir);
                        bull.v.y += bull.speed * Math.sin(bull.dir);
                        if (bull.v.x > w.wSize || bull.v.y > w.wSize || bull.v.x < 0 || bull.v.y < 0) {
                            s.newS.bullets.splice(index, 1);
                        } else if (w.gb.isSolid[aGS(w.wU, bull.v.x, bull.v.y)]) {
                            syncToMobWrap(w, s.dad, particleEffect(5, 5, [ bull.v.x, bull.v.y ], [ .2, .2 ], [ -1, aGS1DB(w.gb.color, aGS(w.wU, bull.v.x, bull.v.y)), s.dad.bull.col ], [ -1, .1, .05 ], [ -1, .02, .005 ], [ 0, 1 ], [ -1, 20, 30 ]), false);
                            hitBlock(w, bull.v.x, bull.v.y, 1, s.dad);
                            s.newS.bullets.splice(index, 1);
                        } else {
                            var hitMobs = mobsAt(w, bull.v.x, bull.v.y, bull.src[0].bull.size / 2);
                            hitMobs.forEach(function(mob) {
                                if (bull.src[1] == 0) { // bullet will not collide with player src[2]
                                    if (mob.id != bull.src[2]) {
                                        hitMob(w, mob, 1, s.newS.dad, index);
                                        s.newS.bullets.splice(index, 1);
                                    }
                                } else if (bull.src[1] == 1) { // bullet will collide with player src[2]
                                    if (mob.id == bull.src[2]) {
                                        hitMob(w, mob, 1, s.newS.dad, index);
                                        s.newS.bullets.splice(index, 1);
                                    }
                                } else if (bull.src[1] == 2) { // bullet will not collide with team src[2]
                                    if (mob.team != bull.src[2]) {
                                        hitMob(w, mob, 1, s.newS.dad, index);
                                        s.newS.bullets.splice(index, 1);
                                    }
                                } else if (bull.src[1] == 3) { // bullet will collide with team src[2]
                                    if (mob.team == bull.src[2]) {
                                        hitMob(w, mob, 1, s.newS.dad, index);
                                        s.newS.bullets.splice(index, 1);
                                    }
                                }
                            });
                        }
                    })
                    if (s.newS.health > 0) {
                        if (s.newS.fireCoolDown > 0) {
                            s.newS.fireCoolDown--;
                        }

                        if (input[0 + i * 5] == 1) {// if move input
                            if (s.tryStaminaAction(1)) {// if we have stamina
                                s.newS.speed += s.dad.accel;// accelerate
                            }
                        }
                        if (s.newS.hSteps < s.newS.dad.hSteps) {
                            s.newS.hSteps++;
                        } else if (s.newS.health < s.newS.dad.hMax && s.tryStaminaAction(5, 0)) {
                            s.newS.health++;
                            s.newS.hSteps = 0;
                        }

                        if (input[2 + i * 5] == 1 && s.newS.fireCoolDown <= 0) {// if
                            // fire
                            if (s.tryStaminaAction(5)) {// if we have stamina
                                s.newS.fireCoolDown += s.newS.dad.fireDelay;
                                s.newS.fire(s.newS, input[3 + i * 5]);
                            }
                        }

                        s.newS.speed = Math.min(Math.max(s.newS.speed - s.dad.drag, 0), s.dad.sMax);// apply
                        // drag
                        // and
                        // ensure
                        // speed
                        // is
                        // within
                        // limits

                        var aDif = angleDif(s.newS.dir, input[1 + i * 5]);
                        // console.log(aDif);
                        if (aDif != 0) {
                            var dirS = Math.round(aDif / Math.abs(aDif));

                            var innspeed = s.newS.tSpeed + s.dad.tAccel * dirS - s.dad.tDrag * dirS;
                            var num = Math.floor(innspeed / s.dad.tDrag * dirS);
                            var rotDis = (num + 1) * (innspeed - num / 2 * s.dad.tDrag * dirS);
                            if (Math.abs(rotDis) / Math.abs(aDif) < 1) {
                                s.newS.tSpeed += dirS * s.dad.tAccel;
                            }
                        }

                        if (Math.abs(s.newS.tSpeed) - s.dad.tDrag > 0) {
                            s.newS.tSpeed = (Math.abs(s.newS.tSpeed) - s.dad.tDrag) * (Math.abs(s.newS.tSpeed) / s.newS.tSpeed);
                        } else {
                            s.newS.tSpeed = 0;
                        }

                        s.newS.tSpeed = Math.min(s.dad.tSMax, Math.max(-s.dad.tSMax, s.newS.tSpeed));

                        s.newS.dir += s.newS.tSpeed * s.newS.speed / s.dad.sMax; // pTSpeed*pSpeed/pSMax
                        // if(aDif != 0){
                        // s.newS.dir = rotDis;
                        // }

                        // s.newS.dir =
                        // pointDir(s.newS.v.x,s.newS.v.y,input[1+i*3],input[2+i*3]);

                        moveInWorld(w, s.newS.v, s.newS.speed * Math.cos(s.newS.dir), s.newS.speed * Math.sin(s.newS.dir), s.dad.size * s.dad.hitboxScale / 2, s.dad.size * s.dad.hitboxScale / 2);
                    }
                }
                break;
        }
        return s.newS;
    }
    s.tryStaminaAction = function(cost, nCost) {
        var negCost = 1;
        if (nCost != undefined) {
            negCost = nCost;
        }
        cost = cost * s.dad.staminaRate;
        if (s.newS.stamina > cost) {
            s.newS.stamina -= cost;
            return true;
        } else {
            s.newS.stamina = Math.max(0, s.newS.stamina - cost / 5 * negCost);
            return false;
        }
    }
    s.fire = function(newS, tDir) {
        newS.bullets.push({
            "v" : {
                "x" : newS.v.x,
                "y" : newS.v.y
            },
            "speed" : newS.dad.bulletSpeed,
            "dir" : tDir,
            "src" : [ s.dad, 0, s.dad.id ]
        });
    }
}
function moveInWorld(w, tV, xSpeed, ySpeed, width, height) {
    if (xSpeed > 0) {
        if (aGS1DB(w.gb.isSolid, aGS(w.wU, tV.x + width / 2 + xSpeed, tV.y + height / 2)) || aGS1DB(w.gb.isSolid, aGS(w.wU, tV.x + width / 2 + xSpeed, tV.y - height / 2))) {
            xSpeed = 0;
            tV.x = Math.floor(tV.x + width / 2 + xSpeed) + .999 - width / 2;
        }
    } else if (xSpeed < 0) {
        if (aGS1DB(w.gb.isSolid, aGS(w.wU, tV.x - width / 2 + xSpeed, tV.y + height / 2)) || aGS1DB(w.gb.isSolid, aGS(w.wU, tV.x - width / 2 + xSpeed, tV.y - height / 2))) {
            xSpeed = 0;
            tV.x = Math.floor(tV.x - width / 2 + xSpeed) + width / 2;
        }
    }
    tV.x += xSpeed;

    if (ySpeed > 0) {
        if (aGS1DB(w.gb.isSolid, aGS(w.wU, tV.x + width / 2, tV.y + height / 2 + ySpeed)) || aGS1DB(w.gb.isSolid, aGS(w.wU, tV.x - width / 2, tV.y + height / 2 + ySpeed))) {
            ySpeed = 0;
            tV.y = Math.floor(tV.y + height / 2 + ySpeed) + .999 - height / 2;
        }
    } else if (ySpeed < 0) {
        if (aGS1DB(w.gb.isSolid, aGS(w.wU, tV.x + width / 2, tV.y - height / 2 + ySpeed)) || aGS1DB(w.gb.isSolid, aGS(w.wU, tV.x - width / 2, tV.y - height / 2 + ySpeed))) {
            ySpeed = 0;
            tV.y = Math.floor(tV.y - height / 2 + ySpeed) + height / 2;
        }
    }
    tV.y += ySpeed;
}
function particleEffect(num, emittime, pos, area, cols, sizes, speeds, shapes, lifespans) {
    var updates = "PEFFECT:" + num + ":" + emittime + ":" + pos[0] + ":" + pos[1] + ":" + area[0] + ":" + area[1] + ":";
    cols.forEach(function(col) {
        if (col != -1) {
            updates += col[0] + "," + col[1] + "," + col[2] + ",";
        } else {
            updates += "-1,-1,-1,";
        }
    });
    updates = updates.substring(0, updates.length - 1) + ":";
    sizes.forEach(function(size) {
        updates += size + ",";
    });
    updates = updates.substring(0, updates.length - 1) + ":";
    speeds.forEach(function(speed) {
        updates += speed + ",";
    });
    updates = updates.substring(0, updates.length - 1) + ":";
    shapes.forEach(function(shape) {
        updates += shape + ",";
    });
    updates = updates.substring(0, updates.length - 1) + ":";
    lifespans.forEach(function(lifespan) {
        updates += lifespan + ",";
    });
    updates = updates.substring(0, updates.length - 1) + ";";
    // println(updates);
    return updates;
}
function outWorld(w) {
    checkArgs(arguments);
    var updates = "WORLD:" + w.wSize + ":" + w.wSize + ":";
    w.wU.forEach(function(i, indI) {
        i.forEach(function(j, indJ) {
            updates += j + ":";
            if (w.wUDamage[indI][indJ] != 0) {
                updates += (-w.wUDamage[indI][indJ]) + ":";
            }
        })
    })
    return updates.substring(0, updates.length - 1) + ";";
}
function fillArray(ar, len, val) {
    for (var i = 0; i < len; i++) {
        ar[i] = val;
    }
}
function outWorldProp(w) {
    checkArgs(arguments);
    var updates = "PROPS:";
    for (var i = 0; i < w.props.length; i++) {
        updates += i + "=" + w.props[i] + ":";
    }
    updates = updates.substring(0, updates.length - 1) + ";" + "GB:";
    for (var i = 0; i < 255; i++) {
        if (w.gb.isSolid[i] != -1) {
            updates += i + ":" + w.gb.isSolid[i] + ":" + w.gb.color[i][0] + ":" + w.gb.color[i][1] + ":" + w.gb.color[i][2] + ":" + w.gb.strength[i] + ":";
        }
    }
    return updates.substring(0, updates.length - 1) + ";";
}
function outWorldMobs(w, notId) {
    var updates = "";
    w.entities.forEach(function(mob) {
        if (mob.id != notId) {
            updates += outMob(mob);
        }
    });
    return updates;
}
function syncToMob(mob, str) {
    // println("MOBSYNC:"+mob.id+":"+mob.recievedMovePacketId+":" + str.replace(/:/g,"%%%"));
    return "MOBSYNC:" + mob.id + ":" + mob.recievedMovePacketId + ":" + str.replace(/:/g, "%%%");
}
function syncToMobWrap(w, mob, str, toSource) {
    if (mob == undefined) {
        out(str, -1, w);
    } else {
        if (mob.src == undefined) {
            out(syncToMob(mob, str), -1, w);
        } else {
            out(syncToMob(mob, str), mob.src, w);
            if (toSource) {
                out(str, mob.src, -1);
            }
        }
    }
}
function outMob(mob) {
    var tempOut = "MOB:" + mob.id + ":" + (mob.moves++) + ":" + mob.snap.v.x + ":" + mob.snap.v.y + ":" + mob.snap.dir + ":" + mob.snap.health + ":";
    mob.snap.bullets.forEach(function(bull) {
        tempOut += bull.v.x + ":" + bull.v.y + ":";
    })
    return tempOut.substring(0, tempOut.length - 1) + ";";
}
function outBlock(w, x, y) {
    return "BLOCK:" + Math.floor(x) + ":" + Math.floor(y) + ":" + aGS(w.wU, x, y) + ":" + aGS(w.wUDamage, x, y) + ";";
}
function out(text, des, w) {
    if (w == -1) {
        des.updates += text;
    } else if (des == -1) {
        w.users.forEach(function(username) {
            w.parent.users[username].updates += text;
        });
    } else {
        w.users.forEach(function(username) {
            if (w.parent.users[username] != des) {
                w.parent.users[username].updates += text;
            }
        });
    }
}
function setup(w) {
    game[0].setup(w);
}
function update(w) {
    w.entities.forEach(function(mob) {
        mob.pv.x = mob.snap.v.x;
        mob.pv.y = mob.snap.v.y;
        mob.update(w, mob);
        if (mob.pv.x != mob.snap.v.x || mob.pv.y != mob.snap.v.y) {
            mob.inMotion = true;
            if (Math.floor(mob.snap.v.x - mob.size * mob.hitboxScale / 2) != Math.floor(mob.pv.x - mob.size * mob.hitboxScale / 2) || Math.floor(mob.snap.v.x + mob.size * mob.hitboxScale / 2) != Math.floor(mob.pv.x + mob.size * mob.hitboxScale / 2) || Math.floor(mob.snap.v.y - mob.size * mob.hitboxScale / 2) != Math.floor(mob.pv.y - mob.size * mob.hitboxScale / 2) || Math.floor(mob.snap.v.y + mob.size * mob.hitboxScale / 2) != Math.floor(mob.pv.y + mob.size * mob.hitboxScale / 2)) {
                mob.inNewBlock = true;
                removeEntityFromGridArea(w, mob.pv.x - mob.size * mob.hitboxScale / 2, mob.pv.y - mob.size * mob.hitboxScale / 2, mob.pv.x + mob.size * mob.hitboxScale / 2, mob.pv.y + mob.size * mob.hitboxScale / 2, mob.id);
                addEntityToGridArea(w, mob.snap.v.x - mob.size * mob.hitboxScale / 2, mob.snap.v.y - mob.size * mob.hitboxScale / 2, mob.snap.v.x + mob.size * mob.hitboxScale / 2, mob.snap.v.y + mob.size * mob.hitboxScale / 2, mob);
            } else {
                mob.inNewBlock = false;
            }
        } else {
            mob.inMotion = false;
            mob.inNewBlock = false;
        }

        if (mob.changes.any) {
            mob.changes.any = false;
            if (mob.changes.die) {
                mob.changes.die = false;
                out("MOB_DIE:" + mob.id + ";", -1, w);
            }
        }
    });
    game[0].update(w);
}
function checkThat(expression, message) {
    if (!expression) {
        throw new Error(message);
    }
}
function checkArgs(args) {
    // checkThat(args.length === args.callee.length,"Wrong arg # for
    // "+args.callee.name);
}
function aSS(tMat, tA, tB, tValue) { // array set safe
    tMat[Math.max(0, Math.min(tMat.length - 1, Math.floor(tA)))][Math.max(0, Math.min(tMat[0].length - 1, Math.floor(tB)))] = tValue;
}
function aGS(tMat, tA, tB) { // array get safe
    try {
        return tMat[Math.max(0, Math.min(tMat.length - 1, Math.floor(tA)))][Math.max(0, Math.min(tMat[0].length - 1, Math.floor(tB)))];
    } catch (ex) {
        // println(ex.stack);
    }
}
function aGS1DB(tMat, tA) { // array get safe
    return tMat[Math.max(0, Math.min(tMat.length - 1, Math.floor(tA)))];
}
function pointDistance(v1x, v1y, v2x, v2y) {
    return Math.sqrt(Math.pow(v1x - v2x, 2) + Math.pow(v1y - v2y, 2));
}
function angleDif(tA, tB) {
    tA = posMod(tA, Math.PI * 2);
    tB = posMod(tB, Math.PI * 2);
    if (tA < tB - Math.PI) {
        tA += Math.PI * 2;
    }
    if (tB < tA - Math.PI) {
        tB += Math.PI * 2;
    }
    return tB - tA;
}
function posMod(tA, tB) {
    var myReturn = tA % tB;
    if (myReturn < 0) {
        myReturn += tB;
    }
    return myReturn;
}
function pointDir(v1x, v1y, v2x, v2y) {
    if ((v2x - v1x) != 0) {
        var tDir = Math.atan((v2y - v1y) / (v2x - v1x));
        if (v1x - v2x > 0) {
            tDir -= Math.PI;
        }
        return tDir;
    } else {
        if ((v2y - v1y) != 0) {
            if (v2y > v1y) {
                return Math.PI / 2;
            } else {
                return Math.PI / 2 * 3;
            }
        } else {
            return Math.random() * 2 * Math.PI;
        }
    }
}
// *************** GEN ***************
function genRect(w, x, y, wi, h, b) {
    checkArgs(arguments);
    wi = Math.round(wi);
    h = Math.round(h);
    x = Math.round(x);
    y = Math.round(y);
    for (var i = 0; i < wi; i++) {
        for (var j = 0; j < h; j++) {
            aSS(w.wU, x + i, y + j, b);
        }
    }
}
function genBox(w, x, y, wi, h, weight, b) {
    checkArgs(arguments);
    genLine(w, x, y, x + wi - 1, y, weight, b);
    genLine(w, x, y, x, y + h - 1, weight, b);
    genLine(w, x, y + h - 1, x + wi - 1, y + h - 1, weight, b);
    genLine(w, x + wi - 1, y, x + wi - 1, y + h - 1, weight, b);
}
function genLine(w, x1, y1, x2, y2, weight, b) {
    checkArgs(arguments);
    var itt = Math.ceil(10 * pointDistance(x1, y1, x2, y2));
    var rise = (y2 - y1) / itt;
    var run = (x2 - x1) / itt;
    var xOff = 0;
    var yOff = 0;
    for (var i = 0; i < itt - 1; i += 1) {
        for (var j = 0; j <= weight * 10; j += 2) {
            xOff = (j - weight * 5) * rise;
            yOff = (j - weight * 5) * -run;
            aSS(w.wU, Math.floor(x1 + xOff + i * run), Math.floor(y1 + yOff + i * rise), b);
        }
    }
    aSS(w.wU, Math.floor(x1), Math.floor(y1), b);
    aSS(w.wU, Math.floor(x2), Math.floor(y2), b);
}
function genRing(w, x, y, wi, h, weight, b) {
    checkArgs(arguments);
    genArc(w, 0, Math.PI * 2, x, y, wi, h, weight, b);
}
function genArc(w, rStart, rEnd, x, y, wi, h, weight, b) {
    checkArgs(arguments);
    if (rStart > rEnd) {
        var rTemp = rStart;
        rStart = rEnd;
        rEnd = rTemp;
    }
    var dR = rEnd - rStart;
    var c = dR / Math.floor(dR * Math.max(wi, h) * 10); // dR is range ->
    // range/(circumfrence of
    // arc(radians *
    // 2*max_radius *5 ->
    // 20*radius -> 20 points
    // per block)) -> gives
    // increment value
    var r;
    for (var i = rStart; i < rEnd; i += c) {
        r = (wi * h / 2) / Math.sqrt(Math.pow(wi * Math.cos(i), 2) + Math.pow(h * Math.sin(i), 2)) - weight / 2;
        for (var j = 0; j <= weight; j += .2) {
            aSS(w.wU, Math.round(x + (r + j) * Math.cos(i)), Math.round(y + (r + j) * Math.sin(i)), b);
        }
    }
}
function genCircle(w, x, y, r, b) {
    checkArgs(arguments);
    for (var i = 0; i < w.wSize; i++) {
        for (var j = 0; j < w.wSize; j++) {
            if (pointDistance(i, j, x, y) < r) {
                w.wU[i][j] = b;
            }
        }
    }
}
function genRoundRect(w, x, y, wi, h, rounding, b) {
    checkArgs(arguments);
    x = Math.round(x);
    y = Math.round(y);
    wi = Math.round(wi);
    h = Math.round(h);
    rounding = Math.round(rounding);
    genRect(w, x + rounding, y, wi - rounding * 2, h, b);
    genRect(w, x, y + rounding, wi, h - rounding * 2, b);
    genCircle(w, x + rounding, y + rounding, rounding, b);
    genCircle(w, x + wi - rounding, y + rounding, rounding, b);
    genCircle(w, x + rounding, y + h - rounding, rounding, b);
    genCircle(w, x + wi - rounding, y + h - rounding, rounding, b);
}
function genRandomProb(w, from, to, prob) {
    checkArgs(arguments);
    var totProb = 0;
    var tRand;
    var k;
    for (var i = 0; i < prob.length; i++) {
        totProb += prob[i];
    }
    for (var i = 0; i < w.wSize; i++) {
        for (var j = 0; j < w.wSize; j++) {
            if (w.wU[i][j] == from) {
                tRand = Math.random() * totProb;
                k = 0;
                while (tRand > 0) {
                    tRand -= prob[k];
                    k++;
                }
                w.wU[i][j] = to[k - 1];
            }
        }
    }
}
function genFlood(w, x, y, b) {
    checkArgs(arguments);
    if (x >= 0 && y >= 0 && x < w.wSize && y < w.wSize) {
        var tB = aGS(w.wU, x, y);
        if (tB != b) {
            aSS(w.wU, x, y, b);
            if (aGS(w.wU, x + 1, y) == tB) {
                genFlood(w, x + 1, y, b);
            }
            if (aGS(w.wU, x - 1, y) == tB) {
                genFlood(w, x - 1, y, b);
            }
            if (aGS(w.wU, x, y + 1) == tB) {
                genFlood(w, x, y + 1, b);
            }
            if (aGS(w.wU, x, y - 1) == tB) {
                genFlood(w, x, y - 1, b);
            }
        }
    }
}
function genReplace(w, from, to) {
    checkArgs(arguments);
    for (var i = 0; i < w.wSize; i++) {
        for (var j = 0; j < w.wSize; j++) {
            if (w.wU[i][j] == from) {
                w.wU[i][j] = to;
            }
        }
    }
}
function genTestPathExists(w, x1, y1, x2, y2) {
    checkArgs(arguments);
    var nmap = [];
    for (var i = 0; i < w.wSize; i++) {
        nmap[i] = [];
        fillArray(nmap[i], w.wSize, 0);
    }
    return genTestPathExistsLoop(w, nmap, Math.floor(x1), Math.floor(y1), Math.floor(x2), Math.floor(y2));
}
function genTestPathExistsLoop(w, nmap, x, y, x2, y2) {
    checkArgs(arguments);
    if (x >= 0 && y >= 0 && x < w.wSize && y < w.wSize) {
        if (aGS(nmap, x, y) === 0) {
            if (Math.abs(x - x2) + Math.abs(y - y2) <= 1) {
                return true;
            }
            aSS(nmap, x, y, 1);
            var bools = false;
            if (aGS1DB(w.gb.isSolid, aGS(w.wU, x + 1, y)) === false) {
                if (genTestPathExistsLoop(w, nmap, x + 1, y, x2, y2)) {
                    bools = true;
                }
            }
            if (aGS1DB(w.gb.isSolid, aGS(w.wU, x - 1, y)) === false) {
                if (genTestPathExistsLoop(w, nmap, x - 1, y, x2, y2)) {
                    bools = true;
                }
            }
            if (aGS1DB(w.gb.isSolid, aGS(w.wU, x, y + 1)) === false) {
                if (genTestPathExistsLoop(w, nmap, x, y + 1, x2, y2)) {
                    bools = true;
                }
            }
            if (aGS1DB(w.gb.isSolid, aGS(w.wU, x, y - 1)) === false) {
                if (genTestPathExistsLoop(w, nmap, x, y - 1, x2, y2)) {
                    bools = true;
                }
            }
            return bools;
        }
    }
    return false;
}
function genLoadMap(w, thisMap) {
    checkArgs(arguments);
    var pointer = 0;
    try {
        thisMap.forEach(function(line) {
            for (var i = 0; i < line[1]; i++) {
                aSS(w.wU, pointer % w.wSize, Math.floor(pointer / w.wSize), line[0]);
                pointer++;
            }
        });
    } catch (ex) {
        println(ex.stack);
    }
    return true;
}

function genRotateMap(w, deg) {
    if (deg >= 1 && deg <= 3) {
        var tempWU = [];
        for (var i = 0; i < w.wSize; i++) {
            tempWU[i] = [];
        }
        if (deg == 1) {
            for (var i = 0; i < w.wSize; i++) {
                for (var j = 0; j < w.wSize; j++) {
                    tempWU[w.wSize - 1 - j][i] = w.wU[i][j];
                }
            }
        } else if (deg == 2) {
            for (var i = 0; i < w.wSize; i++) {
                for (var j = 0; j < w.wSize; j++) {
                    tempWU[w.wSize - 1 - i][w.wSize - 1 - j] = w.wU[i][j];
                }
            }
        } else if (deg == 3) {
            for (var i = 0; i < w.wSize; i++) {
                for (var j = 0; j < w.wSize; j++) {
                    tempWU[j][w.wSize - 1 - i] = w.wU[i][j];
                }
            }
        }
        for (var i = 0; i < w.wSize; i++) {
            for (var j = 0; j < w.wSize; j++) {
                w.wU[i][j] = tempWU[i][j];
            }
        }
    }
}

function bits(str, packs) {
    return (str.length + packs) * 8;
}

function println(str, clear) {
    try {
        if (clear == true) {
            for (var i = 0; i < 70; i++) {
                console.log("");
            }
        } else {
            console.log(str);
        }
    } catch (ex) {
        // java output methods
    }
}
function output(str, ticks) {
    outputText.push(str);
    if (ticks == undefined) {
        outputTick.push(globalE.tick + 500);
    } else {
        outputTick.push(globalE.tick + ticks);
    }
}

function removeEntityFromGridPos(eL, id) {
    eL.forEach(function(mob, ind) {
        if (mob.id == id) {
            eL.splice(ind, 1);
        }
    });
}

function addEntityToGridPos(eL, mob) {
    var notFoundSelf = true;
    eL.forEach(function(tMob) {
        if (tMob.id == mob.id) {
            notFoundSelf = false;
        }
    });
    if (notFoundSelf) {
        eL.push(mob);
    }
}

function removeEntityFromGridArea(w, x1, y1, x2, y2, id) {
    x2 = Math.min(Math.max(Math.floor(x2), 0), w.wSize - 1);
    y2 = Math.min(Math.max(Math.floor(y2), 0), w.wSize - 1);
    for (var i = Math.min(Math.max(Math.floor(x1), 0), w.wSize - 1); i <= x2; i++) {
        for (var j = Math.min(Math.max(Math.floor(y1), 0), w.wSize - 1); j <= y2; j++) {
            removeEntityFromGridPos(aGS(w.eU, i, j), id);
        }
    }
}

function addEntityToGridArea(w, x1, y1, x2, y2, mob) {
    x2 = Math.min(Math.max(Math.floor(x2), 0), w.wSize - 1);
    y2 = Math.min(Math.max(Math.floor(y2), 0), w.wSize - 1);
    for (var i = Math.min(Math.max(Math.floor(x1), 0), w.wSize - 1); i <= x2; i++) {
        for (var j = Math.min(Math.max(Math.floor(y1), 0), w.wSize - 1); j <= y2; j++) {
            addEntityToGridPos(aGS(w.eU, i, j), mob);
        }
    }
}

function getEntitiesFromGridAreaOther(w, x1, y1, x2, y2, id) {
    var myReturn = [];
    var tempAL;
    x2 = Math.min(Math.max(Math.floor(x2), 0), w.wSize - 1);
    y2 = Math.min(Math.max(Math.floor(y2), 0), w.wSize - 1);
    for (var i = Math.min(Math.max(Math.floor(x1), 0), w.wSize - 1); i <= x2; i++) {
        for (var j = Math.min(Math.max(Math.floor(y1), 0), w.wSize - 1); j <= y2; j++) {
            tempAL = aGS(w.eU, i, j);
            tempAL.forEach(function(mob) {
                if (mob.id != id) {
                    if (w.entities.indexOf(mob) != -1) {
                        addUniqueEntityAL(myReturn, mob);
                    } else {
                        removeEntityFromGridPos(tempAL, mob.id);
                    }
                }
            });
        }
    }
    return myReturn;
}

function addUniqueEntityAL(eL, mob) {
    eL.forEach(function(tMob) {
        if (tMob.id == mob.id) {
            return;
        }
    });
    eL.push(mob);
}

function mobsAt(w, x, y, r,/* optional */exceptid) {
    var posMobL = getEntitiesFromGridAreaOther(w, x - r, y - r, x + r, y + r, exceptid);
    var hitMobL = [];
    posMobL.forEach(function(mob) {
        if (mob.snap.health > 0) {
            if (pointDistance(x, y, mob.snap.v.x, mob.snap.v.y) <= r + mob.size * mob.hitboxScale / 2) {
                hitMobL.push(mob);
            }
        }
    });
    return hitMobL;
}

var mapLobbyDimension = [];
var mapLobbyHall = [];
var mapLobbyWing = [];

mapLobbyDimension[0] = [ [ 99, 3543 ], [ 1, 4 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 4 ], [ 99, 85 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 83 ], [ 19, 1 ], [ 15, 5 ], [ 0, 6 ], [ 15, 5 ], [ 19, 1 ], [ 99, 81 ], [ 18, 1 ], [ 0, 2 ], [ 15, 4 ], [ 0, 6 ], [ 15, 4 ], [ 0, 2 ], [ 18, 1 ], [ 99, 79 ], [ 18, 1 ], [ 0, 3 ], [ 15, 5 ], [ 0, 4 ], [ 15, 5 ], [ 0, 3 ], [ 18, 1 ], [ 99, 77 ], [ 18, 1 ], [ 0, 5 ], [ 15, 4 ], [ 0, 4 ], [ 15, 4 ], [ 0, 5 ], [ 18, 1 ], [ 99, 75 ], [ 19, 1 ], [ 0, 7 ], [ 15, 3 ], [ 0, 4 ], [ 15, 3 ], [ 0, 7 ], [ 19, 1 ], [ 99, 73 ], [ 1, 1 ], [ 15, 1 ], [ 0, 7 ], [ 15, 3 ], [ 0, 4 ], [ 15, 3 ], [ 0, 7 ], [ 15, 1 ], [ 1, 1 ], [ 99, 71 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 1 ], [ 0, 6 ], [ 15, 1 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 70 ], [ 1, 1 ], [ 15, 5 ], [ 0, 18 ], [ 15, 5 ], [ 1, 1 ], [ 99, 70 ], [ 1, 1 ], [ 15, 7 ], [ 0, 6 ], [ 15, 2 ], [ 0, 6 ], [ 15, 7 ], [ 1, 1 ], [ 99, 70 ], [ 1, 1 ], [ 15, 8 ], [ 0, 3 ], [ 15, 6 ], [ 0, 3 ],
        [ 15, 8 ], [ 1, 1 ], [ 99, 70 ], [ 19, 1 ], [ 0, 3 ], [ 15, 4 ], [ 0, 3 ], [ 15, 2 ], [ 20, 4 ], [ 15, 2 ], [ 0, 3 ], [ 15, 4 ], [ 0, 3 ], [ 19, 1 ], [ 99, 70 ], [ 18, 1 ], [ 0, 10 ], [ 15, 1 ], [ 20, 6 ], [ 15, 1 ], [ 0, 10 ], [ 18, 1 ], [ 99, 70 ], [ 18, 1 ], [ 0, 9 ], [ 15, 2 ], [ 20, 6 ], [ 15, 2 ], [ 0, 9 ], [ 18, 1 ], [ 99, 70 ], [ 18, 1 ], [ 0, 9 ], [ 15, 2 ], [ 20, 6 ], [ 15, 2 ], [ 0, 9 ], [ 18, 1 ], [ 99, 70 ], [ 18, 1 ], [ 0, 10 ], [ 15, 1 ], [ 20, 6 ], [ 15, 1 ], [ 0, 10 ], [ 18, 1 ], [ 99, 70 ], [ 19, 1 ], [ 0, 3 ], [ 15, 4 ], [ 0, 3 ], [ 15, 2 ], [ 20, 4 ], [ 15, 2 ], [ 0, 3 ], [ 15, 4 ], [ 0, 3 ], [ 19, 1 ], [ 99, 70 ], [ 1, 1 ], [ 15, 8 ], [ 0, 3 ], [ 15, 6 ], [ 0, 3 ], [ 15, 8 ], [ 1, 1 ], [ 99, 70 ], [ 1, 1 ], [ 15, 7 ], [ 0, 6 ], [ 15, 2 ], [ 0, 6 ], [ 15, 7 ], [ 1, 1 ], [ 99, 70 ], [ 1, 1 ], [ 15, 5 ], [ 0, 18 ], [ 15, 5 ], [ 1, 1 ], [ 99, 70 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 1 ], [ 0, 6 ], [ 15, 1 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 71 ],
        [ 1, 1 ], [ 15, 1 ], [ 0, 7 ], [ 15, 3 ], [ 0, 4 ], [ 15, 3 ], [ 0, 7 ], [ 15, 1 ], [ 1, 1 ], [ 99, 73 ], [ 19, 1 ], [ 0, 7 ], [ 15, 3 ], [ 0, 4 ], [ 15, 3 ], [ 0, 7 ], [ 19, 1 ], [ 99, 75 ], [ 18, 1 ], [ 0, 5 ], [ 15, 4 ], [ 0, 4 ], [ 15, 4 ], [ 0, 5 ], [ 18, 1 ], [ 99, 77 ], [ 18, 1 ], [ 0, 3 ], [ 15, 5 ], [ 0, 4 ], [ 15, 5 ], [ 0, 3 ], [ 18, 1 ], [ 99, 79 ], [ 18, 1 ], [ 0, 2 ], [ 15, 4 ], [ 0, 6 ], [ 15, 4 ], [ 0, 2 ], [ 18, 1 ], [ 99, 81 ], [ 19, 1 ], [ 15, 5 ], [ 0, 6 ], [ 15, 5 ], [ 19, 1 ], [ 99, 83 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 85 ], [ 1, 4 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 4 ], [ 99, 3543 ] ];

mapLobbyHall[0] = [ [ 99, 1841 ], [ 1, 4 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 4 ], [ 99, 85 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 2 ], [ 104, 1 ], [ 0, 6 ], [ 105, 1 ], [ 0, 2 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 2 ], [ 102, 1 ], [ 0, 6 ], [ 103, 1 ], [ 0, 2 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ],
        [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 2 ], [ 100, 1 ], [ 0, 6 ], [ 101, 1 ], [ 0, 2 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 85 ], [ 1, 4 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 4 ], [ 99, 5745 ] ];
mapLobbyHall[1] = [ [ 99, 1163 ], [ 1, 1 ], [ 99, 98 ], [ 1, 1 ], [ 15, 1 ], [ 1, 1 ], [ 99, 96 ], [ 1, 1 ], [ 15, 3 ], [ 1, 1 ], [ 99, 94 ], [ 1, 1 ], [ 15, 5 ], [ 1, 1 ], [ 99, 92 ], [ 1, 1 ], [ 15, 7 ], [ 19, 1 ], [ 99, 90 ], [ 1, 1 ], [ 15, 7 ], [ 0, 2 ], [ 18, 1 ], [ 99, 88 ], [ 1, 1 ], [ 15, 6 ], [ 0, 5 ], [ 18, 1 ], [ 99, 86 ], [ 1, 1 ], [ 15, 4 ], [ 0, 9 ], [ 18, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 4 ], [ 0, 11 ], [ 19, 1 ], [ 99, 82 ], [ 1, 1 ], [ 15, 5 ], [ 0, 2 ], [ 104, 1 ], [ 0, 8 ], [ 15, 1 ], [ 1, 1 ], [ 99, 80 ], [ 1, 1 ], [ 15, 6 ], [ 0, 10 ], [ 15, 3 ], [ 1, 1 ], [ 99, 78 ], [ 1, 1 ], [ 15, 6 ], [ 0, 11 ], [ 15, 4 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 4 ], [ 0, 13 ], [ 15, 6 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 4 ], [ 0, 11 ], [ 105, 1 ], [ 0, 2 ], [ 15, 5 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 5 ], [ 0, 2 ], [ 102, 1 ], [ 0, 11 ], [ 15, 4 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 6 ], [ 0, 13 ], [ 15, 4 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 6 ], [ 0, 11 ],
        [ 15, 6 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 4 ], [ 0, 13 ], [ 15, 6 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 4 ], [ 0, 11 ], [ 103, 1 ], [ 0, 2 ], [ 15, 5 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 5 ], [ 0, 2 ], [ 100, 1 ], [ 0, 11 ], [ 15, 4 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 6 ], [ 0, 13 ], [ 15, 4 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 4 ], [ 0, 11 ], [ 15, 6 ], [ 1, 1 ], [ 99, 78 ], [ 1, 1 ], [ 15, 3 ], [ 0, 10 ], [ 15, 6 ], [ 1, 1 ], [ 99, 80 ], [ 1, 1 ], [ 15, 1 ], [ 0, 8 ], [ 101, 1 ], [ 0, 2 ], [ 15, 5 ], [ 1, 1 ], [ 99, 82 ], [ 19, 1 ], [ 0, 11 ], [ 15, 4 ], [ 1, 1 ], [ 99, 84 ], [ 18, 1 ], [ 0, 9 ], [ 15, 4 ], [ 1, 1 ], [ 99, 86 ], [ 18, 1 ], [ 0, 5 ], [ 15, 6 ], [ 1, 1 ], [ 99, 88 ], [ 18, 1 ], [ 0, 2 ], [ 15, 7 ], [ 1, 1 ], [ 99, 90 ], [ 19, 1 ], [ 15, 7 ], [ 1, 1 ], [ 99, 92 ], [ 1, 1 ], [ 15, 5 ], [ 1, 1 ], [ 99, 94 ], [ 1, 1 ], [ 15, 3 ], [ 1, 1 ], [ 99, 96 ], [ 1, 1 ], [ 15, 1 ], [ 1, 1 ], [ 99, 98 ], [ 1, 1 ], [ 99, 4369 ], [ 98, 1 ], [ 99, 100 ],
        [ 98, 1 ], [ 99, 100 ], [ 98, 1 ], [ 99, 1072 ] ];
mapLobbyHall[2] = [ [ 99, 5741 ], [ 1, 4 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 4 ], [ 99, 85 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 2 ], [ 101, 1 ], [ 0, 6 ], [ 100, 1 ], [ 0, 2 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 2 ], [ 103, 1 ], [ 0, 6 ], [ 102, 1 ], [ 0, 2 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ],
        [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 2 ], [ 105, 1 ], [ 0, 6 ], [ 104, 1 ], [ 0, 2 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 1 ], [ 0, 12 ], [ 15, 1 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 2 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 3 ], [ 1, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 85 ], [ 1, 4 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 4 ], [ 99, 1845 ] ];
mapLobbyHall[3] = [ [ 99, 2587 ], [ 98, 1 ], [ 99, 100 ], [ 98, 1 ], [ 99, 100 ], [ 98, 1 ], [ 99, 1541 ], [ 1, 1 ], [ 99, 98 ], [ 1, 1 ], [ 15, 1 ], [ 1, 1 ], [ 99, 96 ], [ 1, 1 ], [ 15, 3 ], [ 1, 1 ], [ 99, 94 ], [ 1, 1 ], [ 15, 5 ], [ 1, 1 ], [ 99, 92 ], [ 1, 1 ], [ 15, 7 ], [ 19, 1 ], [ 99, 90 ], [ 1, 1 ], [ 15, 7 ], [ 0, 2 ], [ 18, 1 ], [ 99, 88 ], [ 1, 1 ], [ 15, 6 ], [ 0, 5 ], [ 18, 1 ], [ 99, 86 ], [ 1, 1 ], [ 15, 4 ], [ 0, 9 ], [ 18, 1 ], [ 99, 84 ], [ 1, 1 ], [ 15, 4 ], [ 0, 11 ], [ 19, 1 ], [ 99, 82 ], [ 1, 1 ], [ 15, 5 ], [ 0, 2 ], [ 101, 1 ], [ 0, 8 ], [ 15, 1 ], [ 1, 1 ], [ 99, 80 ], [ 1, 1 ], [ 15, 6 ], [ 0, 10 ], [ 15, 3 ], [ 1, 1 ], [ 99, 78 ], [ 1, 1 ], [ 15, 6 ], [ 0, 11 ], [ 15, 4 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 4 ], [ 0, 13 ], [ 15, 6 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 4 ], [ 0, 11 ], [ 100, 1 ], [ 0, 2 ], [ 15, 5 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 5 ], [ 0, 2 ], [ 103, 1 ], [ 0, 11 ], [ 15, 4 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 6 ],
        [ 0, 13 ], [ 15, 4 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 6 ], [ 0, 11 ], [ 15, 6 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 4 ], [ 0, 13 ], [ 15, 6 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 4 ], [ 0, 11 ], [ 102, 1 ], [ 0, 2 ], [ 15, 5 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 5 ], [ 0, 2 ], [ 105, 1 ], [ 0, 11 ], [ 15, 4 ], [ 1, 1 ], [ 99, 74 ], [ 1, 1 ], [ 15, 6 ], [ 0, 13 ], [ 15, 4 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 4 ], [ 0, 11 ], [ 15, 6 ], [ 1, 1 ], [ 99, 78 ], [ 1, 1 ], [ 15, 3 ], [ 0, 10 ], [ 15, 6 ], [ 1, 1 ], [ 99, 80 ], [ 1, 1 ], [ 15, 1 ], [ 0, 8 ], [ 104, 1 ], [ 0, 2 ], [ 15, 5 ], [ 1, 1 ], [ 99, 82 ], [ 19, 1 ], [ 0, 11 ], [ 15, 4 ], [ 1, 1 ], [ 99, 84 ], [ 18, 1 ], [ 0, 9 ], [ 15, 4 ], [ 1, 1 ], [ 99, 86 ], [ 18, 1 ], [ 0, 5 ], [ 15, 6 ], [ 1, 1 ], [ 99, 88 ], [ 18, 1 ], [ 0, 2 ], [ 15, 7 ], [ 1, 1 ], [ 99, 90 ], [ 19, 1 ], [ 15, 7 ], [ 1, 1 ], [ 99, 92 ], [ 1, 1 ], [ 15, 5 ], [ 1, 1 ], [ 99, 94 ], [ 1, 1 ], [ 15, 3 ], [ 1, 1 ], [ 99, 96 ], [ 1, 1 ],
        [ 15, 1 ], [ 1, 1 ], [ 99, 98 ], [ 1, 1 ], [ 99, 2476 ] ];

mapLobbyWing[0] = [ [ 99, 4202 ], [ 1, 4 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 4 ], [ 99, 7 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 6 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 6 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 6 ], [ 15, 5 ], [ 1, 1 ], [ 99, 6 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 3 ], [ 0, 10 ], [ 15, 3 ], [ 0, 10 ],
        [ 15, 3 ], [ 0, 10 ], [ 15, 3 ], [ 0, 10 ], [ 15, 3 ], [ 0, 10 ], [ 15, 3 ], [ 0, 7 ], [ 15, 5 ], [ 1, 1 ], [ 99, 6 ], [ 19, 1 ], [ 0, 86 ], [ 15, 6 ], [ 1, 1 ], [ 99, 6 ], [ 18, 1 ], [ 0, 85 ], [ 15, 7 ], [ 1, 1 ], [ 99, 6 ], [ 18, 1 ], [ 0, 84 ], [ 15, 8 ], [ 1, 1 ], [ 99, 6 ], [ 18, 1 ], [ 0, 84 ], [ 15, 8 ], [ 1, 1 ], [ 99, 6 ], [ 18, 1 ], [ 0, 85 ], [ 15, 7 ], [ 1, 1 ], [ 99, 6 ], [ 19, 1 ], [ 0, 86 ], [ 15, 6 ], [ 1, 1 ], [ 99, 6 ], [ 1, 1 ], [ 15, 2 ], [ 0, 10 ], [ 15, 3 ], [ 0, 10 ], [ 15, 3 ], [ 0, 10 ], [ 15, 3 ], [ 0, 10 ], [ 15, 3 ], [ 0, 10 ], [ 15, 3 ], [ 0, 10 ], [ 15, 3 ], [ 0, 7 ], [ 15, 5 ], [ 1, 1 ], [ 99, 6 ], [ 1, 1 ], [ 15, 3 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 8 ], [ 15, 5 ], [ 0, 6 ], [ 15, 5 ], [ 1, 1 ], [ 99, 6 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ],
        [ 15, 4 ], [ 1, 1 ], [ 99, 6 ], [ 1, 1 ], [ 15, 4 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 7 ], [ 0, 6 ], [ 15, 4 ], [ 1, 1 ], [ 99, 7 ], [ 1, 4 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 7 ], [ 19, 1 ], [ 18, 4 ], [ 19, 1 ], [ 1, 4 ], [ 99, 4206 ] ];
mapLobbyWing[1] = [ [ 99, 113 ], [ 1, 1 ], [ 99, 98 ], [ 1, 1 ], [ 15, 1 ], [ 1, 1 ], [ 99, 96 ], [ 1, 1 ], [ 15, 3 ], [ 1, 1 ], [ 99, 94 ], [ 1, 1 ], [ 15, 5 ], [ 1, 1 ], [ 99, 92 ], [ 19, 1 ], [ 15, 7 ], [ 19, 1 ], [ 99, 90 ], [ 18, 1 ], [ 0, 2 ], [ 15, 5 ], [ 0, 2 ], [ 18, 1 ], [ 99, 88 ], [ 18, 1 ], [ 0, 4 ], [ 15, 3 ], [ 0, 4 ], [ 18, 1 ], [ 99, 86 ], [ 18, 1 ], [ 0, 13 ], [ 18, 1 ], [ 99, 84 ], [ 19, 1 ], [ 0, 15 ], [ 19, 1 ], [ 99, 82 ], [ 1, 1 ], [ 15, 1 ], [ 0, 15 ], [ 15, 1 ], [ 1, 1 ], [ 99, 80 ], [ 1, 1 ], [ 15, 3 ], [ 0, 13 ], [ 15, 3 ], [ 1, 1 ], [ 99, 78 ], [ 1, 1 ], [ 15, 5 ], [ 0, 11 ], [ 15, 5 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 6 ], [ 0, 11 ], [ 15, 6 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 5 ], [ 0, 11 ], [ 15, 7 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 3 ], [ 0, 13 ], [ 15, 7 ], [ 19, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 1 ], [ 0, 15 ], [ 15, 5 ], [ 0, 2 ], [ 18, 1 ], [ 99, 76 ], [ 19, 1 ], [ 0, 16 ], [ 15, 3 ], [ 0, 4 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ],
        [ 0, 23 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 4 ], [ 15, 3 ], [ 0, 16 ], [ 19, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 2 ], [ 15, 5 ], [ 0, 15 ], [ 15, 1 ], [ 1, 1 ], [ 99, 76 ], [ 19, 1 ], [ 15, 7 ], [ 0, 13 ], [ 15, 3 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 7 ], [ 0, 11 ], [ 15, 5 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 6 ], [ 0, 11 ], [ 15, 6 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 5 ], [ 0, 11 ], [ 15, 7 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 3 ], [ 0, 13 ], [ 15, 7 ], [ 19, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 1 ], [ 0, 15 ], [ 15, 5 ], [ 0, 2 ], [ 18, 1 ], [ 99, 76 ], [ 19, 1 ], [ 0, 16 ], [ 15, 3 ], [ 0, 4 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 23 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 4 ], [ 15, 3 ], [ 0, 16 ], [ 19, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 2 ], [ 15, 5 ], [ 0, 15 ], [ 15, 1 ], [ 1, 1 ], [ 99, 76 ], [ 19, 1 ], [ 15, 7 ], [ 0, 13 ], [ 15, 3 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 7 ], [ 0, 11 ], [ 15, 5 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 6 ],
        [ 0, 11 ], [ 15, 6 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 5 ], [ 0, 11 ], [ 15, 7 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 3 ], [ 0, 13 ], [ 15, 7 ], [ 19, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 1 ], [ 0, 15 ], [ 15, 5 ], [ 0, 2 ], [ 18, 1 ], [ 99, 76 ], [ 19, 1 ], [ 0, 16 ], [ 15, 3 ], [ 0, 4 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 23 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 4 ], [ 15, 3 ], [ 0, 16 ], [ 19, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 2 ], [ 15, 5 ], [ 0, 15 ], [ 15, 1 ], [ 1, 1 ], [ 99, 76 ], [ 19, 1 ], [ 15, 7 ], [ 0, 13 ], [ 15, 3 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 7 ], [ 0, 11 ], [ 15, 5 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 6 ], [ 0, 11 ], [ 15, 6 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 5 ], [ 0, 11 ], [ 15, 7 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 3 ], [ 0, 13 ], [ 15, 7 ], [ 19, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 1 ], [ 0, 15 ], [ 15, 5 ], [ 0, 2 ], [ 18, 1 ], [ 99, 76 ], [ 19, 1 ], [ 0, 16 ], [ 15, 3 ], [ 0, 4 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ],
        [ 0, 23 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 4 ], [ 15, 3 ], [ 0, 16 ], [ 19, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 2 ], [ 15, 5 ], [ 0, 15 ], [ 15, 1 ], [ 1, 1 ], [ 99, 76 ], [ 19, 1 ], [ 15, 7 ], [ 0, 13 ], [ 15, 3 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 7 ], [ 0, 11 ], [ 15, 5 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 6 ], [ 0, 11 ], [ 15, 6 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 5 ], [ 0, 11 ], [ 15, 7 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 3 ], [ 0, 13 ], [ 15, 7 ], [ 19, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 1 ], [ 0, 15 ], [ 15, 5 ], [ 0, 2 ], [ 18, 1 ], [ 99, 76 ], [ 19, 1 ], [ 0, 16 ], [ 15, 3 ], [ 0, 4 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 23 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 4 ], [ 15, 3 ], [ 0, 16 ], [ 19, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 2 ], [ 15, 5 ], [ 0, 15 ], [ 15, 1 ], [ 1, 1 ], [ 99, 76 ], [ 19, 1 ], [ 15, 7 ], [ 0, 13 ], [ 15, 3 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 7 ], [ 0, 11 ], [ 15, 5 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 6 ],
        [ 0, 11 ], [ 15, 6 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 5 ], [ 0, 11 ], [ 15, 7 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 3 ], [ 0, 13 ], [ 15, 7 ], [ 19, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 1 ], [ 0, 15 ], [ 15, 5 ], [ 0, 2 ], [ 18, 1 ], [ 99, 76 ], [ 19, 1 ], [ 0, 16 ], [ 15, 3 ], [ 0, 4 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 23 ], [ 18, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 4 ], [ 15, 3 ], [ 0, 16 ], [ 19, 1 ], [ 99, 76 ], [ 18, 1 ], [ 0, 2 ], [ 15, 5 ], [ 0, 15 ], [ 15, 1 ], [ 1, 1 ], [ 99, 76 ], [ 19, 1 ], [ 15, 7 ], [ 0, 12 ], [ 15, 4 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 7 ], [ 0, 8 ], [ 15, 8 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 6 ], [ 0, 5 ], [ 15, 12 ], [ 1, 1 ], [ 99, 76 ], [ 1, 1 ], [ 15, 5 ], [ 0, 5 ], [ 15, 11 ], [ 1, 1 ], [ 99, 78 ], [ 1, 1 ], [ 15, 3 ], [ 0, 6 ], [ 15, 10 ], [ 1, 1 ], [ 99, 80 ], [ 1, 1 ], [ 15, 1 ], [ 0, 6 ], [ 15, 10 ], [ 1, 1 ], [ 99, 82 ], [ 19, 1 ], [ 0, 6 ], [ 15, 9 ], [ 1, 1 ], [ 99, 84 ], [ 18, 1 ], [ 0, 5 ], [ 15, 8 ], [ 1, 1 ],
        [ 99, 86 ], [ 18, 1 ], [ 0, 3 ], [ 15, 8 ], [ 1, 1 ], [ 99, 88 ], [ 18, 1 ], [ 0, 2 ], [ 15, 7 ], [ 1, 1 ], [ 99, 90 ], [ 19, 1 ], [ 15, 7 ], [ 1, 1 ], [ 99, 92 ], [ 1, 1 ], [ 15, 5 ], [ 1, 1 ], [ 99, 93 ], [ 98, 1 ], [ 1, 1 ], [ 15, 3 ], [ 1, 1 ], [ 99, 95 ], [ 98, 1 ], [ 1, 1 ], [ 15, 1 ], [ 1, 1 ], [ 99, 97 ], [ 98, 1 ], [ 1, 1 ], [ 99, 1426 ] ];
