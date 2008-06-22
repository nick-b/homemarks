
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
    this.sortable = this.box.up('div.dragable_columns')
    this.header = this.box.down('div.box_header');
    this.insides = this.box.down('div.inside');
    this.list = this.insides.down('ul.sortablelist');
    this.id = parseInt(this.box.id.sub('box_',''));
    this.effectOptions = { duration:0.35 };
    this.downClass = 'box_action_down';
    $super();
    this._initBoxEvents();
  },
  
  collapsed: function() { return !this.insides.visible() },
  
  toggleActions: function(event) {
    event.stop()
    if (this.actions.hasClassName(this.downClass)) {
      this.controls.blindUp(this.effectOptions);
      this.flash('good','Box actions hidden.');
    } else {
      if (this.collapsed()) {
        this.insertControlsHTML(true);
        this.doAjaxRequest(this.title);
        this.insides.blindDown(this.effectOptions);
      } else {
        this.insertControlsHTML();
        this.controls.blindDown(this.effectOptions);
      };
      this.flash('good','Box actions displayed.');
    };
    this.actions.toggleClassName(this.downClass);
  },
  
  editLinks: function(event) {
    
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
    this.box.down('div.box').className = newClassName;
  },
  
  completeChangeColor: function(request) {
    this.flash('good','Box color updated.');
  },
  
  completeToggleCollapse: function(request) {
    var shown = request.responseJSON;
    if (shown) {
      this.insides.blindUp(this.effectOptions);
      this.actions.removeClassName(this.downClass);
      setTimeout(function(){ this.controls.hide(); }.bind(this),0500);
      this.flash('good','Box collapsed.')
    } else {
      this.insides.blindDown(this.effectOptions);
      this.flash('good','Box uncollapsed.')
    };
  },
  
  completeDestroyBox: function(request) {
    Boxes = Boxes.without(this);
    SortableUtils.destroySortableMember(this.sortable,this.box);
    this.box.fade({duration:0.35});
    this.flash('good','Box deleted.');
    setTimeout(function(){ 
      this.box.remove();
      SortableUtils.resetSortableLastValue(this.sortable);
    }.bind(this),0500);
  },
  
  _controlsHTML: function(display) {
    var displayStyle = (display) ? 'block' : 'none';
    var controlContent = [ SPAN({className:'box_delete'}), SPAN({className:'box_edit'}) ];
    Box.colors.each(function(color){ controlContent.push(SPAN({className:'box_swatch swatch_'+color})); });
    controlContent.push(INPUT({className:'box_input',type:'text',value:'Rename Me...',maxlength:'64'}));
    return DIV({className:'box_controls clearfix',style:'display:'+displayStyle},controlContent);
  },
  
  _buildBoxSortables: function() {
    if (!Boxes.sorted) { Boxes.sorted = $H() };
    if (!Boxes.sorted[this.sortable.id]) {
      this.sortable.action = '/boxes/sort';
      this.sortable.parameters = this.columnSortParams;
      this.sortable.method = 'put';
      Sortable.create(this.sortable, {
        handle:       'box_handle', 
        tag:          'div', 
        only:         'dragable_boxes', 
        accept:       'dragable_boxes',
        hoverclass:   'column_hover',
        containment:  this.sortable.id, // :containment => current_user.column_containment_array,
        constraint:   false, 
        dropOnEmpty:  true, 
        onUpdate: this.startAjaxRequest.bindAsEventListener(this,{onComplete:this.completeColumnSort}), 
      });
      Boxes.sorted[this.sortable.id] = true;
    };
  },
  
  // LOADING A LAME SPAN (for toggle actions and toggle insides)
  // if (direction == 'down') { spanclass = 'box_action box_action_down' }
  // if (direction == 'up') { spanclass = 'box_action' }
  // Element.replace('boxid_'+boxid+'_action_alink', '<span class="'+spanclass+'" id="boxid_'+boxid+'_action_lame"></span>')
  
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
    // this.editBox = this.controls.down('span.box_edit');
    /* Change Colors */
    this.controls.select('span.box_swatch').each(function(swatch){
      swatch.action = '/boxes/' + this.id + '/colorize';
      swatch.parameters = $H({color:this._getColorFromSwatch(swatch)});
      swatch.method = 'put';
      this.createAjaxObserver(swatch,{before:this.beforeChangeColor,onComplete:this.completeChangeColor});
    }.bind(this));
    /* Update Title */
    // observe_field
    // "boxid_#{box.id}_input_title",
    // :frequency => 0.4, 
    // :update => "boxid_#{box.id}_title", 
    // :url => change_title_url(:id => box.id), 
    // :with => "'title='+escape(value)"
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


document.observe('dom:loaded', function(){
  $$('div.dragable_boxes').each(function(box){ 
    var boxObject = new Box(box);
    Boxes.push(boxObject);
  });
});



