<?php
include 'db_connect.php';

$data = json_decode(file_get_contents('php://input'));

$username   = $data->{"username"};

if($username){

	$query = "SELECT id FROM users WHERE username = '$username'";
	$stmt = $conn->prepare($query);
	$stmt->execute();
	$stmt->bind_result($uid);
	$stmt->fetch();
	$stmt->close();
	$response["loggedUseID"] = $uid;
	echo json_encode($response);
}

?>