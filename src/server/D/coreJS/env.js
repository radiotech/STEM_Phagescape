module.exports = function(o) {
	
	o.createEnv = function () {
		var e = new o.Env();
		e.fps = 25;
		e.config = undefined;
		e.getConfig = function(a){
			console.log("error: called getConfig before it was re-defined in env.js");
		}
		e.run = (function () {
			var loops, skipTicks, maxFrameSkip, nextGameTick;
			loops = 0;
			skipTicks = 1000 / e.fps;
			maxFrameSkip = 10;
			nextGameTick = (new Date()).getTime();
			return function () {
				loops = 0;
				while ((new Date()).getTime() > nextGameTick && loops < maxFrameSkip) {
					e.update();
					nextGameTick += skipTicks;
					loops++;
				}
			};
		}());
		setTimeout(e.getConfig(function(a){e.config = a;}), 1);
		return e;
	};
	
	o.Env = function() {
		var e = this;
		o.globalE = e;
		e.users = {};
		e.usernames = [];
		e.worlds = [];
		e.tick = 0;
		e.update = function () {
			e.tick++;
			e.worlds.forEach(function (w) {
				o.update(e[w]);
				if (e.tick % 3 == 0) {
					e[w].users.forEach(function (username) {
						if (e.users[username].updates != "") {
							e.users[username].emit("text", e.users[username].updates);
							o.upload += o.bits(e.users[username].updates, 6);
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
				var nonew = 0;
				/*
				o.println(0,true);
				o.println("[SERVER CONSOLE]");
				o.println("Upload: "+Math.ceil(o.upload*0.001)+" kbps");o.upload = 0;
				o.println("Download: "+Math.ceil(o.download*0.001)+" kbps");o.download = 0;
				o.println("Users: "+Object.keys(e.users).length);
				o.println("Worlds: "+e.worlds.length);
				if(o.outputText.length > 0){
					o.println("");
					o.println("[SERVER OUTPUT]");
					o.outputText.forEach(function(text,i){
						o.println(text);
						if(e.tick > o.outputTick[i]){
							o.outputText.splice(i,1);
							o.outputTick.splice(i,1);
						}
					});
				}*/
				
				/*
				 * if(e[0] != undefined){ e[0].eU.forEach(function(wL,ln){ if(ln > 30 && ln < 70){ var thisL = ""; wL.forEach(function(wD,dn){ if(dn > 30 && dn < 70){ thisL += Math.min(wD.length,9)+" "; } }); o.println(thisL); } }); }
				 */
			}
		};
		e.World = function (id) {
			var w, i, j;
			w = this;
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
			o.fillArray(w.gb.isSolid, 256, -1);
			w.gb.color = [];
			w.gb.strength = [];
			// w.gb.breakType = new Array(256).fill(0);
			w.gb.breakType = [];
			w.tips = [];
			o.fillArray(w.gb.breakType, 256, 0);
			for (i = 0; i < w.wSize; i++) {
				// w.wU[i] = new Array(w.wSize).fill(0);
				w.wU[i] = [];
				o.fillArray(w.wU[i], w.wSize, 0);
				// w.wUDamage[i] = new Array(w.wSize).fill(0);
				w.wUDamage[i] = [];
				o.fillArray(w.wUDamage[i], w.wSize, 0);
				w.eU[i] = []; // o.fillArray(w.eU[i],w.wSize,[]);
				for (j = 0; j < w.wSize; j++) {
					w.eU[i][j] = [];
				}
			}
			e.World.prototype.mobEnter = function (mob) {
				w = this;
				w.entities.push(mob);
				o.addEntityToGridArea(w, mob.snap.v.x - mob.size * mob.hitboxScale / 2, mob.snap.v.y - mob.size * mob.hitboxScale / 2, mob.snap.v.x + mob.size * mob.hitboxScale / 2, mob.snap.v.y + mob.size * mob.hitboxScale / 2, mob);
			};
			e.World.prototype.mobExit = function (mob) {
				w = this;
				w.entities.splice(w.entities.indexOf(mob), 1);
				o.removeEntityFromGridArea(w, mob.pv.x - mob.size * mob.hitboxScale / 2, mob.pv.y - mob.size * mob.hitboxScale / 2, mob.pv.x + mob.size * mob.hitboxScale / 2, mob.pv.y + mob.size * mob.hitboxScale / 2, mob.id);
			};
			o.setup(w);
		};
	}
	
	o.setup = function(w) {
		o.game[0].setup(w);
	}
	o.update = function(w) {
		w.entities.forEach(function (mob) {
			mob.pv.x = mob.snap.v.x;
			mob.pv.y = mob.snap.v.y;
			mob.update(w, mob);
			if (mob.pv.x != mob.snap.v.x || mob.pv.y != mob.snap.v.y) {
				mob.inMotion = true;
				if (Math.floor(mob.snap.v.x - mob.size * mob.hitboxScale / 2) != Math.floor(mob.pv.x - mob.size * mob.hitboxScale / 2) || Math.floor(mob.snap.v.x + mob.size * mob.hitboxScale / 2) != Math.floor(mob.pv.x + mob.size * mob.hitboxScale / 2) || Math.floor(mob.snap.v.y - mob.size * mob.hitboxScale / 2) != Math.floor(mob.pv.y - mob.size * mob.hitboxScale / 2) || Math.floor(mob.snap.v.y + mob.size * mob.hitboxScale / 2) != Math.floor(mob.pv.y + mob.size * mob.hitboxScale / 2)) {
					mob.inNewBlock = true;
					o.removeEntityFromGridArea(w, mob.pv.x - mob.size * mob.hitboxScale / 2, mob.pv.y - mob.size * mob.hitboxScale / 2, mob.pv.x + mob.size * mob.hitboxScale / 2, mob.pv.y + mob.size * mob.hitboxScale / 2, mob.id);
					o.addEntityToGridArea(w, mob.snap.v.x - mob.size * mob.hitboxScale / 2, mob.snap.v.y - mob.size * mob.hitboxScale / 2, mob.snap.v.x + mob.size * mob.hitboxScale / 2, mob.snap.v.y + mob.size * mob.hitboxScale / 2, mob);
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
					o.out("MOB_DIE:" + mob.id + ";", -1, w);
				}
			}
		});
		o.game[0].update(w);
	}
	
	o.goToWorldId = function(w, worldID, src) {
		var modSnap, limitLoops, worldExists, nonew;
		w.mobExit(src.playerE);
		w.users.splice(w.users.indexOf(src.userId), 1);
		src.worldID = worldID;

		if (src.playerE.snap.bullets.length > 0) {
			if (w.entities.length > 0) {
				src.playerE.snap.bullets.forEach(function (bull) {
					w.entities[0].snap.bullets.push(bull);
				});
			} else {
				modSnap = src.playerE.snap;
				limitLoops = 0;
				while (modSnap.bullets.length > 0 && limitLoops < 1000) {
					modSnap = modSnap.simulate(w, 1, [ 0, 0, 0, 0 ]);
					limitLoops++;
				}
			}
			src.playerE.snap.bullets = [];
		}

		worldExists = false;
		w.parent.worlds.forEach(function (world) {
			if (world == worldID) {
				worldExists = true;
			}
		});
		if (!worldExists) {
			nonew = new w.parent.World(worldID);
		}

		w.parent[worldID].users.push(src.userId);
		w.parent[worldID].mobEnter(src.playerE);
		o.out("MOB_DIE:" + src.playerE.id + ";", src, w);
		o.out("RESET:0;", src, -1);
		o.out(o.outWorldProp(w.parent[worldID]), src, -1);
		o.out(o.outWorld(w.parent[worldID]), src, -1);
		o.out(o.outWorldMobs(w.parent[worldID], src.playerE.id), src, -1);
	}
	
	return o;
}