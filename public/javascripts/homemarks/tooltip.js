
var Tooltip = Class.create({
  
  initialize: function(a) {
    this.a = $(a);
    this.a.onmouseover = this.showTooltip.bindAsEventListener(this);
    this.a.onmouseout = this.hideTooltip.bindAsEventListener(this);
    this.tooltip_id = this.a.down('span').id.gsub('button_','tt_');
    this.tooltitle = this.a.title;
    this.build();
  },
  
  build: function() {
    tooltip_box = DIV({id:this.tooltip_id,className:'tooltip_box',style:'display:none;'},[
      DIV({className:'tooltip_left'}),
      DIV({className:'tooltip_middle'},[
        DIV({className:'tooltip_middlergt'}),
        SPAN({className:'tooltip_message'},this.tooltitle),
      ]),
      DIV({className:'tooltip_right'}),
    ]);
    this.a.insert({before:tooltip_box});
    this.a.removeAttribute('title');
    this.tooltip = $(this.tooltip_id);
  },
  
  reseteffect: function() {
    var effect = $(this.a).tt_effect;
    if(effect) effect.cancel();
  },
  
  showTooltip: function(event) {
    this.reseteffect();
    this.a.tt_effect = new Effect.Appear(this.tooltip_id,{delay:0.3,duration:0.2});
  },
  
  hideTooltip: function(event) {
    this.reseteffect();
    this.a.tt_effect = new Effect.Fade(this.tooltip_id,{duration:0.2});
  }
  
});


document.observe('dom:loaded', function(){
  toolTipLinks = $$('a.tooltipable');
  toolTipLinks.each( function(a) { new Tooltip(a); } );
});


