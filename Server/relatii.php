<?php
//header('Content-type: application/json');
include'db_connect.php';
session_start();
$connectedUser = $_SESSION['user'];
if(isset($_POST['identifier']))
{
	$uid = $_POST['identifier'];
	//echo "muie";
	//echo $uid;
    //echo $connectedUser;
	$sql_loggedUser_ID = "SELECT id FROM users WHERE username = '$connectedUser'"; 

	$stmt = $conn->prepare($sql_loggedUser_ID);

	$stmt->bind_param('s',$connectedUser);

	$stmt->execute();

	$stmt->bind_result($loggedUserID);

	while($stmt->fetch()){
		//echo "logatu are id:".$loggedUserID;
	}
	$stmt->close();

	//error_log("muie");

	$sql_crate_rel = "INSERT INTO rel (uid1, uid2) VALUES ('$loggedUserID','$uid')";
	$stmt2 = $conn->prepare($sql_crate_rel);

	$sql_getRelID = "SELECT id_r FROM rel WHERE (uid1 = '$loggedUserID' AND uid2 = '$uid') OR (uid1 = '$uid' AND uid2 = '$loggedUserID')";
	$rel_ID = $conn->prepare($sql_getRelID);

	$get_messages = "SELECT * FROM mesages WHERE id_c = '$activeConversationID' LIMIT 2";
	//$history = $conn->prepare($get_messages);

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

		error_log("eeor");
		$hyst = array();
		$get_history = mysqli_query($conn, $get_messages);

		while ($row = mysqli_fetch_assoc($get_history)) {
			$hyst[] = $row;
		}
		

		echo json_encode($activeConversationID);
		//echo json_encode($hyst);
	}

?>