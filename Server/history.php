<?php
include'db_connect.php';

$data = json_decode(file_get_contents('php://input'));
$uid 	  = $data->{"identifier"};
$connectedUser   = $data->{"loggedUsername"};
$token = $data->{"token"};
$id = $data->{"uid"};
error_log("token is : " + $token);

if($token != null){
	$mysqli = new mysqli('127.0.0.1', $db_user, $db_password, $db_name);
	$stmt = $mysqli->prepare("SELECT token FROM sessions WHERE uid = '$id' AND token = '$token'");
	$stmt->execute();
	$stmt->bind_result($receivedToken);
	$stmt->fetch();
	$stmt->close();
	error_log("sent token : "+ $token);
	error_log("received token : " + $receivedToken);

	if($receivedToken == $token){
		$response['status'] = 1;

		if($uid){
			$sql_loggedUser_ID = "SELECT id FROM users WHERE username = '$connectedUser'"; 

			$stmt = $conn->prepare($sql_loggedUser_ID);

			$stmt->execute();

			$stmt->bind_result($loggedUserID);

			$stmt->fetch();

			$stmt->close();

			$sql_crate_rel = "INSERT INTO rel (uid1, uid2) VALUES ('$loggedUserID','$uid')";
			$stmt2 = $conn->prepare($sql_crate_rel);

			$sql_getRelID = "SELECT id_r FROM rel WHERE (uid1 = '$loggedUserID' AND uid2 = '$uid') OR (uid1 = '$uid' AND uid2 = '$loggedUserID')";
			$rel_ID = $conn->prepare($sql_getRelID);

			$query = array();
			$query[]= "SELECT id_r FROM rel WHERE uid1 = '$loggedUserID' AND uid2 = '$uid';";
			$query[]= "SELECT id_r FROM rel WHERE uid1 = '$uid' AND uid2 = '$loggedUserID';";

			error_log(":(");

				$aff_rows = 0;
				foreach ($query as $current_sql) {
					$check = mysqli_query($conn, $current_sql);
					$aff_rows = $aff_rows + mysqli_affected_rows($conn);
				}

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
				$response["loggedUserID"] = $loggedUserID;//Not sure if we need this anymore
				$get_messages = "SELECT * FROM mesages WHERE id_c = '$activeConversationID' ORDER BY id DESC LIMIT 500";

				error_log("eeor");
				$hyst = array();
				$get_history = mysqli_query($conn, $get_messages);

				while ($row = mysqli_fetch_assoc($get_history)) {
					$hyst[] = $row;
				}

				$response["history"] = array_reverse($hyst);
			}

		}else{
			$response["status"] = -1000;
		}
		
	}else{
		$response["status"] = -1000;
	}

	header('Content-type: application/json');
	echo json_encode($response);
?>