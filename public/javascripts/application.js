
var HomeMarksUtilities = {
  
  actionBar: function(request) { return $('action_bar'); },
  
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

var HomeMarksSite = Class.create(HomeMarksUtilities,{ 
  
  initialize: function() {
    this.ajaxFrom = $('ajaxforms_wrapper');
    this.ajaxFromLinks = $$('.ajaxform_link');
    this.supportForm = $('support_form');
    this.loginForm = $('login_form');
    this.signupForm = $('signup_form');
    this.flashes = $$('div.flash_message');
    this.initEvents();
  },
  
  clearFlashes: function() {
    this.flashes.invoke('hide');
    this.flashes.invoke('update','');
  },
  
  flash: function(mood,html) {
    this.clearFlashes();
    var moodFlash = this.flashes.find(function(e){ if (e.id == 'flash_'+mood) {return true}; });
    moodFlash.update(html);
    moodFlash.show();
    $('site_wrapper').scrollTo();
  },
  
  toggleAjaxFormBlind: function(event) {
    if (event) { event.element().blur(); };
    Effect.toggle(this.ajaxFrom, 'blind', {duration:0.4});
  },
  
  startAjaxForm: function(event) {
    event.stop();
    var form = event.findElement('form');
    var options = Object.extend({loadId:'form_loading',imgSrc:'loading_invert.gif'}, arguments[1] || {});
    var imgTag = IMG({src:('/images/'+options.imgSrc)});
    $(options.loadId).update(imgTag);
    new Ajax.Request(form.action,{
      onComplete: function(request){ this.delegateCompleteAjaxForm(form,request) }.bind(this),
      parameters: form.serialize(true)
    });
    form.disable();
  },
  
  delegateCompleteAjaxForm: function(form,request) {
    var mood = this.getRequestMood(request);
    this.completeAjaxForm(form,{mood:mood});
    if (mood == 'good') { 
      this.clearFlashes();
      switch (form) { 
        case this.supportForm : this.completeSupportForm(request);
        case this.loginForm   : this.completeLoginForm(request); 
        case this.signupForm  : this.completeSignupForm(request); 
      }
    }
    else { 
      form.enable();
      var flashHtml = DIV([H2('Errors:'),this.messagesToList(request)]);
      this.flash('bad',flashHtml);
    };
  },
  
  completeAjaxForm: function(form) {
    var options = Object.extend({loadId:'form_loading',mood:'good'}, arguments[1] || {});
    var completeId = 'complete_ajax_form_' + options.loadId;
    var imgSrc = '/images/'+options.mood+'.png';
    var moodHtml = SPAN({id:completeId,class:'m0 p0'}, [IMG({src:imgSrc})]);
    $(options.loadId).update(moodHtml);
    setTimeout(function() { $(completeId).visualEffect('fade') },3000);
  },
  
  submitSupportForm: function(event) { 
    this.startAjaxForm(event,{imgSrc:'loading.gif'});
  },
  
  completeSupportForm: function(request) {
    setTimeout(function(){ this.supportForm.reset(); this.supportForm.enable(); }.bind(this),2000);
    this.toggleAjaxFormBlind();
    this.flash('good','Thanks for submitting a support request!');
  },
  
  completeLoginForm: function(request) {
    window.location = '/myhome'
  },
  
  completeSignupForm: function(request) {
    var flashHTML = DIV([H2('Signup Complete:'),P('We have sent an email with a link to verify and activate your account. You can not login unless you verify your email address.')]);
    this.flash('good',flashHTML);
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


// WindowUtilities.getWindowScroll()     // => { top: 0, left: 0, width: 1002, height: 464 }
// document.viewport.getDimensions()     // => { width: 987, height: 494 }
// document.viewport.getWidth()          // => 987
// document.viewport.getHeight()         // => 494
// document.viewport.getScrollOffsets()  // => [0, 0]
// 
// WindowUtilities.getPageSize()         // => { pageWidth: 1002, pageHeight: 3129, windowWidth: 1002 }
// WindowUtilities.getPageSize()         // => [987,3129]


var Modal = Class.create(HomeMarksUtilities,{
  
  initialize: function(modalFor) {
    this.mask = $('modalmask');
    this.progress = $('modal_progress');
    this.wrapper = $('modal_html_ap-wrapper');
    this.content = $('modal_html_rel-wrapper');
    this.create();
  },
  
  create: function() {
    this.centerStuff();
  },
  
  showProgress: function() {
    this.progress.show();
  },
  
  build: function() {
    
    var maskHTML = DIV({id:'modalmask',style:'display:none;'},[DIV({id:'modal_progress',style:'display:none;'})]);
    var modalHTML = DIV({id:'modal_html_ap-wrapper',className:'inhomemarks_site'},[DIV({id:'modal_html_rel-wrapper',style:'display:none;'})]);
    
    
    //                   :before => "this.blur(); setupModal(#{box.id})",
    //                   :loading => "Element.show('modal_progress')" )
    
    
  },
  
  setupModal: function(boxid) {
    boxid = (boxid == null) ? 'bookmarklet' : boxid;
    centerStuff();
    Effect.Appear(modalMask, {duration:0.4, from:0.0, to:0.9, queue:{position:'end', scope:'boxid_' + boxid}});
    Event.observe(window, 'resize', centerStuff);
    Event.observe(window, 'scroll', centerStuff);
    Event.observe(document, 'keypress', respondtoKeypress);
    if (typeof($('action_area_shim'))!='undefined') {
      Event.stopObserving(document, 'keypress', actionAreaHelper);
      if (this.action_bar().hasClassName('barout')) { toggleActionArea('inbox'); }
    }
  },
  
  centerStuff: function() {
    this.centerMask();
    if (this.wrapper.hasClassName('inhomemarks_site')) {this.centerBoxEdit();} else {this.centerBookmarklet();};
  },
  
  centerMask: function() {
    this.mask.setStyle({height: this.pageSize().height + 'px'});
    this.progress.setStyle({top: (this.scroll().top + 60) + 'px'});
  },
  
  centerBoxEdit: function() {
    modalWrapperLeft = (this.pageSize().width - 652)/2;
    if (modalWrapperLeft < 0) modalWrapperLeft = 0;
    modalWrapper.setStyle({left: modalWrapperLeft+'px'}) ;
  },

  centerBookmarklet: function() {
    modalWrapperLeft = (this.pageSize().width - 352)/2;
    if (modalWrapperLeft < 0) modalWrapperLeft = 0;
    modalWrapper.setStyle({left: modalWrapperLeft+'px'}) ;
  },

  destroyModal: function(boxid) {
    boxid = (boxid == null) ? 'bookmarklet' : boxid;
    Event.stopObserving(window, 'resize', centerStuff);
    Event.stopObserving(window, 'scroll', centerStuff);
    Event.stopObserving(document, 'keypress', respondtoKeypress);
    Effect.SlideUp(modalContent, {duration:0.4, queue:{position:'end', scope:'boxid_' + boxid}});
    Effect.Fade(modalMask, {duration:0.2, queue:{position:'end', scope:'boxid_' + boxid}});
    Event.observe(document, 'keypress', actionAreaHelper);
  },

  respondtoKeypress: function(event) {
    if ($('modal_html_ap-wrapper').hasClassName('inhomemarks_site')) {
      boxidstring = $('modal_button_cancel').classNames().toString();
      boxid = boxidstring.gsub('cancel_modalbox_','');
      if (event.keyCode == Event.KEY_ESC) destroyModal(boxid);
    }
    else {
      if (event.keyCode == Event.KEY_ESC) destroyModal();
    }
  },

  hideModal: function(boxid) {
    boxid = (boxid == null) ? 'bookmarklet' : boxid;
    Event.stopObserving(document, 'keypress', respondtoKeypress);
    Effect.SlideUp(modalContent, {duration:0.4, queue:{position:'end', scope:'boxid_' + boxid}});
    Effect.Appear(modalProgress, {duration:0.2, from:0.0, to:0.9, queue:{position:'end', scope:'boxid_' + boxid}});
  },

  destroyModalMask: function(boxid) {
    boxid = (boxid == null) ? 'bookmarklet' : boxid;
    Event.stopObserving(window, 'resize', centerStuff);
    Event.stopObserving(window, 'scroll', centerStuff);
    Effect.Fade(modalMask, {duration:0.2, queue:{position:'end', scope:'boxid_' + boxid}});
  },

  goHere: function() {
    window.location.reload();
  }

  
});

var Boxes = $A();
var Box = Class.create({
  
  
});

var HomeMarksApp = Class.create(HomeMarksUtilities,{
  
  initialize: function() {
    var boxEdits = $$('span.box_edit');
  },
  
  editBoxLinks: function() {
    
    // Data from request:
    // 
    
    // page.replace_html 'modal_html_rel-wrapper', :partial => 'edit_links'
    // page.hide :modal_progress
    // page.visual_effect :slide_down, 'modal_html_rel-wrapper', :duration => 0.4, :queue => {:position => 'end', :scope => "boxid_#{@box.id}"}
    
  },
  
  initEvents: function() {
    this.boxEdits.each(function(element){ 
      element.observe('click', this.editBoxLinks.bindAsEventListener(this)); 
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
}






/*  Action Area Specific Functions
 * ----------------------------------------------------------------------------------------------------------------- */

function getActionAreaVars() {
  hud = $('hud');
  actionBar = $('action_bar');
  actionArea = $('action_area');
  actionAreaShim = $('action_area_shim');
  pageSize = WindowUtilities.getPageSize();
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










