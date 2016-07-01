"use strict";
var express = require('express');
var app = express();  
var server = require('http').Server(app);  
var io = require('socket.io')(server);
var o = require("./D/coreJS/tabs.js")

o.tabs.forEach(function(tab){
	o = require("./D/coreJS/"+tab+".js")(o);
});

//var ser = require("./D/coreJS/server.js")(o);

var e = -1;

app.use(express.static(__dirname));

e = o.createEnv();
e._intervalId = setInterval(e.run, 0);
console.log("Started Environment Loop");


server.listen(8001);

io.on('connection', function(socket) {  
	socket.on("text", function (str) {
		if(!isNaN(str)){
    		o.getData(e,"[[\"NEWCONN\",\""+str+"\"]]",socket);
			//console.log("NEW CONN");
		} else {
			if(socket.worldID == undefined){	
				console.log("!!A client tried to send data without a connection, did I just crash?!!");
				socket.emit("text","NOCONN;");
			} else {
				o.getData(e[socket.worldID],str,socket);
			}
		}
    })
    socket.on('disconnect', function() {
    	o.getData(e,"[[\"DISCONN\"]]",socket);
    });
});