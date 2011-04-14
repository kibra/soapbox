<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
<title>Soapbox</title>

<link rel="stylesheet" type="text/css" href="/static/mysoapbox.css">	
<script type="text/javascript" src="/static/form2object.js"></script>
<script type="text/javascript" src="/static/json2.js"></script>	
<script type="text/javascript" src="/static/box.js"></script>
<script type="text/javascript" src="/static/jquery-1.5.2.js"></script>
<script type="text/javascript" src="/static/jquery.corner.js"></script>
<script type="text/javascript" src="/static/humanmsg.js"></script>
<script type="text/javascript">

$(document).ready(function(){
$('.widget').corner("bevel 8px");
$('.widget_header').corner("bevel top 30px");
$('.fullContent').hide();
});

</script>
</head>






<body onLoad="loadInbox(1);populateTagWidget();getUser();"	>

<div id="main">
	<div id="header">
		<div id="logo" style="float:left;">
			<div id="logo_img">
				<a href="/box">
					<img src="/static/imgs/logo.png" style="float:left;" />
				</a>
			</div>
	</div>

	<div id="loginbar" style="float:right;">
		<div id="login">
			<span id="user_email"></span> | <a onclick="loadSettings();" style="cursor:pointer;">My Account</a> | <a href="/box/logout" style="cursor:pointer;">Sign Out</a> | <a onclick="loadAbout();" style="cursor:pointer;">About</a>
		</div><!-- #login -->
	</div><!-- #loginbar -->
</div><!-- #header -->

<div id="floatdiv">

<div id="nav">
		   
		    <div class="navtab" id="inboxTab" style="position:relative;z-index:4;"onclick="changeTab(this);">
		     <a onclick="loadInbox(1);">
		   	 <img src="/static/imgs/tab-top.png" style="float:left;" />
			    <div class="innerTab" style="float:left;">
			    	<p class="vertical" id="boldtext">inbox</p>
			    </div>
			 <img src="/static/imgs/tab-bottom.png" style="float:right;" />
			 </a>
		    </div>
		    
		    
		   
		    <div class="navtab" id="puboxTab" style="position:relative;z-index:3;" onclick="changeTab(this);">
		     <a onclick="loadPubox(1);">
		     <img src="/static/imgs/tab-top.png" style="float:left;" />
			    <div class="innerTab" style="float:left;">
		    <p class="vertical" id="boldtext">public</p>
		    </div>
		     <img src="/static/imgs/tab-bottom.png" style="float:right;" />   			 </a>
		    </div>
		
		    
		    
		    <div class="navtab" id="boxedTab" style="position:relative;z-index:2;" onclick="changeTab(this);">
		      <a onclick="loadSaved(1);">
		    <img src="/static/imgs/tab-top.png" style="float:left;" />
			    <div class="innerTab" style="float:left;">
		    <p class="vertical" id="boldtext">saved</p>
		    </div>
		     <img src="/static/imgs/tab-bottom.png" style="float:right;" /></a>
		    </div>
		    
		    
		   
		    <div class="navtab" id="tagsTab" style="position:relative;z-index:1;" onclick="changeTab(this);"> <a onclick="loadTagsBin();">
		    <img src="/static/imgs/tab-top.png" style="float:left;" />
			    <div class="innerTab" style="float:left;">
		    <p class="vertical" id="boldtext">tags</p>
		    </div>
		     <img src="/static/imgs/tab-bottom.png" style="float:right;" /> </a>
		    </div>
		   
		    
		    	    
		    <div class="navtab" id="sentTab" style="position:relative;z-index:0;" onclick="changeTab(this);">
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
			<div class="widget_header"style="float:left;">tags</div>
			</div>
			<div>
			<div id="tags" class="widget"> </div>
			</div>
		</div>
		
		<div>
			<div class="widget_header_container">
			
			<div class="widget_header" style="float:left;">tips</div>
			</div>
			<div>
			<div id="boxes" class="widget" style="text-align:left;"> <div style="padding:10px;font-style:bold;">The tags you collect help us decide which messages to send you!<br><br>

Use the “Personal Emergency” tag to alert people close by that you need help--dead battery, locked out of house, etc.!</div>
			</div></div>
		</div>
		
		<div>
			<div class="widget_header_container">
			
			<div class="widget_header" style="float:left;">ads</div>
				</div>
				<div>
			<div id="ads" class="widget"> </div>
			</div>
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
