
var Columns = $A();

var ColumnBuilder = Class.create(HomeMarksApp,{
  
  initialize: function($super,id) { $super(); this.build(id); },
  
  build: function(id) {
    if (this.welcome.visible()) { this.welcome.hide(); };
    var colId = 'col_'+ id;
    var colHTML = DIV({id:colId,className:'dragable_columns'},[
      SPAN({className:'column_ctl'},[
        SPAN({className:'ctl_close'},''),
        SPAN({className:'ctl_handle'},''),
        SPAN({className:'ctl_add'},'')
      ])
    ]);
    this.colWrap.insert({top:colHTML});
    var column = this.colWrap.down('div.dragable_columns')
    var columnObject = new Column(column);
    Columns.push(columnObject);
    column.pulsate();
    // page.reorder_then_create_box_sortables(@column,@user)
    // page.create_column_sortable
  }
  
});

var Column = Class.create(HomeMarksApp,{
  
  initialize: function($super,column) {
    $super();
    this.id = parseInt(column.id.sub('col_',''));
    this.column = $(column);
    this.controls = this.column.down('span.column_ctl');
    this.buildSortable();
    this._initDestroyCtl();
    this._initCreateBoxCtl();
    this._initEvents();
  },
  
  buildSortable: function() {
    
    // :col_wrapper,
    // :handle => 'ctl_handle',
    // :tag => 'div',
    // :only => 'dragable_columns',
    // :containment => 'col_wrapper',
    // :constraint => false,
    // :dropOnEmpty => true,
    // :url => {:controller => 'column', :action => 'sort'},
    // :before => 'globalLoadingBehavior()',
    // :with => 'findSortedInfo(this)'
  },
  
  destroyColumn: function() {

  },
  
  createBox: function() {
    
  },
  
  _initDestroyCtl: function() {
    this.destroyCtl = this.controls.down('span.ctl_close');
    this.destroyCtl.confirmation = 'Are you sure? Deleting a COLUMN will also delete all the boxes and bookmarks within it.';
    this.destroyCtl.action = '/columns/' + this.id;
    this.destroyCtl.method = 'delete';
  },
  
  _initCreateBoxCtl: function() {
    this.createBoxCtl = this.controls.down('span.ctl_add');
    this.createBoxCtl.action = '/boxes';
    this.createBoxCtl.parameters = $H({column_id:this.id});
  },
  
  _initEvents: function() {
    this.createAjaxObserver(this.destroyCtl,this.destroyColumn);
    this.createAjaxObserver(this.createBoxCtl,this.createBox);
  }
  
});


document.observe('dom:loaded', function(){
  $$('div.dragable_columns').each(function(column){ 
    var columnObject = new Column(column);
    Columns.push(columnObject);
  });  
});

