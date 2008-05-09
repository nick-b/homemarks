
var HomeMarksUtil = {
  
  alertMessages: function(request) {
    var messages = request.responseJSON;
    var alertText = messages.join(".\n");
    if (alertText.endsWith('.')) { alert(alertText); } else { alert(alertText+'.'); };
  },
  
  parseStatus: function(request) {
    return (request.status >= 200 && request.status < 300) ? 'good' : 'bad';
  }
  
};

var HomeMarksSite = Class.create({ 
  
  initialize: function() {
    this.ajaxFrom = $('ajaxforms_wrapper');
    this.ajaxFromLinks = $$('.ajaxform_link');
    this.supportForm = $('support_form');
    this.loginForm = $('login_form');
    this.signupForm = $('signup_form');
    this.initEvents();
  },
  
  toggleAjaxFormBlind: function(event) {
    if (event) { event.element().blur(); };
    Effect.toggle(this.ajaxFrom, 'blind', {duration:0.4});
  },
  
  startAjaxForm: function(event) {
    event.stop();
    var form = event.findElement('form');
    var options = Object.extend({loadId:'form_loading',imgSrc:'loading_invert.gif'}, arguments[1] || {});
    var imgTmpl = new Template('<img src="/images/#{src}" />');
    var imgTag = imgTmpl.evaluate({ src: options.imgSrc });
    $(options.loadId).update(imgTag);
    new Ajax.Request(form.action,{
      onComplete: function(request){ this.delegateCompleteAjaxForm(form,request) }.bind(this),
      parameters: form.serialize(true)
    });
    form.disable();
  },
  
  delegateCompleteAjaxForm: function(form,request) {
    var status = HomeMarksUtil.parseStatus(request);
    this.completeAjaxForm(form,{mood:status,enable:(status == 'bad')}); // This should go in completeAjaxForm ??
    if (status == 'good') { 
      switch (form) { 
        case this.supportForm : this.completeSupportForm(request);
        case this.loginForm   : this.completeLoginForm(request); 
        case this.signupForm  : this.completeSignupForm(request); 
      }
    }
    else { HomeMarksUtil.alertMessages(request); };
  },
  
  completeAjaxForm: function(form) {
    var options = Object.extend({loadId:'form_loading',mood:'good',enable:true}, arguments[1] || {});
    var completeId = 'complete_ajax_form_' + options.loadId;
    var moodTmpl = new Template('<span id="#{id}" class="m0 p0"><img src="/images/#{src}.png" /></span>');
    var moodHtml = moodTmpl.evaluate({ id: completeId, src: options.mood});
    $(options.loadId).update(moodHtml);
    setTimeout(function() { $(completeId).visualEffect('fade') },2000);
    if (options.enable) { $(form).enable(); };
  },
  
  submitSupportForm: function(event) { 
    this.startAjaxForm(event,{imgSrc:'loading.gif'});
  },
  
  completeSupportForm: function() {
    setTimeout(function(){ this.toggleAjaxFormBlind() }.bind(this),1500);
    setTimeout(function(){ this.supportForm.reset(); this.supportForm.enable(); }.bind(this),2000);
  },
  
  completeLoginForm: function() {
    window.location = HomeMarksUrls.root;
  },
  
  completeSignupForm: function() {
    window.location = HomeMarksUrls.root;
  },
  
  initEvents: function() {
    if (this.supportForm) { this.supportForm.observe('submit', this.submitSupportForm.bindAsEventListener(this)); };
    if (this.loginForm) { this.loginForm.observe('submit', this.startAjaxForm.bindAsEventListener(this)); };
    if (this.signupForm) { this.signupForm.observe('submit', this.startAjaxForm.bindAsEventListener(this)); };
    this.ajaxFromLinks.each(function(element){ 
      element.observe('click', this.toggleAjaxFormBlind.bindAsEventListener(this)); 
    }.bind(this));
  }

});


document.observe('dom:loaded', function(){
  HmSite = new HomeMarksSite();
});
























/*  General Application Wide Functions
 * ----------------------------------------------------------------------------------------------------------------- */

Event.observe(document, 'keypress', actionAreaHelper);
function actionAreaHelper(event) { if (event.charCode == 96) {toggleActionArea('inbox')}; };

function globalLoadingBehavior() {
  $('hud').classNames().set('');
	Element.show('loading');
	Element.update('message_wrapper', '<span id="message">&nbsp;</span>');
  }

function loadLameActionSpan(boxid,direction) {
  if (direction == 'down') { spanclass = 'box_action box_action_down' }
  if (direction == 'up') { spanclass = 'box_action' }
  Element.replace('boxid_'+boxid+'_action_alink', '<span class="'+spanclass+'" id="boxid_'+boxid+'_action_lame"></span>')
  }

function remoteFormLoading(formobj,loadid) {
  loadid = (loadid == null) ? 'form_loading' : loadid;
  if (formobj.id == 'request_support_form') {loadimg=''} else {loadimg='_invert'};
  Element.update($(loadid),'<img src="/images/loading'+loadimg+'.gif" />');
  Form.disable(formobj);
  }


/*  Custom sortable serialize params Column#sort
 * ----------------------------------------------------------------------------------------------------------------- */

function findSortedInfo(obj) {
  pg_sortable_id = obj.element.id;
  pg_lastvalues = $A(obj.lastValue.gsub(/col_wrapper\[\]=/i,'').split('&'));
  pg_sortable_seq = $A(Sortable.sequence(pg_sortable_id));
  
  if (pg_lastvalues.length == pg_sortable_seq.length) { // Find the column info within the sortable.
    pg_lastvalues.each(function(v,i) {
      if (v != pg_sortable_seq[i]) {
        /* Check to see if the bookmark was moved down */
        if (pg_lastvalues[i+1] == pg_sortable_seq[i]) { col_id=v; col_position=pg_sortable_seq.indexOf(v)+1; };
        /* Check to see if the bookmark was moved up */
        if (pg_lastvalues[i] == pg_sortable_seq[i+1]) { col_id=pg_sortable_seq[i]; col_position=i+1; };
        throw $break;
      };
    });
  return 'col_id='+col_id+'&col_position='+col_position;
  }
  else { return false; }
}



/*  Custom sortable serialize params Box#sort
 * ----------------------------------------------------------------------------------------------------------------- */

function findDroppedBoxInfo(obj) {
  col_sortable_id = obj.element.id;
  col_sortable_id_num = col_sortable_id.gsub(/col_/i,'');
  col_empty = obj.lastValue.length == 0 ? true : false ;
  col_lastvalues = $A(obj.lastValue.gsub(/(col_\d+)\[\]=/i,'').split('&'));
  col_sortable_seq = $A(Sortable.sequence(col_sortable_id));
  if ((col_lastvalues.length == col_sortable_seq.length) && !col_empty) { // Find the box info within the sortable.
    col_internal_sort = true; col_lost_box = false;
    col_lastvalues.each(function(v,i) {
      if (v != col_sortable_seq[i]) {
        /* Check to see if the box was moved down */
        if (col_lastvalues[i+1] == col_sortable_seq[i]) { box_id=v; box_position=col_sortable_seq.indexOf(v)+1; };
        /* Check to see if the box was moved up */
        if (col_lastvalues[i] == col_sortable_seq[i+1]) { box_id=col_sortable_seq[i]; box_position=i+1; };
        throw $break;
      };
    });
  }
  else { // Find the new or lost box info.
    col_internal_sort = false;
    col_lost_box = col_lastvalues.length > col_sortable_seq.length ? true : false ;
    /* Column's with a lost box is ignored by the server. */
    if (col_lost_box == true) { box_id = 'na' ; box_position = 'na' ; }
    /* Column with no boxes now gaining one. */
    else if (col_empty) { box_id = col_sortable_seq[0] ; box_position = 1 ; }
    else {
      col_long_array =  col_lastvalues.length > col_sortable_seq.length ? col_lastvalues : col_sortable_seq ;
      col_short_array =  col_lastvalues.length < col_sortable_seq.length ? col_lastvalues : col_sortable_seq ;
      col_long_array.each(function(v,i) {
        if (v != col_short_array[i]) { box_id=v; box_position=i+1; throw $break; };
      });
    }
  }
  return 'internal_sort='+col_internal_sort+'&lost_box='+col_lost_box+'&col_id='+col_sortable_id_num+'&box_id='+box_id+'&box_position='+box_position
}



/*  Custom sortable serialize params Bookmark#sort
 * ----------------------------------------------------------------------------------------------------------------- */

function findDroppedBookmarkInfo(obj) {
  sortable_id = obj.element.id;
  sortable_id_num = sortable_id.gsub(/boxid_list_/i,'');
  box_type = findSortableBoxType(sortable_id_num);
  box_empty = obj.lastValue.length == 0 ? true : false ;
  lastvalues = $A(obj.lastValue.gsub(/(boxid_list_\d+|inbox_list|trashbox_list)\[\]=/i,'').split('&'));
  sortable_seq = $A(Sortable.sequence(sortable_id));
  if ((lastvalues.length == sortable_seq.length) && !box_empty) { // Find the bookmark info within the sortable.
    internal_sort = true; lost_bmark = false; bmark_scope = box_type;
    lastvalues.each(function(v,i) {
      if (v != sortable_seq[i]) {
        /* Check to see if the bookmark was moved down */
        if (lastvalues[i+1] == sortable_seq[i]) { bmark_id=v; bmark_position=sortable_seq.indexOf(v)+1; };
        /* Check to see if the bookmark was moved up */
        if (lastvalues[i] == sortable_seq[i+1]) { bmark_id=sortable_seq[i]; bmark_position=i+1; };
        throw $break;
      };
    });
  }
  else { // Find the new or lost bookmark info.
    internal_sort = false;
    lost_bmark = lastvalues.length > sortable_seq.length ? true : false ;
    /* Box's with a lost bookmark are ignored by the server. */
    if (lost_bmark == true) { bmark_id = 'na' ; bmark_position = 'na' ; bmark_scope = 'na'; }
    /* Box with no bookmarks now gaining one. */
    else if (box_empty) { bmark_id = sortable_seq[0] ; bmark_position = 1 ; bmark_scope = findBmarkScope(box_type,sortable_id); }
    else {
      long_array =  lastvalues.length > sortable_seq.length ? lastvalues : sortable_seq ;
      short_array =  lastvalues.length < sortable_seq.length ? lastvalues : sortable_seq ;
      long_array.each(function(v,i) {
        if (v != short_array[i]) { bmark_id=v; bmark_position=i+1; throw $break; };
      });
      bmark_scope = findBmarkScope(box_type,sortable_id);
    }
  }
  return 'internal_sort='+internal_sort+'&lost_bmark='+lost_bmark+'&box_type='+box_type+'&sortable_id='+sortable_id_num+'&bmark_id='+bmark_id+'&bmark_position='+bmark_position+'&bmark_scope='+bmark_scope
}

function findSortableBoxType(sortable_id_num) {
  if (sortable_id_num == 'inbox_list') { return 'inbox'; }
  else if (sortable_id_num == 'trashbox_list') { return 'trashbox'; }
  else { return 'box'; }
}

function findBmarkScope(box_type, sortable_id) {
  if (box_type == 'box') {
    if ($('inbox_list').visible() && sortableHasClass(sortable_id,'inbox')) {return 'inbox'}
    else if ($('trashbox_list').visible() && sortableHasClass(sortable_id,'trashbox')) {return 'trashbox'}
  }
  return 'box';
}

function sortableHasClass(sortable_id, css_class) {
  css_check = false
  $A($(sortable_id).childNodes).each(function(li) {
    if (li.hasClassName(css_class)) {css_check=true; throw $break;}
  });
  return css_check;
}



/*  Tooltip Functions
 * ----------------------------------------------------------------------------------------------------------------- */

var Tooltip = Class.create();

Tooltip.prototype = {
  initialize: function(a) {
    this.a = $(a);
    this.a.onmouseover = this.showTooltip.bindAsEventListener(this);
    this.a.onmouseout = this.hideTooltip.bindAsEventListener(this);
    this.tooltip_id = this.a.firstChild.id.gsub('button_','tt_');
    this.tooltip = this.a.title;
    this.render();
  },
  render: function() {
    tooltip_box = Builder.node('div',{id:this.tooltip_id,className:'tooltip_box',style:'display:none;'},[
      Builder.node('div',{className:'tooltip_left'}),
      Builder.node('div',{className:'tooltip_middle'},[
        Builder.node('div',{className:'tooltip_middlergt'}),
        Builder.node('span',{className:'tooltip_message'},this.tooltip),
      ]),
      Builder.node('div',{className:'tooltip_right'}),
    ]);
		$('button_box').insertBefore(tooltip_box, this.a);
		this.a.removeAttribute('title');
	},
	reseteffect: function() {
	  var effect = $(this.a)._effect;
		if(effect) effect.cancel();
	},
  showTooltip: function(evt) {
    this.reseteffect();
		this.a._effect = new Effect.Appear(this.tooltip_id,{delay:0.5,duration:0.3});
  },
  hideTooltip: function(evt) {
    this.reseteffect();
		this.a._effect = new Effect.Fade(this.tooltip_id,{duration:0.3});
  }
};

Event.observe(window, 'load', activateTooltips, false);

function activateTooltips() {
  toolTipLinks = $$('a.tooltipable');
  toolTipLinks.each( function(a) { new Tooltip(a); } );
};



/*  Modal Specific Functions
 * ----------------------------------------------------------------------------------------------------------------- */

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
  if (typeof($('action_area_shim'))!='undefined') {
    Event.stopObserving(document, 'keypress', actionAreaHelper);
    if (Element.hasClassName('action_bar','barout')) { toggleActionArea('inbox'); }
    }
  }

function centerStuff() {
  getModalVars();
  centerModalMask();
  if (modalWrapper.hasClassName('inhomemarks_site')) {centerBoxEditModal();} else {centerBookmarkletModal();};
  }

function centerModalMask() {
  modalMask.setStyle({height: pageSize.pageHeight + 'px'});
  modalProgress.setStyle({top: (windowScroll.top + 60) + 'px'});
  }

function centerBoxEditModal() {
  modalWrapperLeft = (pageSize.pageWidth - 652)/2;
  if (modalWrapperLeft < 0) modalWrapperLeft = 0;
  modalWrapper.setStyle({left: modalWrapperLeft+'px'}) ;
  }

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
  Event.observe(document, 'keypress', actionAreaHelper);
  }

function respondtoKeypress(event) {
  if ($('modal_html_ap-wrapper').hasClassName('inhomemarks_site')) {
    boxidstring = $('modal_button_cancel').classNames().toString();
    boxid = boxidstring.gsub('cancel_modalbox_','');
    if (event.keyCode == Event.KEY_ESC) destroyModal(boxid);
    }
  else {
    if (event.keyCode == Event.KEY_ESC) destroyModal();
    }
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



/*  Action Area Specific Functions
 * ----------------------------------------------------------------------------------------------------------------- */

function getActionAreaVars() {
  hud = $('hud');
  actionBar = $('action_bar');
  actionArea = $('action_area');
  actionAreaShim = $('action_area_shim');
  pageSize = WindowUtilities.getPageSize();
  windowScroll = WindowUtilities.getWindowScroll();
  }

function toggleActionArea(action_box) {
  getActionAreaVars();
  setActionAreaHeigth();
  if (Element.hasClassName(actionBar,'barout')) {
    if (forceTrashbox(action_box)) { forceTrashboxLoad() }
    else {
      actionAreaShim.hide();
      actionBar.classNames().set('');
      hud.setStyle({marginLeft:'28px'});
      Event.stopObserving(window, 'resize', setActionAreaHeigth);
      Event.stopObserving(window, 'scroll', setActionAreaHeigth);      
      }
    }
  else {
    actionAreaShim.show();
    actionAreaShim.setStyle({height:pageSize.pageHeight+'px'});
    actionArea.setStyle({height:pageSize.windowHeight+'px'});
    actionBar.classNames().set('barout');
    hud.setStyle({marginLeft:'9px'})
    Event.observe(window, 'resize', setActionAreaHeigth);
    Event.observe(window, 'scroll', setActionAreaHeigth);
    if (getFieldsetFlag()=='') {
      if (action_box=='inbox') {inboxLoad()}
      else if (action_box=='trashbox') {trashboxLoad();}
      }
    else if (forceTrashbox(action_box)) { forceTrashboxLoad() }
    }
  }

function forceTrashbox(action_box) {
  if ((getFieldsetFlag()!='legend_trash') && (action_box=='trashbox')) { return true; } else { return false };
  }

function forceTrashboxLoad() {
  loadingActionArea($('legend_trash_link'));
  new Ajax.Request('/actionarea/trashbox', {asynchronous:true, evalScripts:true});
  }

function trashboxLoad() {
  setFieldsetFlag('legend_trash');
  $('legend_trash').classNames().set('fld_on');
  new Ajax.Request('/actionarea/trashbox', {asynchronous:true, evalScripts:true});
  }

function inboxLoad() {
  setFieldsetFlag('legend_inbox');
  $('legend_inbox').classNames().set('fld_on');
  new Ajax.Request('/actionarea/inbox', {asynchronous:true, evalScripts:true});
  }

function setActionAreaHeigth(event) {
  getActionAreaVars();
  actionAreaShim.setStyle({height:pageSize.pageHeight+'px'});
  actionArea.setStyle({height:pageSize.windowHeight+'px'});
  }

function setFieldsetFlag(ulid) {
  $('fieldset_legend').classNames().set(ulid);
  }

function getFieldsetFlag() {
  return $('fieldset_legend').classNames().toString();
  }

function isActionAreaDisplayed(obj) {
  if (obj.childNodes[0].hasClassName('fld_on')) return false ;
  return true;
  }

function loadingActionArea(obj) {
  clicked = obj.childNodes[0];
  currentFieldsetFlag = getFieldsetFlag();
  switch (currentFieldsetFlag) { 
    case 'legend_inbox' : hidelist = 'inbox_list' ; break;
    case 'legend_trash' : hidelist = 'trashbox_list' ; break;
    case 'legend_search' : hidelist = 'searchbox_list' ; break;
    }
  setFieldsetFlag(clicked.id);
  clicked.classNames().set('fld_on');
  $(currentFieldsetFlag).classNames().set('');
  if (clicked.id != 'legend_trash') {$('trashbox_emptytrash_box').hide()};
  $('fieldset_progress_wrap').visualEffect('blind_down',{duration: 0.35});
  $(hidelist).visualEffect('blind_up',{duration: 0.35});
  }

function showOrHideEmptyTrashBox() {
  emptyTrashBox = $('trashbox_emptytrash_box');
  if ( (Element.hasClassName('trashcan','trash_full')) && (getFieldsetFlag()=='legend_trash') ) {emptyTrashBox.show();} else {emptyTrashBox.hide();};
  }


/*  Some Window Utilities
 * -----------------------------------------------------------------------------------------------------------------
 * getPageSize() based on Lightbox JS: Fullsize Image Overlays by Lokesh Dhakar - http://www.huddletogether.com
 * For more information on this script, visit:  http://huddletogether.com/projects/lightbox/
 * Licensed under the Creative Commons Attribution 2.5 License - http://creativecommons.org/licenses/by/2.5/
 * 
 * getWindowScroll() - Returns a hash with top & left scroll offset and total viewport scroll area. From script.aculo.us
 * Get geeky and learn more at http://www.evolt.org/article/document_body_doctype_switching_and_more/17/30655/
 * ----------------------------------------------------------------------------------------------------------------- */

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


