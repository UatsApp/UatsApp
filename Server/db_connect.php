<?php


			$db_name     = 'UatsApp';
			$db_user     = 'root';
			$db_password = 'Uatsapp2014';
			$server_url  = '127.0.0.1';
			

			$conn = new mysqli('127.0.0.1', $db_user, $db_password, $db_name);

			if($conn->connect_error){
				trigger_error('Database connection failed: '.$conn->connect_error, E_USER_ERROR);
			}

?>