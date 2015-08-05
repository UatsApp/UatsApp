<?php 
session_start();
//header('Content-type: application/json');
if(isset($_SESSION['user']) && isset($_SESSION['user_id'])){
	echo 'You are log in as:'.$_SESSION['user'];
}else{
	echo "user session NOT set";

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
	<div id="page-wrapper" >
		<div class="chat-header">
		<h1>UatsApp Demo</h1>
		<p id = "status" class = "chat-partener"></p>
	</div>

		<ul id="log" style = "overflow-y: scroll; overflow-x: hidden; height:30%;"></ul>

		<form id="message-form">

			<textarea id="message" placeholder="Write your message here..."></textarea>

			<button type="button" onClick="submitMessage();">Send Message</button>
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
	//Globals
	var Server;
	var relation_id = 0;
	var userid = -1;
	var partener_username = "";
	var my_username = '<?php echo $_SESSION["user"] ?>';
	var my_id = parseInt('<?php echo $_SESSION["user_id"] ?>');
	var currentMsgFloat = -1;
 	var previousMsgFloat = 2;


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
			debugger;
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
					console.log(JSON.stringify(received_obj));
						//check if you should receive a message and if you have a chat windows opened with the sender
						if(received_obj["receiverID"] == my_id && received_obj["relation_id"] == window_chat.getAttribute('data-identifier')){ 
							if($('#log ul:last-child li:last-child').hasClass("received")){
							previousMsgFloat = 0;
						}else{
							previousMsgFloat = 1;
						}
						logMessage('<li class="received">'+received_obj["message"]+'</li>',currentMsgFloat, previousMsgFloat);

						}else{
   							//Check if you have a chat window opened and someone else sends you a message
   							if(received_obj["receiverID"] == my_id){ 
   								var users = getElements("data-userid");
   								for ( var i = 0; i < users.length; i++ ) {
   									
    								//Check which user sent the message and update users list 
    								if(users[i].getAttribute('data-userid') == received_obj["senderID"]){
    									$(users[i]).data("receivedMessages",parseInt($(users[i]).data("receivedMessages")) + 1);
    									$(users[i]).text(received_obj["sender_username"] + "\n" +$(users[i]).data("receivedMessages") + " new messages ");
    								}
    							}
    						}

    					}



}catch (exception){
	//alert("cannot parse json");
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

		var dataForServer = new Object();
		dataForServer.type = "msg";
		dataForServer.message = text;
		dataForServer.relation_id = relation_id;
		dataForServer.senderID = my_id;
		dataForServer.receiverID = userid;
		dataForServer.sender_username = my_username;

		$.ajax({
			type:'POST',
			url:'insert_message.php',
			data: JSON.stringify(dataForServer),
			error: function(data){
				console.log("There was an error while inserting the message in DB: " + data);
			},
			success: function(success){
				document.getElementById('message').value = "";
				send(JSON.stringify(dataForServer));
			}

		});

	}	

}


$(document).ready(function(){
	populateUsers();
	window_chat = document.getElementById('page-wrapper');
}).on('click','#row li', function(){
	
	partener_username = $(this).data("username");
	document.getElementById('status').innerHTML = partener_username;
	userid = $(this).data('userid');
	$(this).data("receivedMessages",0);

	$(this).text($(this).data("username"));
	document.getElementById('log').innerHTML = "";

	$('#row li').removeClass('active');
	$(this).addClass('active');
	var dataForHistory = new Object();
	dataForHistory.identifier = userid;
	dataForHistory.loggedUsername = my_username; 
	previousMsgFloat = -1;
	$.ajax({
		type:'POST',
		url:'history.php',
		dataType:"json",
		contentType: "application/json; charset=utf-8",
		data: JSON.stringify(dataForHistory),
		success: function(success){
			relation_id = success["relation_id"];
			window_chat.setAttribute("data-identifier", relation_id);
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
		},
		error: function(data){
			console.log("There was an error retrieving your history :::" + data);
		}

	});



});


function populateUsers(){
	$.getJSON('get_users.php', function(data) {

		$.each(data, function(key, value) {
			$('#row').append('<li data-userid="' + value.id + '" data-username="' + value.username + '">' + value.username + '</li>');
			$('#row li').data("receivedMessages",0);
			$('#row li').attr("data-receivedMessages",0);


		});
	});

}

function logOut(){
	window.location.href = "http://uatsapp.tk/UatsAppWeb/index.php";
}


</script>

</body>
</html>
