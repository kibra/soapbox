<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
<title>Soapbox</title>
<link rel="stylesheet" type="text/css" href="/static/mysoapbox.css">
<script type="text/javascript" src="/static/form2object.js"></script>
<script type="text/javascript" src="/static/json2.js"></script>
<script type="text/javascript">

function comment_form(num) {
var formData = form2object('comment_submit');
var submitted_message = JSON.stringify(formData, null, '\t');
var params = "data=" + encodeURIComponent(submitted_message); var i = 1;
ajax = new ajaxRequest();
ajax.open("POST", "/json/message/" + num, true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
console.log('send_new_comment_success');
var output = "<h2>Success!<\/h2><div><a onclick=\"loadInbox(1);\">Click here<\/a> to return to your inbox.<\/div>"
document.getElementById("content").innerHTML=output;
}

function loadAbout() {
document.getElementById("content").innerHTML=
	"<div id=\"about\">About Soapbox<\/div>";
}

function loadSettings() {
document.getElementById("content").innerHTML=
	"<div id=\"usersettings\"><h2>Account Settings<\/h2><div><form>\
	Change Password:<br><input type=\"text\" name=\"new_password\"><\/form><\/div><\/div>";
}

function populateTagWidget() {
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id=\"tag_widget_container\">'
   for (var i=0; i<5; i++){
   	idnumber = jsondata[i]['0'];
   	tagtext = jsondata[i]['1'];
    	output+='<div class=\"public_tag\">';
    	output+= tagtext;
    	output+='<\/a><\/div>';
   }
   output+='<div id=\"seeMore\"><a onclick=\"loadTagsBin();\">see more<\/a><\/div><\/div>';
  	 document.getElementById("tags").innerHTML=output;
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("POST", "/json/public_tags", true);
mygetrequest.send(null);
}

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

function addTag(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"add_tags":[i]}));
ajax = new ajaxRequest();
ajax.open("POST", "/json/tags/", true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
var ni = document.getElementById('my_tag_bucket_container');
var newdiv = document.createElement('div');
var divIdName = i+'';
newdiv.setAttribute('id',divIdName);
var onclickaction = 'removeTag('+i+')';
newdiv.setAttribute('onclick',onclickaction);
newdiv.setAttribute('class','public_tag');
var d = document.getElementById('my_tag_bucket_container');
var olddiv = document.getElementById(i);
newdiv.innerHTML=olddiv.innerHTML;
ni.appendChild(newdiv);
console.log('addTag_success');
}

function removeTag(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"remove_tags":[i]}));
ajax = new ajaxRequest();
ajax.open("POST", "/json/tags/", true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
var d = document.getElementById('my_tag_bucket_container');
var olddiv = document.getElementById(i);
d.removeChild(olddiv);
console.log('removeTag_success');
}		

var jsondata;

function loadInbox(page)
{
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="pubox"><h2>Inbox<\/h2><div style="width:100%;"><div style="float:left;"><form>Search: <input type="text" name="inbox_search"><input type="submit" value="Submit"><\/form><\/div><div id="postButton"><a onclick="loadSend();">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,150);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div style="text-align:center;"><a onclick="upvote(\''+idnumber+'\');loadInbox(1);">upvote <\/a><\/div><div style="text-align:center;">';
    	output+=votes+'<\/div><div style="text-align:center;"><a onclick="downvote(\''+idnumber+'\');loadInbox(1);">downvote <\/a><\/div><\/div><div class="msgSpace" ';
    	output+=' onclick="showFullMessage(\''+idnumber+'\',\''+theString+'\',\''+tags+'\');"><div id="msg'+idnumber+'">';
   	output+=shortstring;
    	output+='...<\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a onclick="markBoxed(\''+idnumber+'\');loadInbox(1);"><img src="/static/imgs/box.svg" width="40"   ><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadInbox(1);"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
   }
   output+='<\/div>';

	if (page > 1) {
   	output+='<\/div><\/div><br><div><a onclick="loadInbox(';
   	output+= (page-1) + ');">previous<\/a><\/div>';
   	}

   	output+='<\/div><\/div><br><div><a onclick="loadInbox(';
   	output+= (page+1) + ');">next<\/a><\/div>';
  
  	 document.getElementById("content").innerHTML=output;
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("POST", "/json/my_messages/" + page, true);
mygetrequest.send(null);
}

function showFullMessage(num,string,tags) {
alert(tags);
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var replies =  jsondata[1]['replies'];
var output = '<div><h2>View Message<\/h2><div class=\"fullMessage\">'+unescape(string)+'<br><br>';
output+= '<div class=\"public_tag\">'+tags;+'<\/div>';
output+= '<\/div><\/div><div><a onclick=\"loadInbox(1);\"><br>return<\/a><div id=\"commentBox\"><h3>'+replies.length+' Comments:<\/h3><\/div>';
for (var i=0; i<replies.length; i++) {
output+='<div class="replyBody">author:<br>';
var replybody=jsondata[1]['replies'][i]['body'];
output+=replybody+'<\/div>';
}
output+='<div id=\"responseBox\"><h3>Submit a Comment:<\/h3><form id=\"comment_submit\" action=\"javascript:comment_form('+num+')\"><textarea name=\"add_reply\" cols=80 rows=12><\/textarea><input type="submit"><\/form><\/div><\/div>';
document.getElementById("content").innerHTML=output;
  }
  else{
   alert(mygetrequest.status);
  }
 }
}
mygetrequest.open("GET", "/json/message/" + num, true);
mygetrequest.send(null);
}


function loadPubox(page)
{
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="pubox"><h2>Public Inbox<\/h2><div style="width:100%;"><div style="float:left;"><form>Search: <input type="text" name="publicinbox_search"><input type="submit" value="Submit"><\/form><\/div><div id="postButton"><a onclick="loadSend();">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,150);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div style="text-align:center;"><a onclick="upvote(\''+idnumber+'\');loadPubox(1);">upvote <\/a><\/div><div style="text-align:center;">';
    	output+=votes+'<\/div><div style="text-align:center;"><a onclick="downvote(\''+idnumber+'\');loadPubox(1);">downvote <\/a><\/div><\/div><div class="msgSpace" ';
    	output+=' onclick="markRead(\''+idnumber+'\');showFullMessagePublic(\''+idnumber+'\',\''+theString+'\',\''+tags+'\');"><div id="msg'+idnumber+'">';
   	output+=shortstring;
    	output+='...<\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a onclick="markBoxed(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/box.svg" width="40"   ><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
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

function showFullMessagePublic(num,string,tags) {
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var replies =  jsondata[1]['replies'];
var output = '<div><h2>View Message<\/h2><div class=\"fullMessage\">'+unescape(string)+'<br><br>';
output+= '<div class=\"public_tag\">'+tags.substring(2);+'<\/div>';
output+= '<\/div><\/div><div><a onclick=\"loadPubox(1);\"><br>return<\/a><div id=\"commentBox\"><h3>'+replies.length+' Comments:<\/h3><\/div>';
for (var i=0; i<replies.length; i++) {
output+='<div class="replyBody">author:<br>';
var replybody=jsondata[1]['replies'][i]['body'];
output+=replybody+'<\/div>';
}
output+='<div id=\"responseBox\"><h3>Submit a Comment:<\/h3><form id=\"comment_submit\" action=\"javascript:comment_form('+num+')\"><textarea name=\"add_reply\" cols=80 rows=12><\/textarea><input type="submit"><\/form><\/div><\/div>';
document.getElementById("content").innerHTML=output;
  }
  else{
   alert(mygetrequest.status);
  }
 }
}
mygetrequest.open("GET", "/json/message/" + num, true);
mygetrequest.send(null);
}

function loadSent(page)
{
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="sent"><h2>Sent Messages<\/h2><div style="width:100%;"><div style="float:left;"><form>Search: <input type="text" name="sentmessages_search"><input type="submit" value="Submit"><\/form><\/div><div id="postButton"><a onclick="loadSend();">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,150);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div style="text-align:center;"><a onclick="upvote(\''+idnumber+'\');loadSent(1);">upvote <\/a><\/div><div style="text-align:center;">';
    	output+=votes+'<\/div><div style="text-align:center;"><a onclick="downvote(\''+idnumber+'\');loadSent(1);">downvote <\/a><\/div><\/div><div class="msgSpace" ';
    	output+=' onclick="markRead(\''+idnumber+'\');showFullMessageSent(\''+idnumber+'\',\''+theString+'\',\''+tags+'\');"><div id="msg'+idnumber+'">';
   	output+=shortstring;
    	output+='...<\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a onclick="markBoxed(\''+idnumber+'\');loadSent(1);"><img src="/static/imgs/box.svg" width="40"             ><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadSent(1);"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
   }
   output+='<\/div>';
	if (page > 1) {
   	output+='<\/div><\/div><br><div><a onclick="loadSent(';
   	output+= (page-1) + ');">previous<\/a><\/div>';
   	}
   	output+='<\/div><\/div><br><div><a onclick="loadSent(';
   	output+= (page+1) + ');">next<\/a><\/div>';
  	 document.getElementById("content").innerHTML=output;
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("POST", "/json/sent_messages/" + page, true);
mygetrequest.send(null);
}

function showFullMessageSent(num,string,tags) {
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var replies =  jsondata[1]['replies'];
var output = '<div><h2>View Message<\/h2><div class=\"fullMessage\">'+unescape(string)+'<br><br>';
output+= '<div class=\"public_tag\">'+tags.substring(2);+'<\/div>';
output+= '<\/div><\/div><div><a onclick=\"loadSent(1);\"><br>return<\/a><div id=\"commentBox\"><h3>'+replies.length+' Comments:<\/h3><\/div>';
for (var i=0; i<replies.length; i++) {
output+='<div class="replyBody">author:<br>';
var replybody=jsondata[1]['replies'][i]['body'];
output+=replybody+'<\/div>';
}
output+='<div id=\"responseBox\"><h3>Submit a Comment:<\/h3><form id=\"comment_submit\" action=\"javascript:comment_form('+num+')\"><textarea name=\"add_reply\" cols=80 rows=12><\/textarea><input type="submit"><\/form><\/div><\/div>';
document.getElementById("content").innerHTML=output;
  }
  else{
   alert(mygetrequest.status);
  }
 }
}
mygetrequest.open("GET", "/json/message/" + num, true);
mygetrequest.send(null);
}

function loadSaved(page)
{
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="boxed"><h2>Boxed Messages<\/h2><div style="width:100%;"><div style="float:left;"><form>Search: <input type="text" name="boxed_search"><input type="submit" value="Submit"><\/form><\/div><div id="postButton"><a onclick="loadSend();">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,150);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div style="text-align:center;"><a onclick="upvote(\''+idnumber+'\');loadSaved(1);">upvote <\/a><\/div><div style="text-align:center;">';
    	output+=votes+'<\/div><div style="text-align:center;"><a onclick="downvote(\''+idnumber+'\');loadSaved(1);">downvote <\/a><\/div><\/div><div class="msgSpace" ';
    	output+=' onclick="markRead(\''+idnumber+'\');showFullMessageSaved(\''+idnumber+'\',\''+theString+'\',\''+tags+'\');"><div id="msg'+idnumber+'">';
   	output+=shortstring;
    	output+='...<\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a onclick="unBoxed(\''+idnumber+'\');loadSaved(1);"><img src="/static/imgs/box.svg" width="40"    ><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadSaved(1);"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
   }
   output+='<\/div>';
	if (page > 1) {
   	output+='<\/div><\/div><br><div><a onclick="loadSaved(';
   	output+= (page-1) + ');">previous<\/a><\/div>';
   	}
   	output+='<\/div><\/div><br><div><a onclick="loadSaved(';
   	output+= (page+1) + ');">next<\/a><\/div>';
  	 document.getElementById("content").innerHTML=output;
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("POST", "/json/boxed_messages/" + page, true);
mygetrequest.send(null);
}

function showFullMessageSaved(num,string,tags) {
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var replies =  jsondata[1]['replies'];
var output = '<div><h2>View Message<\/h2><div class=\"fullMessage\">'+unescape(string)+'<br><br>';
output+= '<div class=\"public_tag\">'+tags.substring(2);+'<\/div>';
output+= '<\/div><\/div><div><a onclick=\"loadSaved(1);\"><br>return<\/a><div id=\"commentBox\"><h3>'+replies.length+' Comments:<\/h3><\/div>';
for (var i=0; i<replies.length; i++) {
output+='<div class="replyBody">author:<br>';
var replybody=jsondata[1]['replies'][i]['body'];
output+=replybody+'<\/div>';
}
output+='<div id=\"responseBox\"><h3>Submit a Comment:<\/h3><form id=\"comment_submit\" action=\"javascript:comment_form('+num+')\"><textarea name=\"add_reply\" cols=80 rows=12><\/textarea><input type="submit"><\/form><\/div><\/div>';
document.getElementById("content").innerHTML=output;
  }
  else{
   alert(mygetrequest.status);
  }
 }
}
mygetrequest.open("GET", "/json/message/" + num, true);
mygetrequest.send(null);
}

function loadTagsBin() {
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata["my_tags"]);
   var output='<h3>My Tags<\/h3><div id=\"my_tag_bucket_container\">';
    for (var i=0; i<jsondata["my_tags"].length; i++){
   	idnumber = jsondata["my_tags"][i]['0'];
   	tagtext = jsondata["my_tags"][i]['1'];
    	output+='<div class=\"public_tag\" id=\''+idnumber+'\' onclick=removeTag(\''+idnumber+'\')>';
    	output+= tagtext;
    	output+='<\/a><\/div>';
   	}
   output+='<\/div>';
   output+='<h3>Public Tags<\/h3><div id=\"public_tag_bucket_container\">';
   for (var i=0; i<jsondata["public_tags"].length; i++){
   	idnumber = jsondata["public_tags"][i]['0'];
   	tagtext = jsondata["public_tags"][i]['1'];
    	output+='<div class=\"public_tag\" id=\''+idnumber+'\' onclick=addTag(\''+idnumber+'\')>';
    	output+= tagtext;
    	output+='<\/a><\/div>';
   	}
   output+='<\/div>';
  	 document.getElementById("content").innerHTML=output;
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("GET", "/json/tags", true);
mygetrequest.send(null);
}

function loadPublicTags() {
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="inbox"><h2>Tags<\/h2><\/div>';
  	 document.getElementById("content").innerHTML=output;
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("GET", "/json/public_tags", true);
mygetrequest.send(null);
}

function loadMyTags() {
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="inbox"><h2>Tags<\/h2><\/div>';
  	 document.getElementById("content").innerHTML=output;
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("GET", "/json/my_tags", true);
mygetrequest.send(null);
}

function message_form() {
var formData = form2object('message_submit');
var submitted_message = JSON.stringify(formData, null, '\t');
alert(submitted_message);
var params = "data=" + encodeURIComponent(submitted_message); var i = 1;
alert(params);
ajax = new ajaxRequest();
ajax.open("POST", "/json/send_message/", true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
console.log('send_new_message_success');
var output = "<h2>Success!<\/h2><div><a onclick=\"loadInbox(1);\">Click here<\/a> to return to your inbox.<\/div>"
document.getElementById("content").innerHTML=output;
}

function loadSend() {
	changeTab(document.getElementById("sendTab"));
	var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var personalTag = jsondata['personal_tag'][0];
   var output='<div id=\"send\"><h2>Send Message<\/h2><div style=\"width:100%;\"><form id=\"message_submit\" action=\"javascript:message_form()\"><h3>Message<\/h3><textarea name=\"body\" cols=80 rows=12><\/textarea><div><h3>Tag it:<\/h3><ul>';
   for (var i=0; i<jsondata['default_tags'].length; i++){
   	var tag = jsondata['default_tags'][i][1];
   	output+='<li><label><input type=\"checkbox\" name=\"tags[]\" value=\"'+jsondata['default_tags'][i][0]+'\">'+tag+'<\/label><\/li>';
   }
   	output+='<br><li><label><input type=\"checkbox\" name=\"tags[]\" value=\"'+personalTag+'\">Tag as Me<\/label><\/li><\/ul><br><input type=\"submit\"><\/form><\/div>';
  	 document.getElementById("content").innerHTML=output;
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("GET", "/json/send_tags", true);
mygetrequest.send(null);
}
</script>
</head>






<body onLoad="loadInbox(1);populateTagWidget();">

<div id="main">
<div id="header">
	<div id="logo" style="float:left;">
		<div id="logo_img">
			<a href="/box">
			<img src="/static/imgs/logo.png" style="float:left;" />
			</a>
		</div>
		<img src="static/imgs/login-bar-right.png" style="float:right;" />
	</div>
	<div id="header_msg_box" style="float:left;">
		<img src="static/imgs/login-bar-left.png" style="float:left;">
		<div id="header_msg_content" style="float:left;">Welcome to Soapbox!</div>
		<img src="static/imgs/login-bar-right.png" style="float:right;">
	</div>
	<div id="loginbar" style="float:right;">
		<div id="login">
		${user.email} | <a onclick="loadSettings();" style="cursor:pointer;">My Account</a> | <a href="/box/logout" style="cursor:pointer;">Sign Out</a> | <a onclick="loadAbout();" style="cursor:pointer;">FAQ</a>
		</div><!-- #login -->
		<div id="login-left"><img src="static/imgs/login-bar-left.png"></div>
	</div><!-- #loginbar -->
</div><!-- #header -->

<div id="floatdiv">

<div id="nav">
		   
		    <div class="navtab" id="inboxTab" style="position:relative;z-index:3;" onclick="changeTab(this);">
		     <a onclick="loadInbox(1);">
		   	 <img src="/static/imgs/tab-top.png" style="float:left;" />
			    <div class="innerTab" style="float:left;">
			    	<p class="vertical" id="boldtext">inbox</p>
			    </div>
			 <img src="/static/imgs/tab-bottom.png" style="float:right;" />
			 </a>
		    </div>
		    
		    
		   
		    <div class="navtab" id="puboxTab" style="position:relative;z-index:2;" onclick="changeTab(this);">
		     <a onclick="loadPubox(1);">
		     <img src="/static/imgs/tab-top.png" style="float:left;" />
			    <div class="innerTab" style="float:left;">
		    <p class="vertical" id="boldtext">pubox</p>
		    </div>
		     <img src="/static/imgs/tab-bottom.png" style="float:right;" />   			 </a>
		    </div>
		
		    
		    
		    <div class="navtab" id="boxedTab" style="position:relative;z-index:0;" onclick="changeTab(this);">
		      <a onclick="loadSaved(1);">
		    <img src="/static/imgs/tab-top.png" style="float:left;" />
			    <div class="innerTab" style="float:left;">
		    <p class="vertical" id="boldtext">saved</p>
		    </div>
		     <img src="/static/imgs/tab-bottom.png" style="float:right;" /></a>
		    </div>
		    
		    
		   
		    <div class="navtab" id="tagsTab" style="position:relative;z-index:0;" onclick="changeTab(this);"> <a onclick="loadTagsBin();">
		    <img src="/static/imgs/tab-top.png" style="float:left;" />
			    <div class="innerTab" style="float:left;">
		    <p class="vertical" id="boldtext">tags</p>
		    </div>
		     <img src="/static/imgs/tab-bottom.png" style="float:right;" /> </a>
		    </div>
		   
		    
		    	    
		    <div class="navtab" id="sendTab" style="position:relative;z-index:1;" onclick="changeTab(this);">
		    <a onclick="loadSent(1);">
		      <img src="/static/imgs/tab-top.png" style="float:left;" />
			    <div class="innerTab" style="float:left;">
		    <p class="vertical" id="boldtext">sent</p>
		     </div>
		     <img src="/static/imgs/tab-bottom.png" style="float:right;" /></a>
		    </div>
		    
		    
	</div><!-- #nav -->
	
	<div id="content">
		loading...
	</div><!-- #content -->
	
	<div id="sidebar">
		<div>
			<div class="widget_header_container">
			<img src="static/imgs/widget-header-left.png" style="float:left;">
			<div class="widget_header" style="float:left;">tags</div>
			<img src="static/imgs/widget-header-right.png" style="float:right;">
			</div>
			<div id="tags" class="widget">tag em and bag em</div>
		</div>
		
		<div>
			<div class="widget_header_container">
			<img src="static/imgs/widget-header-left.png" style="float:left;">
			<div class="widget_header" style="float:left;">soapbox</div>
			<img src="static/imgs/widget-header-right.png" style="float:right;"></div>
			<div id="boxes" class="widget">prettyboxes</div>
		</div>
		
		<div>
			<div class="widget_header_container">
			<img src="static/imgs/widget-header-left.png" style="float:left;">
			<div class="widget_header" style="float:left;">ads</div>
				<img src="static/imgs/widget-header-right.png" style="float:right;"></div>
			<div id="ads" class="widget">i smell the google!</div>
		</div>
	</div><!-- #sidebar -->
	
	<div id="footer">
	&copy; 2011 <a onclick="loadInbox(1);" style="cursor:pointer;">MySoapbox.org</a> - <a onclick="loadPrivacy();" style="cursor:pointer;">Legal / Terms of Service</a> 
	</div><!-- #footer -->

</div><!-- #floatdiv -->

</div> 
<!-- #main -->
</body>
</html>
