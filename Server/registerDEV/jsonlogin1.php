<?php
/* --------------------------- */
/*  Author : Paul Paul & Cata  */
/*  Website: uatsapp.16mb.com  */
/* --------------------------- */
header('Content-type: application/json');
include 'jsonlogin2.php';

if($success == 1){
	echo '{"success":1}';
	}else {
		echo '{"success":0,"error_message":"'.$error_message.'"}';
	}
?>