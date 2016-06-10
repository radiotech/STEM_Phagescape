"use strict";
var express = require('express');
var app = express();  
var server = require('http').Server(app);  
var io = require('socket.io')(server);
var ser = require("./server.js")
var e = -1;

app.use(express.static(__dirname));

e = ser.createEnv();
e._intervalId = setInterval(e.run, 0);
console.log("Started Environment Loop");

server.listen(8001);

io.on('connection', function(socket) {  
	socket.on("text", function (str) {
		if(!isNaN(str)){
    		ser.getData(e,"[[\"NEWCONN\",\""+str+"\"]]",socket);
		} else {
	    	if(socket.worldID < 0){	
				console.log("!!Not connected to server, tried "+str+"!!");
				socket.emit("text","NOCONN;");
			} else {
				ser.getData(e[socket.worldID],str,socket);
			}
		}
    })
    socket.on('disconnect', function() {
    	ser.getData(e,"[[\"DISCONN\"]]",socket);
    });
});