function comment_form(num) {
var formData = form2object('comment_submit');
var submitted_message = JSON.stringify(formData, null, '\t');
var params = "data=" + encodeURIComponent(submitted_message); var i = 1;
ajax = new ajaxRequest();
ajax.open("POST", "/json/message/" + num, true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
humanMsg.displayMsg('Comment Posted!');

}

function loadAbout() {
document.getElementById("content").innerHTML=
	"<div id=\"about\"><h2>About Soapbox<\/h2><div>SoapBox is a \"message router.\" You give us a message and tell us what kinds of people you want it to get to (age, gender, location, etc) and we route the message to a number of other users that we select (through an algorithm). You may also tag the message with things like Neighborhood Talk, Borrow, Party, etc. If people have these tags in their person tag bucket, we will most likely send it to them.<br \/><br \/>Do you want to talk to your neighbors but don't know them? Send a message with a small radius and we'll send it to people within that circle. Promote a party to just people of a certain age\/gender\/location. The applications are endless.<br \/><br \/>Each user will receive their own unique tag upon registration. Unique tags have the following property: anyone can put them in their private bucket (and therefore receive messages containing that tag), but only the creator of the tag can broadcast with it. When the user tags a message with their unique tag, the message will be sent to everyone who has the tag in their private bucket plus any other user that SoapBox believes may be interested in the message. For example, a user could send the message \“I need to borrow a wrench--live at 2419 Durant.\” They could tag the message with both \“Borrow\” and their unique tag, and instruct us to dispatch this message to people within .1 miles of them. Because it is tagged with their unique tag, it will be sent to all of their \“followers.\” In addition, the message will be sent to users in their direct vicinity because of the .1 mile radius. Thus, both their neighbors and their followers will receive the message. This feature effectively puts Twitter under our umbrella.<br \/><br \/>All features above will be available at launch (along with some others). Once Soapbox gets a significant following, we will allow users to create their own tags, and many other features! <\/div>";
		 $('#content').uncorner();
  	 $('#content').corner("bevel 20px")
}


function loadSettings() {
document.getElementById("content").innerHTML=
	"<div id=\"usersettings\"><h2>Account Settings<\/h2><div><form id=\"changeMySettingsForm\">Adult content filter is [value].<br><h3>Change Password<\/h3><br>new password: <input type=\"password\" name=\"newpass1\"><br>confirm it: <input type=\"password\" name=\"newpass2\"><\/form><\/div><\/div>";
		 $('#content').uncorner();
  	 $('#content').corner("bevel 20px")
}

function populateTagWidget() {
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   var output='<div id=\"tag_widget_container\">'
   for (var i=0; i<5; i++){
   	idnumber = jsondata[i]['0'];
   	tagtext = jsondata[i]['1'];
    	output+='<div class=\"public_tag_holder\"><a onclick=\"loadTagsBin();\"<div class=\"public_tag_in_widget\">';
    	output+= tagtext;
    	output+='<\/a><\/div><\/div>';
   }
   output+='<div id=\"seeMore\"><a onclick=\"loadTagsBin();\">see more<\/a><\/div><\/div>';
  	 document.getElementById("tags").innerHTML=output;
  	 $('#tags').corner("bevel 8px");
  	 $('.public_tag_in_widget').corner("bevel 8px").parent().css('padding', '4px').corner("bevel 10px");
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
 var inner = elem.getElementsByTagName('div')[0]
 //inner.style.backgroundColor = '#8A8A8B';
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
}

function markSpam(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"spam":true}));
ajax = new ajaxRequest();
ajax.open("POST", "/json/message/"+i, true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
}

function markBoxed(i) {
	var params = "data=" + encodeURIComponent(JSON.stringify({"boxed":true}));
	ajax = new ajaxRequest();
	ajax.open("POST", "/json/message/"+i, true);
	ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	ajax.send(params);
}

function upvote(i,bool) {
	var params = "data=" + encodeURIComponent(JSON.stringify({"uped":bool}));
	ajax = new ajaxRequest();
	ajax.open("POST", "/json/message/"+i, true);
	ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	ajax.onreadystatechange=function(){
		if (ajax.readyState==4){
			if (ajax.status==200)
				document.getElementById('score'+i).innerHTML = JSON.parse(ajax.responseText)['score'];
				if (bool) {
					document.getElementById('uparrow'+i).setAttribute('src','/static/imgs/uped.png');
					document.getElementById('uplink'+i).setAttribute('onclick','upvote('+i+',false);');
					document.getElementById('downarrow'+i).setAttribute('src','/static/imgs/down.png');
					document.getElementById('downlink'+i).setAttribute('onclick','downvote('+i+',true);');
				}
				else {
					document.getElementById('uparrow'+i).setAttribute('src','/static/imgs/up.png');
					document.getElementById('uplink'+i).setAttribute('onclick','upvote('+i+',true);');
				}
		}
	};
	ajax.send(params);
}

function downvote(i,bool) {	
	var params = "data=" + encodeURIComponent(JSON.stringify({"downed":bool}));
	ajax = new ajaxRequest();
	ajax.open("POST", "/json/message/"+i, true);
	ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	ajax.onreadystatechange=function(){
		if (ajax.readyState==4){
			if (ajax.status==200)
				document.getElementById('score'+i).innerHTML = JSON.parse(ajax.responseText)['score'];
				if (bool) {
					document.getElementById('downarrow'+i).setAttribute('src','/static/imgs/downed.png');
					document.getElementById('downlink'+i).setAttribute('onclick','downvote('+i+',false);');
					document.getElementById('uparrow'+i).setAttribute('src','/static/imgs/up.png');
					document.getElementById('uplink'+i).setAttribute('onclick','upvote('+i+',true);');
				}
				else {
					document.getElementById('downarrow'+i).setAttribute('src','/static/imgs/down.png');
					document.getElementById('downlink'+i).setAttribute('onclick','downvote('+i+',true);');
				}
		}
	};
	ajax.send(params);
}

function addTag(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"add_tags":[i]}));
ajax = new ajaxRequest();
ajax.open("POST", "/json/tags/", true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
var ni = document.getElementById('my_tag_bucket_container');
var newdiv = document.createElement('div');
if (document.getElementById('my'+i))
	return;
newdiv.setAttribute('id','my'+i);
newdiv.setAttribute('onclick','removeTag('+i+')');
var olddiv = document.getElementById('pub'+i);
newdiv.setAttribute('class',olddiv.getAttribute('class'));
olddiv.setAttribute('class',olddiv.getAttribute('class') + ' added');
newdiv.innerHTML=olddiv.innerHTML;
ni.appendChild(newdiv);
}

function removeTag(i) {
var params = "data=" + encodeURIComponent(JSON.stringify({"remove_tags":[i]}));
ajax = new ajaxRequest();
ajax.open("POST", "/json/tags/", true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);
var d = document.getElementById('my_tag_bucket_container');
var olddiv = document.getElementById('my'+i);
d.removeChild(olddiv);
document.getElementById('pub'+i).setAttribute('class',olddiv.getAttribute('class').replace(/\s+\S*$/, ""));
}		

var jsondata;


function expandMessage() {
alert(getLength(this.parentNode));
this.parentNode.style.height = "150px";
}

function loadInbox(page) {
	var mygetrequest=new ajaxRequest();
	mygetrequest.onreadystatechange=function(){
		if (mygetrequest.readyState==4){
			if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
				var response = mygetrequest.responseText;
				jsondata = JSON.parse(response);
				var output='<div style="width:100%;"><div style="float:left;"><form action="javascript:loadSearch();">Search: <input type="text" id="search_field"><input type="button" value="Submit" onclick="loadSearch()"><\/form><\/div><a onclick="loadSend();"><div id="postButton">Post<\/div><\/a><div style="clear:both;"><\/div><div id="msgContainer">';
				for (var i=0; i<jsondata.length; i++){
					idnumber = jsondata[i][0];
					var shortstring = jsondata[i][1]['body'].slice(0,135);
					shortstring=shortstring.replace(/<br>/gi, '');
					var theString = escape(jsondata[i][1]['body']);
					var votes = jsondata[i][1]['score'];
					output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div class="uparrow" style="text-align:center;margin-top:2px">';
					
					if (jsondata[i][1]['uped'])
						output+='<a id="uplink'+idnumber+'" onclick="upvote('+idnumber+',false);"><img id="uparrow'+idnumber+'" src="/static/imgs/uped.png"/> ';
					else
						output+='<a id="uplink'+idnumber+'" onclick="upvote('+idnumber+',true);"><img  id="uparrow'+idnumber+'" src="/static/imgs/up.png"/> ';
					
					output+='<\/a><\/div><div class="numofvotes" id="score'+idnumber+'" style="text-align:center;">'+votes+'<\/div><div class="downarrow" style="text-align:center;margin-bottom:1px">';
					
					if (jsondata[i][1]['downed'])
						output+='<a id="downlink'+idnumber+'" onclick="downvote('+idnumber+',false);"><img id="downarrow'+idnumber+'" src="/static/imgs/downed.png"/> <\/a><\/div><\/div>';
					else
						output+='<a id="downlink'+idnumber+'" onclick="downvote('+idnumber+',true);"><img id="downarrow'+idnumber+'" src="/static/imgs/down.png"/> <\/a><\/div><\/div>';
					
					if (jsondata[i][1]['read'])
						output+='<div class=\"msgSpaceRead\"';
					else
						output+='<div class=\"msgSpace\"';
					output+=' onclick=\"markRead(\''+idnumber+'\');showFullMessagePublic(\''+idnumber+'\',\''+theString+'\',\''+tags+'\');\"><div id=\"message'+idnumber+'\">';
					output+=shortstring;
					output+='...<\/div><div id=\"tags_and_replies\"><\/div>';
					output+='<\/div><div class=\"saveBox\"><a onclick=\"markBoxed(\''+idnumber+'\');loadInbox(1);"><img src="/static/imgs/box.png"><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadInbox(1);"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
				}
				output+='<\/div>';
				if (page > 1) {
					output+='<\/div><\/div><br><div><a onclick="loadInbox(';
					output+= (page-1) + ');">previous<\/a><\/div>';
				}
				output+='<\/div><\/div><br><div><a onclick="loadInbox(';
				output+= (page+1) + ');">next<\/a><\/div>';
				document.getElementById("content").innerHTML=output;
				$('#content').uncorner();
				$('#content').corner("bevel 20px")
			}
			else{ alert("An error has occured making the request"); }
		}
	}
	mygetrequest.open("GET", "/json/my_messages/" + page, true);
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
   var output='<div id=\"pubox\"><h2>Message Search<\/h2><div style="width:100%;"><div style="float:left;"><form action="javascript:loadSearch();">Search: <input type="text" id="search_field"><input type="button" value="Submit" onclick="loadSearch()"><\/form><\/div><div id="postButton"><a onclick="loadSend();">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,145);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div class="uparrow" style="text-align:center;margin-top:2px"><a onclick="upvote(\''+idnumber+'\');"><img src="/static/imgs/up.png"/> <\/a><\/div><div class="numofvotes" style="text-align:center;">';
    	output+=votes+'<\/div><div class="downarrow" style="text-align:center;margin-bottom:1px"><a onclick="downvote(\''+idnumber+'\');"><img src="/static/imgs/down.png"/> <\/a><\/div><\/div><div class="msgSpace" ';
    	output+=' onclick=\"markRead(\''+idnumber+'\');showFullMessagePublic(\''+idnumber+'\',\''+theString+'\',\''+tags+'\');\"><div id=\"msg'+idnumber+'">';
   	output+=shortstring;
    	output+='...<\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a onclick="markBoxed(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/box.png"><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
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

function showFullMessage(num) {
	var mygetrequest=new ajaxRequest();
	mygetrequest.onreadystatechange=function(){
		if (mygetrequest.readyState==4){
			if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
				jsondata = JSON.parse(mygetrequest.responseText);
				var replies =  jsondata[1]['replies'];
				var output = '<h2 style="margin-top:0px;float:left;">View Message<\/h2><a style="font-weight:bold;float:right;" onclick=\"loadInbox(1);\">return to inbox<\/a><br><br><div class=\"fullMessage\">'+unescape(jsondata[1]['body'])+'</div><h4 style="margin-bottom:0px;">Tagged:<\/h4>';
				var tags =  jsondata[1]['tags'];
				output+='<div id=\"send_tags_container\">'
				for (var i=0; i<tags.length; i++) {
					output+= '<div class=\"public_tag_in_widget tag_in_bin\">'+tags[i][1]+'<\/div>';
				}
				output+= '</div><br><div id=\"commentBox\"><h3>'+replies.length+' Comments:<\/h3><\/div>';
				for (var i=0; i<replies.length; i++) {
					output+='<div class="replyBody"><div style="font-weight:bold">author: ';
					output+=jsondata[1]['replies'][i]['author']+'</div>';
					output+=jsondata[1]['replies'][i]['body']+'<\/div>';
				}
				output+='<div id=\"responseBox\"><h3>Submit a Comment:<\/h3><form id=\"comment_submit\" action=\"javascript:comment_form('+num+')\"><textarea name=\"add_reply\" cols=80 rows=8><\/textarea><br><input type="submit"><\/form><\/div><br><a style="font-weight:bold;" onclick=\"loadInbox(1);\">return to inbox<\/a>';
				markRead(num);
				document.getElementById("content").innerHTML=output;
				$('.tag_in_bin').corner("bevel 8px").parent().css('padding','4px').corner("bevel 10px");
				$('#content').uncorner();
				$('#content').corner("bevel 20px");
			}
			else{ alert(mygetrequest.status); }
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
   var output='<div id="pubox"><h2>Public Inbox<\/h2><div style="width:100%;"><div style="float:left;"><form action="javascript:loadSearch();">Search: <input type="text" id="search_field"><input type="button" value="Submit" onclick="loadSearch()"><\/form><\/div><div id="postButton"><a onclick="loadSend();">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,145);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div class="uparrow" style="text-align:center;margin-top:2px"><a onclick="upvote(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/up.png"/> <\/a><\/div><div class="numofvotes" style="text-align:center;">';
    	output+=votes+'<\/div><div class="downarrow" style="text-align:center;margin-bottom:1px"><a onclick="downvote(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/down.png"/> <\/a><\/div><\/div><div class="msgSpace" ';
    	output+=' onclick="markRead(\''+idnumber+'\');showFullMessagePublic(\''+idnumber+'\',\''+theString+'\',\''+tags+'\');"><div id="msg'+idnumber+'">';
   	output+=shortstring;
    	output+='...<\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a onclick="markBoxed(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/box.png"><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadPubox(1);"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
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
mygetrequest.open("GET", "/json/public_messages/" + page, true);
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
var output = '<div><h2>View Message<\/h2><div class=\"fullMessage\">'+unescape(string)+'<br><br><div class=\"tag_in_bin_holder\" style=\"background-color:white;\"><h4>tagged:<\/h4>';
var tags =  jsondata[1]['tags'];
for (var i=0; i<tags.length; i++) {
	output+= '<div class=\"public_tag_in_widget tag_in_bin\">'+tags[i][1]+'<\/div>';
}
output+= '<\/div><div style="clear:both;"><\/div><\/div><\/div><div><a style=\"font-weight:bold\" onclick=\"loadPubox(1);\"><br>return<\/a><div id=\"commentBox\"><h3>'+replies.length+' Comments:<\/h3><\/div>';
for (var i=0; i<replies.length; i++) {
output+='<div class="replyBody"><div style="font-weight:bold">author:  ';
output+=jsondata[1]['replies'][i]['author']+'</div><br>';
var replybody=jsondata[1]['replies'][i]['body'];
output+=replybody+'<\/div>';
}
output+='<div id=\"responseBox\"><h3>Submit a Comment:<\/h3><form id=\"comment_submit\" action=\"javascript:comment_form('+num+')\"><textarea name=\"add_reply\" cols=80 rows=12><\/textarea><input type="submit"><\/form><\/div><\/div>';
document.getElementById("content").innerHTML=output;
$('.tag_in_bin').corner("bevel 8px").parent().css('padding', '4px').corner("bevel 10px");
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

function loadSent(page)
{
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="sent"><h2>Sent Messages<\/h2><div style="width:100%;"><div style="float:left;"><form action="javascript:loadSearch();">Search: <input type="text" id="search_field"><input type="button" value="Submit" onclick="loadSearch()"><\/form><\/div><div id="postButton"><a onclick="loadSend();">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,145);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div class="uparrow" style="text-align:center;margin-top:2px"><a onclick="upvote(\''+idnumber+'\');loadSent(1);"><img src="/static/imgs/up.png"/> <\/a><\/div><div class="numofvotes" style="text-align:center;">';
    	output+=votes+'<\/div><div class="downarrow" style="text-align:center;margin-bottom:1px"><a onclick="downvote(\''+idnumber+'\');loadSent(1);"><img src="/static/imgs/down.png"/> <\/a><\/div><\/div><div class="msgSpace" ';
    	output+=' onclick="markRead(\''+idnumber+'\');showFullMessageSent(\''+idnumber+'\',\''+theString+'\',\''+tags+'\');"><div id="msg'+idnumber+'">';
   	output+=shortstring;
    	output+='...<\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a onclick="markBoxed(\''+idnumber+'\');loadSent(1);"><img src="/static/imgs/box.png"><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadSent(1);"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
   }
   output+='<\/div>';
	if (page > 1) {
   	output+='<\/div><\/div><br><div><a onclick="loadSent(';
   	output+= (page-1) + ');">previous<\/a><\/div>';
   	}
   	output+='<\/div><\/div><br><div><a onclick="loadSent(';
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
var output = '<div><h2>View Message<\/h2><div class=\"fullMessage\">'+unescape(string)+'<br><br><div class=\"tag_in_bin_holder\" style=\"background-color:white;\"><h4>tagged:<\/h4>';
var tags =  jsondata[1]['tags'];
for (var i=0; i<tags.length; i++) {
	output+= '<div class=\"public_tag_in_widget tag_in_bin\">'+tags[i][1]+'<\/div>';
}
output+= '<\/div><div style="clear:both;"><\/div><\/div><\/div><div><a style="font-weight:bold" onclick=\"loadSent(1);\"><br>return<\/a><div id=\"commentBox\"><h3>'+replies.length+' Comments:<\/h3><\/div>';
for (var i=0; i<replies.length; i++) {
output+='<div class="replyBody"><div style="font-weight:bold">author:  ';
output+=jsondata[1]['replies'][i]['author']+'</div><br>';
var replybody=jsondata[1]['replies'][i]['body'];
output+=replybody+'<\/div>';
}
output+='<div id=\"responseBox\"><h3>Submit a Comment:<\/h3><form id=\"comment_submit\" action=\"javascript:comment_form('+num+')\"><textarea name=\"add_reply\" cols=80 rows=12><\/textarea><input type="submit"><\/form><\/div><\/div>';
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

function loadSaved(page)
{
var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   console.log(jsondata);
   var output='<div id="boxed"><h2>Boxed Messages<\/h2><div style="width:100%;"><div style="float:left;"><form action="javascript:loadSearch();">Search: <input type="text" id="search_field"><input type="button" value="Submit" onclick="loadSearch()"><\/form><\/div><div id="postButton"><a onclick="loadSend();">Post<\/a><\/div><div style="clear:both;"><\/div><\/div><div><div id="msgContainer">';
   for (var i=0; i<jsondata.length; i++){
   	idnumber = jsondata[i][0];
   	var shortstring = jsondata[i][1]['body'].slice(0,145);
   	var theString = escape(jsondata[i][1]['body']);
   	var tags = jsondata[i][1]['tags'];
   	var votes = jsondata[i][1]['score'];
    	output+='<div class="msgBox msgColor'+i%2+'"><div class="votes"><div class="uparrow" style="text-align:center;margin-top:2px"><a onclick="upvote(\''+idnumber+'\');loadSaved(1);"><img src="/static/imgs/up.png"/> <\/a><\/div><div class="numofvotes" style="text-align:center;">';
    	output+=votes+'<\/div><div class="downarrow" style="text-align:center;margin-bottom:1px"><a onclick="downvote(\''+idnumber+'\');loadSaved(1);"><img src="/static/imgs/down.png"/> <\/a><\/div><\/div><div class="msgSpace" ';
    	output+=' onclick="markRead(\''+idnumber+'\');showFullMessageSaved(\''+idnumber+'\',\''+theString+'\',\''+tags+'\');"><div id="msg'+idnumber+'">';
   	output+=shortstring;
    	output+='...<\/div><div class=\"fullContent\">'+jsondata[i][1]['body']+'<\/div><div id="tags_and_replies"><\/div>';
    	output+='<\/div><div class="saveBox"><a onclick="unBoxed(\''+idnumber+'\');loadSaved(1);"><img src="/static/imgs/box.png"><\/a><\/div><div class="spamButton"><a onclick="markSpam(\''+idnumber+'\');loadSaved(1);"><img src="/static/imgs/spambutton.png"><\/a><\/div><\/div>';
   }
   output+='<\/div>';
	if (page > 1) {
   	output+='<\/div><\/div><br><div><a onclick="loadSaved(';
   	output+= (page-1) + ');">previous<\/a><\/div>';
   	}
   	output+='<\/div><\/div><br><div><a onclick="loadSaved(';
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
var output = '<div><h2>View Message<\/h2><div class=\"fullMessage\">'+unescape(string)+'<br><br><div class=\"tag_in_bin_holder\" style=\"background-color:white;\"><h4>tagged:<\/h4>';
var tags =  jsondata[1]['tags'];
for (var i=0; i<tags.length; i++) {
	output+= '<div class=\"public_tag_in_widget tag_in_bin\">'+tags[i][1]+'<\/div>';
}
output+= '<\/div><div style="clear:both;"><\/div><\/div><\/div><div><a style="font-weight:bold" onclick=\"loadSaved(1);\"><br>return<\/a><div id=\"commentBox\"><h3>'+replies.length+' Comments:<\/h3><\/div>';
for (var i=0; i<replies.length; i++) {
output+='<div class="replyBody"><div style="font-weight:bold">author:  ';
output+=jsondata[1]['replies'][i]['author']+'</div><br>';
var replybody=jsondata[1]['replies'][i]['body'];
output+=replybody+'<\/div>';
}
output+='<div id=\"responseBox\"><h3>Submit a Comment:<\/h3><form id=\"comment_submit\" action=\"javascript:comment_form('+num+')\"><textarea name=\"add_reply\" cols=80 rows=12><\/textarea><input type="submit"><\/form><\/div><\/div>';
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

function loadTagsBin() {
	var mygetrequest=new ajaxRequest();
	mygetrequest.onreadystatechange=function(){
		if (mygetrequest.readyState==4){
			if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
				var response = mygetrequest.responseText;
				jsondata = JSON.parse(response);
				console.log(jsondata["my_tags"]);
				var output='<h3>My Tags<\/h3><div id=\"my_tag_bucket_container\">';
				output+='<\/div>';
				output+='<h3>Public Tags<\/h3><div id=\"public_tag_bucket_container\">';
				for (var i=0; i<jsondata["default_tags"].length; i++){
					idnumber = jsondata["default_tags"][i][0];
					output+='<div class=\"public_tag tag_in_bin\" id=\'pub'+idnumber+'\' onclick=addTag(\''+idnumber+'\')>';
					output+= jsondata["default_tags"][i][1];
					output+='<\/a><\/div>';
				}
				output+='<div style="clear:both"></div><div class=\"allpublic_tag tag_in_bin\" id=\'pub'+jsondata["public_tag"][0]+'\' onclick=addTag(\''+jsondata["public_tag"][0]+'\')>Public Tag<\/a><\/div><\/div>';
				document.getElementById("content").innerHTML=output;
				for (var i=0; i<jsondata["my_tags"].length; i++) {
					id = jsondata["my_tags"][i][0];
					var ni = document.getElementById('my_tag_bucket_container');
					var newdiv = document.createElement('div');
					newdiv.setAttribute('id','my'+id);
					newdiv.setAttribute('onclick','removeTag('+id+')');
					var olddiv = document.getElementById('pub'+id);
					newdiv.setAttribute('class',olddiv.getAttribute('class'));
					olddiv.setAttribute('class',olddiv.getAttribute('class') + ' added');
					newdiv.innerHTML=olddiv.innerHTML;
					ni.appendChild(newdiv);
				}
				$('#content').uncorner();
				$('#content').corner("bevel 20px")
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
var tags = [];

function message_form() {
	
var formData = form2object('message_submit');
formData.tags = tags;
var submitted_message = JSON.stringify(formData, null, '\t');
var params = "data=" + encodeURIComponent(submitted_message); var i = 1;
console.log(formData);
ajax = new ajaxRequest();
ajax.open("POST", "/json/send_message/", true);
ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
ajax.send(params);


loadInbox(1);
humanMsg.displayMsg('Message Sent!');
scroll(0,0);
//$(document).one('click mousemove keypress', function(e) { 
  //          $('.message').animate({ opacity: 1.0 }, 500).fadeOut();  
   //     });  
}



function loadPrivacy() {
document.getElementById("content").innerHTML=
	"<div id=\"privacy\"><h2>MySoapbox.org Terms of Service<\/h2><div><p>We reserve the right to change the Terms of Use (TOU) at anytime.  It is your responsibility to check this document for updates.<\/p><p>SoapBox is an online messenger that allows user to send messages to other users based on demographics.  As a user, you will receive messages from other users based on the information that you provide SoapBox about yourself.  We want the experience of SoapBox to be as safe, fun, informative, and efficient as possible for all users.  Please help us to ensure that SoapBox remains a safe place for all everyone.<\/p><p>The personal information that you provide us with will be used for the purpose of sending you messages that SoapBox thinks you will have interest in.  Likewise, it will aid in sending your messages to the most pertinent recipients.   With measures to keep your information safe and secure, we will only share certain elements of your user data with third parties that work with us.  This will only be done to help serve you better in the service.  For example, we work with a third party company that specializes in geo-location software.  They will in no way share your information with any other party, nor will they use your information for another purpose other than assisting us in providing you with a great service.  <\/p><p>SoapBox is a community of anonymous users.  It is ignorant of the true identities and intentions of its users.  You, as a user, acknowledge that SoapBox does not pre-screen its users.  Therefore you must be cautious and prudent in your interactions with other users.  We suggest that you do not give any personal data to other users, especially about your location, age, gender, orientation, etc.  SoapBox does not control the content sent or received by its users.  We are not responsible for any offensive material that you may receive from other users.  It is your responsibility to assess the content of a message and decide how to use it.  SoapBox is not responsible for how you chose to use the content that we make available to you.  You are solely responsible for the messages that you send through SoapBox.  If you chose to meet another user through SoapBox, SoapBox is not responsible for the relationship that ensues, nor any harm that may come from the interaction.  It is your responsibility to use SoapBox with regard for your own well being.  <\/p><p>SoapBox does not own any content that you upload to us during your usage.  However, you acknowledge that SoapBox administrators may have access to view this content and may chose to hold it on our server for as long as we wish.  If you have any sensitive material that you would like to share, such as personal information or intellectual property, beware that we, the administrators of SoapBox, may view it during our normal maintenance of the site. <\/p><p>Users who misuse SoapBox in any of the following ways will have their account terminated:  1) attempting to send adult material to users who are under 18 years of age, 2) sending messages that attempt to sell retail items, or a promote a retail service, without tagging them with appropriate tags, 3) attempting to conduct illegal acts through SoapBox, 3) spamming other users with unwanted material, and 4) any other offenses that SoapBox deems unacceptable.  SoapBox has the right to terminate any and all accounts at its discretion.  <\/p><p>Under no circumstances will SoapBox be held reliable for any actions of its users, whether accidental or otherwise.  In no event shall SoapBox, or any of its creators or employees, be liable to you or any third party for any damages, whether indirect, consequential, incidental, or otherwise, even if SoapBox has been advised of the possibility of such damages.  SoapBox will only be liable for money paid by you, the user, to SoapBox for any of its services.<\/p><p>The TOU will be governed by the laws of the state of California.<\/p><\/div><\/div>";
	 $('#content').uncorner();
  	 $('#content').corner("bevel 20px")
}

function addsendTag(i) {
if (document.getElementById('send'+i)) {return;}
var ni = document.getElementById('send_tags_container');
var newdiv = document.createElement('div');
newdiv.setAttribute('id','send'+i);
newdiv.setAttribute('class','public_tag');
newdiv.setAttribute('onclick','removesendTag('+i+')');
var olddiv = document.getElementById('sendable'+i);
olddiv.setAttribute('class',olddiv.getAttribute('class') + ' added');
newdiv.innerHTML=olddiv.innerHTML;
ni.appendChild(newdiv);
tags.push(i);
}

function removesendTag(i) {
var d = document.getElementById('send_tags_container');
var olddiv = document.getElementById('send'+i);
d.removeChild(olddiv);
tags.splice(tags.indexOf(i),1);
document.getElementById('sendable'+i).setAttribute('class',olddiv.getAttribute('class').replace(/\s+\S*$/, ""));
}

function loadSend() {
	var mygetrequest=new ajaxRequest();
mygetrequest.onreadystatechange=function(){
 if (mygetrequest.readyState==4){
  if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
   var response = mygetrequest.responseText;
   jsondata = JSON.parse(response);
   var output='<div id=\"send\"><div style=\"width:300px;\"><form id=\"message_submit\" action=\"javascript:message_form()\"><h3>Message<\/h3><textarea name=\"body\" cols=80 rows=12><\/textarea><h3>Tags:<\/h3><div id="send_tags_container"></div><h3>Tag it:<\/h3>';

      output+='<div id=\"sendable_tags_container\">';
    for (var i=0; i<jsondata["default_tags"].length; i++){
   	idnumber = jsondata["default_tags"][i][0];
   	tagtext = jsondata['default_tags'][i][1];
    	output+='<div class=\"public_tag tag_in_bin\" id=\'sendable'+idnumber+'\' onclick=addsendTag('+idnumber+')>';
    	output+= tagtext;
    	output+='<\/a><\/div>';
   	}
   
   
   	output+='<div style="clear:both"></div><div class=\"personal_tag tag_in_bin\" id=\'sendable'+jsondata['personal_tag'][0]+'\' onclick=addsendTag('+jsondata['personal_tag'][0]+')>Personal Tag</div><div class=\"allpublic_tag tag_in_bin\" id=\'sendable'+jsondata['public_tag'][0]+'\' onclick=addsendTag('+jsondata['public_tag'][0]+')>Public Tag</div></div>';
   	output+='<h3>To who?</h3>';
   	output+='Age range: <select name=\"from\"><option value=\"\" selected=\"selected\">any<\/option><option value=\"18\">18<\/option> <option value=\"19\">19<\/option> <option value=\"20\">20<\/option> <option value=\"21\">21<\/option> <option value=\"22\">22<\/option> <option value=\"23\">23<\/option> <option value=\"24\">24<\/option> <option value=\"25\">25<\/option> <option value=\"26\">26<\/option> <option value=\"27\">27<\/option> <option value=\"28\">28<\/option> <option value=\"29\">29<\/option> <option value=\"30\">30<\/option> <option value=\"31\">31<\/option> <option value=\"32\">32<\/option> <option value=\"33\">33<\/option> <option value=\"34\">35<\/option> <option value=\"36\">36<\/option> <option value=\"37\">37<\/option> <option value=\"38\">38<\/option> <option value=\"39\">39<\/option> <option value=\"40\">40<\/option> <option value=\"41\">41<\/option> <\/select> to <select name=\"to\"><option value=\"\" selected=\"selected\">any<\/option><option value=\"18\">18<\/option> <option value=\"19\">19<\/option> <option value=\"20\">20<\/option> <option value=\"21\">21<\/option> <option value=\"22\">22<\/option> <option value=\"23\">23<\/option> <option value=\"24\">24<\/option> <option value=\"25\">25<\/option> <option value=\"26\">26<\/option> <option value=\"27\">27<\/option> <option value=\"28\">28<\/option> <option value=\"29\">29<\/option> <option value=\"30\">30<\/option> <option value=\"31\">31<\/option> <option value=\"32\">32<\/option> <option value=\"33\">33<\/option> <option value=\"34\">35<\/option> <option value=\"36\">36<\/option> <option value=\"37\">37<\/option> <option value=\"38\">38<\/option> <option value=\"39\">39<\/option> <option value=\"40\">40<\/option> <option value=\"41\">41<\/option> <\/select>';
   	output+='<br>Sex: <select name=\"sex\"><option value=\"\" selected=\"selected\">both<\/option><option value=\"females\">females<\/option> <option value=\"males\">males<\/option> <option value=\"both\">both<\/option> <\/select> ';
   	output+='<br>Within: <select name=\"miles\"><option value=\"\" selected=\"selected\">any<\/option><option value=\".1\">.1<\/option> <option value=\".25\">.25<\/option><option value=\".5\">.5<\/option><option value=\"1\">1<\/option><option value=\"2\">2<\/option><option value=\"5\">5<\/option><option value=\"any\">any<\/option><\/select> miles';
   	output+='<br><br><input type=\"submit\"><\/form><\/div>';
  	 document.getElementById("content").innerHTML=output;
  	 	 $('#content').uncorner();
  	 $('#content').corner("bevel 20px")
  }
  else{
   alert("An error has occured making the request");
  }
 }
}
mygetrequest.open("GET", "/json/send_tags", true);
mygetrequest.send(null);
}

function getUser() {
	var mygetrequest=new ajaxRequest();
	mygetrequest.onreadystatechange=function() {
		if (mygetrequest.readyState==4){
			if (mygetrequest.status==200 || window.location.href.indexOf("http")==-1){
				jsondata = JSON.parse(mygetrequest.responseText);
				var login = document.getElementById('user_email');
				login.innerHTML = jsondata['email'];
			}
			else{
				console.log("An error has occured making the request");
			}
		}
	}
	mygetrequest.open("GET", "/json/user/", true);
	mygetrequest.send(null);
}
