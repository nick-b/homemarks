
var ActionBoxMixins = {
  
  superActionAreaMixins: function() {
    this.fieldset = $('fieldset_legend');
    this.legendInbox = $('legend_inbox');
    this.legendTrashbox = $('legend_trash');
    this.fieldsetProgress = $('fieldset_progress_wrap');
    this.fieldsetArea = $('fieldset_middle');
    this.inboxList = this.fieldsetArea.down('ul.inbox_list');
    this.trashboxList = this.fieldsetArea.down('ul.trashbox_list');
    this.emptyTrashButtonWrap = $('trashbox_emptytrash_box');
    this.emptyTrashButton = $('trashbox_emptytrash_button');
  },
  
  showFieldsetProgress: function() {
    if (!this.fieldsetProgress.visible()) { this.fieldsetProgress.blindDown({duration: 0.35}); };
  },
  
  hideFieldsetProgress: function() {
    if (this.fieldsetProgress.visible()) { this.fieldsetProgress.blindUp({duration: 0.35}); };
  },
  
  hideProgressAndShowList: function(list) {
    this.hideFieldsetProgress();
    if (!list.visible()) { list.blindDown({duration: 0.35}); };
    if (list == this.trashboxList) { this.emptyTrashButtonWrap.show() } else { this.emptyTrashButtonWrap.hide() };
  },
  
  setField: function(element) {
    $A([this.legendInbox,this.legendTrashbox]).each(function(legend){ legend.className = ''; });
    element.className = 'fld_on';
    if (element == this.legendInbox) {
      this.trashboxList.hide();
      if (!this.inboxList.loaded) { this.showFieldsetProgress(); };
      this.inboxList.show();
      this.inboxList.open = true;
    }
    else {
      this.inboxList.hide();
      if (!this.trashboxList.loaded) { this.showFieldsetProgress(); };
      this.trashboxList.show();
      this.trashboxList.open = true;
    };
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
    if (event.keyCode == 192) { Page.toggleActionArea() }; 
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
      if (!openInbox && this.actionArea.down('ul.inbox_list').visible()) { 
        Trashbox.open();
        return;
      }
      else {
        this.actionAreaShim.hide();
        this.actionBar.className = '';
        this.hud.setStyle({marginLeft:'28px'});
        Event.stopObserving(window, 'resize', this.actionAreaObserver);
        Event.stopObserving(window, 'scroll', this.actionAreaObserver);
      };
    }
  },
  
  doTrash: function(element) {
    var bookmark = Bookmarks.find(function(bm){ return bm.bookmark.id == element.id });
    bookmark.trash();
  },
  
  trashFull: function() {
    this.trashcan.className = 'trash_full';
  },
  
  trashEmpty: function() {
    this.trashcan.className = 'trash_empty';
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

