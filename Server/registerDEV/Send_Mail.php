
<?php
function Send_Mail($to,$subject,$body)
{
require 'PHPMailerAutoload.php';
$from      		  = "UatsApp@no-replay.tk";
$mail       	  = new PHPMailer();
$mail->IsSMTP(true);
$mail->IsHTML(true);		
$mail->SMTPAuth   = true;        		// enable SMTP authentication					
$mail->Host       = "smtp.gmail.com";  			// SMTP host
$mail->Port       =  465;  						// set the SMTP port            	
$mail->Username   = 'paulp9426@gmail.com';  	// SMTP  username
$mail->Password   = '';  			// SMTP password
$mail->SMTPSecure = 'ssl';
//$mail->Mailer = "tsl"; 
//$mail->MsgHTML($body);
$mail->SetFrom($from, 'UatsApp Account Activation');
$mail->AddReplyTo($from,'UatsApp Account Activation');
$mail->Subject    = $subject;
$mail->MsgHTML($body);
$mail->AddAddress($to);
if(!$mail->Send()) {
		error_log( "Mailer Error: " . $mail->ErrorInfo);
		} else {
		error_log("Message sent!");
	}
}
?>