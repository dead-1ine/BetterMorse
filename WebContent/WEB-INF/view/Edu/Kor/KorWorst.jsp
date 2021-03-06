<%@page import="java.util.Date"%>
<%@page import="javax.xml.crypto.Data"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8" />

<link rel="apple-touch-icon" sizes="76x76" href="/resources/assets/img/apple-icon.png">
<link rel="icon" type="image/png" href="/resources/assets/img/favicon.png">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>Better Morse (EngWord)</title>
<meta
	content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no'
	name='viewport' />
<!--     Fonts and icons     -->
<link href="https://fonts.googleapis.com/css?family=Montserrat:400,700,200" rel="stylesheet" />
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" rel="stylesheet">

<!-- CSS Files -->
<link href="/resources/assets/css/bootstrap.min.css" rel="stylesheet" />
<link href="/resources/assets/css/paper-dashboard.css?v=2.0.1"
	rel="stylesheet" />
<link rel="stylesheet" href="/resources/scss/Button.css">
</head>

<body>
	<div class="wrapper">
		<%@ include file="/WEB-INF/view/sidebar.jsp"%>
		<div class="main-panel">
			<!-- Navbar -->
			<nav
				class="navbar navbar-expand-lg 
					   navbar-absolute fixed-top 
					   navbar-transparent">
				<div class="container-fluid">
					<div class="navbar-wrapper">
						<div class="navbar-toggle">
							<button type="button" class="navbar-toggler" id="navbar-toggler">
								<span class="navbar-toggler-bar bar1"></span> 
								<span class="navbar-toggler-bar bar2"></span>
								<span class="navbar-toggler-bar bar3"></span>
							</button>
						</div>
						<a class="navbar-brand" href="/Home/MorseMain.do">Better Morse</a> &nbsp; <i class="nc-icon nc-spaceship"></i>
					</div>
				</div>
			</nav>
			<!-- End Navbar -->
			<!-- μΉ΄λ μμ -->
			<div class="content">
			<h2 class="ml-4 mt-4 mb-4 text-monospace text-center"> English Character </h2>
				<div class="card ml-4 mr-4">
					<div class="card-body">
						<h2 class="ml-5 mt-4 text-monospace" id="Num" style="color: #5ABB92">#1</h2>						
						<!-- μΆλ ₯λλ λ¬Έμ -->
						<h1 class="text-center text-monospace" id="Word"></h1><br><hr><br>
						
						<div class="row">
							<!-- μΆλ ₯λ λ¬Έμμ ν΄λΉνλ λͺ¨μ€λΆνΈ -->
							<div class="col-6">
								<h2 class="text-center text-monospace" id="Code"></h2>
							</div>
							<div class="col-6">
								<h2 class="ml-1 text-monospace text-center" style="color: #5ABB92" id="userInput">&nbsp;</h2>	
							</div>
						</div>
						
					</div>
				</div>
				
				<div class="ml-4 mr-4">
					<!-- SpaceBarλ₯Ό λλ₯΄λ©΄ λͺ¨μ€λΆνΈκ° μλ ₯λλ€.  -->
					<button type="submit" id="spacebar" style="border-radius: 12px; font-size: 50px; background-color: #5ABB92; height: 100px; width: 100%;"
					onmousedown="down();return false;" onmouseup="up();return false;"
					ontouchstart="down();return false;" ontouchend="up();return false;"></button>
					<!-- μΉ΄λ λ -->
				</div>
				<div id="speed" style="display: none;" class="text-monospace text-center font-weight-lighter">Speed: 8WpM &nbsp; Ratio: 9592086411.9 &nbsp; eff.Speed: 0</div>
			</div>
		</div>
	</div>
	<!--   Core JS Files   -->
	<script src="/resources/assets/js/core/jquery.min.js"></script>
	<script src="/resources/assets/js/core/popper.min.js"></script>
	<script src="/resources/assets/js/core/bootstrap.min.js"></script>
	<script
		src="/resources/assets/js/plugins/perfect-scrollbar.jquery.min.js"></script>
	<!-- Chart JS -->
	<script src="/resources/assets/js/plugins/chartjs.min.js"></script>
	<!--  Notifications Plugin    -->
	<script src="/resources/assets/js/plugins/bootstrap-notify.js"></script>
	<!-- Side bar Script -->
	<script>
		$("#navbar-toggler").on('click', function() {
			if ($(this).hasClass("toggled")) {
				$(this).removeClass("toggled");
				$("html").first().removeClass("nav-open");
			} else {
				$(this).addClass("toggled");
				$("html").first().addClass("nav-open");

			}

		})
		$("#go-bottom").click(function(){
			$('html, body').scrollTop( $(document).height() );
		});
	</script>
	<!-- Morse Audio -->
	<script>	
		var audioCtx = new (window.AudioContext || window.webkitAudioContext)();
		var oscillator = audioCtx.createOscillator();
		var biquadFilter = audioCtx.createBiquadFilter();
		var gainNode = audioCtx.createGain();
		
		var count = 0;
		
		biquadFilter.type = "lowpass";
		biquadFilter.frequency.setValueAtTime(600, audioCtx.currentTime);
		biquadFilter.Q.setValueAtTime(15, audioCtx.currentTime);
		
		oscillator.type = 'sine';
		oscillator.frequency.setValueAtTime(600, audioCtx.currentTime); // value in hertz
		
		oscillator.connect(gainNode);
		gainNode.connect(biquadFilter);
		biquadFilter.connect(audioCtx.destination);
		
		oscillator.start();
		
		gainNode.gain.value = 0;
	</script>
	<!-- Morse Functions -->
	<script>
	
	// HTML κ΄λ ¨ λ³μ
	var htmlWord = document.getElementById("Word");
	var htmlCode = document.getElementById("Code");
	var htmlNum = document.getElementById("Num"); 
	var userInput = document.getElementById("userInput");
	var space = document.getElementById("spacebar");

	// λͺ¨μ€λΆνΈ λ³μ
	var code = new Array();
	code['.-..'] = "γ±";
	code['..-.'] = "γ΄";
	code['-...'] = "γ·";
	code['...-'] = "γΉ";
	code['--'] = "γ";
	code['.--'] = "γ";
	code['--.'] = "γ";
	code['-.-'] = "γ";
	code['.--.'] = "γ";
	code['-.-.'] = "γ";
	code['-..-'] = "γ";
	code['--..'] = "γ";
	code['---'] = "γ";
	code['.---'] = "γ";
	 
	code['.'] = "γ";
	code['..'] = "γ";
	code['-'] = "γ";
	code['...'] = "γ";
	code['.-'] = "γ";
	code['-.'] = "γ";
	code['....'] = "γ";
	code['.-.'] = "γ ";
	code['--.'] = "γ‘";
	code['..-'] = "γ£";
	code['-....-'] = "γ’";
	code['--.-'] = "γ";
	code['-.--'] = "γ";
	code['.....-'] = "γ";
	code['....-'] = "γ";
	
	let alphabet = ["γ±", "γ΄", "γ·", "γΉ", "γ", "γ", "γ", "γ", "γ", "γ", "γ", "γ", "γ", "γ", 
		"γ", "γ", "γ", "γ", "γ", "γ", "γ", "γ ", "γ‘", "γ£", "γ’", "γ", "γ", "γ", "γ"];
	
	// Key -> Value
	// document.write(code['.-']);
	
	// Value -> Key
	// getKeyByValue(code, "A");
	
	// μ¬μ©μκ° μλ ₯ν λ¬Έμλ₯Ό μ μ₯νλ λ³μ
	var userAnswer = new Array();
	// νλ©΄μ μΆλ ₯λλ λ¬Έμμ λͺ¨μ€λΆνΈκ° μ μ₯λ  λ³μ 
	var translatedWord = new Array();
	// λ¬Έμ λ°°μ΄μ κ°μ μ¦κ°μν€λ©° λ³΄μ¬μ£ΌκΈ° μν λ³μ
	var indexCnt = 0;
	
	// μμλ¨κ³Ό λμμ μ μΈ
	htmlWord.innerText = alphabet[indexCnt];
	htmlCode.innerHTML = "<br>";
	htmlCode.innerText += getKeyByValue(code, alphabet[indexCnt]);
 	htmlCode.innerHTML += "<br><br>";
	
	document.onkeydown = function(evt) {
		
		evt = evt || window.event;
		
		if ("key" in evt) {
			// escκ° μλ ₯λλ©΄ μ¬μ©μκ° μλ ₯ν λ°μ΄ν°κ° μμ΄μ§κ³ ,
			// μ²μλΆν° μΈ μ μκ² λλ€.
			if (evt.key === "Escape" || evt.key === "Esc") {
				userInput.innerHTML = "<br>";
				userAnswer = new Array();
			}
			// Enterλ‘ μ¬μ©μμ μλ ₯κ°κ³Ό λ΅μ λΉκ΅νλ€.
			else if (evt.key === "Enter") {
				// Enter μ μ²μλΆν° λ€μ μλ ₯ν  μ μλλ‘ λ³μ μ΄κΈ°ν 
				spacebar.innerHTML = "&nbsp;";
				userInput.innerHTML = "<br>";
				
				indexCnt++;
				if (indexCnt > 28) {
					indexCnt = 0;
				}
				
				htmlNum.innerText = "#" + (indexCnt + 1);
				htmlWord.innerText = alphabet[indexCnt];
				htmlCode.innerHTML = "<br>";
				htmlCode.innerText += getKeyByValue(code, alphabet[indexCnt]);
				htmlCode.innerHTML += "<br><br>";
				
			
			// λ§μ§λ§μ μμ±ν λ¬Έμλ₯Ό μ κ±°νκΈ° μν ν¨μ
			} else if (evt.key === "d" || evt.key === "γ") {
				// μ μΌ λ§μ§λ§μ ν΄λΉνλ λ¬Έμ μ κ±°
				userAnswer.length = userAnswer.length - 1;
				var tempuserAnswer = userAnswer.toString().split(',');
				spacebar.innerHTML = "<br>";
				
				for (i in tempuserAnswer) {
					spacebar.innerHTML += tempuserAnswer[i] + "<br><br>";
				}

			} else if (evt.key == " ") {
				down();
			}
		}
	}
	
	// μ€νμ΄μ€λ°λ₯Ό λΌμμ λ μ€νλλ ν¨μ
	document.onkeyup = function(evt) {
		evt = evt || window.event;
		if ("key" in evt) {
			if (evt.key == " "){
				up();
			}
		} 
	}

	var time;
	var temp;
	var lastchar = "";
	var dotlength = 150;
	var avgdot = dotlength;
	var avgdash = dotlength*3;
	var idletime = new Date().getTime();
	var keydown = 0;
	var sent = 0;
	var queue = new Queue();
	var element = "";
	
	window.setInterval("checkspace();", (5 * dotlength));
	
//	<button id="spacebar" style="background-color: black; height: 100px; width: 100%;"></button>
	// ν€λ₯Ό λλ₯Ό κ²½μ° gainNodeμ μλ¦¬κ° λμ΄
	function down () {
		time = new Date().getTime();
		space.style.color = "#5ABB92";
		space.style.backgroundColor = "white";
		checkspace();
		keydown = 1;
		gainNode.gain.value = 0.1;
	}
	
	// λ°°μ΄μ valueλ₯Ό μ£Όλ©΄ keyλ₯Ό returnνκΈ° μν ν¨μ
	function getKeyByValue(object, value) {
		return Object.keys(object).find(key => object[key] === value);
	}
	
	// ν€λ₯Ό λΌμμ κ²½μ° 
	// 1. gainNodeμ μλ¦¬λ₯Ό μμ°
	// 2. time λ³μμ μ μ­ λ³μ timeκ³Ό νμ¬ μκ°μ λΊ κ°μ λ£μ
	// 3. λ§μ½ timeμ΄ dotlengthλ³΄λ€ ν¬λ€λ©΄ ->
	//	  λ³μ elementμ "-"λ₯Ό λμν¨
	// 4. timeμ΄ dotlengthλ³΄λ€ λ?λ€λ©΄ ->
	//	  λ³μ elementμ "."λ₯Ό λμ
	// 5. 
	function up () {
		space.style.backgroundColor = "#5ABB92";
		space.style.color = "white";
		
		keydown = 0;
		gainNode.gain.value = 0.0;
		time = new Date().getTime() - time;
		elements = "";
		
		if (time > dotlength) {
			element = "-";
			space.innerText += element;
			avgdash = (avgdash + time)/2;
		}
		else {
			element = ".";
			space.innerText += element;
			avgdot = (avgdot + time)/2;
		}
		lastchar += element;
		update();
		idletime = new Date().getTime();		
	}
	
	function checkspace () {
		if (keydown) { return; }
		var mytime = new Date().getTime();
		var diff = mytime - idletime;
		
		// λ§μ½ diffκ° 1000λ³΄λ€ ν¬λ©΄μ queue.getlength()κ° 0λ³΄λ€ ν¬λ€λ©΄ ->
		// text = queue.purge(), wpm = Math.round(effspeed)
		if (diff > 1000) {
			if (queue.getlength() > 0) {
				submittext(queue.purge(), Math.round(effspeed));
			}
		}
		
		if (diff > 2*dotlength) {
			if (code[lastchar]) {  
				append(code[lastchar], "userInput", lastchar);
				queue.add(code[lastchar]);
				
				// λΆνΈμ ν΄λΉνλ λ¬Έμ νλ©΄μ μΆλ ₯
		
				space.innerText = "";
			} else if (lastchar) {
				append("*", "userInput");
				queue.add('*');
			}
			
			lastchar = '';
			
			if (time - idletime > 4 * dotlength) {
				append(" ", "userInput");
				queue.add(' ');
			}
		}
	}
	
	// Func ν€λ³΄λμ μλ ₯μ λ°λΌ μΆκ°λλ λ¬Έμ
	// what: λͺ¨μ€λΆνΈμ ν΄λΉνλ λ¬Έμ, where: HTMLμ μ½μν  μμΉ, lastchar: λ¬Έμμ ν΄λΉνλ λͺ¨μ€λΆνΈ
	function append(what, where, lastchar) {
		
		if (what == " ") {
			document.getElementById(where).innerHTML += what + "<br/>";
		} else {
			count++;
			document.getElementById(where).innerHTML = "<br>";
			document.getElementById(where).innerHTML += lastchar + "<br>";
		}
		
	}
	
	function changespeed (a) {
		if (a) {
			dotlength -= 5;	
		}
		else {
			dotlength += 5;	
		}
		update();
	}
	
	function update () {
		wpm = Math.round(10*1200/dotlength)/10;
		ratio = Math.round((10 * avgdash) / avgdot)/10;
		effspeed = Math.round(10*3600/avgdash)/10;
		var x = document.getElementById('speed');
		x.innerHTML = "Speed: "+wpm+"WpM";
		x.innerHTML += "; Ratio: " + ratio;
		x.innerHTML += "; eff. Speed: " + effspeed;
	}
	
	function Queue () {
		this.content = '';
		this.tmp = '';
		this.add = function (chr) {
			this.content += chr;
		}
		this.getlength = function () {
			return this.content.length;
		}
		this.purge = function () {
			this.tmp = this.content;
			this.content = '';
			return this.tmp+ ' ';
		}
	}
	
	function submittext (text, wpm) {
	}  
</script>


</body>

</html>
