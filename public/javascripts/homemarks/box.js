
var Boxes = $A();
var Box = Class.create({
  
  initialize: function(box) {
    this.box = box;
    if (!Boxes.include(this.box)) { Boxes.push(this.box); };
    this.action = this.box.down('span.box_action');
    this.title = this.box.down('.box_title a');
  },
  
  showActions: function(event) {
    
  },
  
  editLinks: function(event) {
    var modal = new Modal('bookmarks');
    // :before => "this.blur(); setupModal(#{box.id})",
    // :loading => "Element.show('modal_progress')" )
    // 
    // Data from request:
    // 
    // page.replace_html 'modal_html_rel-wrapper', :partial => 'edit_links'
    // page.hide :modal_progress
    // page.visual_effect :slide_down, 'modal_html_rel-wrapper', :duration => 0.4, :queue => {:position => 'end', :scope => "boxid_#{@box.id}"}
  },
  
  initEvents: function() {
    this.action.observe('click', this.showActions.bindAsEventListener(this));
  }
  
});


var HomeMarksApp = Class.create(HomeMarksUtilities,{
  
  initialize: function() {
    
  }
  
});


document.observe('dom:loaded', function(){
  $$('div.dragable_boxes').each(function(box){ new Box(box); });
});

