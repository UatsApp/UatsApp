<?php 
session_start();
//header('Content-type: application/json');
if(isset($_SESSION['user']) && isset($_SESSION['user_id'])){
	echo 'You are log in as:'.$_SESSION['user'].' with database id: '.$_SESSION['user_id'];
}else{
	echo "user session NOT set";
	http_redirect("http://uatsapp.tk/UatsAppWebDEV/index.php", false, HTTP_REDIRECT_PERM);
}
			//$connectedUser = $_SESSION['user'];

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
	<div id="page-wrapper" >
		<h1>UatsApp Demo</h1>

		<ul id="log" style = "overflow-y: scroll; overflow-x: hidden; height:30%;"></ul>

		<form id="message-form">

			<textarea id="message" placeholder="Write your message here..."></textarea>

			<button type="button" onClick="pula();">Send Message</button>
			<button type="button" id="close" onClick = "logOut()">Close Connection</button>

		</form>


	</div>

	<div id = "usersList" class = "usersList">
		<p>Full list of database users:</p>
		<ul id = "row">
			
		</ul>

	</div>


	<script src="fancywebsocket.js"></script>
	<script>
	var Server;
	var relation_id = 0;


	function getElements(attrib) {
		return document.querySelectorAll('[' + attrib + ']');
	}

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
			//$('#page-wrapper').hide();

			log('Status: ');
			Server = new FancyWebSocket('ws://46.101.248.188:9300');

			$('#message').keypress(function(e) {
				if ( e.keyCode == 13 && this.value ) {
					if(relation_id !=0){
						log( '<li class="sent"> <span><?php echo $_SESSION['user'];?>:</span>'+this.value+'</li>');
						var dataForServer = new Object();
						dataForServer.message = this.value;
						dataForServer.relation_id = relation_id;
						dataForServer.senderID = '<?php echo $_SESSION["user_id"] ?>';
						var validator = JSON.stringify(dataForServer);
						$.ajax({
							type:'POST',
							url:'insert_message.php',
							data: validator,
							error: function(data){
								alert("There was an error: " + data);

							},
							success: function(success){
								debugger;
								send(JSON.stringify(dataForServer));
							}

						});

						$(this).val('');
					}	
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
				try{
					var received_obj = JSON.parse(payload);
					$.ajax({
						type:'POST',
						url:'validate_message.php',
						data: received_obj,
						error: function(data){
							debugger;
							alert("There was an error: " + data);
							
						},
						success: function(success){
							debugger;
						//check if you should receive a message and if you have a chat windows opened with the sender
						if(success["receiver"] == '<?php echo $_SESSION["user_id"] ?>' && success["relation_id"] == window_chat.getAttribute('data-identifier')){ 
							log('<li class="received"> <span>' + success["sender_username"]+ ':</span>'+success["message"]+'</li>');

						}else{
   							//Check if you have a chat window opened and someone else sends you a message
   							if(success["receiver"] == '<?php echo $_SESSION["user_id"] ?>'){ 
   								var users = getElements("data-userid");
   								for ( var i = 0; i < users.length; i++ ) {
   									
    								//Check which user sent the message and update users list 
    								if(users[i].getAttribute('data-userid') == success["sender"]){
    									$(users[i]).data("receivedMessages",parseInt($(users[i]).data("receivedMessages")) + 1);
    									$(users[i]).text(success["sender_username"] + " " +$(users[i]).data("receivedMessages") + " new messages ");
    								}
    							}
    						}

    					}

    				}
    			});
}catch (exception){
	alert("cannot parse json");
}


});

Server.connect();
});
</script>

<script>

$(document).ready(function(){
	populateUsers();
}).on('click','#row li', function(){
	window_chat = document.getElementById('page-wrapper');
	var userid = $(this).data('userid');
	document.getElementById('log').innerHTML = "";

	$('#row li').removeClass('active');
	$(this).addClass('active');
	debugger;
	var dataForHistory = new Object();
	dataForHistory.identifier = userid;
	dataForHistory.loggedUsername = '<?php echo $_SESSION["user"]?>'; 
        	$.ajax({
        		type:'POST',
        		url:'history.php',
        		dataType:"json",
        		contentType: "application/json; charset=utf-8",
        		data: JSON.stringify(dataForHistory),
        		success: function(success){
        			relation_id = success["relation_id"];
        			jQuery.fn.reverse = [].reverse;
        			$.each(success["history"], function(key, value) {
        				console.log(value);
        				debugger;
        				window_chat.setAttribute("data-identifier", value.id_c);
        				//check who is the sender and who's the receiver
        				if(value._from == '<?php echo $_SESSION["user_id"]?>'){
        					log('<li class="sent"> <span><?php echo $_SESSION['user'];?>:</span>'+value.message.toString()+'</li>');
        				}else{
        					log('<li class="received"> <span>'+value._from+':</span>'+value.message+'</li>');//TODO get username from DB not userid
        				}

        			});
   					$('#page-wrapper').show();
   				},
   				error: function(data){
   					debugger;
   					console.log(data);
   				}

   			});



        });


function populateUsers(){
	$.getJSON('get_users.php', function(data) {

		
		listofusers = data;
		/* data will hold the php array as a javascript object */

		$.each(data, function(key, value) {
			$('#row').append('<li data-userid="'+value.id+'">' + value.username + '</li>');
			$('#row li').data("receivedMessages",0);
			$('#row li').attr("data-receivedMessages",0);
		});
	});

}

</script>



<script type="text/javascript">
function logOut(){
	window.location.href = "http://uatsapp.tk/UatsAppWebDEV/index.php";
		//disconect();
	}


	</script>

</body>
</html>
