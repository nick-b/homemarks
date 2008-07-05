
var Page = Class.create(HomeMarksApp,{
  
  initialize: function($super) { 
    $super();
    this.sortable = this.pageSortable;
    this._buildColumnsSortable();
  },
  
  columns: function() {
    return Columns;
  },
  
  columnSortParams: function() {
    return SortableUtils.getSortParams(this);
  },
  
  completeColumnSort: function() {
    this.flash('good','Columns sorted.');
    SortableUtils.resetSortableLastValue(this.sortable);
  },
  
  _buildColumnsSortable: function() {
    this.sortable.action = '/columns/sort';
    this.sortable.parameters = this.columnSortParams;
    this.sortable.method = 'put';
    Sortable.create(this.sortable, {
      handle:       'ctl_handle', 
      tag:          'div', 
      accept:       'dragable_columns', 
      containment:  this.sortable.id,
      constraint:   false, 
      dropOnEmpty:  true, 
      onUpdate: this.startAjaxRequest.bindAsEventListener(this,{onComplete:this.completeColumnSort}), 
    });
  }
  
});


document.observe('dom:loaded', function(){
  Page.obj = new Page();
});

