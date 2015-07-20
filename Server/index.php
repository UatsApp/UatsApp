<?php session_start(); ?>

<!-- TODO:
	-modify html tags (use divs) ex:instead of <h3> tag use <div class="containerLogin">  
	-add a index.css and define a template for index.php{background, alings, etc.} (use the div classes you declared)
	-add Uatsapp logo somewhere on the page
	-facebook login....


-->


<html>

<head>
	<!--<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script>-->
	<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
	<!--<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>	-->
<link rel="stylesheet" type="text/css" href="stylesheets/index.css">

</head>

<body>

<h3><form action="action_page.php"> 
Username:<br>
<input  id = "userName" type="text" required>
<br>
Password:<br>
<input id = "userPass" type="password" required>
</form>
<a href="forgot_password.html" id = "forgot-password">Did you forget your password? </a>


<br><br>
<form>
<input type="button" value="Sign in" onClick = "submitLogin()">
<input type="submit" value="Sign up" formaction = "sign_up_page.html">

</form>  </h3>

<script type="text/javascript">


$(document).ready(function() {
			$('#forgot-password').hide();
		});


window.addEventListener('keydown',this.check,false);

	function submitLogin(){

		var user = $('#userName').val();
		var password = $('#userPass').val();
		var dataToSend = new Object();
		dataToSend.username = user;
		dataToSend.password = password;


		if(dataToSend.username && dataToSend.password){
		$.ajax({
   			type: 'POST',
   			url: 'process_user.php',
   			// dataType: "application/json; charset=utf-8",
   			contentType: "application/json",
   			xhrFields: {
         		withCredentials: true
    		},
   			data: JSON.stringify(dataToSend),                      
   			success: function (result) {

   				if(result["status"] === 1){
					window.location.href = "http://uatsapp.tk/UatsAppWebDEV/UatsApp.php";
					//alert("result[]")
					}else{
						alert(result["error"]);
						$('#forgot-password').show();
					}

   				},
   			error: function(error){

   				alert(error);
   			}
		});
	}else{
		if(dataToSend.username){
			alert("Please fill your password, retard.");
		}else{
			alert("Please fill your username, retard.");
		}
	}
}

	function check(e) {
		if(e.keyCode == 13){
    		submitLogin();
		}
	}



</script>

</form>
</body>
</html>
