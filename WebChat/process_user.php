<?php
	include '../registerDEV/jsonlogin2.php';

	session_start();


	
	if($success == 1){
		$_SESSION["user"] = $username;
	}

	echo $success;

?>