<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Soapbox</title>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
<link rel="stylesheet" type="text/css" href="/static/mysoapbox.css">
<script type="text/javascript" src="/static/jquery-1.5.2.js"></script>
<script type="text/javascript" src="/static/jquery.corner.js"></script>
<!--[if IE]>-->
<style type="text/css">
.msgColor0 
{filter: 
progid:DXImageTransform.Microsoft.gradient(startColorstr='#c3ceda', 
endColorstr='#60656B');}
.msgColor1 {filter: 
progid:DXImageTransform.Microsoft.gradient(startColorstr='#A8ECA8', 
endColorstr='#456045');}
</style>
<!--<![endif]-->
<script type="text/javascript">

$(document).ready(function(){
$('.widget').corner("bevel 8px");
$('.widget_header').corner("bevel top 30px");
$('.').corner("bevel left 30px");
});

function expand(thing){
var heightz=$(thing.firstChild.nextSibling).height();
heightz=heightz+100;
if (heightz >= 63) {
  $(thing.parentNode).animate({
    height: heightz+'px'
  }, 500);
  }
$(thing.firstChild).css("display", "none");
$(thing.firstChild.nextSibling).css("display", "inline");
  thing.onclick=new Function("collapse(this);");
};

function collapse(thing){
  $(thing.parentNode).animate({
    height: '63px'
  }, 500);
  $(thing.firstChild).css("display", "inline");
$(thing.firstChild.nextSibling).css("display", "none");
  thing.onclick=new Function("expand(this);");
};




var hash;
 var getHashValue = function() {
        var arr = window.location.hash.split("#");
        var hasValue = arr[1];
        //sets default
        if (typeof hasValue == "undefined") {
            return false;
        }
        var hashLen = hasValue.indexOf("?");
        if(hashLen>0){
            hasValue = hasValue.substring(0,hashLen);
        }
        return hasValue;
    }
// hashchange listeners
var onHashChange = function(event) {
    //get hash function
    getHashValue();
    //last hash
    var lastHash = getHashValue();
    //checker
    (function watchHash() {
        hash = getHashValue();
        if (hash !== lastHash) {
            event();
            lastHash = hash;
        }
        var t = setTimeout(watchHash, 100);
    })();
} 

onHashChange(function() {
if (hash == "inbox") {loadRegisterForm();scroll(0,0);}
else if (hash == "send") {loadRegisterForm();scroll(0,0);}
else if (hash == "register") {loadRegisterForm();scroll(0,0);}
else if (hash == "privacy") {loadPrivacy();scroll(0,0);}
else if (hash == "about") {loadAbout();scroll(0,0);}
else if (hash == "public") {loadPubox(1);scroll(0,0);}
else if (hash != null) {showFullMessagePublic(hash);scroll(0,0);}
});






var Z = 20;
function changeTab(elem){
 Z += 10;
 var objElem = elem;
 elem.style.zIndex = Z;
 document.getElementById("content").style.zIndex = Z+10;
}

function ajaxRequest(){
 var activexmodes=["Msxml2.XMLHTTP", "Microsoft.XMLHTTP"]
 if (window.ActiveXObject){
  for (var i=0; i<activexmodes.length; i++){
   try{return new ActiveXObject(activexmodes[i])}
   catch(e){}
  }
 }
 else if (window.XMLHttpRequest)
  return new XMLHttpRequest()
 else
  return false
}

function showFullMessagePublic(num) {
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var replies =  jsondata[1]['replies'];
   var string = jsondata[1]['body'];
   var tags = jsondata[1]['tags'];
   var votes = jsondata[1]['score'];
var output = '<div><h2>View Message<\/h2><div class="fullMessage"><div class="msgBoxSingle"><div class="votes"><div class="uparrow" style="text-align:center;margin-top:2px">';
						output+='<a id="uplink'+idnumber+'" href="#register"><img  id="uparrow'+idnumber+'" src="/static/imgs/up.png"/> ';
					output+='<\/a><\/div><div class="numofvotes" id="score'+idnumber+'" style="text-align:center;">'+votes+'<\/div><div class="downarrow" style="text-align:center;margin-bottom:1px">';
						output+='<a id="downlink'+idnumber+'" href="#register"><img id="downarrow'+idnumber+'" src="/static/imgs/down.png"/> <\/a><\/div><\/div><div class=\"msgSpace\">';
   	output+=unescape(string);
    	output+='<\/div>';
    	output+='<div class="saveBox"><a href="#register"><img src="/static/imgs/box.png"><\/a><\/div><div class="spamButton"><a href="#register"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
output+='<div class=\"tag_in_bin_holder\" style=\"background-color:white;\"><div id=\"tagBinTitle\"><h4>tagged:<\/h4><\/div>';
var tags =  jsondata[1]['tags'];
for (var i=0; i<tags.length; i++) {
	output+= '<div class=\"public_tag_in_widget tag_in_bin\">'+tags[i][1]+'<\/div>';
}
output+= '<\/div><div style="clear:both;"><\/div><\/div><\/div><div><a href="javascript: history.go(-1);"><br>return<\/a><div id=\"commentBox\"><h3>'+replies.length+' Comments:<\/h3><\/div>';
for (var i=0; i<replies.length; i++) {
output+='<div class="replyBody"><div style="font-weight:bold">author:  ';
output+=jsondata[1]['replies'][i]['author']+'</div><br>';
var replybody=jsondata[1]['replies'][i]['body'];
output+=replybody+'<\/div>';
}
output+='<div id=\"responseBox\"><h3><a href="#register">Register with Soapbox to submit a comment!</a><\/h3><\/div><\/div>';
document.getElementById("content").innerHTML=output;
		 $('#content').uncorner();
  	 $('#content').corner("bevel 20px")
  }
  else{
   alert(mygetrequest.status);
  }
 }
}
mygetrequest.open("GET", "/json/message/" + num, true);
mygetrequest.send(null);
}

function loadSearch()
{
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id=\"pubox\"><h2>Message Search<\/h2><div style="width:100%;"><div style="float:left;"><form action="javascript:loadSearch();">Search: <input type="text" id="search_field"><input type="button" value="Submit" onclick="loadSearch()"><\/form><\/div><div id="postButton"><a href="#register">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,145);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div class="uparrow" style="text-align:center;margin-top:2px"><a href="#register"><img src="/static/imgs/up.png"/> <\/a><\/div><div class="numofvotes" style="text-align:center;">';
    	output+=votes+'<\/div><div class="downarrow" style="text-align:center;margin-bottom:1px"><a href="#register"><img src="/static/imgs/down.png"/> <\/a><\/div><\/div><a href=\"#'+idnumber+'\"><div class="msgSpace"><div id=\"msg'+idnumber+'\">';
   	output+=shortstring;
    	output+='...<\/div><\/a><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a href="#register"><img src="/static/imgs/box.png"><\/a><\/div><div class="spamButton"><a href="#register"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
   }
   output+='<\/div>';



   	output+='<\/div><\/div><br>';
  
  	 document.getElementById("content").innerHTML=output;
  	 	 $('#content').uncorner();
  	 $('#content').corner("bevel 20px");
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
data2 = JSON.stringify({"terms":[document.getElementById('search_field').value]});
mygetrequest.open("POST", "/json/search_messages/", true);
mygetrequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
mygetrequest.send("data=" + encodeURIComponent(data2));
}

function loadPubox(page)
{
changeTab(document.getElementById('puboxtab'));
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="pubox"><h2>Public Inbox<\/h2><div style="width:100%;"><div style="float:left;"><form action="javascript:loadSearch();">Search: <input type="text" id="search_field" name="publicinbox_search"><input type="submit" value="Submit"><\/form><\/div><div id="postButton"><a href="#register">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,145);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div class="uparrow" style="text-align:center;margin-top:2px">';
						output+='<a id="uplink'+idnumber+'" onclick="loadRegisterForm();"><img id="uparrow'+idnumber+'" src="/static/imgs/up.png"/> ';
					output+='<\/a><\/div><div class="numofvotes" id="score'+idnumber+'" style="text-align:center;">'+votes+'<\/div><div class="downarrow" style="text-align:center;margin-bottom:1px">';
						output+='<a id="downlink'+idnumber+'" onclick="loadRegisterForm();"><img id="downarrow'+idnumber+'" src="/static/imgs/down.png"> <\/a><\/div><\/div><div class="msgSpace" onclick="expand(this);"><div id="msg'+idnumber+'">';
   	output+=shortstring;
    	output+='... <\/div><div class=\"hiddenText\" style=\"display:none\">'+jsondata[i][1]['body']+'<div><a href=\"#'+idnumber+'\">more...<\/a><\/div><\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a href="#register"><img src="/static/imgs/box.png"><\/a><\/div><div class="spamButton"><a href="#register"><img src="/static/imgs/spambutton.png" /><\/a><\/div><\/div>';
   }
   output+='<\/div>';

	if (page > 1) {
   	output+='<\/div><\/div><br><div><a onclick="loadPubox(';
   	output+= (page-1) + ');">previous<\/a><\/div>';
   	}

   	output+='<\/div><\/div><br><div><a onclick="loadPubox(';
   	output+= (page+1) + ');">next<\/a><\/div>';
  
  	 document.getElementById("content").innerHTML=output;
  	 		 $('#content').uncorner();
  	 $('#content').corner("bevel 20px")
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("POST", "/json/public_messages/" + page, true);
mygetrequest.send(null);
}


function loadAbout() {
document.getElementById("content").innerHTML=
	"<div id=\"about\"><h2>About Soapbox<\/h2><div>SoapBox is a \"message router.\" You give us a message and tell us what kinds of people you want it to get to (age, gender, location, etc) and we route the message to a number of other users that we select (through an algorithm). You may also tag the message with things like Neighborhood Talk, Borrow, Party, etc. If people have these tags in their person tag bucket, we will most likely send it to them.<br \/><br \/>Do you want to talk to your neighbors but don't know them? Send a message with a small radius and we'll send it to people within that circle. Promote a party to just people of a certain age\/gender\/location. The applications are endless.<br \/><br \/>Each user will receive their own unique tag upon registration. Unique tags have the following property: anyone can put them in their private bucket (and therefore receive messages containing that tag), but only the creator of the tag can broadcast with it. When the user tags a message with their unique tag, the message will be sent to everyone who has the tag in their private bucket plus any other user that SoapBox believes may be interested in the message. For example, a user could send the message \“I need to borrow a wrench--live at 2419 Durant.\” They could tag the message with both \“Borrow\” and their unique tag, and instruct us to dispatch this message to people within .1 miles of them. Because it is tagged with their unique tag, it will be sent to all of their \“followers.\” In addition, the message will be sent to users in their direct vicinity because of the .1 mile radius. Thus, both their neighbors and their followers will receive the message. This feature effectively puts Twitter under our umbrella.<br \/><br \/>All features above will be available at launch (along with some others). Once Soapbox gets a significant following, we will allow users to create their own tags, and many other features! <\/div>";
		 $('#content').uncorner();
  	 $('#content').corner("bevel 20px")
}

function loadPrivacy() {
document.getElementById("content").innerHTML=
	"<div id=\"privacy\"><h2>MySoapbox.org Terms of Service<\/h2><div><p>We reserve the right to change the Terms of Use (TOU) at anytime.  It is your responsibility to check this document for updates.<\/p><p>SoapBox is an online messenger that allows user to send messages to other users based on demographics.  As a user, you will receive messages from other users based on the information that you provide SoapBox about yourself.  We want the experience of SoapBox to be as safe, fun, informative, and efficient as possible for all users.  Please help us to ensure that SoapBox remains a safe place for all everyone.<\/p><p>The personal information that you provide us with will be used for the purpose of sending you messages that SoapBox thinks you will have interest in.  Likewise, it will aid in sending your messages to the most pertinent recipients.   With measures to keep your information safe and secure, we will only share certain elements of your user data with third parties that work with us.  This will only be done to help serve you better in the service.  For example, we work with a third party company that specializes in geo-location software.  They will in no way share your information with any other party, nor will they use your information for another purpose other than assisting us in providing you with a great service.  <\/p><p>SoapBox is a community of anonymous users.  It is ignorant of the true identities and intentions of its users.  You, as a user, acknowledge that SoapBox does not pre-screen its users.  Therefore you must be cautious and prudent in your interactions with other users.  We suggest that you do not give any personal data to other users, especially about your location, age, gender, orientation, etc.  SoapBox does not control the content sent or received by its users.  We are not responsible for any offensive material that you may receive from other users.  It is your responsibility to assess the content of a message and decide how to use it.  SoapBox is not responsible for how you chose to use the content that we make available to you.  You are solely responsible for the messages that you send through SoapBox.  If you chose to meet another user through SoapBox, SoapBox is not responsible for the relationship that ensues, nor any harm that may come from the interaction.  It is your responsibility to use SoapBox with regard for your own well being.  <\/p><p>SoapBox does not own any content that you upload to us during your usage.  However, you acknowledge that SoapBox administrators may have access to view this content and may chose to hold it on our server for as long as we wish.  If you have any sensitive material that you would like to share, such as personal information or intellectual property, beware that we, the administrators of SoapBox, may view it during our normal maintenance of the site. <\/p><p>Users who misuse SoapBox in any of the following ways will have their account terminated:  1) attempting to send adult material to users who are under 18 years of age, 2) sending messages that attempt to sell retail items, or a promote a retail service, without tagging them with appropriate tags, 3) attempting to conduct illegal acts through SoapBox, 3) spamming other users with unwanted material, and 4) any other offenses that SoapBox deems unacceptable.  SoapBox has the right to terminate any and all accounts at its discretion.  <\/p><p>Under no circumstances will SoapBox be held reliable for any actions of its users, whether accidental or otherwise.  In no event shall SoapBox, or any of its creators or employees, be liable to you or any third party for any damages, whether indirect, consequential, incidental, or otherwise, even if SoapBox has been advised of the possibility of such damages.  SoapBox will only be liable for money paid by you, the user, to SoapBox for any of its services.<\/p><p>The TOU will be governed by the laws of the state of California.<\/p><\/div><\/div>";
		 $('#content').uncorner();
  	 $('#content').corner("bevel 20px")
}

function loadRegisterForm() {
if (hash == "inbox") {changeTab(document.getElementById('inboxtab'))}
else {changeTab(document.getElementById('sendtab'))}
document.getElementById("content").innerHTML=
    "<h2>Like what you see? Register for even more Soapbox!<\/h2><div id=\"registerPageCopy\">SoapBox is a message router:  you send us a message, and we send it out to other Soapbox users based on the kind of people you want it to reach.  For example, you can tell us you want the message sent to males of a certain age in your neighborhood, and we will analyze the content of the message, see what SoapBox users may like it, then send it to them--instantly\!  <br><br>Talk with your neighbors, even if you don\’t know them.  <br><br>Promote an event by demographics\!  <br><br>Ask your neighbors for favors\!  <br><br>Buy and Sell, micro-local\!<\/div><div id=\"register_iframe\"><iframe src=\"\/auth\/register\" width=\"800px\" height=\"500px\" frameborder=\"0\" scrolling=\"no\"><p>Your browser does not support iframes!<\/p><\/iframe><\/div>";
		 $('#content').uncorner();
  	 $('#content').corner("bevel 20px")
}
</script>
</head>

<body onLoad="loadPubox(1);">
<div id="main">
<div id="header">
	<div id="logo" style="float:left;">
		<div id="logo_img">
			<a href="#public">
			<img src="/static/imgs/logo.png" style="float:left;" alt="Soapbox Logo">
			</a>
		</div>
	</div>
	<div id="loginbar" style="float:right;">
		<div id="login">
		<a href="#register" onmouseover="this.style.cursor='pointer';">Sign Up</a> | <a href="#about" onmouseover="this.style.cursor='pointer';">About</a>
		</div><!-- #login -->
	</div><!-- #loginbar -->
</div><!-- #header -->




<div id="floatdiv">



	<div id="nav">
                   <div class="navtab" id="inboxtab" style="position:relative;z-index:2;" href="#register" onclick="changeTab(this);" onmouseover="this.style.cursor='pointer';">
                   <a href="#inbox">
                   <img src="/static/imgs/tab-top.png" style="float:left;" alt="tab element">
			    <div class="innerTab" style="float:left;">
                   <p class="vertical boldtext">inbox</p>
                      </div>
			 <img src="/static/imgs/tab-bottom.png" style="float:right;" alt="tab element">
			 </a>
                   </div>
                

                   <div class="navtab" id="puboxtab" style="position:relative;top:-30px;z-index:3;" href="#public" onmouseover="this.style.cursor='pointer';">
                   <a href="#public">
                   <img src="/static/imgs/tab-top.png" style="float:left;" alt="tab element">
			    <div class="innerTab" style="float:left;">
                   <p class="vertical">public</p>
                      </div>
			 <img src="/static/imgs/tab-bottom.png" style="float:right;" alt="tab element">
			 </a>
                   </div>
                
                   <div class="navtab" id="sendtab" style="position:relative;top:-60px;z-index:1;" onclick="changeTab(this);loadRegisterForm();" onmouseover="this.style.cursor='pointer';">
                  <a href="#send">
                   <img src="/static/imgs/tab-top.png" style="float:left;" alt="tab element">
			    <div class="innerTab" style="float:left;">
                   <p class="vertical boldtext">send</p>
                      </div>
			 <img src="/static/imgs/tab-bottom.png" style="float:right;" alt="tab element">
			 </a>
                   </div>
                   
        </div><!-- #nav -->   
        

	<div id="content">
		loading...
	</div><!-- #content -->

             <div id="sidebar">   
        	<div>
        		<div class="widget_header_container">
			
        		<div class="widget_header" style="float:left;">sign in</div>   
        		
			</div>
        		<div id="loginForm" class="widget"> 
           			 <form action="/auth/login_post" method="post">
             			  <div class="login_widget_element">Email:<input type="text" name="email"></div>
             			  <div class="login_widget_element">Password:<input type="password" name="password"></div>
             			  <div class="login_widget_element"><input type="submit" value="Login"></div>
          		         </form>
			<div id="login_widget">Don't have an account? Click <a href="#register" onmouseover="this.style.cursor='pointer';">here</a> to register.</div>
			</div><!-- .widget -->
		</div>
	
		<div>
			<div class="widget_header_container">
		
			<div class="widget_header" style="float:left;">tips</div>
	
			</div>
			<div id="ads" class="widget" style="text-align:left;height:270px;" > <div style="padding:10px;font-style:bold;">When a sender marks a message as “public” it goes here, where everyone can see it!<br><br>

The public inbox can be seen by all users.  Register with SoapBox to send messages to targeted audiences and receive messages based on your profile and preferences!
			</div></div>
		</div>
</div><!-- #sidebar -->
<div id="footer">
	(c) 2011 <a href="#inbox" onmouseover="this.style.cursor='pointer';">MySoapbox.org</a> - <a href="#about" onmouseover="this.style.cursor='pointer';">About</a> - <a href="#privacy" onmouseover="this.style.cursor='pointer';">Legal / Terms of Service</a> 
	</div><!-- #footer -->
</div><!-- #floatdiv -->



</div> <!-- #main -->
      
</body>
</html>
