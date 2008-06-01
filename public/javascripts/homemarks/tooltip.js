
var Tooltip = Class.create(HomeMarksApp,{
  
  initialize: function($super,a) {
    $super();
    this.a = $(a);
    this.a.onmouseover = this.showTooltip.bindAsEventListener(this);
    this.a.onmouseout = this.hideTooltip.bindAsEventListener(this);
    this.action = this.a.href;
    this.toolButton = this.a.down('span');
    this.tooltipId = this.toolButton.id.gsub('button_','tt_');
    this.toolTitle = this.a.title;
    this.build();
    this.initEvents();
  },
  
  build: function() {
    tooltip_box = DIV({id:this.tooltipId,className:'tooltip_box',style:'display:none;'},[
      DIV({className:'tooltip_left'}),
      DIV({className:'tooltip_middle'},[
        DIV({className:'tooltip_middlergt'}),
        SPAN({className:'tooltip_message'},this.toolTitle),
      ]),
      DIV({className:'tooltip_right'}),
    ]);
    this.a.insert({before:tooltip_box});
    this.a.removeAttribute('title');
    this.tooltip = $(this.tooltipId);
  },
  
  reseteffect: function() {
    var effect = $(this.a).tt_effect;
    if(effect) effect.cancel();
  },
  
  showTooltip: function(event) {
    this.reseteffect();
    this.a.tt_effect = new Effect.Appear(this.tooltipId,{delay:0.3,duration:0.2});
  },
  
  hideTooltip: function(event) {
    this.reseteffect();
    this.a.tt_effect = new Effect.Fade(this.tooltipId,{duration:0.2});
  },
  
  initEvents: function() {
    if (this.toolButton.id == 'button_new_column') { this.createAjaxObserver(this.a,this._completeNewColumn); };
  },
  
  _completeNewColumn: function() {
    new ColumnBuilder();
  }
  
});


document.observe('dom:loaded', function(){
  toolTipLinks = $$('a.tooltipable');
  toolTipLinks.each( function(a) { new Tooltip(a); } );  
});


