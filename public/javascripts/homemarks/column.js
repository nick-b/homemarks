
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
    this.column = column;
    this.controls = column.down('span.column_ctl');
    
  },
  
  initEvents: function() {
    
  }
  
});


document.observe('dom:loaded', function(){
  $$('div.dragable_columns').each(function(column){ 
    var columnObject = new Column(column);
    Columns.push(columnObject);
  });  
});

