
var InboxClass = Class.create(HomeMarksApp,ActionBoxMixins,BookmarkSortableMixins,{
  
  initialize: function($super) { 
    $super();
    this.class = 'Inbox';
    this.box = $('inbox');
    this.id = parseInt(this.sortableList().id.sub('inbox_list_',''));
    this.initActionAreaMixins();
    this._initInboxEvents();
  },
  
  open: function() {
    this.setField(this.legendInbox);
    this.loadInbox();
    this.showFieldsetProgress();
    this.hideFieldsetProgress();
    this.sortableList().blindUp({duration: 0.35});
  },
  
  loadInbox: function() {
    if (this.sortableList().loaded) { return true };
    var request = new Ajax.Request('/inbox/bookmarks',{asynchronous:false,method:'get'});
    var bookmarkData = request.transport.responseText.evalJSON();
    bookmarkData.each(function(bm){
      new BookmarkBuilder(this,bm.bookmark);
    }.bind(this));
    this.sortableList().loaded = true;
  },
  
  _initInboxEvents: function() {
    this._buildBookmarksSortables();
    // this.legendInbox.observe('click',this.showInbox.bindAsEventListener(this));
  }
  
});


document.observe('dom:loaded', function(){
  Inbox = new InboxClass;
});

