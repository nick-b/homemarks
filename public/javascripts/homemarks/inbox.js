
var InboxClass = Class.create(HomeMarksApp,ActionBoxMixins,BookmarkSortableMixins,{
  
  initialize: function($super) { 
    $super();
    this.superActionAreaMixins();
    this.class = 'Inbox';
    this.box = $('inbox');
    this.id = parseInt(this.inboxList.id.sub('inbox_list_',''));
    this._initInboxEvents();
  },
  
  open: function() {
    this.setField(this.legendInbox);
    this.load();
    this.hideProgressAndShowList(this.inboxList);
  },
  
  load: function() {
    if (this.inboxList.loaded) { return true };
    var request = new Ajax.Request('/inbox/bookmarks',{asynchronous:false,method:'get'});
    var bookmarkData = request.transport.responseText.evalJSON();
    bookmarkData.reverse().each(function(bm){
      new BookmarkBuilder(this,bm.bookmark);
    }.bind(this));
    this.inboxList.loaded = true;
  },
  
  _initInboxEvents: function() {
    this._buildBookmarksSortables();
    this.legendInbox.observe('click',this.open.bindAsEventListener(this));
  }
  
});


document.observe('dom:loaded', function(){
  Inbox = new InboxClass;
  Boxes.push(Inbox);
});

