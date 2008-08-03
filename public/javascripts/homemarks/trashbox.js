
var TrashboxClass = Class.create(HomeMarksApp,ActionBoxMixins,BookmarkSortableMixins,{
  
  initialize: function($super) { 
    $super();
    this.superActionAreaMixins();
    this.class = 'Trashbox';
    this.box = $('trashbox');
    this.id = parseInt(this.sortableList().id.sub('trashbox_list_',''));
    this._initTrashboxEvents();
  },
  
  open: function() {
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
    // this._buildBookmarksSortables();
    // this.legendTrashbox.observe('click',this.showTrashbox.bindAsEventListener(this));
  }
  
});


document.observe('dom:loaded', function(){
  Trashbox = new TrashboxClass;
});

