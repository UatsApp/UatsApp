<?php 
session_start();
	if(isset($_SESSION['user'])){
		echo "user session set";
	}else{
		echo "user session NOT set";
		http_redirect("http://uatsapp.github.io/UatsApp/WebChat/index.php", false, HTTP_REDIRECT_PERM);
	}

?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>UatsApp Demo</title>

	<link rel="stylesheet" href="stylesheets/style.css">
	<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
</head>

<body>
	<div id="page-wrapper">
		<h1>UatsApp Demo</h1>

		<!-- <div id="status">Connecting...</div> -->

		<ul id="log"></ul>

		<form id="message-form">
			<textarea id="message" placeholder="Write your message here..."></textarea>

			<button type="button" onClick="pula();">Send Message</button>
			<button type="button" id="close">Close Connection</button>
		</form>
	</div>


<script src="fancywebsocket.js"></script>
	<script>
		var Server;

		function log( text ) {
			$log = $('#log');
			//Add text to log
			$log.append(($log.val()?"\n":'')+text);
			//Autoscroll
			$log[0].scrollTop = $log[0].scrollHeight - $log[0].clientHeight;
		}

		function send( text ) {
			Server.send( 'message', text );
		}

		$(document).ready(function() {
			log('Status: ');
			Server = new FancyWebSocket('ws://46.101.248.188:9300');

			$('#message').keypress(function(e) {
				if ( e.keyCode == 13 && this.value ) {
					log( '<li class="sent"> <span> Sent: </span>' + this.value + '</li>');
					send( this.value );

					$(this).val('');
				}
			});

			//Let the user know we're connected
			Server.bind('open', function() {
				log( "Connected." );
			});

			//OH NOES! Disconnection occurred.
			Server.bind('close', function( data ) {
				log( "Disconnected." );
			});

			//Log any messages sent from server
			Server.bind('message', function( payload ) {
				log( payload );
			});

			Server.connect();
		});
	</script>



</body>
</html>
