<?php 
session_start();
//header('Content-type: application/json');
if(isset($_SESSION['user']) && isset($_SESSION['token'])){

}else{
	echo "user session NOT set";

}


?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>UatsApp Demo</title>
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

	<!-- jQuery library -->
	<link rel="stylesheet" href="stylesheets/style.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

	<!-- Latest compiled JavaScript -->
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

	<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
</head>

<body>

	
	<p class="navbar-text" id = "profile">Signed in as <?php echo $_SESSION["user"]?></p><br>

	<div id="page-wrapper">
		<div id ="chat-div">
			<div class="chat-header">
				<h1>UatsApp Demo</h1>
				<p id = "chat-partener" class = "chat-partener"></p>
			</div>

			<ul id="log"></ul>

			<form id="message-form">

				<textarea id="message" placeholder="Write your message here..."></textarea>

				<button type="button" onClick="submitMessage();">Send Message</button>
				<button type="button" id="close" onClick = "logOut();">Close Connection</button>

			</form>
		</div>
		<div id = "usersList" class = "list-group">
			<p>Full list of database users:</p>
			<ul id = "row">
			  	
			</ul>
			
		</div>
	</div>

	

	


	<script src="fancywebsocket.js"></script>
	<script>
	//Globals
	var Server;
	var relation_id = 0;
	var userid = -1;
	var partener_username = "";
	var my_username = '<?php echo $_SESSION["user"] ?>';
	var my_id = parseInt('<?php echo $_SESSION["user_id"] ?>');
	console.log("user id:"+ my_id);
	var currentMsgFloat = -1;
	var previousMsgFloat = 2;
	var active_token = '';


	$('#page-wrapper').show();

	function handShake(){
		var data = new Object();
		data.type = "handShake";
		data.senderID = my_id;
		send(JSON.stringify(data));
	}

	function getElements(attrib) {
		return document.querySelectorAll('[' + attrib + ']');
	}

	function log( text, temp, temp2 ) {
		$log = $('#log');
			//Add text to log
			$log.append(($log.val()?"\n":'')+text);
			//Autoscroll
			$log[0].scrollTop = $log[0].scrollHeight - $log[0].clientHeight;
		}


		function logMessage(text, temp, temp2){
			$log = $('#log');
			if (temp == temp2){
				$ul = $('#log ul:last-child');
				$ul.append(text);
			}else{
				$log.append("<ul></ul>");
				$ul = $('#log ul:last-child');
				$ul.append(text);
			}
			$log[0].scrollTop = $log[0].scrollHeight - $log[0].clientHeight;
		}

		function send( text ) {
			Server.send( 'message', text );
		}

		$(document).ready(function() {

			Server = new FancyWebSocket('ws://46.101.248.188:9400');

			$('#message').keypress(function(e) {
				if ( e.keyCode == 13 && this.value) {
					submitMessage();
				}
			});

			//Call server handShake
			Server.bind('open', function() {
				handShake();
				$('#page-wrapper').show();
			});

			//Disconnection occurred.
			Server.bind('close', function( data ) {
				alert("You've been disconnected from the server");
			});

			//Received a new message
			Server.bind('message', function( payload ) {
				try{
					debugger;
					var received_obj = JSON.parse(payload);
					currentMsgFloat = 0;
					console.log("received:::::" + JSON.stringify(received_obj));
					
					switch(received_obj["type"]){
						case "handShake":
							var users = getElements("data-userid");
   							$('[data-userid="'+received_obj["senderID"] +'"]').find('#online-status').show();
							break;
							
						case "online-status":
							var users = getElements("data-userid");
								for (var j = 0; j<received_obj["online-users"].length ; j++){
									$('[data-userid="'+received_obj["online-users"][j] +'"]').find('#online-status').show();
								}
							break;
							
						case "msg":
							if(received_obj["relation_id"] == window_chat.getAttribute('data-identifier') && window_chat.getAttribute('data-identifier') != 0){ 
								if($('#log ul:last-child li:last-child').hasClass("received")){
									previousMsgFloat = 0;
								}else{
									previousMsgFloat = 1;
								}
							logMessage('<li class="received">'+received_obj["message"]+'</li>',currentMsgFloat, previousMsgFloat);

							}else{
   							//Check if you have a chat window opened and someone else sends you a message
   								var users = getElements("data-userid");
   								for ( var i = 0; i < users.length; i++ ) {
    								//Check which user sent the message and update users list 
    								if(users[i].getAttribute('data-userid') == received_obj["senderID"]){
    									var msgNumber = parseInt($(users[i]).data("receivedMessages")) + 1;
										$(users[i]).find('span').remove();
    									$(users[i]).append('<span class="badge">'+msgNumber+'</span>');
    									$(users[i]).data("receivedMessages",parseInt($(users[i]).data("receivedMessages")) + 1);
    								}
    							}
    						}
							break;
							
						case "clientDisconnected":
							$('[data-userid="' + received_obj["clientID"] + '"]').find('#online-status').hide();
							break;
					}
    				}catch (exception){
}


});

Server.connect();
});

function submitMessage(){
	var msg = document.getElementById('message');
	debugger;
	text = msg.value.replace(/[\n\t\r]/g,"");
	currentMsgFloat = 0;
	if(relation_id !=0 && text != ""){
		if($('#log ul:last-child li:last-child').hasClass("sent")){
			previousMsgFloat = 0;
		}else{
			previousMsgFloat = 1;
		}
		logMessage('<li class="sent"> '+text+'</li>',currentMsgFloat, previousMsgFloat);
		debugger;
		var dataForServer = new Object();
		dataForServer.message = text;
		dataForServer.relation_id = relation_id;
		dataForServer.senderID = my_id;
		dataForServer.token = active_token;
		$.ajax({
			type:'POST',
			url:'insert_message.php',
			contentType:'application/json; charset=utf-8',
			dataType:'json',
			data: JSON.stringify(dataForServer),
			error: function(data){
				console.log("There was an error while inserting the message in DB: " + data);
			},
			success: function(success){
				debugger;
				if(success["status"] == 1){
					var dataToSend = new Object();
					dataToSend.type = "msg";
					dataToSend.message = text;
					dataToSend.relation_id = relation_id;
					dataToSend.senderID = my_id;
					dataToSend.receiverID = userid;
					dataToSend.sender_username = my_username;
					
					send(JSON.stringify(dataToSend));

				}else{
					alert("You've been disconnected");
					var callObject = new Object();
					callObject.invalidator = active_token;
					callObject.id = my_id; 
					$.ajax({
						type:"POST",
						url:'http://uatsapp.tk/registerDEV/invalidate.php',
						dataType:"json",
						ContentType:"application/json; charset=utf-8",
						data: JSON.stringify(callObject),
						success: function(response){
							if(response["status"] == 1){
								window.location.href = "index.php";
							}
						}
					});
				}
				

				
			}

		});
		document.getElementById('message').value = "";

	}	

}


$(document).ready(function(){
	active_token = '<?php echo $_SESSION["token"] ?>' ;
	if(active_token == ""  || isNaN(my_id)){
		window.location.href = "index.php";
	}
	console.log("token : " + active_token);
	populateUsers();
	window_chat = document.getElementById('page-wrapper');
}).on('click','#row a', function(){
	partener_username = $(this).data("username");
	document.getElementById('chat-partener').innerHTML = partener_username;
	userid = $(this).data('userid');
	$(this).data("receivedMessages",0);
	
	$(this).find('span').remove();
	document.getElementById('log').innerHTML = "";

	$('#row a').removeClass('active');
	$(this).addClass('active');
	var dataForHistory = new Object();
	dataForHistory.identifier = userid;
	dataForHistory.loggedUsername = my_username; 
	dataForHistory.token = active_token;
	dataForHistory.uid = my_id;
	previousMsgFloat = -1;
	console.log(JSON.stringify(dataForHistory));
	$.ajax({
		type:'POST',
		url:'history.php',
		dataType:"json",
		contentType: "application/json; charset=utf-8",
		data: JSON.stringify(dataForHistory),
		success: function(success){
			if(success["status"] == 1){
				debugger;
				window_chat.setAttribute("data-identifier", success["relation_id"]);
				relation_id = success["relation_id"];
				jQuery.fn.reverse = [].reverse;
				$.each(success["history"], function(key, value) {
					console.log(value);
        				//check who is the sender and who's the receiver
        				if(value._from == my_id){
        					currentMsgFloat = 0;
        					logMessage('<li class="sent"> ' + value.message.toString() + '</li>',currentMsgFloat, previousMsgFloat);
        				}else{
        					currentMsgFloat = 1;
        					logMessage('<li class="received"> ' + value.message.toString() + '</li>',currentMsgFloat, previousMsgFloat);
        				}
        				previousMsgFloat = currentMsgFloat;
        			});
				$('#page-wrapper').show();
			}else{
				alert("You've been disconnected.");
				var callObject = new Object();
				callObject.invalidator = active_token;
				callObject.id = my_id; 
				$.ajax({
					type:"POST",
					url:'http://uatsapp.tk/registerDEV/invalidate.php',
					dataType:"json",
					ContentType:"application/json; charset=utf-8",
					data: JSON.stringify(callObject),
					success: function(response){
						if(response["status"] == 1){
							window.location.href = "index.php";
						}
					}
				});
			}
			
		},
		error: function(data){
			console.log("There was an error retrieving your history :::" + data);
		}

	});



});


function populateUsers(){
	debugger;
	var dataToSend = new Object();
	dataToSend.token = active_token;
	dataToSend.uid = my_id;

	$.ajax({
		type:"POST",
		url:'http://uatsapp.tk/accounts/get_users.php',
		dataType:"json",
		contentType: "application/json; charset=utf-8",
		data:JSON.stringify(dataToSend),
		success: function(response){
			if(response["status"] == 1){

				$.each(response["friends"], function(key, value) {
					$('#row').append('<a href="#" data-userid="' + value.id + '" data-username="' + value.username + '"  class="list-group-item" >' + value.username + '</a>');
					
					$('#row a').data("receivedMessages",0);
					$('#row a').attr("data-receivedMessages",0);
				});
				$('#row a').append('<img src="online_icon.png" div class = "pull-right" id = "online-status" style="width:25px;height:25px;"/>');
				$('#row a').find('#online-status').hide();
			}else{
				if(response["status"] == -1000){
					debugger;
					alert("You've been disconnected.");
					console.log("token issue");
					var callObject = new Object();
					callObject.invalidator = active_token;
					callObject.id = my_id; 
					$.ajax({
						type:"POST",
						url:'http://uatsapp.tk/registerDEV/invalidate.php',
						dataType:"json",
						ContentType:"application/json; charset=utf-8",
						data: JSON.stringify(callObject),
						success: function(response){
							if (response["status"] == 1){
								window.location.href = "index.php";
							}
						}
					});
					
				} 
			}
		},

		error: function(error){
			console.log("Call error for geting friends list.");
		}
	});		

}

function logOut(){
	debugger;
	var dataToSend = new Object();
	dataToSend.invalidator = active_token;
	dataToSend.id = my_id;
		$.ajax({
		type:"POST",
		url:'http://uatsapp.tk/registerDEV/invalidate.php',
		dataType:"json",
		contentType: "application/json; charset=utf-8",
		data:JSON.stringify(dataToSend),
		success: function(response){
			if(response["status"] == 1){
					window.location.href = "index.php";
					alert("Log out, Successful!");
				}
				else
				{
					if(response["status"] == 0){
						alert("Oops, Someting went wrong");
					}
				}
			}
		});
}



</script>

</body>
</html>
