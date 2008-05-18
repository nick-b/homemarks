
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
    };
  },
    
  show: function(content) {
    var options = Object.extend({contentFor:'misc',color:'indif'}, arguments[1] || {});
    this.contentFor = contentFor;
    this.color = options.color;
    this.toggleMask('on');
    this.toggleProgress('on');
    this.toggleObservers('on');
    this.updateContent(content);
    this.toggleProgress('off');
    this.relWrapper.slideDown({duration:0.4, queue:this.queue});
    // document.stopObserving('keypress', actionAreaHelper);
    // if (this.action_bar().hasClassName('barout')) { toggleActionArea('inbox'); }
  },
  
  updateContent: function(content) {
    this.topShadow.setStyle({width:this.dimensions().topWidth+'px'});
    this.content.setStyle({width:this.dimensions().contentWidth, height:this.dimensions().contentHeight});
    this.content.update(content);
    this.center();
  },
  
  hide: function(boxid) {
    this.toggleObservers('off');
    this.toggleProgress('off');
    this.toggleMask('off');
    // document.observe('keypress', actionAreaHelper);
  },
  
  setMood: function() {
    var classMood = 
    $A('good','bad','indif').each(function(m){ this.content.removeClassName(m); });
    
    switch (this.mood) { 
      case 'misc'     : return { topWidth:452, contentWidth:'400px', contentHeight:'auto' };
      case 'box'      : return { topWidth:652, contentWidth:'600px', contentHeight:'300px' }; 
      case 'bookmark' : return { topWidth:352, contentWidth:'300px', contentHeight:'145px' }; 
    }
    this.content.addClassName();
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
    if (toggle == 'on') {
      this.mask.appear({duration:0.4, from:0.0, to:0.9, queue:this.queue});
    }
    else {
      // May not need visible check.
      if (this.relWrapper.visible()) { this.relWrapper.slideUp({duration:0.4, queue:this.queue}); };
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
    if (event.keyCode == Event.KEY_ESC) { this.hide(); };
  }
  
  // goHere: function() {
  //   window.location.reload();
  // }
  
});



