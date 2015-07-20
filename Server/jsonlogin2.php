<?php
/* --------------------------- */
/*  Author : Paul Paul         */
/*  Website: uatsapp.tk        */
/* --------------------------- */

header('Content-type: application/json');
$data = json_decode(file_get_contents('php://input'));
  	$username   = $data->{"username"};
 	$password   = $data->{"password"};

if($username) {
	// $username   = $_POST['username'];
	// $password   = $_POST['password'];
	$error_message = "";
	if($username && $password) {


			$db_name     = 'UatsApp';
			$db_user     = 'root';
			$db_password = 'Uatsapp2014';
			$server_url  = '127.0.0.1';
			

			$mysqli = new mysqli('127.0.0.1', $db_user, $db_password, $db_name);


			/* check connection */
			if (mysqli_connect_errno()) {
				$error_message = "Connect failed: ";
			//	$success = 0;
			} else {
				if ($stmt = $mysqli->prepare("SELECT username FROM users WHERE username = ? and password = ?")) {

					$password = md5($password);
				

					/* bind parameters for markers */
					$stmt->bind_param("ss", $username, $password);

					/* execute query */
					$stmt->execute();

					/* bind result variables */
					$stmt->bind_result($id);

					/* fetch value */
					$stmt->fetch();

					/* close statement */
					$stmt->close();
				}

				/* close connection */
				$mysqli->close();
				
				if ($id) {
					$success = 1;

				} else {
					$success = 0;
					$error_message = "Check your username";	

				}
			}
	} else {
		$success = 0;
		$error_message = "Invalid Username/Password.";
	}
}else {
	$success = 0;
	$error_message = "Invalid Data.";
}

?>