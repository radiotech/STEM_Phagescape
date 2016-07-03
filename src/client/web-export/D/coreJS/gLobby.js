module.exports = function(o) {
	
	o.game[0].setup = function (w) {
		var i;
		var g = o.game[0];
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

		o.addGeneralBlock(w, 0, [ 100, 0, 0 ], false, 0); // background

		o.addGeneralBlock(w, 1, [ 255, 255, 190 ], true, -1); // bone1
		o.addGeneralBlock(w, 2, [ 255, 255, 170 ], true, -1); // bone2
		o.addGeneralBlock(w, 3, [ 255, 255, 210 ], true, -1); // bone3

		o.addGeneralBlock(w, 6, [ 230, 0, 0 ], true, 5); // rock1
		o.addGeneralBlock(w, 5, [ 200, 0, 0 ], true, 7); // rock2
		o.addGeneralBlock(w, 4, [ 260, 0, 0 ], true, 3); // rock3

		o.addGeneralBlock(w, 10, [ 0, 255, 0 ], true, 10); // question

		o.addGeneralBlock(w, 15, [ 100, 0, 0 ], false, 0); // broken

		o.addGeneralBlock(w, 18, [ 150, 250, 100 ], false, 0); // door
		o.addGeneralBlock(w, 19, [ 255, 150, 150 ], true, -1); // door frame

		o.addGeneralBlock(w, 20, [ 150, 50, 50 ], false, 0); // spawn area

		o.addGeneralBlock(w, 99, [ 0, 0, 0 ], false, 0); // darkness

		 // game 0
		for(i = 0; i < 20; i++){
			o.addGeneralBlock(w, 100+i, [ 150, 0, 250 ], false, 0);
		}
		
		//o.addTip(w, 46.5, 46.5, 10, "This is a server-hosted popup box!", 0.5);
		
		g.setupLobby(w);
		
		o.genRandomProb(w, 15, [ 4, 5, 6, 15, 10 ], [ 20, 5, 10, 5, 1 ]);

		w.props = [ 10, 1, 1, 0, 1 ];
		// o.aSS(w.wU,0,0,1);
	};
	o.game[0].exitRoom = function (player, w) {
		var g, checkPoint, dimensionOffset, dimensionOffset2, wing, hall, temp, room;
		g = o.game[0];
		checkPoint = {"x" : 0, "y" : 0};
		dimensionOffset = { "x" : 0, "y" : 0};
		dimensionOffset2 = {"x" : 0, "y" : 0};
		if (w.level == 0) {
			wing = o.posMod(Math.round(o.pointDir(50, 50, player.snap.v.x, player.snap.v.y) / (Math.PI * 2) * 8), 8);
			dimensionOffset.x = (63 - (wing % 2 * 10)) * Math.round(Math.cos(wing * (Math.PI / 4)));
			dimensionOffset.y = (63 - (wing % 2 * 10)) * Math.round(Math.sin(wing * (Math.PI / 4)));
			player.listJumps.push(function(){
				player.snap.v.x -= dimensionOffset.x;
				player.snap.v.y -= dimensionOffset.y;
				o.goToWorldId(w,g.getLobbyId(w.dimension, wing, -1, -1),player.src);
			});
		} else if (w.level == 1) {
			dimensionOffset.x = (63 - (w.wing % 2 * 10)) * Math.round(Math.cos(w.wing * (Math.PI / 4)));
			dimensionOffset.y = (63 - (w.wing % 2 * 10)) * Math.round(Math.sin(w.wing * (Math.PI / 4)));
			checkPoint.x = 50 - 1050 * Math.round(dimensionOffset.x / Math.abs(dimensionOffset.x + 0.01));
			checkPoint.y = 50 - 1050 * Math.round(dimensionOffset.y / Math.abs(dimensionOffset.y + 0.01));
			if (w.wing % 2 == 0) {
				hall = Math.round((o.pointDistance(checkPoint.x, checkPoint.y, player.snap.v.x, player.snap.v.y) - 1009) / 13 - 0.25);
			} else {
				hall = Math.round((o.pointDistance(checkPoint.x, checkPoint.y, player.snap.v.x, player.snap.v.y) - 1433) / 14.1667 - 0.25);
			}
			if (hall != -1) {
				temp = Math.ceil(o.posMod(o.pointDir(checkPoint.x, checkPoint.y, player.snap.v.x, player.snap.v.y), (Math.PI * 2)) - (Math.PI / 4) * w.wing);
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
				player.listJumps.push(function(){
					player.snap.v.x -= dimensionOffset2.x;
					player.snap.v.y -= dimensionOffset2.y;
					o.goToWorldId(w,g.getLobbyId(w.dimension, w.wing, hall, 0),player.src);
				});
			} else {
				player.listJumps.push(function(){
					player.snap.v.x += dimensionOffset.x;
					player.snap.v.y += dimensionOffset.y;
					o.goToWorldId(w,g.getLobbyId(w.dimension, -1, -1, -1),player.src);
				});
			}
		} else if (w.level == 2) {
			hall = w.hall;
			if (o.pointDistance(50 - 8 * Math.cos((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1), 50 - 8 * Math.sin((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1), player.snap.v.x, player.snap.v.y) > 15) {
				room = w.room + 1;
				if (w.wing % 2 == 0) {
					player.listJumps.push(function(){
						player.snap.v.x += 24 * Math.cos((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1);
						player.snap.v.y += 24 * Math.sin((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1);
					});
				} else {
					player.listJumps.push(function(){
						player.snap.v.x += 20 * Math.round(Math.cos((w.wing - 2) * (Math.PI / 4))) * (w.hall % 2 * 2 - 1);
						player.snap.v.y += 20 * Math.round(Math.sin((w.wing - 2) * (Math.PI / 4))) * (w.hall % 2 * 2 - 1);
					});
				}
			} else if (w.room > 0) {
				room = w.room - 1;
				if (w.wing % 2 == 0) {
					player.listJumps.push(function(){
						player.snap.v.x -= 24 * Math.cos((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1);
						player.snap.v.y -= 24 * Math.sin((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1);
					});
				} else {
					player.listJumps.push(function(){
						player.snap.v.x -= 20 * Math.round(Math.cos((w.wing - 2) * (Math.PI / 4))) * (w.hall % 2 * 2 - 1);
						player.snap.v.y -= 20 * Math.round(Math.sin((w.wing - 2) * (Math.PI / 4))) * (w.hall % 2 * 2 - 1);
					});
				}
			} else {
				if (w.wing % 2 == 0) {
					dimensionOffset2.x = (Math.floor(w.hall / 2) - 3) * 13 * Math.cos(w.wing * (Math.PI / 4));
					dimensionOffset2.y = (Math.floor(w.hall / 2) - 3) * 13 * Math.sin(w.wing * (Math.PI / 4));
				} else {
					dimensionOffset2.x = (Math.floor(w.hall / 2) - 3) * 10 * Math.round(Math.cos(w.wing * (Math.PI / 4)));
					dimensionOffset2.y = (Math.floor(w.hall / 2) - 3) * 10 * Math.round(Math.sin(w.wing * (Math.PI / 4)));
				}
				player.listJumps.push(function(){
					player.snap.v.x += dimensionOffset2.x;
					player.snap.v.y += dimensionOffset2.y;
				});
				hall = -1;
				room = -1;
			}
			player.listJumps.push(function(){
				o.goToWorldId(w,g.getLobbyId(w.dimension, w.wing, hall, room),player.src);
			});
		}
	};
	o.game[0].setupLobby = function (w) {
		var i, dir, flip, width, space, shift, itt, tx, ty, tsx, tsy, spots, text, filler;
		if (w.level == 0) {
			o.genLoadMap(w, o.mapLobbyDimension[0]);
			for(i = 0; i < 8; i++){
				dir = i*Math.PI/4;
				o.addTip(w,50+Math.cos(dir)*15,50+Math.sin(dir)*15,15.1,o.fixConfigName((w.parent.config[w.dimension][i] || {"-1":"Store"})[-1]),0.5);
			}
		} else if (w.level == 1) {
			o.genLoadMap(w, o.mapLobbyWing[w.wing % 2]);
			o.genRotateMap(w, Math.floor(w.wing / 2));
			
			dir = w.wing*Math.PI/4;
			if(w.wing%2 == 0){
				width = 8;
				space = 13;
				shift = 2;
			} else {
				width = 9;
				space = 14.142;
				shift = 9.17;
			}
			filler = 0;
			for(itt = -1; itt < 14; itt++){
				if(itt == -1){
					flip = 0;
					i = -1.22-shift/200;
				} else {
					flip = Math.PI/2*((itt%2)*2-1);
					i = Math.floor(itt/2);
				}
				tx = 50+Math.cos(dir)*(space*(i-3)-shift)+Math.cos(dir+flip)*width;
				ty = 50+Math.sin(dir)*(space*(i-3)-shift)+Math.sin(dir+flip)*width;
				if(itt > -1){
					if(w.parent.config[w.dimension][w.wing][itt] == undefined){
						//add random stuff around
						if(filler == 1){
							tsx = 50+Math.cos(dir)*100;
							tsy = 50+Math.sin(dir)*100;
							o.genReplaceNear(w,0,15,tsx,tsy,o.pointDistance(tsx,tsy,tx,ty)+8);
						}
						filler++;
						o.genReplaceNear(w,18,1,tx,ty,4);
						o.genReplaceNear(w,19,1,tx,ty,4);
					} else {
						o.addTip(w,tx,ty,space+2,o.fixConfigName(w.parent.config[w.dimension][w.wing][itt][-1]),0.5);
					}
				} else {
					o.addTip(w,tx,ty,space+2,({"-1":"Lobby"})[-1],0.5);
				}
			}
			
		} else if (w.level == 2) {
			o.genLoadMap(w, o.mapLobbyHall[w.wing % 2 + w.hall % 2 * 2]);
			o.genRotateMap(w, Math.floor(w.wing / 2));
			
			spots = o.genPairSpots(o.genGetBlockSpots(w, 19)).sort(function(a,b){
				if(o.pointDistance(a[0],a[1],50,50) < o.pointDistance(b[0],b[1],50,50)){
					return -1;
				}
				return 1;
			});
			dir = o.pointDir(spots[0][0],spots[0][1],spots[1][0],spots[1][1]);
			tsx = (spots[0][0] + spots[1][0])/2+0.5;
			tsy = (spots[0][1] + spots[1][1])/2+0.5;
			
			if(w.wing%2 == 0){
				width = 3.5;
				space = 7;
				shift = 0;
			} else {
				width = 3;
				space = 7.071;
				shift = 0.19;
			}
			for(itt = -2; itt < 6; itt++){
				if(itt == -2){
					flip = 0;
					i = -1.29-shift;
				} else if(itt == -1){
					flip = 0;
					i = 2.29+shift*1.8;
				} else {
					flip = Math.PI/2*((itt%2)*2-1);
					i = Math.floor(itt/2);
				}
				tx = tsx+Math.cos(dir)*(space*(i-1))+Math.cos(dir+flip)*width;
				ty = tsy+Math.sin(dir)*(space*(i-1))+Math.sin(dir+flip)*width;
				//if(w.parent.config[w.dimension][w.wing][i*2] != undefined){
				if(itt > -1){
					if(w.parent.config[w.dimension][w.wing][w.hall][w.room]["Games"][itt] == undefined){
						o.aSS(w.wU,tx,ty,10);
					} else {
						o.addTip(w,Math.floor(tx)+0.5,Math.floor(ty)+0.5,space-1,o.fixConfigName(w.parent.config[w.dimension][w.wing][w.hall][w.room]["Games"][itt][-1]),0.5);
						o.aSS(w.wU,tx,ty,100+parseInt(w.parent.config[w.dimension][w.wing][w.hall][w.room]["Games"][itt]["Index"],10));
					}
				} else if(itt == -1){
					if(w.parent.config[w.dimension][w.wing][w.hall][w.room+1] == undefined){
						o.genReplaceNear(w,18,1,tx,ty,4);
						o.genReplaceNear(w,19,1,tx,ty,4);
					} else {
						o.addTip(w,tx,ty,space,o.fixConfigName(w.parent.config[w.dimension][w.wing][w.hall][w.room+1][-1]),0.5);
					}
					
				} else if(itt == -2){
					if(w.room == 0){
						text = w.parent.config[w.dimension][w.wing][-1];
					} else {
						text = w.parent.config[w.dimension][w.wing][w.hall][w.room-1][-1];
					}
					o.addTip(w,tx,ty,space,o.fixConfigName(text),0.5);
				}
			}
			
		}
	};
	o.game[0].getLobbyId = function (dim, wing, hall, room) {
		if (wing > -1) {
			dim += wing * 100 + 100;
		}
		if (hall > -1) {
			dim += hall * 700 + 700 + room * 9800;
		}
		return dim;
	};
	o.game[0].update = function (w) {
		var g = o.game[0];
		w.entities.forEach(function (mob) {
			if (mob.type == "player") {
				if (mob.inNewBlock) {
					if (o.aGS(w.wU, mob.snap.v.x, mob.snap.v.y) == 99) {
						g.exitRoom(mob, w);
					}
				}
			}
		});
	};
	return o;
}