<?php session_start() ?>
<html>
<body>

<STYLE type="text/css">
  H3 { text-align: center}
</STYLE>

<head>
	<!--<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script>-->
	<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
	<!--<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>	-->
</head>

<h3><form action="action_page.php"> 
Username:<br>
<input  id = "userName" type="text" required>
<br>
Password:<br>
<input id = "userPass" type="password" required>
</form>

<a href="forgot_password.html">Did you forget your password? </a>

<br><br>
<form  method = "post">
<input type="submit" value="Sign in" onClick = "muie()">
<input type="submit" value="Sign up" formaction = "sign_up_page.html">

</form></h3>

<script type="text/javascript">
	function muie(){
		var user = $('#userName').val();
		var password = $('#userPass').val();
		//alert(user + '  ' + password);
		

		// $.post('process_user.php',{username: user,password: password},
		// 	function(data)
		// 	{	
		// 		console.log(data);
		// 		//alert(data);
		// 		if(data == 1){
		// 			window.location.href = "http://uatsapp.tk/UatsAppWebDEV/UatsApp.php";
		// 			//$( location ).attr("href", " http://uatsapp.tk/UatsAppWebDEV/UatsApp.php");
		// 		}
		// 	});

		//POST V2

		$.ajax({
   			type: 'POST',
   			url: 'process_user.php',
   			data: { username: user, password: password },                      
   			success: function (result) {
   				//alert(result);
   				if(result == 1){
					window.location.href = "http://uatsapp.github.io/UatsApp/WebChat/UatsApp.php";
					//$( location ).attr("href", " http://uatsapp.tk/UatsAppWebDEV/UatsApp.php");
					}else{
						location.reload();

					}

   				}
		});
		




	}

</script>

</form>
</body>
</html>
