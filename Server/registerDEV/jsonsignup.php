<?php
/* --------------------------- */
/*  Author : Paul Paul         */
/*  Website: uatsapp.tk        */
/* --------------------------- */
include 'Send_Mail.php';
header('Content-type: application/json');
$data = json_decode(file_get_contents('php://input'));
$username   = $data->{"username"};
$password   = $data->{"password"};
$c_password = $data->{"c_password"};
$email 	 = $data->{"email"};
if($username) {
	if ( $password == $c_password ) {

		$db_name     = 'UatsApp';
		$db_user     = 'root';
		$db_password = 'Uatsapp2014';
		$server_url  = '127.0.0.1';

		$password = md5($password);
		$activation=md5($email.time());

		$mysqli = new mysqli('127.0.0.1', $db_user, $db_password, $db_name);

		/* check connection */
		if ($mysqli->connect_error) {
				//trigger_error('Database connection failed: '.$conn->connect_error, E_USER_ERROR);
		} else {

			$sql = "INSERT INTO users (username, password, email, activation) VALUES (?, ?, ?, ?)";
			$fbSQL = "SELECT id FROM users where username = ?";

			$stmt = $mysqli->prepare($sql);
			$stmtFB = $mysqli->prepare($fbSQL);

			if($stmt === false) {
				trigger_error('Wrong SQL: ' . $sql . ' Error: ' . $conn->error, E_USER_ERROR);
			}

			$stmt->bind_param('ssss', $username, $password, $email, $activation);
			$stmtFB->bind_param('s',$username);

			/* execute prepared statement */
			$stmt->execute();
			$stmtFB->execute();


			//if ($stmt->error) {error_log("Error: " . $stmt->error); }

			$success = $stmt->affected_rows;
			$stmtFB->bind_result($FBUserID);
			$stmtFB->fetch();

			/* close statement and connection */
			$stmt->close();
			$stmtFB->close();
			/* close connection */
			error_log("Success: $success");
			if ($success > 0) {
				$to = $email;
				$subject="Email verification";
				$base_url = "http://uatsapp.tk/registerDEV/";
				$body = '<br/> <br/> Hi '.$username.', <br/> <br/> Please verify your account, by clicking the link below, and get started using your Uatsapp.
						 <br/> <br/> <a href="'.$base_url.'activation.php?code='.$activation.'">'.$base_url.'activation.php?code='.$activation.'</a>';
				Send_Mail($to,$subject,$body);
				echo '{"success":1, "FBUserID":'.$FBUserID.'}';
			} else {
				echo '{"success":0,"error_message":"Username Exists.", "FBUserID":'.$FBUserID.'}';
			}
		}
	} else {
		echo '{"success":0,"error_message":"Passwords does not match."}';
	}
} else {
	echo '{"success":0,"error_message":"Invalid Username."}';
}




?>