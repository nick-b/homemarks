
var ActionBoxMixins = {
  
  initActionAreaMixins: function() {
    this.fieldset = $('fieldset_legend');
    this.legendInbox = $('legend_inbox');
    this.legendTrashbox = $('legend_trash');
    this.fieldsetProgress = $('fieldset_progress_wrap');
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
  }
  
};

var PageClass = Class.create(HomeMarksApp,{
  
  initialize: function($super) { 
    $super();
    this.sortable = this.pageSortable;
    this.actionBar = $('action_bar');
    this.actionArea = $('action_area');
    this.actionAreaShim = $('action_area_shim');
    this.trashcan = $('trashcan');
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
  
  actionAreaHelper: function(event) { 
    if (event.keyCode == Event.KEY_ESC) { Page.toggleActionArea() }; 
  },
  
  toggleActionArea: function(event) {
    var openInbox = (event == undefined) || (event.element() == this.actionBar);
    this.setActionAreaHeigth();
    if (!this.actionBar.hasClassName('barout')) {
      this.actionAreaShim.show();
      this.actionBar.className = 'barout';
      this.hud.setStyle({marginLeft:'9px'});
      this.actionAreaObserver = this.setActionAreaHeigth.bindAsEventListener(this);
      Event.observe(window, 'resize', this.actionAreaObserver);
      Event.observe(window, 'scroll', this.actionAreaObserver);
      if (openInbox) { Inbox.open(); } else { Trashbox.open(); };
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
  
  
  
  
  doTrash: function(element) {
    var bookmark = Bookmarks.find(function(bm){ return bm.bookmark.id == element.id });
    bookmark.trash();
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
  
  _buildTrashcanEvents: function() {
    this.trashcan.observe('click',this.toggleActionArea.bindAsEventListener(this));
    Droppables.add(this.trashcan,{
      accept: 'dragable_bmarks', 
      hoverclass: 'trash_droppable', 
      onDrop: this.doTrash
    }); 
  },
  
  _initPageEvents: function() {
    this._buildColumnsSortable();
    this._buildTrashcanEvents();
    Event.observe(document,'keydown',this.actionAreaHelper);
    this.actionBar.observe('click',this.toggleActionArea.bindAsEventListener(this));
  }
  
});


document.observe('dom:loaded', function(){
  Page = new PageClass();
});

