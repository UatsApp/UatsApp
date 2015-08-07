<?php

/*
$response_array["error"]
$response_array["status"]
$response_array["user_id"]
*/

session_start();

$data = json_decode(file_get_contents('php://input'));
$username   = $data->{"username"};
$password   = $data->{"password"};

$db_name     = 'UatsApp';
$db_user     = 'root';
$db_password = 'Uatsapp2014';
$server_url  = '127.0.0.1';


$mysqli = new mysqli('127.0.0.1', $db_user, $db_password, $db_name);

$stmt = $mysqli->prepare("SELECT username FROM users WHERE username = ? and password = ?");
$acc_status = $mysqli->prepare("SELECT status FROM users WHERE username = ?");

if($username){
	$acc_status->bind_param("s", $username);
	$acc_status->execute();

	$acc_status->bind_result($stat);
	$acc_status->fetch();
	$acc_status->close();
	if($stat > 0) {

		$response_array;
		$response_array["user_id"] = 0;


		if($username && $password) {
			error_log($username);
			if (mysqli_connect_errno()) {
				$response_array["error"] = "Connect with DB failed";
				$response_array["status"] = 0;
			} else {
				if ($stmt) {
					$password = md5($password);
					$stmt->bind_param("ss", $username, $password);
					$stmt->execute();
					$stmt->bind_result($id);
					$stmt->fetch();
					$stmt->close();
				}
				if ($id) {
					$response_array["status"] = 1;

				} else {
					$response_array["status"] = 0;
					$response_array["error"] = "Invalid Username/Password.";
				}	
			}
		}

	}else {
		$response_array["status"] = 0;
		$response_array["error"] = "Please Activate Your account!";
	}

}else{
	$response_array["status"] = 0;
	$response_array["error"] = "Invalid Data.";
}



//Get user id from database
if ($stmt = $mysqli->prepare("SELECT id FROM users WHERE username = ?")) {
	$stmt->bind_param("s", $username);
	$stmt->execute();
	$stmt->bind_result($id);
	$stmt->fetch();
	$stmt->close();
}
if($id){
	$_SESSION["user_id"] = $id;
	$response_array["user_id"] = $id;
}





if($response_array["status"] == 1){
	$_SESSION["user"] = $username;
}else{
	$response_array["status"] = 0;
}

header('Content-type: application/json');
echo json_encode($response_array);

?>