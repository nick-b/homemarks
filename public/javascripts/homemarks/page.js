
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
    this.inboxList = $('inbox_list');
    this.trashboxList = $('trashbox_list');
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
  
  
  
  
  showInbox: function() {
    this.setField(this.legendInbox);
    this.loadInbox();
    this.showFieldsetProgress();
    this.hideFieldsetProgress();
    this.inboxList.blindUp({duration: 0.35});
  },
  
  loadInbox: function() {
    if (this.inboxList.loaded) { return true };
    var request = new Ajax.Request('/inbox/bookmarks',{asynchronous:false,method:'get'});
    var bookmarkData = request.transport.responseText.evalJSON();
    bookmarkData.each(function(bm){
      new BookmarkBuilder(this.inboxList,bm.bookmark);
    }.bind(this));
    this.inboxList.loaded = true;
  },
  
  showTrashbox: function() {
    this.setField(this.legendTrashbox);
    this.loadTrashbox();
    this.showFieldsetProgress();
    this.trashboxList.blindUp({duration: 0.35});
  },
  
  loadTrashbox: function() {
    if (this.trashboxList.loaded) { return true };
    var request = new Ajax.Request('/trashbox/bookmarks',{asynchronous:false,method:'get'});
    var bookmarks = request.transport.responseText.evalJSON();
    this.trashboxList.loaded = true;
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
    this.sortable.action = '/columns/sort';
    this.sortable.parameters = this.columnSortParams;
    this.sortable.method = 'put';
    Sortable.create(this.sortable, {
      handle:       'ctl_handle', 
      tag:          'div', 
      only:         'dragable_columns',
      accept:       'dragable_columns', 
      containment:  this.sortable.id,
      constraint:   false, 
      dropOnEmpty:  true, 
      onUpdate: this.startAjaxRequest.bindAsEventListener(this,{onComplete:this.completeColumnSort}), 
    });
  },
  
  
  
  completeBookmarkSort: function() {
    this.flash('good','Bookmarks sorted.');
    SortableUtils.resetSortableLastValue(this.list);
  },
  
  bookmarkSortParams: function() {
    return SortableUtils.getSortParams(this);
  },
  
  _buildInboxSortable: function() {
    // TODO: Make this box type aware.
    this.inboxList.action = '/bookmarks/sort';
    this.inboxList.parameters = this.bookmarkSortParams;
    this.inboxList.method = 'put';
    Sortable.create(this.list, {
      handle:       'bmrk_handle', 
      tag:          'li', 
      accept:       'dragable_bmarks', 
      containment:  Bookmark.containment(), 
      constraint:   false, 
      dropOnEmpty:  true, 
      onUpdate: this.startAjaxRequest.bindAsEventListener(this,{onComplete:this.completeBookmarkSort}), 
    });
  },
  
  _initPageEvents: function() {
    this._buildColumnsSortable();
    // this._buildInboxSortable();
    this.actionBar.observe('click',this.toggleActionArea.bindAsEventListener(this));
    this.legendInbox.observe('click',this.showInbox.bindAsEventListener(this));
    this.legendTrashbox.observe('click',this.showTrashbox.bindAsEventListener(this));
  }
  
});


document.observe('dom:loaded', function(){
  Page.obj = new Page();
});

