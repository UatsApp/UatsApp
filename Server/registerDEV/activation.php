<?php

define('DB_SERVER', '127.0.0.1');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', 'Uatsapp2014');
define('DB_DATABASE', 'UatsApp');

$connection = @mysqli_connect(DB_SERVER,DB_USERNAME,DB_PASSWORD,DB_DATABASE);

$msg='';
if(!empty($_GET['code']) && isset($_GET['code']))
{
$code=mysqli_real_escape_string($connection,$_GET['code']);
$c=mysqli_query($connection,"SELECT id FROM users WHERE activation='$code'");

if(mysqli_num_rows($c) > 0)
{
$count=mysqli_query($connection,"SELECT id FROM users WHERE activation='$code' and status='0'");

if(mysqli_num_rows($count) == 1)
{
mysqli_query($connection,"UPDATE users SET status='1' WHERE activation='$code'");
$msg="Your account is activated"; 
}
else
{
$msg ="Your account is already active, no need to activate again!";
}

}
else
{
$msg ="Wrong activation code.";
}

}
?>
<?php echo $msg; ?>