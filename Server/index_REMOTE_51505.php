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
	<meta charset="UTF-8">
</head>

<body>

<script>
  // This is called with the results from from FB.getLoginStatus().
  function statusChangeCallback(response) {
    console.log('statusChangeCallback');
    console.log(response);
    // The response object is returned with a status field that lets the
    // app know the current login status of the person.
    // Full docs on the response object can be found in the documentation
    // for FB.getLoginStatus().
    if (response.status === 'connected') {
      // Logged into your app and Facebook.
      testAPI();
    } else if (response.status === 'not_authorized') {
      // The person is logged into Facebook, but not your app.
      //document.getElementById('status').innerHTML = 'Please log ' +
       // 'into this app.';
    } else {
      // The person is not logged into Facebook, so we're not sure if
      // they are logged into this app or not.
      //document.getElementById('status').innerHTML = 'Please log ' +
        //'into Facebook.';
    }
  }

  // This function is called when someone finishes with the Login
  // Button.  See the onlogin handler attached to it in the sample
  // code below.
  function checkLoginState() {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }

   logInWithFacebook = function() {
    FB.login(function(response) {
      if (response.authResponse) {
        alert('You are logged in & cookie set!');
        // Now you can redirect the user or do an AJAX request to
        // a PHP script that grabs the signed request from the cookie.
      } else {
        alert('User cancelled login or did not fully authorize.');
      }
    });
    return false;
  };

  window.fbAsyncInit = function() {
  FB.init({
    appId      : '1467539773539391',
    cookie     : true,  // enable cookies to allow the server to access 
                        // the session
    xfbml      : true,  // parse social plugins on this page
    version    : 'v2.0' // use version 2.0
  });

  // Now that we've initialized the JavaScript SDK, we call 
  // FB.getLoginStatus().  This function gets the state of the
  // person visiting this page and can return one of three states to
  // the callback you provide.  They can be:
  //
  // 1. Logged into your app ('connected')
  // 2. Logged into Facebook, but not your app ('not_authorized')
  // 3. Not logged into Facebook and can't tell if they are logged into
  //    your app or not.
  //
  // These three cases are handled in the callback function.

  FB.getLoginStatus(function(response) {
    statusChangeCallback(response);
  });
 
 };

  // Load the SDK asynchronously
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  // Here we run a very simple test of the Graph API after login is
  // successful.  See statusChangeCallback() for when this call is made.
  function testAPI() {
    console.log('Welcome!  Fetching your information.... ');
    FB.api('/me', function(response) {
      console.log('Successful login for: ' + response.name);
      document.getElementById('status').innerHTML =
        'Thanks for logging in, ' + response.name + '!';

       
        var user = response.name;
        alert(user);
		    var password = response.name;
		    var c_password = response.name;
    		var email = response.email;
		    var dataToSend = new Object();
		    dataToSend.username = user;
		    dataToSend.password = password;
		    dataToSend.c_password = c_password;
		    dataToSend.email = email;



		if(dataToSend.username && dataToSend.password && dataToSend.c_password && dataToSend.email){
		$.ajax({
   			type: 'POST',
   			url: 'http://uatsapp.tk/registerDEV/jsonsignup.php',
   			// dataType: "application/json; charset=utf-8",
   			contentType: "application/json",
   			data: JSON.stringify(dataToSend),                      
   			success: function (result) {
   				debugger;
   				if(result["success"] === 1 || dataToSend.email == email){
            
						window.location.href = "http://uatsapp.tk/UatsAppWebDEV/UatsApp.php";

					}else{
						alert(result["error"]);
					}

   				},
   			error: function(error){

   				alert(error);
   			}
		});
	}
    });


     	FB.logout(function(response) {
        // Person is now logged out
    });
  }
</script>

<!--
  Below we include the Login Button social plugin. This button uses
  the JavaScript SDK to present a graphical Login button that triggers
  the FB.login() function when clicked.
-->


<div id="status">
</div>

<div id="containerLogin" >
<form action="action_page.php"> 
Username:<br>
<input  id = "userName" type="text" placeholder="Username" required>
<br><br>
Password:<br>
<input id = "userPass" type="password" placeholder="Password" required>
</form>
<a href="forgot_password.html" id = "forgot-password">Did you forget your password? </a>


<br><br>
<form>
<input type="button" value="Sign in" onClick = "submitLogin()">
<input type="submit" value="Sign up" formaction = "sign_up_page.html">
<br><br>

<div id="containerLogin" >
<fb:login-button scope="public_profile,email" onlogin="checkLoginState();">
</fb:login-button>
</div>

</form> 
</div>



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