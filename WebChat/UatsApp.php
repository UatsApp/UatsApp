<!DOCTYPE html PUBLIC>


<head>
<title>UatsApp</title>
<link type="text/css" rel="stylesheet" href="stylesheets/style.css" />
</head>
 
<div id="wrapper">
    <div id="menu">
        <p class="welcome">Welcome, <b></b></p>
        <p class="logout"><a id="exit" href="#">Log Out</a></p>
        <div style="clear:both"></div>
    </div>
     
    <div id="chatbox"></div>
     
        <input name="usermsg" type="text" id="usermsg" size="63" />
    
</div>

<script src=http://cdn.pubnub.com/pubnub.min.js></script>
<script>(function(){
var box = PUBNUB.$('chatbox'), input = PUBNUB.$('usermsg'), channel = 'chat';
PUBNUB.subscribe({
    channel  : channel,
    callback : function(text) { box.innerHTML = (''+text).replace( /[<>]/g, '' ) + '<br>' + box.innerHTML }
});
PUBNUB.bind( 'keyup', input, function(e) {
    (e.keyCode || e.charCode) === 13 && PUBNUB.publish({
        channel : channel, message : input.value, x : (input.value='')
    })
} )
})()</script>

</body>
</html>

