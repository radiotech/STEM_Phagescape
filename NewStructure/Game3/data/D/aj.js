/**
 * AJIO-emulation code by AJ
 */


//var require;
//var module = {};
//var exports = module.exports = {};
//var __filename;
//var __dirname;

var ser;
var exports = {};

var e = -1;
var serverOutput = "";
var outputFun = function(a,outs){serverOutput += outs;};

var socket = {};
socket.live = -1;


function AJ() {
	this.MP = function(){return true;}
	this.isWeb = function () {return true;}
	this.D = function () {return "D/";};
	this.forceUpdateServer = function(){};
	this.sendData = function (str) {
		
		if(this.MP()){
			//connection.send("con");
			//console.log("Emit")
			if(socket.live == -1){
				socket.live = 1;
				socket =  io.connect('/');
				socket.on('text', function(data) {
					outputFun(0,data);
				});
			}
			socket.emit("text",str);
			return "Sent data";
		} else {
			if(!isNaN(str)){
				if(e == -1){
					ser = exports;
					e = ser.createEnv();
					try {
						e._intervalId = setInterval(e.run, 0);
					}catch(ex){}
					this.forceUpdateServer = e.update;
					
					socket.emit = outputFun;
				}
				ser.getData(e,"[[\"NEWCONN\",\""+str+"\"]]",socket);
			} else {
		    	if(socket.worldID < -1){
					outputFun(0,"NOCONN;");
				} else {
					ser.getData(e[socket.worldID],str,socket);
				}
			}
			return true;
		}
	}
	this.checkServer = function () { //*requestPacket*
		var content = serverOutput;
		serverOutput = "";
		return content;
	};
	
};