
var Boxes = $A();

var BoxBuilder = Class.create(HomeMarksApp,{
  
  initialize: function($super,columnObj,id) { 
    $super();
    this.build(columnObj,id);
  },
  
  build: function(columnObj,id) {
    var boxId = 'box_'+ id;
    var sortable = columnObj.sortableElement();
    var boxHTML = DIV({id:boxId,className:'dragable_boxes',style:'display:none;'},[
      DIV({className:'box'},[
        DIV({className:'box_header clearfix'},[
          SPAN({className:'box_action box_action_down'}),
          SPAN({className:'box_title'},[
            SPAN({className:'box_handle'}),
            SPAN({className:'box_titletext'},'Rename Me...')
          ])
        ]),
        DIV({className:'line'}),
        DIV({className:'inside'},[
          UL({id:'bmrklist_'+id,className:'sortablelist'})
        ])
      ])
    ]);
    columnObj.controls.insert({after:boxHTML});
    var box = sortable.down('div.dragable_boxes');
    var boxObject = new Box(box);
    Boxes.push(boxObject);
    boxObject.insertControlsHTML(true);
    box.blindDown({duration:0.35});
    SortableUtils.createSortableMember(sortable,box);
  }
  
});

var Box = Class.create(HomeMarksApp,BookmarkSortableMixins,{
  
  initialize: function($super,box) {
    this.class = 'Box';
    this.box = $(box);
    this.div = this.box.down('div.box');
    this.header = this.box.down('div.box_header');
    this.insides = this.box.down('div.inside');
    this.list = this.insides.down('ul.sortablelist');
    this.id = parseInt(this.box.id.sub('box_',''));
    this.effectOptions = { duration:0.35 };
    this.downClass = 'box_action_down';
    $super();
    this._initBoxEvents();
  },
  
  sortableElement: function() {
    return this.box;
  },
  
  sortableParent: function() {
    return this.box.up('div.dragable_columns');
  },
  
  collapsed: function() { return !this.insides.visible() },
  
  toggleActions: function(event) {
    event.stop();
    if (this.actions.hasClassName(this.downClass)) {
      this.controls.blindUp(this.effectOptions);
      this.flash('good','Box actions hidden.');
    } 
    else {
      if (this.collapsed()) { 
        this.doAjaxRequest(this.title);
        this.insertControlsHTML(true);
        this.controls.show();
        this.insides.blindDown(this.effectOptions);
      }
      else { 
        this.insertControlsHTML();
        this.controls.blindDown(this.effectOptions);
      };
      this.flash('good','Box actions displayed.');
    };
    this.actions.toggleClassName(this.downClass);
  },
  
  editLinks: function(event) {
    var editHTML = DIV({id:'edit_links'},[
      IMG({src:'/stylesheets/images/modal/command_new-bookmark2.png',alt:'New Bookmark',className:'modal_command_new'}),
      H3(this.currentTitle()),
      TABLE({id:'bookmark_header_table',border:'0'},[
        TR([TD({id:'bookmark_header_name'},'Name:'),TD({id:'bookmark_header_url'},'Location:')])
      ]),
      FORM({action:'/boxes/'+this.id+'/bookmarks',id:'modal_form'},[
        DIV({id:'bookmark_scroll'},[
          TABLE({id:'bookmark_edit_table',border:'0'},this.bookmarkRows())
        ])
      ])
    ]);
    HomeMarksModal.show(editHTML,{contentFor:'box',color:this.currentColor()});
    this._initEditLinksEvents();
  },
  
  serializeEditForm: function() {
    return $H(this.editForm.serialize(true));
  },
  
  startEditBox: function() {
    HomeMarksModal.startHide();
  },
  
  completeEditBox: function(request) {
    var bookmarkData = request.responseJSON;
    var bookmarks = this.bookmarks();
    bookmarkData.updated_bookmarks.each(function(upData){
      bookmark = bookmarks.detect(function(bm){ return bm.id == upData.bookmark.id });
      bookmark.update(upData.bookmark);
    }.bind(this));
    bookmarkData.new_bookmarks.each(function(newData){
      new BookmarkBuilder(this,newData.bookmark);
    }.bind(this));
    HomeMarksModal.completeHide();
    this.flash('good','Bookmarks updated.');
  },
  
  insertBookmarkRow: function() {
    if (this.editTable.newBookmarkIndex) { this.editTable.newBookmarkIndex = this.editTable.newBookmarkIndex+1 } 
    else { this.editTable.newBookmarkIndex = 1 };
    var newRow = this.buildBookmarkRow();
    this.editTable.insert({top:newRow});
  },
  
  buildBookmarkRow: function(bookmark) {
    if (bookmark) {
      var bmUrl = bookmark.url, bmName = bookmark.name;
      var namePrefix = 'bookmarks['+bookmark.id+']';
      var nameName = namePrefix + '[name]';
      var nameUrl = namePrefix + '[url]';
    } 
    else {
      var bmUrl = '', bmName = '';
      var namePrefix = 'new_bookmarks['+this.editTable.newBookmarkIndex+']';
      var nameName = namePrefix + '[name]';
      var nameUrl = namePrefix + '[url]';
    };
    return TR({className:'bookmark_row'},[
      TD([INPUT({name:nameName, value:bmName.unescapeHTML(), className:'bookmark_name_field', type:'text', size:'20'})]),
      TD([INPUT({name:nameUrl, value:bmUrl, className:'bookmark_url_field', type:'text', size:'55'})])
    ]);
  },
  
  bookmarkRows: function() {
    return this.bookmarks().map(function(bookmark){ return this.buildBookmarkRow(bookmark); }.bind(this));
  },
  
  insertControlsHTML: function(display) {
    if (!this.controls) {
      this.insides.insert({top:this._controlsHTML(display)});
      this.controls = this.insides.down('div.box_controls');
      this._initAllControls();
    };
  },
  
  beforeChangeColor: function(element) {
    var color = this._getColorFromSwatch(element);
    var newClassName = 'box ' + color;
    this.div.className = newClassName;
  },
  
  completeChangeColor: function(request) {
    this.flash('good','Box color updated.');
  },
  
  completeToggleCollapse: function(request) {
    var shown = request.responseJSON;
    if (shown) {
      this.insides.blindUp(this.effectOptions);
      this.actions.removeClassName(this.downClass);
      setTimeout(function(){ if (this.controls) {this.controls.hide()}; }.bind(this),0500);
      this.flash('good','Box collapsed.')
    } else {
      this.insides.blindDown(this.effectOptions);
      this.flash('good','Box uncollapsed.')
    };
  },
  
  completeDestroyBox: function(request,cascadeDelete) {
    var sortableParent = this.sortableParent();
    var sortableElement = this.sortableElement();
    Boxes = Boxes.without(this);
    SortableUtils.destroySortableMember(sortableParent,sortableElement);
    if (!cascadeDelete) {
      this.flash('good','Box deleted.');
      sortableElement.fade({duration:0.35});
      setTimeout(function(){ 
        sortableElement.remove();
        SortableUtils.destroySortableMemberPostDOM(sortableParent,sortableElement);
      }.bind(this),0500);
    };
  },
  
  currentTitle: function() {
    return this.title.innerHTML;
  },
  
  currentColor: function() {
    var classNames = $w(this.div.className);
    if (classNames.size() > 1) { return classNames.last() } else { return 'timberwolf' };
  },
  
  startUpdateTitle: function(event) {
    var action = '/boxes/' + this.id + '/change_title';
    var parameters = $H({ title:$F(this.title_input) });
    new Ajax.Request(action,{
      onComplete: function(request){ this.completeUpdateTitle(request) }.bind(this),
      parameters: parameters.merge(authParams),
      method: 'put'
    });
  },
  
  completeUpdateTitle: function(request) {
    var newTitle = request.responseJSON;
    this.title.update(newTitle.escapeHTML());
  },
  
  _controlsHTML: function(display) {
    var currentTitle = this.currentTitle();
    var displayStyle = (display) ? 'block' : 'none';
    var controlContent = [ SPAN({className:'box_delete'}), SPAN({className:'box_edit'}) ];
    Box.colors.each(function(color){ controlContent.push(SPAN({className:'box_swatch swatch_'+color})); });
    controlContent.push(INPUT({className:'box_input',type:'text',value:currentTitle,maxlength:'64'}));
    return DIV({className:'box_controls clearfix',style:'display:'+displayStyle},controlContent);
  },
  
  _initToggleCollapse: function() {
    this.title = this.header.down('span.box_titletext');
    this.title.action = '/boxes/' + this.id + '/toggle_collapse';
    this.title.method = 'put';
    this.createAjaxObserver(this.title,{onComplete:this.completeToggleCollapse});
  },
  
  _initAllControls: function() {
    /* Destroy Box */
    this.destroyButton = this.controls.down('span.box_delete');
    this.destroyButton.confirmation = 'Are you sure? Deleting a BOX will also delete all the bookmarks within it.';
    this.destroyButton.action = '/boxes/' + this.id;
    this.destroyButton.method = 'delete';
    this.createAjaxObserver(this.destroyButton,{onComplete:this.completeDestroyBox});
    /* Edit Box */
    this.editBox = this.controls.down('span.box_edit');
    this.editBox.observe('click',this.editLinks.bindAsEventListener(this));
    /* Change Colors */
    this.controls.select('span.box_swatch').each(function(swatch){
      swatch.action = '/boxes/' + this.id + '/colorize';
      swatch.parameters = $H({color:this._getColorFromSwatch(swatch)});
      swatch.method = 'put';
      this.createAjaxObserver(swatch,{before:this.beforeChangeColor,onComplete:this.completeChangeColor});
    }.bind(this));
    /* Update Title */
    this.title_input = this.controls.down('input.box_input');
    new Field.Observer(this.title_input, 0.4, this.startUpdateTitle.bind(this));
  },
  
  _getColorFromSwatch: function(swatch) {
    var classes = $w(swatch.className);
    var colorClass = classes.detect(function(c){ return c.startsWith('swatch_') });
    return colorClass.sub('swatch_','');
  },
  
  _initPrefAction: function() {
     this.actions = this.header.down('span.box_action');
     this.actions.observe('click',this.toggleActions.bindAsEventListener(this));
  },
  
  _initEditLinksEvents: function() {
    this.editModal = $('edit_links');
    this.editTable = this.editModal.down('#bookmark_edit_table');
    this.editForm = this.editModal.down('#modal_form');
    this.buildBookmark = this.editModal.down('img.modal_command_new');
    this.buildBookmark.observe('click',this.insertBookmarkRow.bindAsEventListener(this));
    HomeMarksModal.saveButton.action = this.editForm.action;
    HomeMarksModal.saveButton.parameters = this.serializeEditForm;
    HomeMarksModal.saveButton.method = 'put';
    this.createAjaxObserver(HomeMarksModal.saveButton,{before:this.startEditBox,onComplete:this.completeEditBox});
  },
  
  _initBoxEvents: function() {
    this._buildBookmarksSortables();
    this._initToggleCollapse();
    this._initPrefAction();
  }
  
});


Box.colors = $A([ 
  'white',      'aqua',     'melon',  'limeade',      'lavender', 'postit', 'bisque',
  'timberwolf', 'sky_blue', 'salmon', 'spring_green', 'wistera',  'yellow', 'apricot',
  'black',      'cerulian', 'red',    'yellow_green', 'violet',   'orange', 'raw_sienna' 
]);


Box.containment = function() {
  return $$('div.dragable_columns');
};


document.observe('dom:loaded', function(){
  $$('div.dragable_boxes').each(function(box){ 
    var boxObject = new Box(box);
    Boxes.push(boxObject);
  });
});



