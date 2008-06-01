
var Columns = $A();

var ColumnBuilder = Class.create(HomeMarksApp,{
  
  initialize: function($super) { $super(); this.build(); },
  
  build: function() {
    if (this.welcome.visible()) { this.welcome.hide(); };
    var id = 'col_'+1;
    var colHTML = DIV({id:id,className:'dragable_columns'},[
      SPAN({className:'column_ctl'},[
        SPAN({className:'ctl_close'},''),
        SPAN({className:'ctl_handle'},''),
        SPAN({className:'ctl_add'},'')
      ])
    ]);
    this.colWrap.insert({top:colHTML});
    var column = this.colWrap.down('div.dragable_columns')
    new Column(column);
    column.pulsate();
    
    // <div id="col_<%= col.id %>" class="dragable_columns">
    //   <span class="column_ctl">
    //     <%= link_to_remote_for_column_delete(col) %>
    //     <span class="ctl_handle">&nbsp;</span>
    //     <%= link_to_remote_for_column_add(col) %>
    //   </span>
    // </div>
    
    // def link_to_remote_for_column_delete(col)
    //   link_to_remote( content_tag('span', '', :class => 'ctl_close'),
    //                 { :confirm => 'Are you sure? Deleting a COLUMN will also delete all the boxes and bookmarks within it.',
    //                   :url => '',
    //                   :before => 'this.blur(); globalLoadingBehavior()' })
    // end
    // 
    // def link_to_remote_for_column_add(col)
    //   link_to_remote( content_tag('span', '', :class => 'ctl_add'),
    //                 { :url => '',
    //                   :before => 'this.blur(); globalLoadingBehavior()' })
    // end
    
    // page.insert_html :top, 'col_wrapper', {:partial => 'new_col', :locals => {:col => @column}}
    // page.visual_effect :pulsate, "col_#{@column.id}"
    // page.reorder_then_create_box_sortables(@column,@user)
    // page.create_column_sortable
  }
  
});

var Column = Class.create(HomeMarksApp,{
  
  initialize: function($super,column) {
    $super();
    this.column = column;
    if (!Columns.include(this.column)) { Columns.push(this.column); };
    this.controls = this.column.down('span.column_ctl');
    
  },
  
  initEvents: function() {
    
  }
  
});


document.observe('dom:loaded', function(){
  columns = $$('div.dragable_columns');
  columns.each( function(c) { new Column(c); } );  
});

