
var HomeMarksModal = Class.create(HomeMarksUtilities,{
  
  initialize: function(contents) {
    this.build();
    this.contents = contents || 'misc' // ['box','bookmark']
    this.mask = $('modalmask'); 
    this.progress = $('modal_progress');
    this.wrapper = $('modal_html_ap-wrapper');
    this.content = $('modal_html_rel-wrapper');
    this.queue = {position:'end', scope:'modalscope'};
  },
  
  miscContents: function() { return this.contents == 'misc'; },
  boxContents: function() { return this.contents == 'box'; },
  bookmarkContents: function() { return this.contents == 'bookmark'; },
  
  build: function() {
    if (!$('modalmask')) {
      var body = $('body');
      var maskHTML = DIV({id:'modalmask',style:'display:none;'},[DIV({id:'modal_progress',style:'display:none;',onclick:'location.reload();'})]);
      var modalHTML = DIV({id:'modal_html_ap-wrapper'},[DIV({id:'modal_html_rel-wrapper',style:'display:none;'})]);
      body.insert({top:modalHTML});
      body.insert({top:maskHTML});
    };
  },
  
  create: function() {
    this.center();
    this.toggleMask('on');
    this.toggleProgress('on');
    this.toggleObservers('on');
    // document.stopObserving('keypress', actionAreaHelper);
    // if (this.action_bar().hasClassName('barout')) { toggleActionArea('inbox'); }
  },
  
  destroy: function(boxid) {
    this.toggleObservers('off');
    this.toggleProgress('off');
    this.toggleMask('off');
    // document.observe('keypress', actionAreaHelper);
  },
  
  center: function() {
    this.centerMask();
    this.centerModal();
  },
  
  centerMask: function() {
    this.mask.setStyle({height: this.pageSize().height + 'px'});
    this.progress.setStyle({top: (this.scroll().top + 60) + 'px'});
  },
  
  centerModal: function() {
    left = (( this.pageSize().width - this.width() ) / 2).ceil();
    if (left < 0) left = 0;
    this.wrapper.setStyle({left: left+'px'});
  },
  
  width: function() {
    switch (this.contents) { 
      case 'misc' : return 450;
      case 'box' : return 652; 
      case 'bookmark' : return 352; 
    }
  },
  
  toggleMask: function(toggle) {
    if (toggle == 'on') {
      this.mask.appear({duration:0.4, from:0.0, to:0.9, queue:this.queue});
    }
    else {
      // May not need visible check.
      if (this.content.visible()) { this.content.slideUp({duration:0.4, queue:this.queue}); };
      this.mask.fade({duration:0.2, queue:this.queue});
    };
  },
  
  toggleObservers: function(toggle) {
    if (toggle == 'on') {
      Event.observe(window, 'resize', this.center.bindAsEventListener(this));
      Event.observe(window, 'scroll', this.center.bind(this));
      document.observe('keypress', this.keypress.bind(this));
    }
    else {
      Event.stopObserving(window, 'resize', this.center);
      Event.stopObserving(window, 'scroll', this.center);
      document.stopObserving('keypress', this.keypress);
    };
  },
  
  toggleProgress: function(toggle) {
    var options = {duration:0.2, queue:this.queue}
    if (toggle == 'on') { this.progress.appear(options); } else { this.progress.fade(options); };
  },
  
  keypress: function(event) {
    console.log(event)
    if (event.keyCode == Event.KEY_ESC) { this.destroy(); };
  }
  
  // hideModal: function(boxid) {
  //   boxid = (boxid == null) ? 'bookmarklet' : boxid;
  //   Event.stopObserving(document, 'keypress', respondtoKeypress);
  //   Effect.SlideUp(modalContent, {duration:0.4, queue:{position:'end', scope:'boxid_' + boxid}});
  //   Effect.Appear(modalProgress, {duration:0.2, from:0.0, to:0.9, queue:{position:'end', scope:'boxid_' + boxid}});
  // },
  // 
  // destroyModalMask: function(boxid) {
  //   boxid = (boxid == null) ? 'bookmarklet' : boxid;
  //   Event.stopObserving(window, 'resize', centerStuff);
  //   Event.stopObserving(window, 'scroll', centerStuff);
  //   Effect.Fade(modalMask, {duration:0.2, queue:{position:'end', scope:'boxid_' + boxid}});
  // },
  // 
  // goHere: function() {
  //   window.location.reload();
  // }
  
});



