
var Boxes = $A();

var BoxBuilder = Class.create(HomeMarksApp,{
  
  initialize: function($super,id) { $super(); this.build(id); },
  
  build: function(column,id) {
    
    var boxId = 'box_'+ id;
    var sortable = $('col_wrapper');
    var colHTML = DIV({id:colId,className:'dragable_columns'},[
      SPAN({className:'column_ctl'},[
        SPAN({className:'ctl_close'},''),
        SPAN({className:'ctl_handle'},''),
        SPAN({className:'ctl_add'},'')
      ])
    ]);
    sortable.insert({top:colHTML});
    var column = sortable.down('div.dragable_columns')
    var columnObject = new Column(column);
    Columns.push(columnObject);
    column.pulsate({duration:0.75});
    SortableUtils.createSortableMember(sortable,column);
    
    
    // render :update do |page|
    //   page.insert_html :after, "column_#{@col.id}_ctl", {:partial => 'new_box', :locals => {:box => @box}}
    //   page["boxid_#{@box.id}_controls"].show
    //   page.create_bookmark_sortables(@user)
    //   page.reorder_then_create_box_sortables(@col,@user)
    //   page.create_column_sortable
    //   page.blind_new_box(@box)
    // end
  }
  
});

var Box = Class.create({
  
  initialize: function(box) {
    this.box = box;
    
    // The nodes I know I need in the box.
    
    this.header = this.box.down('div.box_header');
    this.insides = this.box.down('div.inside');
    this.controls = this.insides.down('div.box_controls');
    this.list = this.insides.down('ul.sortablelist');
    
    // if (!Boxes.include(this.box)) { Boxes.push(this.box); };
    // this.action = this.box.down('span.box_action');
    // this.title = this.box.down('.box_title a');
  },
  
  toggleActions: function(event) {
    // When showing:
    // this.actions.addClassName('box_action_down');
    // When hiding:
    // this.actions.removeClassName('box_action_down');
  },
  
  editLinks: function(event) {
    
  },
  
  changeColor: function() {
    // $('boxid_#{box.id}_style').classNames().set('box #{swatch}')
  },
  
  _buildBoxSortables: function() {
    if (!Boxes.sorted) {
      this.sortable.action = '/boxes/sort';
      this.sortable.parameters = this.columnSortParams;
      this.sortable.method = 'put';
      Sortable.create(this.sortable, {
        handle:       'box_handle', 
        tag:          'div', 
        only:         'dragable_boxes', 
        accept:       'dragable_boxes',
        hoverclass:   'column_hover',
        containment:  this.sortable.id, // :containment => current_user.column_containment_array,
        constraint:   false, 
        dropOnEmpty:  true, 
        onUpdate: this.startAjaxRequest.bindAsEventListener(this,this.completeColumnSort), 
      });
      Boxes.sorted = true;
    };
  },
  
  // LOADING A LAME SPAN (for toggle actions and toggle insides)
  // if (direction == 'down') { spanclass = 'box_action box_action_down' }
  // if (direction == 'up') { spanclass = 'box_action' }
  // Element.replace('boxid_'+boxid+'_action_alink', '<span class="'+spanclass+'" id="boxid_'+boxid+'_action_lame"></span>')
  
  _initToggleActions: function() {
    this.actions = this.header.down('span.box_action');
    
  },
  
  _initDestroyBox: function() {
    this.destroyBox = this.controls.down('span.box_delete');
    this.destroyBox.confirmation = 'Are you sure? Deleting a BOX will also delete all the bookmarks within it.';
    this.destroyBox.action = '/boxes/' + this.id;
    this.destroyBox.method = 'delete';
  },
  
  _initEditBox: function() {
    this.editBox = this.controls.down('span.box_edit');
  },
  
  _initChangeTitle: function() {
    // observe_field
    // "boxid_#{box.id}_input_title",
    // :frequency => 0.4, 
    // :update => "boxid_#{box.id}_title", 
    // :url => change_title_url(:id => box.id), 
    // :with => "'title='+escape(value)"
  },
  
  // _initCreateBoxCtl: function() {
  //   this.createBoxCtl = this.controls.down('span.ctl_add');
  //   this.createBoxCtl.action = '/boxes';
  //   this.createBoxCtl.parameters = $H({column_id:this.id});
  // },
  
  _initBoxEvents: function() {
    // this._buildBoxSortables();
    // this._initDestroyCtl();
    // this._initCreateBoxCtl();
    // this.createAjaxObserver(this.destroyCtl,this.completeDestroyColumn);
    // this.createAjaxObserver(this.createBoxCtl,this.completeCreateBox);
  }
  
});

Box.colors = $w( 'white     timberwolf    black' +
                 'aqua      sky_blue      cerulian' +
                 'melon     salmon        red' +
                 'limeade   spring_green  yellow_green' +
                 'lavender  wistera       violet' +
                 'postit    yellow        orange' +
                 'bisque    apricot       raw_sienna' );

document.observe('dom:loaded', function(){
  // $$('div.dragable_boxes').each(function(box){ new Box(box); });
});


