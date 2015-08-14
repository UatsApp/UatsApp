<?php
$db_name     = 'UatsApp';
$db_user     = 'root';
$db_password = 'Uatsapp2014';
$server_url  = '127.0.0.1';

$data = json_decode(file_get_contents('php://input'));
$token = $data->{"token"};
$id = $data->{"uid"};

if ($token != null){

	$stmt = mysqli->prepare("SELECT token FROM sessions WHERE uid = '$id' AND token = '$token'")
	$stmt->execute();
	$stmt->bind_result($receivedToken);
	$stmt->fetch();
	$stmt->close();

	if($receivedToken == $token){
		$connection = mysqli_connect("127.0.0.1","$db_user","$db_password","$db_name") or die("Error " . mysqli_error($connection));

		$q = "SELECT id, username, email FROM users";

		$result = mysqli_query($connection, $q) or die("Error in Selecting " . mysqli_error($connection));

		$user = array();
		while($row =mysqli_fetch_assoc($result))
		{
			$user[] = $row;
		}
		echo json_encode($user);
		mysqli_close($connection);
	}

}


?>