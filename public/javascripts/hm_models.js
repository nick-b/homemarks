
var Boxes = $A();
var Box = Class.create({
  
  initialize: function(box) {
    this.box = box;
    this.action = this.box.down('span.box_action');
    this.title = this.box.down('.box_title a');
  },
  
  editLinks: function(event) {
    // Data from request:
    // 
    // page.replace_html 'modal_html_rel-wrapper', :partial => 'edit_links'
    // page.hide :modal_progress
    // page.visual_effect :slide_down, 'modal_html_rel-wrapper', :duration => 0.4, :queue => {:position => 'end', :scope => "boxid_#{@box.id}"}
  },
  
  initEvents: function() {
    this.action.observe('click', this.editLinks.bindAsEventListener(this));
  }
  
});


var HomeMarksApp = Class.create(HomeMarksUtilities,{
  
  initialize: function() {
    
  }
  
});


