"use strict";
/*global $, jQuery, alert, io*/

var exports = {};
var e = -1;
var serverOutput = "";
var outputFun = function (a, outs) {
	serverOutput += outs;
};
var module = {};
module.exports = {};

var o = {};

$.get( "D/coreJS/tabs.js", function( tdata ) {
  console.log("loaded tabs.js");
  eval(tdata);
  o.tabs = module.exports.tabs;
  o.tabs.forEach(function(tab){
	$.get("D/coreJS/"+tab+".js", function(data){
		console.log("loaded "+tab+".js");
		eval(data);
		o = module.exports(o);
	});
  });
});

var socket = {};
socket.live = -1;

function AJ() {
	this.MP = function () {
		return true;
	};
	this.isWeb = function () {
		return true;
	};
	this.D = function () {
		return "D/";
	};
	this.forceUpdateServer = function () {};
	this.setHUDHTML = function (html) {
		//document.getElementById("moveMe2").style.left = rnd+'px';
		//document.getElementById("hudBody").innerHTML = html;
		$("#hudBody").html(html);
	};
	this.hud = function recurse() {
		var i, j, k, size, a, ctx, props, proplen, args, $box, $div, $div2, $div3, $divId, $div2Id, $div3Id, $tip, $leaf, amNew, lastx, lasty, x, y, rx, ry, w, h, dir, dis, intervalId, intervalCount, intervalLeafId, interval;
		//document.getElementById("moveMe2").style.left = rnd+'px';
		//document.getElementById("hudBody").innerHTML = html;
		args = arguments;
		switch (args[0]) {
		case "add":
			$(args[1]).append("<div id='" + args[2] + "' class='hudDiv'><span class='hudSpan'></span></div>");
			return "#" + args[2];
		case "css":
			props = (args.length - 2) / 2;
			for (i = 0; i < props; i++) {
				$(args[1]).css(args[2 + i * 2], args[3 + i * 2]);
			}
			break;
		case "act":
			proplen = (args.length - 3) / 2;
			props = {};
			for (i = 0; i < proplen; i++) {
				props[args[3 + i * 2]] = args[4 + i * 2];
			}
			$(args[1]).animate(props, parseInt(args[2], 10));
			break;
		case "del":
			$(args[1]).animate({
				color : "rgba(0,0,0,0)",
				backgroundColor : "rgba(0,0,0,0)"
			}, parseInt(args[2], 10), "swing", function () {
				$(this).remove();
			});
			break;
		case "chatPush":
			$box = $("#inputBox");
			$box.stop();
			$("#hud").css("pointer-events", "auto");
			$("#chatInputSpan").focus();
			$(".chat-old").stop();
			$(".chat-old").animate({opacity: "1"}, 500);
			$box.animate({
				bottom : "0px",
				opacity: ".9"
			},500);
			$("#chatInputSpan").on('blur', function(){
				//$("#chatInputSpan").focus();
			});
			$("#chat").data("push",true);
			break;
		case "setupChat":
			recurse("add", "#chat", "inputBox");
			$div = $("#inputBox");
			$div.css("bottom","-101px");
			$div.addClass("chat");
			$div.addClass("chatInput");
			$div.children("span").prop('contenteditable', true);
			$div.children("span").attr('id', 'chatInputSpan');
			$div.children("span").addClass('spanInput');
			$("#chat").data("push",false);
			//$("#chatInputSpan").focus();
			$div.on('keydown', function (e) {
				var minWid, $all, newId, bott;
				if($(".splash-bg").length > 0){
					e.preventDefault();
					return;
				}
				if (e.which == 13) {
					if($(this).children("span").text().length > 0){
						e.preventDefault();
						minWid = $(this).width() + 1;
						$all = $(this).children(".chat");
						if ($all.length === 0) {
							newId = "m0";
						} else {
							newId = "m" + (parseInt(($all.attr('id')).substring(1), 10) + 1);
						}
						$(this).append("<div id='" + newId + "' class='hudDiv chat'><span class='hudSpan'>" + $(this).children("span").text() + "</span></div>");
						$(this).children("span").text("");
						$("#" + newId).append($all);
						$("#" + newId).prop('contenteditable', false);
						$("#" + newId).css("min-width", minWid);
						setTimeout(function () {
							$("#"+newId).addClass("chat-old");
							if($("#chat").data("push") == false){
								if($(".chat-old").length-$(".chat").length == -1){
									$("#inputBox").animate({opacity:"0"},500);
								} else {
									$("#"+newId).animate({opacity: "0"},500);
								}
							}
							
						}, 5000);
						$(this).css("bottom", "-"+($(this).height()+20-2)+"px");
						$("#hud").css("pointer-events", "none");
						$(".chat-old").stop();
						$(".chat-old").animate({opacity: "0"},500);
						$(this).animate({
							opacity: ".4"
						}, 500);
						$("#chatInputSpan").off('blur');
						$("canvas").focus();
						//$all.remove();
						//serverOutput += "MYCHAT:0;"
						$("#chat").data("push",false);
					} else {
						e.which = 27;
					}
				}
				if (e.which == 27) {
					e.preventDefault();
					$all = $(this).children(".chat");
					if ($all.length === 0) {
						bott = "-101px";
					} else {
						bott = "-"+($(this).height()+20-2)+"px";
					}
					$(this).children("span").text("");
					$(this).stop();
					$(".chat-old").stop();
					$(".chat-old").animate({opacity: "0"},500);
					if($(".chat-old").length-$(".chat").length == -1){
						a = "0";
					} else {
						a = ".4";
					}
					$(this).animate({
						bottom : bott,
						opacity: a
					}, 500);
					$("#hud").css("pointer-events", "none");
					$("#chatInputSpan").off('blur');
					$("canvas").focus();
					$("#chat").data("push",false);
				}
				setTimeout(function () {
					if ($("#chatInputSpan").width() > 400) {
						var $box = $("#chatInputSpan"), btxt = $box.text();
						$box.text(btxt.substring(0, btxt.length - 1));
					}
				}, 5);

			});
			break;
		case "class":
			$(args[1]).addClass(args[2]);
			break;
		case "text":
			$(args[1]).children('span').text(args[2]);
			break;
		case "focus":
			$(args[1]).css("pointer-events", "auto");
			$(args[1]).focus();
			break;
		case "splash":
			$(".splash-bg").addClass("splash-old");
			$(".splash-old").children("div").animate({
				color : "rgba(255,255,255,0)"
			}, {
				duration : 1000,
				queue : false
			});

			if (args.length > 1) {
				$divId = "splash-bg" + Math.floor(Math.random() * 10000);
				$div2Id = "splash-title" + Math.floor(Math.random() * 10000);
				$div3Id = "splash-subtitle" + Math.floor(Math.random() * 10000);
				$div = $(recurse("add", "#hud", $divId));
				$div.addClass("splash-bg");
				$div.css("background-image", "url(" + args[1] + ")");
				$div.focus();
				$div.delay(parseInt(args[4], 10)).animate({
					opacity : "1"
				}, parseInt(args[7], 10), function () {
					$(".splash-old").remove();
				});

				$div2 = $(recurse("add", "#" + $divId, $div2Id));
				$div2.children("span").text(args[2]);
				$div2.addClass("splash-title");
				if (args[3] === "") {
					$div2.css("top", "calc(45% - 40px)");
				}
				$div2.delay(parseInt(args[5], 10)).animate({
					color : "rgba(255,255,255,.95)"
				}, parseInt(args[8], 10));

				$div3 = $(recurse("add", "#" + $divId, $div3Id));
				$div3.children("span").text(args[3]);
				$div3.addClass("splash-subtitle");
				$div3.delay(parseInt(args[6], 10)).animate({
					color : "rgba(255,255,255,.95)"
				}, parseInt(args[9], 10));
			} else {
				$(".splash-old").animate({
					opacity : 0
				}, 1000, function () {
					$(".splash-old").remove();
					if(parseInt($("#inputBox").css("bottom"),10) < -1){
						$("canvas").focus();
					} else {
						recurse("chatPush");
					}
				});
			}
			break;
		case "map":
			
			size = parseInt(args[2],10);
			w = 300/size;
			ctx = $("#map-c")[0].getContext('2d');
			ctx.clearRect(0,0,300,300);
			props = JSON.parse(args[1]);
			for(i = 0; i < size; i++){
				for(j = 0; j < size; j++){
					k = j+i*size;
					ctx.fillStyle = props[k];
					ctx.fillRect(Math.floor(i*w),Math.floor(j*w),Math.floor((i+1)*w)-Math.floor(i*w),Math.floor((j+1)*w)-Math.floor(j*w));
				}
			}
			ctx.beginPath();
			ctx.arc(150,150,w/2,0,2*Math.PI,true);
			ctx.fillStyle = "rgb(255,255,255)";
			ctx.fill();
			break;
		case "mapScale":
			if(args[1] == "1"){
				$("#map").stop();
				size = ($("#hud").width()-40)*100/$("#hud").width();
				$("#map").animate({width: size+"%", height: size+"%", opacity: 0.95});
			} else {
				$("#map").stop();
				$("#map").animate({width: "190px", height: "190px", opacity: 0.5});
			}
			break;
		case "tip": //TIP, id, dir, x, y, text, fade
			if($(".splash-bg").length == 0) {
				$tip = $("#" + args[1]);
				$leaf = $("#l" + args[1]);
				amNew = false;
				if ($tip.length == 0) {
					$tip = $(recurse("add", "#tips", args[1]));
					$leaf = $(recurse("add", "#tips", "l" + args[1]));
					$tip.addClass("tip");
					$leaf.addClass("tip-leaf");
					$tip.children("span").text(args[5]);
					$leaf.children("span").remove();
					amNew = true;
				}
				lastx = $tip.data("x") || 0;
				lasty = $tip.data("y") || 0;
				x = Math.min($("#hud").width(), Math.max(0, parseFloat(args[3])));
				y = Math.min($("#hud").height(), Math.max(0, parseFloat(args[4])));
				if (x != lastx || y != lasty) {
					$tip.data("x", x).data("y", y);
					rx = x;
					ry = y;
					w = $tip.width() + 18;
					h = $tip.height() + 18;
					dir = parseFloat(args[2]);
					dis = Math.sqrt(w * w + h * h) / 2;
					x -= w / 2;
					y -= h / 2;
					x += Math.max(Math.min(Math.cos(dir) * dis, w / 2), -w / 2);
					y += Math.max(Math.min(Math.sin(dir) * dis, h / 2), -h / 2);

					if (amNew || $tip.data('dead')) {
						$tip.data('dead', false);
						$tip.css("left", x + "px").css("top", y + "px");
						$leaf.css("left", (rx - 5)).css("top", (ry - 5));
						$tip.stop();
						$leaf.stop();
						$tip.animate({
							borderColor : "rgba(0,0,0," + args[6] + ")",
							color : "rgba(0,0,0," + args[6] + ")",
							backgroundColor : "rgba(255,255,255," + args[6] + ")"
						}, {
							duration : 500,
							queue : false
						});
						$leaf.animate({
							backgroundColor : "rgba(0,0,0," + args[6] + ")"
						}, {
							duration : 500,
							queue : false
						});

						$tip.data('intervalCount', 1);
						intervalId = "#" + args[1];
						intervalCount = 0;
						intervalLeafId = "#l" + args[1];
						interval = setInterval(function () {
							if ($(intervalId).data('intervalCount') == intervalCount) {
								clearInterval(interval);
								$(intervalId).stop();
								$(intervalLeafId).stop();
								$(intervalId).animate({
									borderColor : "rgba(0,0,0,0)",
									color : "rgba(0,0,0,0)",
									backgroundColor : "rgba(255,255,255,0)"
								}, {
									duration : 500,
									queue : false,
									complete : function () {
										$(intervalId).remove();
										$(intervalLeafId).remove();
									}
								});
								$(intervalLeafId).animate({
									backgroundColor : "rgba(0,0,0,0)"
								}, {
									duration : 500,
									queue : false
								});
								$(intervalId).data('dead', true);
							} else {
								intervalCount = $(intervalId).data('intervalCount');
							}
						}, 150);
					}
					$tip.css("left", x + "px").css("top", y + "px");
					$leaf.css("left", (rx - 5)).css("top", (ry - 5));
					//$tip.animate({left: (x+"px"),top: (y+"px")},{duration: 10, queue: false, easing: "linear" })
					//$leaf.animate({left: ((rx-5)+"px"),top: ((ry-5)+"px")},{duration: 10, queue: false, easing: "linear" })
					//$tip.css("color","rgba(255,255,255,1)");
				}
				$tip.data('intervalCount', $tip.data('intervalCount') + 1);
			}
			break;
		}
	};
	this.sendData = function (str) {

		if (this.MP()) {
			//connection.send("con");
			//console.log("Emit")

			
			if (socket.live == -1) {

				socket = io.connect('/');
				socket.on('text', function (data) {
					outputFun(0, data);
				});
				socket.on('disconnect', function() {
					serverOutput = "NOCONN;";
					socket.live = -1;
				});
				socket.on('connect', function() {
					console.log("Connected!");
					socket.live = 1;
				});
				socket.on('connect_error', function() {
					console.log("Connect Error!");
					if(socket.live != 1){
						console.log("Not Connected!");
						socket.live = -1;
					}
				});

			} else if (socket.live == 1) {
				socket.emit("text", str);
				return "Sent data";
			}

		} else {
			if (!isNaN(str)) {
				if (e == -1) {
					e = o.createEnv();
					try {
						e.intervalId = setInterval(e.run, 0);
					} catch (ex) {}
					this.forceUpdateServer = e.update;

					socket.emit = outputFun;
				}
				o.getData(e, "[[\"NEWCONN\",\"" + str + "\"]]", socket);
			} else {
				if (socket.worldID < -1) {
					outputFun(0, "NOCONN;");
				} else {
					o.getData(e[socket.worldID], str, socket);
				}
			}
			return true;
		}
	};
	this.checkServer = function () { //*requestPacket*
		var content = serverOutput;
		serverOutput = "";
		return content;
	};

}
