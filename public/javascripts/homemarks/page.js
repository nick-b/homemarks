
var Page = Class.create(HomeMarksApp,{
  
  initialize: function($super) { 
    $super();
    this.sortable = this.pageSortable;
    this._initPageEvents();
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
  
  
  setActionAreaHeigth: function (event) {
    this.actionAreaShim.setStyle({height:this.pageSize().height+'px'});
    this.actionArea.setStyle({height:this.viewSize().height+'px'});
  },
  
  toggleActionArea: function(event) {
    var openInbox = event.element() == this.actionBar;
    this.setActionAreaHeigth();
    if (!this.actionBar.hasClassName('barout')) {
      this.actionAreaShim.show();
      this.actionBar.className = 'barout';
      this.hud.setStyle({marginLeft:'9px'});
      this.actionAreaObserver = this.setActionAreaHeigth.bindAsEventListener(this);
      Event.observe(window, 'resize', this.actionAreaObserver);
      Event.observe(window, 'scroll', this.actionAreaObserver);
      // if (getFieldsetFlag()=='') {
      //   if (action_box=='inbox') {inboxLoad()}
      //   else if (action_box=='trashbox') {trashboxLoad();}
      // }
      // else if (forceTrashbox(action_box)) { forceTrashboxLoad() }
    }
    else {
      // if (forceTrashbox(action_box)) { forceTrashboxLoad() }
      // if (false) {  }
      // else {
        this.actionAreaShim.hide();
        this.actionBar.className = '';
        this.hud.setStyle({marginLeft:'28px'});
        Event.stopObserving(window, 'resize', this.actionAreaObserver);
        Event.stopObserving(window, 'scroll', this.actionAreaObserver);
      // }
    }
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
  },
  
  _initPageEvents: function() {
    this._buildColumnsSortable();
    this.actionBar = $('action_bar');
    this.actionBar.observe('click',this.toggleActionArea.bindAsEventListener(this));
    
    this.actionArea = $('action_area');
    this.actionAreaShim = $('action_area_shim');
    
  }
  
});


document.observe('dom:loaded', function(){
  Page.obj = new Page();
});

