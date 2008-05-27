
var HomeMarksApp = Class.create(HomeMarksBase,{
  
  initialize: function() {
    this.loading = $('loading');
    this.modal = new HomeMarksModal();
    this.initEvents();
  },
  
  
  
  flash: function(mood,message) {
    this.hud = $('hud');
    this.messageArea = $('message_wrapper');
    this.resetFlash();
    this.resetFlashEffect();
    this.hud.addClassName(mood);
    this.messageArea.update(SPAN({id:'message'},message));
    this.flashEffect = setTimeout(function(){
      this.resetFlash();
      $('message').fade();
    }.bind(this),5000);
  },
  
  resetFlash: function() {
    this.flashMoods.each(function(m){ this.hud.removeClassName(m); }.bind(this));
  },
  
  resetFlashEffect: function() {
    if (this.flashEffect) { clearTimeout(this.flashEffect); };
  },
  
  initEvents: function() {
    
  }
  
});


