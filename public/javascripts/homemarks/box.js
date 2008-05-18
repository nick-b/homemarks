
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
  },
  
  initEvents: function() {
    this.action.observe('click', this.showActions.bindAsEventListener(this));
  }
  
});

Box.colors = $w('white     timberwolf    black' +
                'aqua      sky_blue      cerulian' +
                'melon     salmon        red' +
                'limeade   spring_green  yellow_green' +
                'lavender  wistera       violet' +
                'postit    yellow        orange' +
                'bisque    apricot       raw_sienna' );




// document.observe('dom:loaded', function(){
//   $$('div.dragable_boxes').each(function(box){ new Box(box); });
// });

