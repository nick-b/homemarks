
var HomeMarksBase = {
  
  flashMoods: $A(['good','bad','indif']),
  flashMoodColors: $H({ good:'spring_green', bad:'red', indif:'aqua' }),
  
  getRequestMood: function(request) {
    return (request.status >= 200 && request.status < 300) ? 'good' : 'bad';
  },
  
  messagesToAlert: function(request) {
    var messages = request.responseJSON;
    var alertText = messages.join(".\n");
    if (alertText.endsWith('.')) { alert(alertText); } else { alert(alertText+'.'); };
  },
  
  messagesToList: function(request) {
    var messages = request.responseJSON;
    var messageList = UL();
    messages.each(function(message){ 
      messageList.appendChild( LI(message.escapeHTML()) );
    });
    return messageList;
  },
  
  redirectToUserHome: function() {
    window.location = '/myhome';
  },
  
  scroll: function() { return document.viewport.getScrollOffsets(); },
  
  pageSize: function() { 
    var xScroll, yScroll;
    if (window.innerHeight && window.scrollMaxY) {	
  		xScroll = window.innerWidth + window.scrollMaxX;
  		yScroll = window.innerHeight + window.scrollMaxY;
  	} else if (document.body.scrollHeight > document.body.offsetHeight){
  		xScroll = document.body.scrollWidth;
  		yScroll = document.body.scrollHeight;
  	} else {
  		xScroll = document.body.offsetWidth;
  		yScroll = document.body.offsetHeight;
  	}
	  var windowWidth, windowHeight;
  	if (self.innerHeight) {
  		if(document.documentElement.clientWidth){
  			windowWidth = document.documentElement.clientWidth; 
  		} else {
  			windowWidth = self.innerWidth;
  		}
  		windowHeight = self.innerHeight;
  	} else if (document.documentElement && document.documentElement.clientHeight) {
  		windowWidth = document.documentElement.clientWidth;
  		windowHeight = document.documentElement.clientHeight;
  	} else if (document.body) { 
  		windowWidth = document.body.clientWidth;
  		windowHeight = document.body.clientHeight;
  	}	
  	if(yScroll < windowHeight){
  		pageHeight = windowHeight;
  	} else { 
  		pageHeight = yScroll;
  	}
  	if(xScroll < windowWidth){	
  		pageWidth = xScroll;		
  	} else {
  		pageWidth = windowWidth;
  	}
  	return { width: pageWidth, height: pageHeight };
  }
  
};
