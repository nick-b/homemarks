function getModalVars() {
  modalMask = $('modalmask');
  modalProgress = $('modal_progress');
  modalWrapper = $('modal_html_ap-wrapper');
  modalContent = $('modal_html_rel-wrapper');
  windowScroll = WindowUtilities.getWindowScroll();
  pageSize = WindowUtilities.getPageSize();
  }

function setupModal(boxid) {
  boxid = (boxid == null) ? 'bookmarklet' : boxid;
  getModalVars();
  centerStuff();
  Effect.Appear(modalMask, {duration:0.4, from:0.0, to:0.9, queue:{position:'end', scope:'boxid_' + boxid}});
  Event.observe(window, 'resize', centerStuff);
  Event.observe(window, 'scroll', centerStuff);
  Event.observe(document, 'keypress', respondtoKeypress);
  // Removed actoin area conditions from here
  // if (typeof($('action_area_shim'))!='undefined') {
  //   Event.stopObserving(document, 'keypress', actionAreaHelper);
  //   if (Element.hasClassName('action_bar','barout')) { toggleActionArea('inbox'); }
  //   }
  }

function centerStuff() {
  getModalVars();
  centerModalMask();
  // Removed (modalWrapper.hasClassName('inhomemarks_site')
  // if (modalWrapper.hasClassName('inhomemarks_site')) {centerBoxEditModal();} else {centerBookmarkletModal();};
  // Added this instead
  centerBookmarkletModal();
  }

function centerModalMask() {
  modalMask.setStyle({height: pageSize.pageHeight + 'px'});
  modalProgress.setStyle({top: (windowScroll.top + 60) + 'px'});
  }

// Removed this since it was not needed in the removed condition above.
// function centerBoxEditModal() {
//   modalWrapperLeft = (pageSize.pageWidth - 652)/2;
//   if (modalWrapperLeft < 0) modalWrapperLeft = 0;
//   modalWrapper.setStyle({left: modalWrapperLeft+'px'}) ;
//   }

function centerBookmarkletModal() {
  modalWrapperLeft = (pageSize.pageWidth - 352)/2;
  if (modalWrapperLeft < 0) modalWrapperLeft = 0;
  modalWrapper.setStyle({left: modalWrapperLeft+'px'}) ;
  }

function destroyModal(boxid) {
  boxid = (boxid == null) ? 'bookmarklet' : boxid;
  getModalVars();
  Event.stopObserving(window, 'resize', centerStuff);
  Event.stopObserving(window, 'scroll', centerStuff);
  Event.stopObserving(document, 'keypress', respondtoKeypress);
  Effect.SlideUp(modalContent, {duration:0.4, queue:{position:'end', scope:'boxid_' + boxid}});
  Effect.Fade(modalMask, {duration:0.2, queue:{position:'end', scope:'boxid_' + boxid}});
  // Did not need this either.
  // Event.observe(document, 'keypress', actionAreaHelper);
  }

function respondtoKeypress(event) {
  // Did not need this since it is not in the HM site.
  // if ($('modal_html_ap-wrapper').hasClassName('inhomemarks_site')) {
  //   boxidstring = $('modal_button_cancel').classNames().toString();
  //   boxid = boxidstring.gsub('cancel_modalbox_','');
  //   if (event.keyCode == Event.KEY_ESC) destroyModal(boxid);
  //   }
  // else {
    if (event.keyCode == Event.KEY_ESC) destroyModal();
  //  }
  }

function hideModal(boxid) {
  boxid = (boxid == null) ? 'bookmarklet' : boxid;
  getModalVars();
  Event.stopObserving(document, 'keypress', respondtoKeypress);
  Effect.SlideUp(modalContent, {duration:0.4, queue:{position:'end', scope:'boxid_' + boxid}});
  Effect.Appear(modalProgress, {duration:0.2, from:0.0, to:0.9, queue:{position:'end', scope:'boxid_' + boxid}});
  }

function destroyModalMask(boxid) {
  boxid = (boxid == null) ? 'bookmarklet' : boxid;
  getModalVars();
  Event.stopObserving(window, 'resize', centerStuff);
  Event.stopObserving(window, 'scroll', centerStuff);
  Effect.Fade(modalMask, {duration:0.2, queue:{position:'end', scope:'boxid_' + boxid}});
  }

function goHere() {
  window.location.reload();
  }



var WindowUtilities = {

  getWindowScroll: function() {
    var w = window;
      var T, L, W, H;
      with (w.document) {
        if (w.document.documentElement && documentElement.scrollTop) {
          T = documentElement.scrollTop;
          L = documentElement.scrollLeft;
        } else if (w.document.body) {
          T = body.scrollTop;
          L = body.scrollLeft;
        }
        if (w.innerWidth) {
          W = w.innerWidth;
          H = w.innerHeight;
        } else if (w.document.documentElement && documentElement.clientWidth) {
          W = documentElement.clientWidth;
          H = documentElement.clientHeight;
        } else {
          W = body.offsetWidth;
          H = body.offsetHeight
        }
      }
      return { top: T, left: L, width: W, height: H };
  },

  getPageSize: function(){
    var xScroll, yScroll;
    if (window.innerHeight && window.scrollMaxY) {  
      xScroll = document.body.scrollWidth;
      yScroll = window.innerHeight + window.scrollMaxY;
    } else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
      xScroll = document.body.scrollWidth;
      yScroll = document.body.scrollHeight;
    } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
      xScroll = document.body.offsetWidth;
      yScroll = document.body.offsetHeight;
    }
    var windowWidth, windowHeight;
    if (self.innerHeight) {  // all except Explorer
      windowWidth = self.innerWidth;
      windowHeight = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
      windowWidth = document.documentElement.clientWidth;
      windowHeight = document.documentElement.clientHeight;
    } else if (document.body) { // other Explorers
      windowWidth = document.body.clientWidth;
      windowHeight = document.body.clientHeight;
    }  
    var pageHeight, pageWidth;
    // for small pages with total height less then height of the viewport
    if(yScroll < windowHeight){
      pageHeight = windowHeight;
    } else { 
      pageHeight = yScroll;
    }
    // for small pages with total width less then width of the viewport
    if(xScroll < windowWidth){  
      pageWidth = windowWidth;
    } else {
      pageWidth = xScroll;
    }
    return {pageWidth: pageWidth ,pageHeight: pageHeight , windowWidth: windowWidth, windowHeight: windowHeight};
  }

}


