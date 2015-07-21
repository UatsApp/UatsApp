<?php
include'db_connect.php';

$data = json_decode(file_get_contents('php://input'));
$uid 	  = $data->{"identifier"};
$connectedUser   = $data->{"loggedUsername"};

if($uid){
	$sql_loggedUser_ID = "SELECT id FROM users WHERE username = '$connectedUser'"; 

	$stmt = $conn->prepare($sql_loggedUser_ID);

	$stmt->execute();

	$stmt->bind_result($loggedUserID);

	while($stmt->fetch()){
		//echo "logatu are id:".$loggedUserID;
	}
	$stmt->close();

	$sql_crate_rel = "INSERT INTO rel (uid1, uid2) VALUES ('$loggedUserID','$uid')";
	$stmt2 = $conn->prepare($sql_crate_rel);

	$sql_getRelID = "SELECT id_r FROM rel WHERE (uid1 = '$loggedUserID' AND uid2 = '$uid') OR (uid1 = '$uid' AND uid2 = '$loggedUserID')";
	$rel_ID = $conn->prepare($sql_getRelID);

/////////////////CHECK IF THERE IS A RELATIONSHIP//////////////
 // $query = "SELECT id_r FROM rel WHERE uid1 = '$loggedUserID' AND uid2 = '$uid';";

 // $query .= "SELECT id_r FROM rel WHERE uid1 = '$uid' AND uid2 = '$loggedUserID'";
	// $query = array();
	// $query= "SELECT id_r FROM rel WHERE ((uid1 = '$uid' AND uid2 = '$loggedUserID') OR (uid2 = '$uid' AND uid1 = '$loggedUserID'));";
	// $result = mysqli_query($conn, $query);
	// $exists = false;
	// while($row = mysqli_fetch_array($result)) {
	// 	$exists = true;
	// }

	// echo $exists ? "IESTE" : "NU IESTE";
	// error_log(":(");

	
	$query = array();
	$query[]= "SELECT id_r FROM rel WHERE uid1 = '$loggedUserID' AND uid2 = '$uid';";
	$query[]= "SELECT id_r FROM rel WHERE uid1 = '$uid' AND uid2 = '$loggedUserID';";

	error_log(":(");

		$aff_rows = 0;
		foreach ($query as $current_sql) {
			$check = mysqli_query($conn, $current_sql);
			$aff_rows = $aff_rows + mysqli_affected_rows($conn);
		}
		//echo $aff_rows;

		if($aff_rows == 0){
			$stmt2->bind_param('ss',$loggedUserID,$uid);

			$stmt2->execute();

			$stmt2->close();
		}
		$rel_ID->execute();
		$rel_ID->bind_result($activeConversationID);
		$rel_ID->fetch();
		$rel_ID->close();

		$response["relation_id"] = $activeConversationID;
		$get_messages = "SELECT * FROM mesages WHERE id_c = '$activeConversationID' ORDER BY id DESC LIMIT 5";

		error_log("eeor");
		$hyst = array();
		$get_history = mysqli_query($conn, $get_messages);

		while ($row = mysqli_fetch_assoc($get_history)) {
			$hyst[] = $row;
		}
		$response["history"] = array_reverse($hyst);

		header('Content-type: application/json');
		echo json_encode($response);
	}
	?>