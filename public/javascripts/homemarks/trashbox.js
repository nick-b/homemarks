
var TrashboxClass = Class.create(HomeMarksApp,ActionBoxMixins,BookmarkSortableMixins,{
  
  initialize: function($super) { 
    $super();
    this.superActionAreaMixins();
    this.class = 'Trashbox';
    this.box = $('trashbox');
    this.id = parseInt(this.trashboxList.id.sub('trashbox_list_',''));
    this._initTrashboxEvents();
  },
  
  open: function() {
    this.setField(this.legendTrashbox);
    this.load();
    this.hideProgressAndShowList(this.trashboxList);
  },
  
  load: function() {
    if (this.trashboxList.loaded) { return true };
    var request = new Ajax.Request('/trashbox/bookmarks',{asynchronous:false,method:'get'});
    var bookmarkData = request.transport.responseText.evalJSON();
    bookmarkData.each(function(bm){
      new BookmarkBuilder(this,bm.bookmark);
    }.bind(this));
    this.trashboxList.loaded = true;
  },
  
  _initTrashboxEvents: function() {
    this._buildBookmarksSortables();
    this.legendTrashbox.observe('click',this.open.bindAsEventListener(this));
    this._initEmptyTrash();
  },
  
  _initEmptyTrash: function() {
    this.emptyTrashButton.action = '/trashbox';
    this.emptyTrashButton.method = 'delete';
    this.createAjaxObserver(this.emptyTrashButton,{onComplete:this.completeEmptyTrash});
  },
  
  completeEmptyTrash: function() {
    
  }
  
});


document.observe('dom:loaded', function(){
  Trashbox = new TrashboxClass;
});

