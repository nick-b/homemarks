
var Boxes = $A();

var BoxBuilder = Class.create(HomeMarksApp,{
  
  initialize: function($super,columnObj,id) { 
    $super();
    this.build(columnObj,id);
  },
  
  build: function(columnObj,id) {
    var boxId = 'box_'+ id;
    var sortable = columnObj.column;
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
          UL({className:'sortablelist'})
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

var Box = Class.create(HomeMarksApp,{
  
  initialize: function($super,box) {
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
  
  sortable: function() {
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
    var editHTML = DIV([
      IMG({src:'/stylesheets/images/modal/command_new-bookmark2.png',alt:'New Bookmark',className:'modal_command_new'}),
      H3(this.currentTitle()),
      TABLE({id:'bookmark_header_table',border:'0'},[
        TR([TD({id:'bookmark_header_name'},'Name:'),TD({id:'bookmark_header_url'},'Location:')])
      ]),
      FORM({action:'/bookmarks/update',id:'modal_form'},[
        DIV({id:'bookmark_scroll'},[
          TABLE({id:'bookmark_edit_table',border:'0'},this.bookmarkRows())
        ])
      ])
    ]);
    Modal.show(editHTML,{contentFor:'box',color:this.currentColor()});
  },
  
  bookmarks: function() {
    return Bookmarks.findAll(function(bookmark){ return bookmark.sortable() == this.box }.bind(this));
  },
  
  bookmarkRows: function() {
    return this.bookmarks().map(function(bookmark){
      var id = bookmark.id;
      return TR({className:'bookmark_row'},[
        TD([INPUT({name:'bookmark_row['+id+'][name]',value:bookmark.name,className:'bookmark_name_field',type:'text',size:'20'})]),
        TD([INPUT({name:'bookmark_row['+id+'][name]',value:bookmark.url,className:'bookmark_url_field',type:'text',size:'55'})])
      ]);
    })
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
  
  completeDestroyBox: function(request) {
    Boxes = Boxes.without(this);
    SortableUtils.destroySortableMember(this.sortable(),this.box);
    this.box.fade({duration:0.35});
    this.flash('good','Box deleted.');
    setTimeout(function(){ 
      this.box.remove();
      SortableUtils.resetSortableLastValue(this.sortable());
    }.bind(this),0500);
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
  
  _buildBoxSortables: function() {
    
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
  
  _initBoxEvents: function() {
    this._buildBoxSortables();
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



