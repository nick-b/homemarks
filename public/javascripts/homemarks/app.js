
var HomeMarksApp = Class.create(HomeMarksBase,{
  
  initialize: function() {
    this.loading = $('loading');
    this.welcome = $('welcome_box');
    this.modal = new HomeMarksModal();
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
  
  createAjaxObserver: function(element,finishMethod) {
    element.observe('click',this.startAjaxRequest.bindAsEventListener(this,finishMethod));
  },
  
  startAjaxRequest: function(event,finishMethod) {
    if (event instanceof Event) { var elmnt = event.element(); event.stop(); } 
    else { var elmnt = event; }; /* Sortable callbacks drop element as first arg */
    elmnt.blur();
    if (elmnt.confirmation) { if (confirm(elmnt.confirmation)) { this.doAjaxRequest(elmnt,finishMethod); }; }
    else { this.doAjaxRequest(elmnt,finishMethod); };
  },
  
  doAjaxRequest: function(elmnt,finishMethod) {
    this.loading.show();
    var parameters = (elmnt.parameters && elmnt.parameters instanceof Function) ? elmnt.parameters.call(this) : elmnt.parameters || $H()
    var method = elmnt.method || 'post';
    new Ajax.Request(elmnt.action,{
      onComplete: function(request){
        this.completeAjaxRequest(request);
        if (finishMethod) { finishMethod.call(this,request) };
      }.bind(this),
      parameters: parameters.merge(authParams),
      method: method
    });
  },
  
  completeAjaxRequest: function(request) {
    var mood = this.getRequestMood(request);
    if (mood == 'good') { this.loading.hide(); } else { window.location.reload(); };
  },
  
});




