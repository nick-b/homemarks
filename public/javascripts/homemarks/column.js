
var Columns = $A();

var ColumnBuilder = Class.create(HomeMarksApp,{

  initialize: function($super,id) { $super(); this.build(id); },

  build: function(id) {
    if (this.welcome.visible()) { this.welcome.hide(); };
    var colId = 'col_'+ id;
    var sortable = this.pageSortable;
    var colHTML = DIV({id:colId,className:'dragable_columns'},[
      SPAN({className:'column_ctl'},[
        SPAN({className:'ctl_close'},''),
        SPAN({className:'ctl_handle'},''),
        SPAN({className:'ctl_add'},'')
      ])
    ]);
    sortable.insert({top:colHTML});
    var column = sortable.down('div.dragable_columns');
    var columnObject = new Column(column);
    Columns.push(columnObject);
    column.pulsate({duration:0.75});
    SortableUtils.createSortableMember(sortable,column);
  }

});

var Column = Class.create(HomeMarksApp,{

  initialize: function($super,column) {
    $super();
    this.column = $(column);
    this.id = parseInt(this.column.id.sub('col_',''));
    this.controls = this.column.down('span.column_ctl');
    this._initColumnEvents();
  },

  sortableElement: function() {
    return this.column;
  },

  sortableParent: function() {
    return this.pageSortable;
  },

  boxes: function() {
    return Box.boxes().findAll(function(box){ return box.sortableParent() == this.sortableElement() },this);
  },

  empty: function() {
    return Object.isUndefined(this.column.down('div.dragable_boxes'));
  },

  completeDestroyColumn: function(request) {
    var sortableParent = this.sortableParent();
    var sortableElement = this.sortableElement();
    this.boxes().invoke('completeDestroyBox',null,true);
    Columns = Columns.without(this);
    SortableUtils.destroySortableMember(sortableParent,sortableElement);
    this.flash('good','Column deleted.');
    sortableElement.fade({duration:0.25});
    setTimeout(function(){
      sortableElement.remove();
      if (!Columns.first()) { this.welcome.show(); };
      SortableUtils.destroySortableMemberPostDOM(sortableParent,sortableElement);
    }.bind(this),0350);
  },

  completeCreateBox: function(request) {
    var id = request.responseJSON;
    new BoxBuilder(this,id);
    this.flash('good','New box created.');
  },

  boxSortParams: function() {
    var params = SortableUtils.getSortParams(this);
    var gainedId = params.get('gained_id');
    if (gainedId) { Page.gainedSortable = this.sortableElement(); };
    return params;
  },

  completeBoxSort: function() {
    this.flash('good','Boxes sorted.');
    SortableUtils.resetSortableLastValue(this.sortableElement());
    SortableUtils.updateSortablesDragAndDrops(this.sortableElement());
  },

  _buildBoxesSortable: function() {
    this.sortableElement().action = '/boxes/sort';
    this.sortableElement().parameters = this.boxSortParams;
    this.sortableElement().method = 'put';
    Sortable.create(this.sortableElement(), {
      handle:       'box_handle',
      tag:          'div',
      accept:       'dragable_boxes',
      hoverclass:   'column_hover',
      containment:  Box.containment(),
      constraint:   false,
      dropOnEmpty:  true,
      onUpdate: this.startAjaxRequest.bindAsEventListener(this,{onComplete:this.completeBoxSort}),
    });
  },

  _initDestroyCtl: function() {
    this.destroyCtl = this.controls.down('span.ctl_close');
    this.destroyCtl.confirmation = 'Are you sure? Deleting a COLUMN will also delete all the boxes and bookmarks within it.';
    this.destroyCtl.action = '/columns/' + this.id;
    this.destroyCtl.method = 'delete';
    this.createAjaxObserver(this.destroyCtl,{onComplete:this.completeDestroyColumn});
  },

  _initCreateBoxCtl: function() {
    this.createBoxCtl = this.controls.down('span.ctl_add');
    this.createBoxCtl.action = '/boxes';
    this.createBoxCtl.parameters = $H({column_id:this.id});
    this.createAjaxObserver(this.createBoxCtl,{onComplete:this.completeCreateBox});
  },

  _initColumnEvents: function() {
    this._buildBoxesSortable();
    this._initDestroyCtl();
    this._initCreateBoxCtl();
  }

});


document.observe('dom:loaded', function(){
  $$('div.dragable_columns').each(function(column){
    var columnObject = new Column(column);
    Columns.push(columnObject);
  });
});

