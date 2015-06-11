<!DOCTYPE html PUBLIC>


<head>
<title>UatsApp</title>
<link type="text/css" rel="stylesheet" href="style.css" />
</head>
 
<div id="wrapper">
    <div id="menu">
        <p class="welcome">Welcome, <b></b></p>
        <p class="logout"><a id="exit" href="#">Log Out</a></p>
        <div style="clear:both"></div>
    </div>
     
    <div id="chatbox"></div>
     
    <form name="message"  method = "post">

        <input name="usermsg" type="text" id="usermsg" size="63" />

        <input name="submitmsg" type="submit"  id="submitmsg" value="Send Muie" /> 

    </form>
</div>

</script>
<?php 
$message = $_POST['usermsg'];
echo $massage;
?>

</body>
</html>

