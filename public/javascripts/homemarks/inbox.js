
var Inbox = Class.create(HomeMarksApp,BookmarkSortableMixins,{
  
  initialize: function($super) { 
    $super();
    this.class = 'Inbox';
    this.box = $('inbox_list');
    this._initInboxEvents();
  },
  
  sortableChild: function() {
    return this.inboxList;
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
  
  
  
  _initInboxEvents: function() {
    this._buildBookmarksSortables();
    
  }
  
});


document.observe('dom:loaded', function(){
  
});

