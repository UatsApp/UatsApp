<?php



			$db_name     = 'UatsApp';
			$db_user     = 'root';
			$db_password = 'Uatsapp2014';
			$server_url  = '127.0.0.1';
			

		    $connection = mysqli_connect("127.0.0.1","$db_user","$db_password","$db_name") or die("Error " . mysqli_error($connection));

		    $q = "SELECT id, username, email FROM users";

		    $result = mysqli_query($connection, $q) or die("Error in Selecting " . mysqli_error($connection));

		    $uzar = array();
   			 while($row =mysqli_fetch_assoc($result))
    		{
  			      $uzar[] = $row;
   			}
   			echo json_encode($uzar);
   			mysqli_close($connection);

?>