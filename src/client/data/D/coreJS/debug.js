module.exports = function(o) {
	
	o.bits = function(str, packs) {
		return (str.length + packs) * 8;
	}

	o.println = function(str, clear) {
		var i;
		try {
			if (clear == true) {
				for (i = 0; i < 70; i++) {
					console.log("");
				}
			} else {
				console.log(str);
			}
		} catch (ex) {
			console.log(ex.stack);
		}
	}
	
	o.output = function(str, ticks) {
		o.outputText.push(str);
		if (ticks == undefined) {
			o.outputTick.push(o.globalE.tick + 500);
		} else {
			o.outputTick.push(o.globalE.tick + ticks);
		}
	}
	
	return o;
}