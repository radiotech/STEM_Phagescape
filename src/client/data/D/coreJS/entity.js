module.exports = function(o) {
	
	o.Snap = function (mom) {
		var s, i, j, k, bull, hitMobs, aDif, dirS, innspeed, num, rotDis;
		s = this;
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
		s.simulate = function (w, reps, input) {
			s.newS = new o.Snap(s.dad);
			s.newS.type = s.type;
			switch (s.type) {
			case 0:// player simulation
				s.bullets.forEach(function (bull, ind) {
					s.newS.bullets[ind] = {
						"v" : {
							"x" : bull.v.x,
							"y" : bull.v.y
						},
						"speed" : bull.speed,
						"dir" : bull.dir,
						"src" : [ bull.src[0], bull.src[1], bull.src[2] ]
					};
				});
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

				for (i = 0; i < reps; i++) {
					for (j = s.newS.bullets.length-1; j >= 0; j--) {
						bull = s.newS.bullets[j];
						bull.v.x += bull.speed * Math.cos(bull.dir);
						bull.v.y += bull.speed * Math.sin(bull.dir);
						if (bull.v.x > w.wSize || bull.v.y > w.wSize || bull.v.x < 0 || bull.v.y < 0) {
							s.newS.bullets.splice(j, 1);
							break;
						}
						if (w.gb.isSolid[o.aGS(w.wU, bull.v.x, bull.v.y)]) {
							o.syncToMobWrap(w, s.dad, o.particleEffect(5, 5, [ bull.v.x, bull.v.y ], [ 0.2, 0.2 ], [ -1, o.aGS1DB(w.gb.color, o.aGS(w.wU, bull.v.x, bull.v.y)), s.dad.bull.col ], [ -1, 0.1, 0.05 ], [ -1, 0.02, 0.005 ], [ 0, 1 ], [ -1, 20, 30 ]), false);
							o.hitBlock(w, bull.v.x, bull.v.y, 1, s.dad);
							s.newS.bullets.splice(j, 1);
							break;
						}
						hitMobs = o.mobsAt(w, bull.v.x, bull.v.y, bull.src[0].bull.size / 2);
						for (k = 0; k < hitMobs.length; k++) {
							if (bull.src[1] == 0) { // bullet will not collide with player src[2]
								if (hitMobs[k].id != bull.src[2]) {
									o.hitMob(w, hitMobs[k], 1, s.newS.dad, j);
									s.newS.bullets.splice(j, 1);
								}
							} else if (bull.src[1] == 1) { // bullet will collide with player src[2]
								if (hitMobs[k].id == bull.src[2]) {
									o.hitMob(w, hitMobs[k], 1, s.newS.dad, j);
									s.newS.bullets.splice(j, 1);
								}
							} else if (bull.src[1] == 2) { // bullet will not collide with team src[2]
								if (hitMobs[k].team != bull.src[2]) {
									o.hitMob(w, hitMobs[k], 1, s.newS.dad, j);
									s.newS.bullets.splice(j, 1);
								}
							} else if (bull.src[1] == 3) { // bullet will collide with team src[2]
								if (hitMobs[k].team == bull.src[2]) {
									o.hitMob(w, hitMobs[k], 1, s.newS.dad, j);
									s.newS.bullets.splice(j, 1);
								}
							}
						}
					}
					if (s.newS.health > 0) {
						if (s.newS.fireCoolDown > 0) {
							s.newS.fireCoolDown--;
						}

						if (input[i * 5] == 1) {// if move input
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
						aDif = o.angleDif(s.newS.dir, input[1 + i * 5]);
						// console.log(aDif);
						if (aDif != 0) {
							dirS = Math.round(aDif / Math.abs(aDif));

							innspeed = s.newS.tSpeed + s.dad.tAccel * dirS - s.dad.tDrag * dirS;
							num = Math.floor(innspeed / s.dad.tDrag * dirS);
							rotDis = (num + 1) * (innspeed - num / 2 * s.dad.tDrag * dirS);
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
						// o.pointDir(s.newS.v.x,s.newS.v.y,input[1+i*3],input[2+i*3]);

						o.moveInWorld(w, s.newS.v, s.newS.speed * Math.cos(s.newS.dir), s.newS.speed * Math.sin(s.newS.dir), s.dad.size * s.dad.hitboxScale / 2, s.dad.size * s.dad.hitboxScale / 2);
					}
				}
				break;
			}
			return s.newS;
		};
		s.tryStaminaAction = function (cost, nCost) {
			var negCost = 1;
			if (nCost != undefined) {
				negCost = nCost;
			}
			cost = cost * s.dad.staminaRate;
			if (s.newS.stamina > cost) {
				s.newS.stamina -= cost;
				return true;
			}
			s.newS.stamina = Math.max(0, s.newS.stamina - cost / 5 * negCost);
			return false;
		};
		s.fire = function (newS, tDir) {
			newS.bullets.push({
				"v" : {
					"x" : newS.v.x,
					"y" : newS.v.y
				},
				"speed" : newS.dad.bulletSpeed,
				"dir" : tDir,
				"src" : [ s.dad, 0, s.dad.id ]
			});
		};
	};
	o.Entity = function (w, tX, tY, tType, tSpeed, tDir, tSrc) {
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

		mob.bulletSpeed = 0.14;
		mob.drag = 0.008;
		mob.tAccel = 0.03;
		mob.accel = 0.04;
		mob.tSMax = 0.2;
		mob.sMax = 0.15;
		mob.tDrag = 0.016;
		mob.hitboxScale = 1;
		mob.staminaRate = 1;
		mob.fireDelay = 10;
		mob.size = 1;

		mob.hMax = 20;
		mob.hSteps = 100;

		mob.bull = {};
		mob.bull.col = [ 0, 0, 0 ];
		mob.bull.size = 0.1;

		mob.snap = new o.Snap(mob); // controls movement and position, NOT safe to
		// change x and y values of this (use listJumps)
	};
	o.Entity.prototype.changed = function (str) {
		this.changes.any = true;
		this.changes[str] = true;
	};
	o.Entity.prototype.update = function (w, mob) {
		var s, tempOut;
		if (mob.type == "player") {
			if (mob.listInput.length > 0 || mob.listJumps.length > 0) {
				if (mob.listJumps.length > 0) {
					s = mob.snap;
					mob.listJumps.forEach(function (jump) {
						try{
							jump();
						} catch(ex){
							console.log("Error!: "+ex.name+" "+ex.message);
						}
					});
					if (mob.src != undefined) {
						w = w.parent[mob.src.worldID];
					}

					o.out(o.outMob(mob), mob.src, w);
					mob.listJumps = []; // may be improved with something like
					// array.clear although I wrote this code
					// without web access for reference..
				}
				if (mob.listInput.length > 0) {
					mob.listInput.forEach(function (input) {
						mob.snap = mob.snap.simulate(w, 1, input);
						o.out(o.outMob(mob), mob.src, w);
					});
					mob.listInput = []; // may be improved with something like
					// array.clear although I wrote this code
					// without web access for reference..
					mob.lastActiveTick = w.parent.tick;
					w.lastActiveTick = w.parent.tick;
				}
				tempOut = "MOVED:" + mob.recievedMovePacketId + ":" + mob.snap.v.x + ":" + mob.snap.v.y + ":" + mob.snap.speed + ":" + mob.snap.dir + ":" + mob.snap.tSpeed + ":" + mob.snap.stamina + ":" + mob.snap.health + ":" + mob.snap.hSteps + ":" + mob.snap.fireCoolDown + ":";
				mob.snap.bullets.forEach(function (bull) {
					tempOut += bull.v.x + ":" + bull.v.y + ":" + bull.speed + ":" + bull.dir + ":";
				});
				o.out(tempOut.substring(0, tempOut.length - 1) + ";", mob.src, -1);
			}
			if (w.parent.tick % 25 == 0) {
				if (mob.lastActiveTick + 250 < w.parent.tick) {
					o.getData(w.parent, "[[\"DISCONN\"]]", mob.src);
				}
			}
		}
		// if(mob.x)
		// mob.changed("move");
	};
	o.Entity.prototype.remove = function (w) {
		w.mobExit(this);
		this.changed("die");
	};
	
	return o;
}