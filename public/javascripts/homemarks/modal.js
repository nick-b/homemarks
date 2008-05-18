
var HomeMarksModal = Class.create(HomeMarksBase,{
  
  initialize: function() {
    this.build();
    this.mask = $('modalmask'); 
    this.progress = $('modal_progress');
    this.apWrapper = $('modal_html_ap-wrapper');
    this.relWrapper = $('modal_html_rel-wrapper');
    this.topShadow = $('modal_html_top');
    this.content = $('modal_html');
    this.queue = {position:'end', scope:'modalscope'};
  },
  
  build: function() {
    if (!$('modalmask')) {
      var body = $$('body').first();
      var maskHTML = DIV({id:'modalmask',style:'display:none;'},[DIV({id:'modal_progress',style:'display:none;',onclick:'location.reload();'})]);
      var modalHTML = DIV({id:'modal_html_ap-wrapper'},[
        DIV({id:'modal_html_rel-wrapper',style:'display:none;'},[
          DIV({id:'modal_html_border'},[
            DIV({id:'modal_html'})
          ]),
          DIV({id:'modal_html_top'})
        ])]
      );
      body.insert({top:modalHTML});
      body.insert({top:maskHTML});
      this.cancelButton = DIV({id:'modal_button_cancel',onclick:'HmModal.hide()'});
    };
  },
  
  show: function(content) {
    var options = Object.extend({contentFor:'misc',color:'timberwolf',showProgress:false}, arguments[1] || {});
    this.contentFor = options.contentFor;
    this.color = options.color;
    this.updateContent(content);
    this.toggleMask('on');
    if (options.showProgress) { this.toggleProgress('on') };
    this.toggleObservers('on');
    this.toggleModal('on');
    // document.stopObserving('keypress', actionAreaHelper);
    // if (this.action_bar().hasClassName('barout')) { toggleActionArea('inbox'); }
  },
  
  hide: function(boxid) {
    this.toggleObservers('off');
    this.toggleProgress('off');
    this.toggleMask('off');
    this.toggleModal('off');
    // document.observe('keypress', actionAreaHelper);
  },

  updateContent: function(content) {
    this.topShadow.setStyle({width:this.dimensions().topWidth+'px'});
    this.content.setStyle({width:this.dimensions().contentWidth, height:this.dimensions().contentHeight});
    this.content.addClassName(this.color);
    this.appendButtons(content);
    this.content.update(content);
    this.center();
  },
  
  appendButtons: function(content) {
    switch (this.contentFor) { 
      case 'misc'     : var modalButtons = [this.cancelButton]; break;
      case 'box'      : var modalButtons = [this.cancelButton]; break; 
      case 'bookmark' : var modalButtons = [this.cancelButton]; break; 
    }
    var buttonBox = DIV({id:'modal_buttons',className:'clearfix'},modalButtons);
    content.appendChild(buttonBox);
  },
  
  center: function() {
    this.mask.setStyle({height: this.pageSize().height + 'px'});
    this.progress.setStyle({top: (this.scroll().top + 60) + 'px'});
    var total = this.pageSize().width - this.dimensions().topWidth;
    var left = (total/2).ceil();
    if (left < 0) left = 0;
    this.apWrapper.setStyle({left:left+'px'});
  },
  
  dimensions: function() {
    switch (this.contentFor) { 
      case 'misc'     : return { topWidth:452, contentWidth:'400px', contentHeight:'auto' };
      case 'box'      : return { topWidth:652, contentWidth:'600px', contentHeight:'300px' }; 
      case 'bookmark' : return { topWidth:352, contentWidth:'300px', contentHeight:'145px' }; 
    }
  },
  
  toggleMask: function(toggle) {
    var options = { duration:0.2, queue:this.queue };
    if (toggle == 'on') { this.mask.appear(Object.extend(options,{from:0.0,to:0.9})); }
    else { this.mask.fade(options); };
  },
  
  toggleObservers: function(toggle) {
    if (toggle == 'on') {
      this.modalResizeObserver = this.center.bindAsEventListener(this);
      Event.observe(window,'resize', this.modalResizeObserver);
      Event.observe(window,'scroll', this.modalResizeObserver);
      this.keypressObserver = this.keypress.bindAsEventListener(this);
      document.observe('keypress', this.keypressObserver);
    }
    else {
      Event.stopObserving(window,'resize',this.modalResizeObserver);
      Event.stopObserving(window,'scroll',this.modalResizeObserver);
      document.stopObserving('keypress',this.keypressObserver);
    };
  },
  
  toggleProgress: function(toggle) {
    var options = {duration:0.2, queue:this.queue}
    if (toggle == 'on') { this.progress.appear(options); } else { this.progress.fade(options); };
  },
  
  toggleModal: function(toggle) {
    var options = { duration:0.4 }; // Helps speed by removing: queue:this.queue} 
    if (toggle == 'on') { this.relWrapper.slideDown(options); } else { this.relWrapper.slideUp(options); };
  },
  
  keypress: function(event) {
    if (event.keyCode == Event.KEY_ESC) { this.hide(); };
  }
  
  // goHere: function() {
  //   window.location.reload();
  // }
  
});


