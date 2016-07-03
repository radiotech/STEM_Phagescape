module.exports = function(o) {
	
	o.genRect = function(w, x, y, wi, h, b) {
		var i, j;
		wi = Math.round(wi);
		h = Math.round(h);
		x = Math.round(x);
		y = Math.round(y);
		for (i = 0; i < wi; i++) {
			for (j = 0; j < h; j++) {
				o.aSS(w.wU, x + i, y + j, b);
			}
		}
	}
	o.genLine = function(w, x1, y1, x2, y2, weight, b) {
		var itt, rise, run, xOff, yOff, i, j;
		itt = Math.ceil(10 * o.pointDistance(x1, y1, x2, y2));
		rise = (y2 - y1) / itt;
		run = (x2 - x1) / itt;
		xOff = 0;
		yOff = 0;
		for (i = 0; i < itt - 1; i += 1) {
			for (j = 0; j <= weight * 10; j += 2) {
				xOff = (j - weight * 5) * rise;
				yOff = (j - weight * 5) * -run;
				o.aSS(w.wU, Math.floor(x1 + xOff + i * run), Math.floor(y1 + yOff + i * rise), b);
			}
		}
		o.aSS(w.wU, Math.floor(x1), Math.floor(y1), b);
		o.aSS(w.wU, Math.floor(x2), Math.floor(y2), b);
	}
	o.genBox = function(w, x, y, wi, h, weight, b) {
		o.genLine(w, x, y, x + wi - 1, y, weight, b);
		o.genLine(w, x, y, x, y + h - 1, weight, b);
		o.genLine(w, x, y + h - 1, x + wi - 1, y + h - 1, weight, b);
		o.genLine(w, x + wi - 1, y, x + wi - 1, y + h - 1, weight, b);
	}
	o.genArc = function(w, rStart, rEnd, x, y, wi, h, weight, b) {
		var rTemp, dR, c, r, i, j;
		if (rStart > rEnd) {
			rTemp = rStart;
			rStart = rEnd;
			rEnd = rTemp;
		}
		dR = rEnd - rStart;
		c = dR / Math.floor(dR * Math.max(wi, h) * 10); // dR is range ->
		// range/(circumfrence of
		// arc(radians *
		// 2*max_radius *5 ->
		// 20*radius -> 20 points
		// per block)) -> gives
		// increment value
		for (i = rStart; i < rEnd; i += c) {
			r = (wi * h / 2) / Math.sqrt(Math.pow(wi * Math.cos(i), 2) + Math.pow(h * Math.sin(i), 2)) - weight / 2;
			for (j = 0; j <= weight; j += 0.2) {
				o.aSS(w.wU, Math.round(x + (r + j) * Math.cos(i)), Math.round(y + (r + j) * Math.sin(i)), b);
			}
		}
	}
	o.genRing = function(w, x, y, wi, h, weight, b) {
		o.genArc(w, 0, Math.PI * 2, x, y, wi, h, weight, b);
	}
	o.genCircle = function(w, x, y, r, b) {
		var i, j;
		for (i = 0; i < w.wSize; i++) {
			for (j = 0; j < w.wSize; j++) {
				if (o.pointDistance(i, j, x, y) < r) {
					w.wU[i][j] = b;
				}
			}
		}
	}
	o.genRoundRect = function(w, x, y, wi, h, rounding, b) {
		x = Math.round(x);
		y = Math.round(y);
		wi = Math.round(wi);
		h = Math.round(h);
		rounding = Math.round(rounding);
		o.genRect(w, x + rounding, y, wi - rounding * 2, h, b);
		o.genRect(w, x, y + rounding, wi, h - rounding * 2, b);
		o.genCircle(w, x + rounding, y + rounding, rounding, b);
		o.genCircle(w, x + wi - rounding, y + rounding, rounding, b);
		o.genCircle(w, x + rounding, y + h - rounding, rounding, b);
		o.genCircle(w, x + wi - rounding, y + h - rounding, rounding, b);
	}
	o.genRandomProb = function(w, fromb, to, prob) {
		var totProb, tRand, k, i, j;
		totProb = 0;
		for (i = 0; i < prob.length; i++) {
			totProb += prob[i];
		}
		for (i = 0; i < w.wSize; i++) {
			for (j = 0; j < w.wSize; j++) {
				if (w.wU[i][j] == fromb) {
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
	o.genFlood = function(w, x, y, b) {
		if (x >= 0 && y >= 0 && x < w.wSize && y < w.wSize) {
			var tB = o.aGS(w.wU, x, y);
			if (tB != b) {
				o.aSS(w.wU, x, y, b);
				if (o.aGS(w.wU, x + 1, y) == tB) {
					o.genFlood(w, x + 1, y, b);
				}
				if (o.aGS(w.wU, x - 1, y) == tB) {
					o.genFlood(w, x - 1, y, b);
				}
				if (o.aGS(w.wU, x, y + 1) == tB) {
					o.genFlood(w, x, y + 1, b);
				}
				if (o.aGS(w.wU, x, y - 1) == tB) {
					o.genFlood(w, x, y - 1, b);
				}
			}
		}
	}
	o.genReplace = function(w, fromb, to) {
		var i, j;
		for (i = 0; i < w.wSize; i++) {
			for (j = 0; j < w.wSize; j++) {
				if (w.wU[i][j] == fromb) {
					w.wU[i][j] = to;
				}
			}
		}
	}
	o.genReplaceNear = function(w, fromb, to, x, y, r) {
		var i, j;
		for (i = 0; i < w.wSize; i++) {
			for (j = 0; j < w.wSize; j++) {
				if (w.wU[i][j] == fromb) {
					if(o.pointDistance(x,y,i+0.5,j+0.5) <= r){
						w.wU[i][j] = to;
					}
				}
			}
		}
	}
	o.genTestPathExistsLoop = function(w, nmap, x, y, x2, y2) {
		if (x >= 0 && y >= 0 && x < w.wSize && y < w.wSize) {
			if (o.aGS(nmap, x, y) === 0) {
				if (Math.abs(x - x2) + Math.abs(y - y2) <= 1) {
					return true;
				}
				o.aSS(nmap, x, y, 1);
				var bools = false;
				if (o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, x + 1, y)) === false) {
					if (o.genTestPathExistsLoop(w, nmap, x + 1, y, x2, y2)) {
						bools = true;
					}
				}
				if (o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, x - 1, y)) === false) {
					if (o.genTestPathExistsLoop(w, nmap, x - 1, y, x2, y2)) {
						bools = true;
					}
				}
				if (o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, x, y + 1)) === false) {
					if (o.genTestPathExistsLoop(w, nmap, x, y + 1, x2, y2)) {
						bools = true;
					}
				}
				if (o.aGS1DB(w.gb.isSolid, o.aGS(w.wU, x, y - 1)) === false) {
					if (o.genTestPathExistsLoop(w, nmap, x, y - 1, x2, y2)) {
						bools = true;
					}
				}
				return bools;
			}
		}
		return false;
	}
	o.genTestPathExists = function(w, x1, y1, x2, y2) {
		var nmap, i;
		nmap = [];
		for (i = 0; i < w.wSize; i++) {
			nmap[i] = [];
			o.fillArray(nmap[i], w.wSize, 0);
		}
		return o.genTestPathExistsLoop(w, nmap, Math.floor(x1), Math.floor(y1), Math.floor(x2), Math.floor(y2));
	}
	o.genLoadMap = function(w, thisMap) {
		var pointer, i;
		pointer = 0;
		try {
			thisMap.forEach(function (line) {
				for (i = 0; i < line[1]; i++) {
					o.aSS(w.wU, pointer % w.wSize, Math.floor(pointer / w.wSize), line[0]);
					pointer++;
				}
			});
		} catch (ex) {
			console.log(ex.stack);
		}
		return true;
	}
	o.genRotateMap = function(w, deg) {
		var tempWU, i, j;
		if (deg >= 1 && deg <= 3) {
			tempWU = [];
			for (i = 0; i < w.wSize; i++) {
				tempWU[i] = [];
			}
			if (deg == 1) {
				for (i = 0; i < w.wSize; i++) {
					for (j = 0; j < w.wSize; j++) {
						tempWU[w.wSize - 1 - j][i] = w.wU[i][j];
					}
				}
			} else if (deg == 2) {
				for (i = 0; i < w.wSize; i++) {
					for (j = 0; j < w.wSize; j++) {
						tempWU[w.wSize - 1 - i][w.wSize - 1 - j] = w.wU[i][j];
					}
				}
			} else if (deg == 3) {
				for (i = 0; i < w.wSize; i++) {
					for (j = 0; j < w.wSize; j++) {
						tempWU[j][w.wSize - 1 - i] = w.wU[i][j];
					}
				}
			}
			for (i = 0; i < w.wSize; i++) {
				for (j = 0; j < w.wSize; j++) {
					w.wU[i][j] = tempWU[i][j];
				}
			}
		}
	}
	
	o.genGetBlockSpots = function(w, block){
		var i, j;
		var out = [];
		for (i = 0; i < w.wSize; i++) {
			for (j = 0; j < w.wSize; j++) {
				if(w.wU[i][j] == block){
					out.push([i,j]);
				}
			}
		}
		return out;
	}
	
	o.genPairSpots = function(spots){
		var i, j, pairNum, index, value, pairs, tempVal;
		pairs = [];
		pairNum = Math.floor(spots.length/2);
		for(i = 0; i < pairNum; i++){
			index = -1;
			value = Infinity;
			for(j = (i*2)+1; j < spots.length; j++){
				tempVal = o.pointDistance(spots[i*2][0],spots[i*2][1],spots[j][0],spots[j][1]);
				if(tempVal < value){
					value = tempVal;
					index = j;
				}
			}
			pairs.push([(spots[i*2][0]+spots[index][0])/2,(spots[i*2][1]+spots[index][1])/2]);
			spots[index] = spots[i*2+1];
		}
		return pairs;
	}
	
	return o;
}