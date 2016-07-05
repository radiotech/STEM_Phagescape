module.exports = function(o) {
	
	o.out = function(text, des, w) {
		if (w == -1) {
			des.updates += text;
		} else if (des == -1) {
			w.users.forEach(function (username) {
				w.parent.users[username].updates += text;
			});
		} else {
			w.users.forEach(function (username) {
				if (w.parent.users[username] != des) {
					w.parent.users[username].updates += text;
				}
			});
		}
	}
	o.outWorldProp = function(w) {
		var updates, i;
		updates = "PROPS:";
		for (i = 0; i < w.props.length; i++) {
			updates += i + "=" + w.props[i] + ":";
		}
		updates = updates.substring(0, updates.length - 1) + ";" + "GB:";
		for (i = 0; i < 256; i++) {
			if (w.gb.isSolid[i] != -1) {
				updates += i + ":" + w.gb.isSolid[i] + ":" + w.gb.color[i][0] + ":" + w.gb.color[i][1] + ":" + w.gb.color[i][2] + ":" + w.gb.strength[i] + ":";
			}
		}
		updates = updates.substring(0, updates.length - 1) + ";" + "TIPS:";
		for (i = 0; i < w.tips.length; i++) {
			updates += w.tips[i][0] + ":" + w.tips[i][1] + ":" + w.tips[i][2] + ":" + w.tips[i][3] + ":" + w.tips[i][4] + ":";
		}
		return updates.substring(0, updates.length - 1) + ";";
	}
	o.outMob = function(mob) {
		var tempOut = "MOB:" + mob.id + ":" + (mob.moves++) + ":" + mob.snap.v.x + ":" + mob.snap.v.y + ":" + mob.snap.dir + ":" + mob.snap.health + ":";
		mob.snap.bullets.forEach(function (bull) {
			tempOut += bull.v.x + ":" + bull.v.y + ":";
		});
		return tempOut.substring(0, tempOut.length - 1) + ";";
	}
	o.outBullHitMob = function(src, ind, mob) {
		return "BHITM:" + src.id + ":" + ind + ":" + mob.id + ";";
	}
	o.outBlock = function(w, x, y) {
		return "BLOCK:" + Math.floor(x) + ":" + Math.floor(y) + ":" + o.aGS(w.wU, x, y) + ":" + o.aGS(w.wUDamage, x, y) + ";";
	}
	o.outWorld = function(w) {
		var updates = "WORLD:" + w.wSize + ":" + w.wSize + ":";
		w.wU.forEach(function (i, indI) {
			i.forEach(function (j, indJ) {
				updates += j + ":";
				if (w.wUDamage[indI][indJ] != 0) {
					updates += (-w.wUDamage[indI][indJ]) + ":";
				}
			});
		});
		return updates.substring(0, updates.length - 1) + ";";
	}
	o.outWorldMobs = function(w, notId) {
		var updates = "";
		w.entities.forEach(function (mob) {
			if (mob.id != notId) {
				updates += o.outMob(mob);
			}
		});
		return updates;
	}
	o.syncToMob = function(mob, str) {
		// o.println("MOBSYNC:"+mob.id+":"+mob.recievedMovePacketId+":" + str.replace(/:/g,"%%%"));
		return "MOBSYNC:" + mob.id + ":" + mob.recievedMovePacketId + ":" + str.replace(/:/g, "%%%");
	}
	o.syncToMobWrap = function(w, mob, str, toSource) {
		if (mob == undefined) {
			o.out(str, -1, w);
		} else {
			if (mob.src == undefined) {
				o.out(o.syncToMob(mob, str), -1, w);
			} else {
				o.out(o.syncToMob(mob, str), mob.src, w);
				if (toSource) {
					o.out(str, mob.src, -1);
				}
			}
		}
	}
	
	o.getData = function (w, data, src) {
		var dataItems, worldExists, e, nonew;
		o.download += o.bits(data, 10);
		dataItems = JSON.parse(data);
		dataItems.forEach(function (item) {
			if (item[0] == "MOVE") {

				item.forEach(function (input) {
					if (input != "MOVE") {
						if (input[0] > src.playerE.recievedMovePacketId) {
							// console.log(input[1]+1-1);
							// console.log(input[2]+1-1);
							src.playerE.listInput.push([ input[1], input[2], input[3], input[4] ]);
						}
					}
				});
				//console.log(data);
				//console.log(item[1][0] - item[item.length-1][0]);
				src.playerE.recievedMovePacketId = item[1][0];
			} else if (item[0] == "NEWCONN") { // NEWCONN,world
				// console.log("NEW CONN");
				e = w;
				if (src.userId == undefined) {
					o.output("New User!");
					src.userId = "User_"+Math.floor(Math.random() * 10000);
					src.updates = "";
					src.worldID = item[1];
					e.users[src.userId] = src;

					worldExists = false;
					e.worlds.forEach(function (world) {
						if (world == src.worldID) {
							worldExists = true;
						}
					});
					if (!worldExists) {
						nonew = new e.World(src.worldID);
					}

					e[src.worldID].users.push(src.userId);

					src.playerE = new o.Entity(e[src.worldID], 50, 50, "player", 0, 0, src);
					e[src.worldID].mobEnter(src.playerE);

					o.out("MOVED:0:" + src.playerE.snap.v.x + ":" + src.playerE.snap.v.y + ":" + src.playerE.snap.speed + ":" + src.playerE.snap.dir + ":" + src.playerE.snap.tSpeed + ":" + src.playerE.snap.stamina + ":" + src.playerE.snap.health + ":" + src.playerE.snap.hSteps + ":" + src.playerE.snap.fireCoolDown + ";", src, -1);
					o.out(o.outWorldProp(e[src.worldID]), src, -1);
					o.out(o.outWorld(e[src.worldID]), src, -1);
					o.out(o.outWorldMobs(e[src.worldID], src.playerE.id), src, -1);
					o.out("PID:" + src.playerE.id + ";", src, -1);
				}
			} else if (item[0] == "CHAT") {
				item[1] = "CHAT:<font color=\"yellow\">&lt\\b"+src.userId+"&gt</font>\ "+item[1]+";";
				console.log(item[1]);
				w.users.forEach(function (username) {
					w.parent.users[username].updates += item[1];
				});
			} else if (item[0] == "DISCONN") {
				e = w;
				if (src.playerE != undefined) {

					o.out("MOB_DIE:" + src.playerE.id + ";", -1, e[src.worldID]);
					// delete src.playerE;

					// o.println("TESTED "+src.playerE.snap.bullets.length);
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
				o.out("READY:", src, -1);
			} else {
				o.output("UNRECOGNIZED USER COMMAND!!! - " + item[0]);
			}
		});
	};
	
	return o;
}