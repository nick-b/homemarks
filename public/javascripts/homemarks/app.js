
var HomeMarksApp = Class.create(HomeMarksBase,{
  
  initialize: function() {
    this.loading = $('loading');
    this.welcome = $('welcome_box');
    this.pageSortable = $('col_wrapper');
    this.hud = $('hud');
  },
  
  flash: function(mood,message) {
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
  
  defaultAjaxOptions: function() {
    return {};
  },
  
  createAjaxObserver: function(element) {
    var options = Object.extend(this.defaultAjaxOptions(), arguments[1] || {});
    element.observe('click',this.startAjaxRequest.bindAsEventListener(this,options));
  },
  
  startAjaxRequest: function(event) {
    var options = Object.extend(this.defaultAjaxOptions(), arguments[1] || {});
    if (event instanceof Event) { var elmnt = event.element(); event.stop(); } 
    else { var elmnt = event; }; /* Sortable callbacks drop element as first arg */
    elmnt.blur();
    if (elmnt.confirmation) { if (confirm(elmnt.confirmation)) { this.doAjaxRequest(elmnt,options); }; }
    else { this.doAjaxRequest(elmnt,options); };
  },
  
  doAjaxRequest: function(elmnt) {
    var options = Object.extend(this.defaultAjaxOptions(), arguments[1] || {});
    if (options.before) { options.before.call(this,elmnt) };
    this.loading.show();
    var parameters = (elmnt.parameters && elmnt.parameters instanceof Function) ? $H(elmnt.parameters.call(this)) : elmnt.parameters || $H()
    var method = elmnt.method || 'post';
    new Ajax.Request(elmnt.action,{
      onComplete: function(request){
        this.completeAjaxRequest(request);
        if (options.onComplete) { options.onComplete.call(this,request) };
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


