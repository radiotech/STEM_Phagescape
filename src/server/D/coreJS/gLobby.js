module.exports = function(o) {
	
	o.game[0].setup = function (w) {
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

		o.addGeneralBlock(w, 100, [ 0, 0, 250 ], false, 0); // game 0
		o.addGeneralBlock(w, 101, [ 0, 50, 200 ], false, 0); // game 1
		o.addGeneralBlock(w, 102, [ 0, 100, 150 ], false, 0); // game 2
		o.addGeneralBlock(w, 103, [ 0, 150, 100 ], false, 0); // game 3
		o.addGeneralBlock(w, 104, [ 0, 200, 50 ], false, 0); // game 4
		o.addGeneralBlock(w, 105, [ 0, 250, 0 ], false, 0); // game 5
		
		//o.addTip(w, 46.5, 46.5, 10, "This is a server-hosted popup box!", 0.5);

		g.setupLobby(w);
		o.genRandomProb(w, 15, [ 4, 6, 15, 5, 10 ], [ 8, 4, 200, 1, 1 ]);

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
			player.listJumps.push("s.v.x -= " + dimensionOffset.x + "; s.v.y -= " + dimensionOffset.y + "; o.goToWorldId(w," + g.getLobbyId(w.dimension, wing, -1, -1) + ",mob.src);");
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
				player.listJumps.push("s.v.x -= " + dimensionOffset2.x + "; s.v.y -= " + dimensionOffset2.y + "; o.goToWorldId(w," + g.getLobbyId(w.dimension, w.wing, hall, 0) + ",mob.src);");
			} else {
				player.listJumps.push("s.v.x += " + dimensionOffset.x + "; s.v.y += " + dimensionOffset.y + "; o.goToWorldId(w," + g.getLobbyId(w.dimension, -1, -1, -1) + ",mob.src);");
			}
		} else if (w.level == 2) {
			hall = w.hall;
			if (o.pointDistance(50 - 8 * Math.cos((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1), 50 - 8 * Math.sin((w.wing - 2) * (Math.PI / 4)) * (w.hall % 2 * 2 - 1), player.snap.v.x, player.snap.v.y) > 15) {
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
			player.listJumps.push("o.goToWorldId(w," + g.getLobbyId(w.dimension, w.wing, hall, room) + ",mob.src);");
		}
	};
	o.game[0].setupLobby = function (w) {
		var i, dir, flip, width, space, shift;
		if (w.level == 0) {
			o.genLoadMap(w, o.mapLobbyDimension[0]);
			for(i = 0; i < 8; i++){
				dir = i*Math.PI/4;
				o.addTip(w,50+Math.cos(dir)*15,50+Math.sin(dir)*15,15.1,(w.parent.config[0][i] || {"-1":"Store"})[-1],0.5);
			}
		} else if (w.level == 1) {
			o.genLoadMap(w, o.mapLobbyWing[w.wing % 2]);
			o.genRotateMap(w, Math.floor(w.wing / 2));
			
			dir = w.wing*Math.PI/4;
			width = 8;
			space = 13;
			shift = 2;
			for(i = 0; i < 14; i++){
				flip = Math.PI/2*((i%2)*2-1);
				itt = Math.floor(i/2)
				//if(w.parent.config[0][w.wing][i*2] != undefined){
					o.addTip(w,50+Math.cos(dir)*(space*(i-3)-shift)+Math.cos(dir+flip)*width,50+Math.sin(dir)*(space*(i-3)-shift)+Math.sin(dir+flip)*width,space+2,(w.parent.config[0][w.wing][i] || {"-1":"LOCKED "+i})[-1],0.5);
				//}
				
			}
		} else if (w.level == 2) {
			o.genLoadMap(w, o.mapLobbyHall[w.wing % 2 + w.hall % 2 * 2]);
			o.genRotateMap(w, Math.floor(w.wing / 2));
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