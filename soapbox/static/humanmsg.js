/*
	HUMANIZED MESSAGES 1.0
	idea - http://www.humanized.com/weblog/2006/09/11/monolog_boxes_and_transparent_messages
	home - http://humanmsg.googlecode.com
*/

var humanMsg = {
	setup: function(appendTo, msgOpacity) {
		humanMsg.msgID = 'humanMsg';
		humanMsg.logID = 'humanMsgLog';

		// Opacity of the message
		humanMsg.msgOpacity = .8;

		// Inject the message structure
		jQuery('body').append('<div id="'+humanMsg.msgID+'" class="humanMsg"><div class="round"></div><p></p><div class="round"></div></div> ')
		
	},

	displayMsg: function(msg) {
		if (msg == '')
			return;

		clearTimeout(humanMsg.t2);

		// Inject message
		jQuery('#'+humanMsg.msgID+' p').html(msg);
	
		// Show message
		jQuery('#'+humanMsg.msgID+'').show().animate({ opacity: humanMsg.msgOpacity}, 200, function() {});

		// Watch for mouse & keyboard in .5s
		humanMsg.t1 = setTimeout("humanMsg.bindEvents()", 2000);
		// Remove message after 5s
		humanMsg.t2 = setTimeout("humanMsg.removeMsg()", 3000);

	},

	bindEvents: function() {
	// Remove message if mouse is moved or key is pressed
		jQuery(window)
			.mousemove(humanMsg.removeMsg)
			.click(humanMsg.removeMsg)
			.keypress(humanMsg.removeMsg)
	},

	removeMsg: function() {
		// Unbind mouse & keyboard
		jQuery(window)
			.unbind('mousemove', humanMsg.removeMsg)
			.unbind('click', humanMsg.removeMsg)
			.unbind('keypress', humanMsg.removeMsg)
		// If message is fully transparent, fade it out
			jQuery('#'+humanMsg.msgID).animate({ opacity: 0 }, 500, function() { jQuery('#'+humanMsg.msgID).hide() })
	}
};

jQuery(document).ready(function(){
	humanMsg.setup();
})
