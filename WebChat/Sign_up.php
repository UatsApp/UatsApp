<?php
header('Content-type: application/json');



    foreach ($_POST as $key => $value) {
        echo "</br>";
        echo $key.":".$value;
        echo "</br>";
        

    }

if($_POST) {
    $username   = $_POST['username'];
    $password   = $_POST['password'];
    $c_password = $_POST['c_password'];
    $email = $_POST['email'];

    if($_POST['username']) {
        if ( $password == $c_password ) {
 
            $db_name     = 'u879223555_uapp';
            $db_user     = 'u879223555_jimmy';
            $db_password = 'a1s2d3f4';
            $server_url  = 'mysql.hostinger.ro';
 
            $mysqli = new mysqli('mysql.hostinger.ro', $db_user, $db_password, $db_name);
 
            /* check connection */
            if (mysqli_connect_errno()) {
                error_log("Connect failed: " . mysqli_connect_error());
                echo '{"success":0,"error_message":"' . mysqli_connect_error() . '"}';
            } else {
                $stmt = $mysqli->prepare("INSERT INTO users (username, password , email) VALUES (?, ?, ?)");
                $password = md5($password);
                $stmt->bind_param('sss', $username, $password , $email);
 
                /* execute prepared statement */
                $stmt->execute();
 
                if ($stmt->error) {error_log("Error: " . $stmt->error); }
 
                $success = $stmt->affected_rows;
 
                /* close statement and connection */
                $stmt->close();
 
                /* close connection */
                $mysqli->close();
                error_log("Success: $success");
 
                if ($success > 0) {
                    error_log("User '$username' created.");
                    echo '{"success":1}';
                } else {
                    echo '{"success":0,"error_message":"Username Exist."}';
                }
            }
        } else {
            echo '{"success":0,"error_message":"Passwords does not match."}';
        }
    } else {
        echo '{"success":0,"error_message":"Invalid Username."}';
    }
}else {
    echo '{"success":0,"error_message":"Invalid Data."}';
}
?>