
var Bookmarks = $A();

var BookmarkSortableUtils = {
  
  completeBookmarkSort: function() {
    this.flash('good','Bookmarks sorted.');
    var sortableElement = this.trashboxList || this.inboxList || this.list;
    SortableUtils.resetSortableLastValue(sortableElement);
  },
  
  bookmarkSortParams: function() {
    return SortableUtils.getSortParams(this);
  },
  
  _buildBookmarksSortables: function(sortableElement) {
    // TODO: Make this box type aware.
    sortableElement.action = '/bookmarks/sort';
    sortableElement.parameters = this.bookmarkSortParams;
    sortableElement.method = 'put';
    Sortable.create(sortableElement, {
      handle:       'bmrk_handle', 
      tag:          'li', 
      accept:       'dragable_bmarks', 
      containment:  Bookmark.containment(), 
      constraint:   false, 
      dropOnEmpty:  true, 
      onUpdate: this.startAjaxRequest.bindAsEventListener(this,{onComplete:this.completeBookmarkSort}), 
    });
  }
  
};

var BookmarkBuilder = Class.create(HomeMarksApp,{
  
  initialize: function($super,listElement,newData) { 
    $super();
    this.build(listElement,newData);
  },
  
  build: function(listElement,newData) {
    var bookmarkId = 'bmark_'+ newData.id;
    var sortable = listElement;
    var bookmarkHTML = LI({id:bookmarkId,className:'dragable_bmarks clearfix'},[
      SPAN({className:'bmrk_handle'},''),
      SPAN({className:'boxlink'},[A({href:newData.url},newData.name.escapeHTML())])
    ]);
    sortable.insert({top:bookmarkHTML});
    var bookmark = sortable.down('li.dragable_bmarks');
    var bookmarkObject = new Bookmark(bookmark);
    Bookmarks.push(bookmarkObject);
    SortableUtils.createSortableMember(sortable,bookmark);
  }
  
});

var Bookmark = Class.create(HomeMarksApp,{
  
  initialize: function($super,bookmark) {
    this.bookmark = $(bookmark);
    this.id = parseInt(this.bookmark.id.sub('bmark_',''));
    this.link = this.bookmark.down('a');
    this.name = this.link.innerHTML;
    this.url = this.link.readAttribute('href');
    $super();
    this._initBookmarkEvents();
  },
  
  sortable: function() {
    return this.bookmark.up('div.dragable_boxes');
  },
  
  update: function(newData) {
    this.link.update(newData.name.escapeHTML());
    this.link.writeAttribute({href:newData.url});
  },
  
  _initBookmarkEvents: function() {
    
  }
  
});


Bookmark.containment = function() {
  return $$('ul.sortablelist');
};


document.observe('dom:loaded', function(){
  $$('li.dragable_bmarks').each(function(bookmark){ 
    var bookmarkObject = new Bookmark(bookmark);
    Bookmarks.push(bookmarkObject);
  });
});



