
var Z = 20;
function changeTab(elem){
 Z += 10;
 var objElem = elem;
 elem.style.zIndex = Z;
 document.getElementById("content").style.zIndex = Z+10;
}

function ajaxRequest(){
 var activexmodes=["Msxml2.XMLHTTP", "Microsoft.XMLHTTP"] //activeX versions to check for in IE
 if (window.ActiveXObject){ //Test for support for ActiveXObject in IE first (as XMLHttpRequest in IE7 is broken)
  for (var i=0; i<activexmodes.length; i++){
   try{
    return new ActiveXObject(activexmodes[i])
   }
   catch(e){
    //suppress error
   }
  }
 }
 else if (window.XMLHttpRequest) // if Mozilla, Safari etc
  return new XMLHttpRequest()
 else
  return false
}

function markRead(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"read":true})); 
ajax = new ajaxRequest();
ajax.open("POST", "/json/message/"+i, true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
console.log(i,params,'read_success');
}

function markSpam(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"spam":true}));
ajax = new ajaxRequest();
ajax.open("POST", "/json/message/"+i, true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
console.log('spam_success');
}

function markBoxed(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"boxed":true}));
ajax = new ajaxRequest();
ajax.open("POST", "/json/message/"+i, true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
console.log('spam_success');
}

function upvote(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"up":true}));
ajax = new ajaxRequest();
ajax.open("POST", "/json/message/"+i, true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
console.log('upvote_success');
}

function downvote(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"up":true}));
ajax = new ajaxRequest();
ajax.open("POST", "/json/message/"+i, true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
console.log('downvote_success');
}


function showFullMessagePublic(string,tags) {
var output = '<div><h2>View Message<\/h2><div class=\"fullMessage\"><div class=\"messageText\">'+string;
output+= '<\/div><div class=\"public_tag\">'+tags.substring(2);+'<\/div>';
output+= '<\/div><\/div><div><a onclick=\"loadPubox(1);\"><br \/>return<\/a><\/div>';
document.getElementById("content").innerHTML=output;}

function loadPubox(page)
{
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="pubox"><h2>Public Inbox<\/h2><div style="width:100%;"><div style="float:left;"><form>Search: <input type="text" name="publicinbox_search"><input type="submit" value="Submit"><\/form><\/div><div id="postButton"><a onclick="loadRegisterForm();">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,150);
   	var theString = jsondata[i][1]['body'];
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div style="text-align:center;"><a onclick="upvote(\''+idnumber+'\');loadPubox(1);">upvote <\/a><\/div><div style="text-align:center;">';
    	output+=votes+'<\/div><div style="text-align:center;"><a onclick="downvote(\''+idnumber+'\');loadPubox(1);">downvote <\/a><\/div><\/div><div class="msgSpace" ';
    	output+=' onclick="markRead(\''+idnumber+'\');showFullMessage(\''+theString+'\',\''+tags+'\');"><div id="msg'+idnumber+'">';
   	output+=shortstring;
    	output+='...<\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a onclick="markBoxed(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/savebutton.png"><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/spambutton.png" /><\/a><\/div><\/div>';
   }
   output+='<\/div>';

	if (page > 1) {
   	output+='<\/div><\/div><br><div><a onclick="loadPubox(';
   	output+= (page-1) + ');">previous<\/a><\/div>';
   	}

   	output+='<\/div><\/div><br><div><a onclick="loadPubox(';
   	output+= (page+1) + ');">next<\/a><\/div>';
  
  	 document.getElementById("content").innerHTML=output;
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
	"<div id=\"about\"><h2>About Soapbox<\/h2><div>Launching in IV, SoapBox is a brand new platform for communication developed by UCSB students Scott, Kyle, and Max! Find us on twitter @MySoapBoxOrg to follow the action and hear about the party!<br \/><br \/>Today, multiple platforms exist for online communication--basic email (users exchange messages with friends), Twitter (users voluntarily subscribe to another user's \“feed\”), Craigslist\/forums (users post to a categorized public message board), and so on. SoapBox is a brand new platform that allows for completely novel communication.<br \/><br \/>SoapBox is a \"message router.\" You give us a message and tell us what kinds of people you want it to get to (age, gender, location, etc) and we route the message to a number of other users that we select (through an algorithm). You may also tag the message with things like Neighborhood Talk, Borrow, Party, etc. If people have these tags in their person tag bucket, we will most likely send it to them.<br \/><br \/>Do you want to talk to your neighbors but don't know them? Send a message with a small radius and we'll send it to people within that circle. Promote a party to just people of a certain age\/gender\/location. The applications are endless.<br \/><br \/>Each user will receive their own unique tag upon registration. Unique tags have the following property: anyone can put them in their private bucket (and therefore receive messages containing that tag), but only the creator of the tag can broadcast with it. When the user tags a message with their unique tag, the message will be sent to everyone who has the tag in their private bucket plus any other user that SoapBox believes may be interested in the message. For example, a user could send the message \“I need to borrow a wrench--live at 2419 Durant.\” They could tag the message with both \“Borrow\” and their unique tag, and instruct us to dispatch this message to people within .1 miles of them. Because it is tagged with their unique tag, it will be sent to all of their \“followers.\” In addition, the message will be sent to users in their direct vicinity because of the .1 mile radius. Thus, both their neighbors and their followers will receive the message. This feature effectively puts Twitter under our umbrella.<br \/><br \/>All features above will be available at launch (along with some others). Once Soapbox gets a significant following, we will allow users to create their own tags, and many other features! <\/div>";
}

function loadPrivacy() {
document.getElementById("content").innerHTML=
	"<div id=\"privacy\"><h2>MySoapbox.org Terms of Service<\/h2><div><p>We reserve the right to change the Terms of Use (TOU) at anytime.  It is your responsibility to check this document for updates.<\/p><p>SoapBox is an online messenger that allows user to send messages to other users based on demographics.  As a user, you will receive messages from other users based on the information that you provide SoapBox about yourself.  We want the experience of SoapBox to be as safe, fun, informative, and efficient as possible for all users.  Please help us to ensure that SoapBox remains a safe place for all everyone.<\/p><p>The personal information that you provide us with will be used for the purpose of sending you messages that SoapBox thinks you will have interest in.  Likewise, it will aid in sending your messages to the most pertinent recipients.   With measures to keep your information safe and secure, we will only share certain elements of your user data with third parties that work with us.  This will only be done to help serve you better in the service.  For example, we work with a third party company that specializes in geo-location software.  They will in no way share your information with any other party, nor will they use your information for another purpose other than assisting us in providing you with a great service.  <\/p><p>SoapBox is a community of anonymous users.  It is ignorant of the true identities and intentions of its users.  You, as a user, acknowledge that SoapBox does not pre-screen its users.  Therefore you must be cautious and prudent in your interactions with other users.  We suggest that you do not give any personal data to other users, especially about your location, age, gender, orientation, etc.  SoapBox does not control the content sent or received by its users.  We are not responsible for any offensive material that you may receive from other users.  It is your responsibility to assess the content of a message and decide how to use it.  SoapBox is not responsible for how you chose to use the content that we make available to you.  You are solely responsible for the messages that you send through SoapBox.  If you chose to meet another user through SoapBox, SoapBox is not responsible for the relationship that ensues, nor any harm that may come from the interaction.  It is your responsibility to use SoapBox with regard for your own well being.  <\/p><p>SoapBox does not own any content that you upload to us during your usage.  However, you acknowledge that SoapBox administrators may have access to view this content and may chose to hold it on our server for as long as we wish.  If you have any sensitive material that you would like to share, such as personal information or intellectual property, beware that we, the administrators of SoapBox, may view it during our normal maintenance of the site. <\/p><p>Users who misuse SoapBox in any of the following ways will have their account terminated:  1) attempting to send adult material to users who are under 18 years of age, 2) sending messages that attempt to sell retail items, or a promote a retail service, without tagging them with appropriate tags, 3) attempting to conduct illegal acts through SoapBox, 3) spamming other users with unwanted material, and 4) any other offenses that SoapBox deems unacceptable.  SoapBox has the right to terminate any and all accounts at its discretion.  <\/p><p>Under no circumstances will SoapBox be held reliable for any actions of its users, whether accidental or otherwise.  In no event shall SoapBox, or any of its creators or employees, be liable to you or any third party for any damages, whether indirect, consequential, incidental, or otherwise, even if SoapBox has been advised of the possibility of such damages.  SoapBox will only be liable for money paid by you, the user, to SoapBox for any of its services.<\/p><p>The TOU will be governed by the laws of the state of California.<\/p><\/div><\/div>";
}

function loadRegisterForm() {
document.getElementById("content").innerHTML=
		       "<div id=\"register_iframe\"><iframe src=\"http:\/\/mysoapbox.org\/auth\/register\" width=\"800px\" height=\"500px\" frameborder=\"0\" scrolling=\"no\"><p>Your browser does not support iframes!<\/p><\/iframe><\/div>";
}
