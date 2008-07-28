
var Trashbox = Class.create(HomeMarksApp,BookmarkSortableMixins,{
  
  initialize: function($super) { 
    $super();
    this.class = 'Trashbox';
    this.box = $('trashbox_list');
    this._initTrashboxEvents();
  },
  
  sortableChild: function() {
    return this.trashboxList;
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
  
  
  
  _initTrashboxEvents: function() {
    this._buildBookmarksSortables();
    
  }
  
});


document.observe('dom:loaded', function(){
  
});

