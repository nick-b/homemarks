
var Page = Class.create(HomeMarksApp,{
  
  initialize: function($super) { 
    $super();
    this.sortable = this.pageSortable;
    this.actionBar = $('action_bar');
    this.actionArea = $('action_area');
    this.actionAreaShim = $('action_area_shim');
    this.fieldset = $('fieldset_legend');
    this.legendInbox = $('legend_inbox');
    this.legendTrashbox = $('legend_trash');
    this.fieldsetProgress = $('fieldset_progress_wrap');
    this._initPageEvents();
  },
  
  sortableElement: function() {
    return this.sortable;
  },
  
  columns: function() {
    return Columns;
  },
  
  columnSortParams: function() {
    return SortableUtils.getSortParams(this);
  },
  
  completeColumnSort: function() {
    this.flash('good','Columns sorted.');
    SortableUtils.resetSortableLastValue(this.sortableElement());
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
      if (openInbox) { this.showInbox() }
      else if (false) {  };
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
  
  
  
  showFieldsetProgress: function() {
    if (!this.fieldsetProgress.visible()) { this.fieldsetProgress.blindDown({duration: 0.35}); };
  },
  
  hideFieldsetProgress: function() {
    this.fieldsetProgress.blindUp({duration: 0.35});
  },
  
  setField: function(element) {
    $A([this.legendInbox,this.legendTrashbox]).each(function(legend){
      legend.className = '';
      legend.open = false;
    });
    element.className = 'fld_on';
    element.open = true;
  },
  
  
  
  
  _buildColumnsSortable: function() {
    this.sortableElement().action = '/columns/sort';
    this.sortableElement().parameters = this.columnSortParams;
    this.sortableElement().method = 'put';
    Sortable.create(this.sortableElement(), {
      handle:       'ctl_handle', 
      tag:          'div', 
      only:         'dragable_columns',
      accept:       'dragable_columns', 
      containment:  this.sortableElement().id,
      constraint:   false, 
      dropOnEmpty:  true, 
      onUpdate: this.startAjaxRequest.bindAsEventListener(this,{onComplete:this.completeColumnSort}), 
    });
  },
  
  _initPageEvents: function() {
    this._buildColumnsSortable();
    this.actionBar.observe('click',this.toggleActionArea.bindAsEventListener(this));
    // this.legendInbox.observe('click',this.showInbox.bindAsEventListener(this));
    // this.legendTrashbox.observe('click',this.showTrashbox.bindAsEventListener(this));
  }
  
});


document.observe('dom:loaded', function(){
  Page.obj = new Page();
});

