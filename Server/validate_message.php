<?php
header('Content-type: application/json');
include'db_connect.php';

/*
$response_obj["relation_id"] = $id_rel;
$response_obj["message"] = $_POST['message'];
$response_obj["sender"] = $uid1;
$response_obj["receiver"] = $uid2;
$response_obj["sender_username"] = $username;
*/


if($_POST){
	error_log("muio");
	$response_obj["message"] = $_POST['message'];
	$mesaj = $_POST['message'];
	$senderID = $_POST["senderID"];
	$id_rel= $_POST["relation_id"];
	$response_obj["relation_id"] = $id_rel;
	//echo $idul_relatiei;
	$query = "SELECT uid1,uid2 FROM rel WHERE id_r = '$id_rel'";
	$stmt = $conn->prepare($query);

	$name = "SELECT username FROM users WHERE id = '$senderID'";
	$stmt2 = $conn->prepare($name);


	$stmt->execute();
	$stmt->bind_result($uid1,$uid2);
	$stmt->fetch();
	$stmt->close();
	if($senderID == $uid1){
		$stmt2->execute();
		$stmt2->bind_result($username);
		$stmt2->fetch();
		$stmt2->close();
		$response_obj["sender"] = $uid1;
		$response_obj["receiver"] = $uid2;
		$response_obj["sender_username"] = $username;


	}else{
		$stmt2->execute();
		$stmt2->bind_result($username);
		$stmt2->fetch();
		$stmt2->close();
		$response_obj["sender"] = $uid2;
		$response_obj["receiver"] = $uid1;
		$response_obj["sender_username"] = $username;

	}
//	echo $response_obj;
	
	echo json_encode($response_obj);
}


?>