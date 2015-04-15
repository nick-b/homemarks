
var Bookmarks = $A();

var BookmarkSortableMixins = {

  sortableList: function() {
    return this.box.down('ul.sortablelist');
  },

  completeBookmarkSort: function() {
    this.flash('good','Bookmarks sorted.');
    SortableUtils.resetSortableLastValue(this.sortableList());
    SortableUtils.updateSortablesDragAndDrops(this.sortableList());
  },

  bookmarkSortParams: function() {
    var params = SortableUtils.getSortParams(this);
    var gainedId = params.get('gained_id');
    if (gainedId) {
      var bookmark = Bookmarks.find(function(bm){ return bm.id == params.get('id') });
      params.set('old_type',bookmark.oldType);
      Page.gainedSortable = this.sortableList();
    };
    return params.merge({type:this.klass});
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
      onUpdate: this.startAjaxRequest.bindAsEventListener(this,{onComplete:this.completeBookmarkSort})
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

  box: function() {
    return Boxes.find(function(box){ return box.box == this.sortableParent() },this);
  },

  type: function() {
    return this.box().klass;
  },

  name: function() {
    return this.link.innerHTML;
  },

  url: function() {
    return this.link.readAttribute('href');
  },

  defaultParameters: function() {
    return $H({ type: this.type() });
  },

  update: function(newData) {
    this.link.update(newData.name.escapeHTML());
    this.link.writeAttribute({href:newData.url});
  },

  trash: function() {
    this.bookmark.action = '/bookmarks/' + this.id + '/trash';
    this.bookmark.method = 'put';
    this.bookmark.parameters = this.defaultParameters();
    this.doAjaxRequest(this.bookmark,{
      before: function(){ this.destroySortableElement() }.bind(this),
      onComplete: function(){ this.moveToTrash() }.bind(this)
    });
  },

  stashCurrentType: function() {
    this.oldType = this.type();
  },

  destroySortableElement: function(request,cascadeDelete) {
    var sortableList = this.sortableList();
    var sortableElement = this.sortableElement();
    Bookmarks = Bookmarks.without(this);
    SortableUtils.destroySortableMember(sortableList,sortableElement);
    if (!cascadeDelete) {
      this.flash('good','Bookmarks trashed.');
      this.url = this.url();
      this.name = this.name();
      sortableElement.remove();
      SortableUtils.destroySortableMemberPostDOM(sortableList,sortableElement);
    };
  },

  moveToTrash: function() {
    Page.trashFull();
    if (Trashbox.trashboxList.loaded) {
      var newData = Object.extend({ id: this.id, url: this.url, name: this.name });
      new BookmarkBuilder(Trashbox,newData);
    };
  }

});


Bookmark.containment = function() {
  return $$('ul.sortablelist');
};

Bookmark.onStartObserver = function(callbackName,draggable,event) {
  if (draggable.element.hasClassName('dragable_bmarks')) {
    var bookmark = Bookmarks.find(function(bm){ return bm.bookmark == draggable.element });
    bookmark.stashCurrentType();
  };
};

document.observe('dom:loaded', function(){
  $$('li.dragable_bmarks').each(function(bookmark){
    var bookmarkObject = new Bookmark(bookmark);
    Bookmarks.push(bookmarkObject);
  });
  Draggables.addObserver({ onStart: Bookmark.onStartObserver });
});



