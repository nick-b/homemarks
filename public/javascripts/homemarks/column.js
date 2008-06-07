
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
    column.pulsate({duration:0.75});
    SortableUtils.resetSortableLastValue(this.colWrap);
  }
  
});

var Column = Class.create(HomeMarksApp,{
  
  initialize: function($super,column) {
    this.column = $(column);
    this.col_id = this.column.id;
    this.id = parseInt(this.col_id.sub('col_',''));
    $super();
    this.controls = this.column.down('span.column_ctl');
    this.buildColumnSortable();
    this._initDestroyCtl();
    this._initCreateBoxCtl();
    this._initColumnEvents();
  },
  
  buildSortable: function() {
    
  },
  
  completeDestroyColumn: function() {
    Columns = Columns.without(this);
    SortableUtils.destroySortableMember(this.colWrap,this.column);
    this.flash('good','Column deleted.');
    this.column.fade({duration:0.25});
    setTimeout(function(){
      this.column.remove();
      if (!Columns.first()) { this.welcome.show(); };
      SortableUtils.resetSortableLastValue(this.colWrap);
    }.bind(this),0350);
    // TODO: Add more sub element destroy?
  },
  
  completeCreateBox: function() {
    
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
  
  _initColumnEvents: function() {
    this.createAjaxObserver(this.destroyCtl,this.completeDestroyColumn);
    this.createAjaxObserver(this.createBoxCtl,this.completeCreateBox);
  }
  
});


document.observe('dom:loaded', function(){
  $$('div.dragable_columns').each(function(column){ 
    var columnObject = new Column(column);
    Columns.push(columnObject);
  });  
});

