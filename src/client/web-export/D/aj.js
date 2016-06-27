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
	$.fn.setCursorPosition = function(pos) {
	  this.each(function(index, elem) {
		if (elem.setSelectionRange) {
		  elem.setSelectionRange(pos, pos);
		} else if (elem.createTextRange) {
		  var range = elem.createTextRange();
		  range.collapse(true);
		  range.moveEnd('character', pos);
		  range.moveStart('character', pos);
		  range.select();
		}
	  });
	  return this;
	};
	this.MP = function(){return false;}
	this.isWeb = function () {return true;}
	this.D = function () {return "D/";};
	this.forceUpdateServer = function(){};
	this.setHUDHTML = function(html){
		//document.getElementById("moveMe2").style.left = rnd+'px';
		//document.getElementById("hudBody").innerHTML = html;
		$("#hudBody").html(html);
	};
	this.hud = function recurse(){
		//document.getElementById("moveMe2").style.left = rnd+'px';
		//document.getElementById("hudBody").innerHTML = html;
		if(arguments[0] == "add"){
			$(arguments[1]).append("<div id='"+arguments[2]+"' class='hudDiv'><span class='hudSpan'></span></div>");
			return "#"+arguments[2];
		}
		if(arguments[0] == "css"){
			var props = (arguments.length-2)/2;
			for(var i = 0; i < props; i++){
				$(arguments[1]).css(arguments[2+i*2],arguments[3+i*2]);
			}
		}
		if(arguments[0] == "act"){
			var proplen = (arguments.length-3)/2;
			var props = {};
			for(var i = 0; i < proplen; i++){
				props[arguments[3+i*2]] = arguments[4+i*2];
			}
			$(arguments[1]).animate(props,parseInt(arguments[2]));
		}
		if(arguments[0] == "del"){
			$(arguments[1]).animate({color: "rgba(0,0,0,0)",backgroundColor: "rgba(0,0,0,0)"},parseInt(arguments[2]),"swing",function(){$(this).remove();});
		}
		if(arguments[0] == "chatPush"){
			var $box = $("#inputBox");
			$box.stop();
			$("#hud").css("pointer-events","auto");
			$box.css("bottom","-42px");
			$("#chatInputSpan").text("")
			$("#chatInputSpan").focus();
			$box.animate({bottom: "0px", backgroundColor: "rgba(0,0,0,.9)", color: "rgba(255,255,255,1)"});
		}
		if(arguments[0] == "setupChat"){
			recurse("add","#chat","inputBox");
			var $div=$("#inputBox");
			$div.addClass("chat");
			$div.addClass("chatInput");
			$div.children("span").prop('contenteditable',true);
			$div.children("span").attr('id','chatInputSpan');
			$div.children("span").addClass('spanInput');
			//$("#chatInputSpan").focus();
			
			$div.on('keydown', function(e) {
				if (e.which == 13) {
					e.preventDefault();
					var minWid = $(this).width()+1;
					var $all = $(this).children(".chat");
					if($all.length === 0){
						var newId = "m0";
					} else {
						var newId = "m"+(parseInt(($all.attr('id')).substring(1))+1);
					}
					$(this).append("<div id='"+newId+"' class='hudDiv chat'><span class='hudSpan'>"+$(this).children("span").text()+"</span></div>");
					$(this).children("span").text("");
					$("#"+newId).append($all);
					$("#"+newId).prop('contenteditable',false);
					$("#"+newId).css("min-width",minWid);
					$(this).css("bottom","-42px");
					$("#hud").css("pointer-events","none");
					$(this).animate({color: "rgba(255,255,255,.4)",backgroundColor: "rgba(0,0,0,.4)"},1000);
					$("canvas").focus();
					//$all.remove();
					//serverOutput += "MYCHAT:0;"
				}
				if (e.which == 27) {
					$(this).animate({bottom: "-42px", color: "rgba(255,255,255,.4)",backgroundColor: "rgba(0,0,0,.4)"},1000);
					$("#hud").css("pointer-events","none");
					$("canvas").focus();
				}
				setTimeout(function(){
					if($("#chatInputSpan").width() > 400){
						var $box = $("#chatInputSpan"), btxt = $box.text();
						$box.text(btxt.substring(0,btxt.length-1));
					}
				}, 5);
				
			});
		}
		if(arguments[0] == "class"){
			$(arguments[1]).addClass(arguments[2]);
		}
		if(arguments[0] == "text"){
			$(arguments[1]).children('span').text(arguments[2]);
		}
		if(arguments[0] == "focus"){
			$(arguments[1]).focus();
		}
		
	};
	this.sendData = function (str) {
		
		if(this.MP()){
			//connection.send("con");
			//console.log("Emit")
			
				
				if(socket.live == -1){
					
					socket.live = 1;
					socket = io.connect('/');
					socket.on('text', function(data) {
						outputFun(0,data);
					});
					
				} else {
					socket.emit("text",str);
					return "Sent data";
				}
				
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