
var Bookmarks = $A();

var BookmarkBuilder = Class.create(HomeMarksApp,{
  
  initialize: function($super,boxObj,id) { 
    $super();
    this.build(boxObj,id);
  },
  
  build: function(boxObj,id) {
    var bookmarkId = 'bmark_'+ id;
    // var sortable = boxObj.column;
    // var boxHTML = DIV({id:boxId,className:'dragable_boxes',style:'display:none;'},[
    //   DIV({className:'box'},[
    //     DIV({className:'box_header clearfix'},[
    //       SPAN({className:'box_action box_action_down'}),
    //       SPAN({className:'box_title'},[
    //         SPAN({className:'box_handle'}),
    //         SPAN({className:'box_titletext'},'Rename Me...')
    //       ])
    //     ]),
    //     DIV({className:'line'}),
    //     DIV({className:'inside'},[
    //       UL({className:'sortablelist'})
    //     ])
    //   ])
    // ]);
    // boxObj.controls.insert({after:boxHTML});
    // var box = sortable.down('div.dragable_boxes');
    // var boxObject = new Box(box);
    // Boxes.push(boxObject);
    // boxObject.insertControlsHTML(true);
    // box.blindDown({duration:0.35});
    // SortableUtils.createSortableMember(sortable,box);
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



