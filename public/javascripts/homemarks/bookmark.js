
var Bookmarks = $A();

var BookmarkSortableMixins = {
  
  sortableList: function() {
    return this.box.down('ul.sortablelist');
  },
  
  completeBookmarkSort: function() {
    this.flash('good','Bookmarks sorted.');
    SortableUtils.resetSortableLastValue(this.sortableList());
  },
  
  bookmarkSortParams: function() {
    return SortableUtils.getSortParams(this).merge({type:this.class});
  },
  
  bookmarks: function() {
    return Bookmarks.findAll(function(bm){ return bm.sortableParent() == this.box },this);
  },
  
  _buildBookmarksSortables: function() {
    var sortableList = this.sortableList();
    sortableList.action = '/bookmarks/sort';
    sortableList.parameters = this.bookmarkSortParams;
    sortableList.method = 'put';
    Sortable.create(sortableList, {
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
  
  initialize: function($super,boxObject,newData) { 
    $super();
    this.build(boxObject,newData);
  },
  
  build: function(boxObject,newData) {
    var bookmarkId = 'bmark_'+ newData.id;
    var sortable = boxObject.sortableList();
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
    $super();
    this._initBookmarkEvents();
  },
  
  sortableElement: function() {
    return this.bookmark;
  },
  
  sortableParent: function() {
    return this.bookmark.up('div#inbox') || this.bookmark.up('div#trashbox') || this.bookmark.up('div.dragable_boxes');
  },
  
  sortableList: function() {
    return this.bookmark.up('ul.sortablelist');
  },
  
  name: function() {
    return this.link.innerHTML;
  },
  
  url: function() {
    return this.link.readAttribute('href');
  },
  
  update: function(newData) {
    this.link.update(newData.name.escapeHTML());
    this.link.writeAttribute({href:newData.url});
  },
  
  destroy: function() {
    this.bookmark.action = '/bookmarks/'+this.id;
    this.bookmark.method = 'delete';
    this.bookmark.parameters = $H({type:this.class});
    this.doAjaxRequest(this.bookmark,{
      before: function(){ this.bookmark.remove() }.bind(this),
      onComplete: function(){ this.destroySortableBookmark() }.bind(this)
    });
  },
  
  destroySortableElement: function(request,cascadeDelete) {
    var sortableParent = this.sortableList();
    var sortableElement = this.sortableElement();
    Bookmarks = Bookmarks.without(this);
    SortableUtils.destroySortableMember(sortableParent,sortableElement);
    if (!cascadeDelete) {
      sortableElement.remove();
      SortableUtils.destroySortableMemberPostDOM(sortableParent,sortableElement);
    };
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



