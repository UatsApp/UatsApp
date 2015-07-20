<?php
	//{"message":"asda","relation_id":"5","senderID":"1"}
include'db_connect.php';

	$data = json_decode(file_get_contents('php://input'));

  	$mesaj   = $data->{"message"};
 	$id_rel    = $data->{"relation_id"};
 	$sender    = $data->{"senderID"};

 	$query = "SELECT uid1,uid2 FROM rel WHERE id_r = '$id_rel'";
	$stmt = $conn->prepare($query);

	$insert_msg = "INSERT INTO mesages (id_c, _from, _to, message) VALUES ('$id_rel',?,?,'$mesaj')";
	$insert = $conn->prepare($insert_msg);

	$stmt->execute();
	$stmt->bind_result($uid1,$uid2);
	$stmt->fetch();
	$stmt->close();
	error_log("ss");

	if($sender == $uid1){
		$insert->bind_param('ss', $uid1, $uid2);
		$insert->execute();
		$insert->close();

	}else{
		$insert->bind_param('ss', $uid2, $uid1);
		$insert->execute();
		$insert->close();
	}

	echo "string";

?>