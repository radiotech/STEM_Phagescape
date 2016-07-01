module.exports = function(o) {
	
	o.particleEffect = function(num, emittime, pos, area, cols, sizes, speeds, shapes, lifespans) {
		var updates = "PEFFECT:" + num + ":" + emittime + ":" + pos[0] + ":" + pos[1] + ":" + area[0] + ":" + area[1] + ":";
		cols.forEach(function (col) {
			if (col != -1) {
				updates += col[0] + "," + col[1] + "," + col[2] + ",";
			} else {
				updates += "-1,-1,-1,";
			}
		});
		updates = updates.substring(0, updates.length - 1) + ":";
		sizes.forEach(function (size) {
			updates += size + ",";
		});
		updates = updates.substring(0, updates.length - 1) + ":";
		speeds.forEach(function (speed) {
			updates += speed + ",";
		});
		updates = updates.substring(0, updates.length - 1) + ":";
		shapes.forEach(function (shape) {
			updates += shape + ",";
		});
		updates = updates.substring(0, updates.length - 1) + ":";
		lifespans.forEach(function (lifespan) {
			updates += lifespan + ",";
		});
		updates = updates.substring(0, updates.length - 1) + ";";
		// o.println(updates);
		return updates;
	}
	
	o.addTip = function(w, x, y, r, str, a) {
		w.tips.push([x,y,r,str,a]);
	}
	
	return o;
}