module.exports = function(o) {
	
	o.upload = 0;
	o.download = 0;
	o.outputText = [];
	o.outputTick = [];
	o.globalE;
	o.game = [ {} ];

	o.fillArray = function(ar, len, val) {
		var i;
		for (i = 0; i < len; i++) {
			ar[i] = val;
		}
	}
	o.aSS = function(tMat, tA, tB, tValue) { // array set safe
		tMat[Math.max(0, Math.min(tMat.length - 1, Math.floor(tA)))][Math.max(0, Math.min(tMat[0].length - 1, Math.floor(tB)))] = tValue;
	}
	o.aGS = function(tMat, tA, tB) { // array get safe
		try {
			return tMat[Math.max(0, Math.min(tMat.length - 1, Math.floor(tA)))][Math.max(0, Math.min(tMat[0].length - 1, Math.floor(tB)))];
		} catch (ex) {
			console.log(ex.stack);
		}
	}
	o.aGS1DB = function(tMat, tA) { // array get safe
		return tMat[Math.max(0, Math.min(tMat.length - 1, Math.floor(tA)))];
	}
	o.pointDistance = function(v1x, v1y, v2x, v2y) {
		return Math.sqrt(Math.pow(v1x - v2x, 2) + Math.pow(v1y - v2y, 2));
	}
	o.posMod = function(tA, tB) {
		var myReturn = tA % tB;
		if (myReturn < 0) {
			myReturn += tB;
		}
		return myReturn;
	}
	o.angleDif = function(tA, tB) {
		tA = o.posMod(tA, Math.PI * 2);
		tB = o.posMod(tB, Math.PI * 2);
		if (tA < tB - Math.PI) {
			tA += Math.PI * 2;
		}
		if (tB < tA - Math.PI) {
			tB += Math.PI * 2;
		}
		return tB - tA;
	}
	o.pointDir = function(v1x, v1y, v2x, v2y) {
		if ((v2x - v1x) != 0) {
			var tDir = Math.atan((v2y - v1y) / (v2x - v1x));
			if (v1x - v2x > 0) {
				tDir -= Math.PI;
			}
			return tDir;
		}
		if ((v2y - v1y) != 0) {
			if (v2y > v1y) {
				return Math.PI / 2;
			}
			return Math.PI / 2 * 3;
		}
		return Math.random() * 2 * Math.PI;
	}
	
	o.hitMob = function(w, mob, pow, src, ind) {
		if (mob.hMax >= 0 || pow >= 999) {
			mob.snap.health -= pow;
			if (src != undefined) {
				o.out(o.outBullHitMob(src, ind, mob), -1, w);
			}
			mob.snap.health = Math.max(Math.min(mob.snap.health, mob.hMax), 0);
			if (mob.snap.health == 0) {
				mob.snap.health = 0;
				// if(o.aGS1DS(gBBreakCommand,o.aGS(wU,x,y)) != null){
				// tryCommand(StringReplaceAll(StringReplaceAll(o.aGS1DS(gBBreakCommand,o.aGS(wU,x,y)),"_x_",str(int(x))),"_y_",str(int(y))),"");//o.aGS1DS(gBBreakCommand,wUP[i][j])
				// }

				// MOB DIES

				// o.aSS(w.wU,x,y,o.aGS1DB(w.gb.breakType,o.aGS(w.wU,x,y)));
				// var pe = o.particleEffect(15,5,[Math.floor(x)+.5,Math.floor(y)+.5],[1,1],[o.aGS1DB(w.gb.color,o.aGS(w.wU,x,y))],[-1,.1,.05],[-1,.02,.005],[0,1],[-1,20,30]);
				// o.syncToMobWrap(w,mob,pe,true);

				// o.particleEffect(x,y,1,1,15,tempC,o.aGS1DC(gBColor,o.aGS(wU,x,y)),.01);

			}
			o.out(o.outMob(mob), mob.src, w);
		}
	}
	o.hitBlock = function(w, x, y, pow,/* OPTIONAL */mob) {
		if (o.aGS1DB(w.gb.strength, o.aGS(w.wU, x, y)) >= 0 || pow >= 999) {
			o.aSS(w.wUDamage, x, y, o.aGS(w.wUDamage, x, y) + pow);
			if (o.aGS(w.wUDamage, x, y) > o.aGS1DB(w.gb.strength, o.aGS(w.wU, x, y))) {
				// if(o.aGS1DS(gBBreakCommand,o.aGS(wU,x,y)) != null){
				// tryCommand(StringReplaceAll(StringReplaceAll(o.aGS1DS(gBBreakCommand,o.aGS(wU,x,y)),"_x_",str(int(x))),"_y_",str(int(y))),"");//o.aGS1DS(gBBreakCommand,wUP[i][j])
				// }

				var pe = o.particleEffect(15, 5, [ Math.floor(x) + 0.5, Math.floor(y) + 0.5 ], [ 1, 1 ], [ o.aGS1DB(w.gb.color, o.aGS(w.wU, x, y)) ], [ -1, 0.1, 0.05 ], [ -1, 0.02, 0.005 ], [ 0, 1 ], [ -1, 20, 30 ]);
				o.syncToMobWrap(w, mob, pe, true);
				o.aSS(w.wU, x, y, o.aGS1DB(w.gb.breakType, o.aGS(w.wU, x, y)));
				// o.particleEffect(x,y,1,1,15,tempC,o.aGS1DC(gBColor,o.aGS(wU,x,y)),.01);

				o.aSS(w.wUDamage, x, y, 0);
			} else if (o.aGS(w.wUDamage, x, y) < 0) {
				o.aSS(w.wUDamage, x, y, 0);
			}
			o.syncToMobWrap(w, mob, o.outBlock(w, x, y), true);
		}
	}
	o.moveInWorld = function(w, tV, xSpeed, ySpeed, width, height) {
		if (xSpeed > 0) {
			if (o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, tV.x + width / 2 + xSpeed, tV.y + height / 2)) || o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, tV.x + width / 2 + xSpeed, tV.y - height / 2))) {
				xSpeed = 0;
				tV.x = Math.floor(tV.x + width / 2 + xSpeed) + 0.999 - width / 2;
			}
		} else if (xSpeed < 0) {
			if (o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, tV.x - width / 2 + xSpeed, tV.y + height / 2)) || o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, tV.x - width / 2 + xSpeed, tV.y - height / 2))) {
				xSpeed = 0;
				tV.x = Math.floor(tV.x - width / 2 + xSpeed) + width / 2;
			}
		}
		tV.x += xSpeed;

		if (ySpeed > 0) {
			if (o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, tV.x + width / 2, tV.y + height / 2 + ySpeed)) || o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, tV.x - width / 2, tV.y + height / 2 + ySpeed))) {
				ySpeed = 0;
				tV.y = Math.floor(tV.y + height / 2 + ySpeed) + 0.999 - height / 2;
			}
		} else if (ySpeed < 0) {
			if (o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, tV.x + width / 2, tV.y - height / 2 + ySpeed)) || o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, tV.x - width / 2, tV.y - height / 2 + ySpeed))) {
				ySpeed = 0;
				tV.y = Math.floor(tV.y - height / 2 + ySpeed) + height / 2;
			}
		}
		tV.y += ySpeed;
	}
	o.removeEntityFromGridPos = function(eL, id) {
		eL.forEach(function (mob, ind) {
			if (mob.id == id) {
				eL.splice(ind, 1);
			}
		});
	}

	o.addEntityToGridPos = function(eL, mob) {
		var notFoundSelf = true;
		eL.forEach(function (tMob) {
			if (tMob.id == mob.id) {
				notFoundSelf = false;
			}
		});
		if (notFoundSelf) {
			eL.push(mob);
		}
	}

	o.removeEntityFromGridArea = function(w, x1, y1, x2, y2, id) {
		var i, j;
		x2 = Math.min(Math.max(Math.floor(x2), 0), w.wSize - 1);
		y2 = Math.min(Math.max(Math.floor(y2), 0), w.wSize - 1);
		for (i = Math.min(Math.max(Math.floor(x1), 0), w.wSize - 1); i <= x2; i++) {
			for (j = Math.min(Math.max(Math.floor(y1), 0), w.wSize - 1); j <= y2; j++) {
				o.removeEntityFromGridPos(o.aGS(w.eU, i, j), id);
			}
		}
	}

	o.addEntityToGridArea = function(w, x1, y1, x2, y2, mob) {
		var i, j;
		x2 = Math.min(Math.max(Math.floor(x2), 0), w.wSize - 1);
		y2 = Math.min(Math.max(Math.floor(y2), 0), w.wSize - 1);
		for (i = Math.min(Math.max(Math.floor(x1), 0), w.wSize - 1); i <= x2; i++) {
			for (j = Math.min(Math.max(Math.floor(y1), 0), w.wSize - 1); j <= y2; j++) {
				o.addEntityToGridPos(o.aGS(w.eU, i, j), mob);
			}
		}
	}
	o.addUniqueEntityAL = function(eL, mob) {
		eL.forEach(function (tMob) {
			if (tMob.id == mob.id) {
				return;
			}
		});
		eL.push(mob);
	}
	o.getEntitiesFromGridAreaOther = function(w, x1, y1, x2, y2, id) {
		var myReturn, tempAL, i, j, k;
		myReturn = [];
		x2 = Math.min(Math.max(Math.floor(x2), 0), w.wSize - 1);
		y2 = Math.min(Math.max(Math.floor(y2), 0), w.wSize - 1);
		for (i = Math.min(Math.max(Math.floor(x1), 0), w.wSize - 1); i <= x2; i++) {
			for (j = Math.min(Math.max(Math.floor(y1), 0), w.wSize - 1); j <= y2; j++) {
				tempAL = o.aGS(w.eU, i, j);
				for (k = 0; k < tempAL.length; k++) {
					if (tempAL[k].id != id) {
						if (w.entities.indexOf(tempAL[k]) != -1) {
							o.addUniqueEntityAL(myReturn, tempAL[k]);
						} else {
							o.removeEntityFromGridPos(tempAL, tempAL[k].id);
						}
					}
				}
			}
		}
		return myReturn;
	}
	o.mobsAt = function(w, x, y, r,/* optional */exceptid) {
		var posMobL, hitMobL;
		posMobL = o.getEntitiesFromGridAreaOther(w, x - r, y - r, x + r, y + r, exceptid);
		hitMobL = [];
		posMobL.forEach(function (mob) {
			if (mob.snap.health > 0) {
				if (o.pointDistance(x, y, mob.snap.v.x, mob.snap.v.y) <= r + mob.size * mob.hitboxScale / 2) {
					hitMobL.push(mob);
				}
			}
		});
		return hitMobL;
	}
	
	o.addGeneralBlock = function(w, i, col, solid, hard) {
		w.gb.isSolid[i] = solid;
		w.gb.color[i] = col;
		w.gb.strength[i] = hard;
	}
	o.fixConfigName = function(name){
		if(name.indexOf('.') != -1){
			name = name.substring(name.indexOf('.')+1);
			name = name.substring(name.indexOf('.')+1);
		}
		return name.replace(/_/g, " ");
	}
	return o;
}