<?php

/*
$response_array["error"]
$response_array["status"]
$response_array["user_id"]
*/

session_start();
$db_name     = 'UatsApp';
$db_user     = 'root';
$db_password = 'Uatsapp2014';
$server_url  = '127.0.0.1';



$data = json_decode(file_get_contents('php://input'));
$loginType = $data->{"type"};
if($loginType == "simpleLogin"){
	$username   = $data->{"username"};
	$password   = $data->{"password"};

	$mysqli = new mysqli('127.0.0.1', $db_user, $db_password, $db_name);
	if (mysqli_connect_errno()) {

		$response_array["error"] = "Connect with DB failed";
		$response_array["status"] = 0;

	} else {

		$token = uniqid($username.time());

		$stmt = $mysqli->prepare("SELECT username,status,id FROM users WHERE username = ? and password = ?");

		if($username && $password){

			$password = md5($password);
			$stmt->bind_param("ss", $username, $password);
			$stmt->execute();
			$stmt->bind_result($id,$stat,$idfortoken);
			$stmt->fetch();
			$stmt->close();

			$update_token = $mysqli->prepare("INSERT INTO sessions(uid,token) VALUES('$idfortoken','$token')");

			if($id) {

				$response_array;
				$response_array["user_id"] = 0;

				if ($stat > 0) {

					$update_token->execute();
					$update_token->close();
					$response_array["user_id"] = $idfortoken;
					$_SESSION["user_id"] = $idfortoken;
					$response_array["token"] = $token;
					$response_array["status"] = 1;
				} else {
					$response_array["status"] = 0;
					$response_array["error"] = "Please Activate Your account!";
				}	

			}else {
				$response_array["status"] = 0;
				$response_array["error"] = "Invalid Username/Password.";
			}

		}else{
			$response_array["status"] = 0;
			$response_array["error"] = "Invalid Data.";
		}
	}


	if($response_array["status"] == 1){
		$_SESSION["user"] = $username;
		$_SESSION["token"] = $token;
	}else{
		$response_array["status"] = 0;
	}

}else{
	if($loginType == "FBLogin"){
		$username = $data->{"username"};
		$password = md5($data->{"password"});
		$c_password = $password;
		$email = $data->{"email"};
		$activation = md5($email.time());
		$token = uniqid($username.time());
		$stat = "1";

		$mysqli = new mysqli('127.0.0.1', $db_user, $db_password, $db_name);
		if (mysqli_connect_errno()) {
			$response_array["error"] = "Connect with DB failed";
			$response_array["status"] = 0;

		}else{
			$token = uniqid($username.time());
			$sql = "INSERT INTO users (username, password, email, activation, status, nickname) VALUES (?, ?, ?, ?, ?, ?)";
			$stmt = $mysqli->prepare($sql);
			$stmt->bind_param('ssssss',$username, $password, $email, $activation, $stat, $username);
			$stmt->execute();
			$success= $stmt->affected_rows;
			error_log("success = " + $success);
			$stmt->close();

				error_log("Got into get id if");
				$getID = $mysqli->prepare("SELECT id FROM users WHERE username = ? and password = ?");
				$getID->bind_param('ss', $username, $password);
				$getID->execute();
				
				$getID->bind_result($userID);
				$getID->fetch();
				error_log("user id is "+$userID);
				$getID->close();
				if($userID != null){
					$response_array["user_id"] = $userID;
					$_SESSION["user_id"] = $userID;
					$response_array["status"] = 1;
					$update_token = $mysqli->prepare("INSERT INTO sessions(uid,token) VALUES('$userID','$token')");
					$update_token->execute();
					$update_token->close();
					$response_array["token"] = $token;
					$_SESSION["token"] = $token;
					$_SESSION["user"] = $username;
				}else{
					$response_array["status"] = 0;
					$response_array["error"] = "Something went wrong.";
				}			
			
		}

	}

}

header('Content-type: application/json');
echo json_encode($response_array);

?>