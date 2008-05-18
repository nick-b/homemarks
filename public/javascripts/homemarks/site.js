
var HomeMarksSite = Class.create(HomeMarksBase,{ 
  
  initialize: function() {
    this.ajaxFrom = $('ajaxforms_wrapper');
    this.ajaxFromLinks = $$('.ajaxform_link');
    this.supportForm = $('support_form');
    this.loginForm = $('login_form');
    this.signupForm = $('signup_form');
    this.flashes = $$('div.flash_message');
    this.initEvents();
  },
  
  clearFlashes: function() {
    this.flashes.invoke('hide');
    this.flashes.invoke('update','');
  },
  
  flash: function(mood,html) {
    this.clearFlashes();
    var moodFlash = this.flashes.find(function(e){ if (e.id == 'flash_'+mood) {return true}; });
    moodFlash.update(html);
    moodFlash.show();
    $('site_wrapper').scrollTo();
  },
  
  flashModal: function(mood,html) {
    
    
    HmModal.show(html,{contentFor:'misc',mood:mood});
    
  },
  
  toggleAjaxFormBlind: function(event) {
    if (event) { event.element().blur(); };
    Effect.toggle(this.ajaxFrom, 'blind', {duration:0.4});
  },
  
  startAjaxForm: function(event) {
    event.stop();
    var form = event.findElement('form');
    var options = Object.extend({loadId:'form_loading',imgSrc:'loading_invert.gif'}, arguments[1] || {});
    var imgTag = IMG({src:('/images/'+options.imgSrc)});
    $(options.loadId).update(imgTag);
    new Ajax.Request(form.action,{
      onComplete: function(request){ this.delegateCompleteAjaxForm(form,request) }.bind(this),
      parameters: form.serialize(true)
    });
    form.disable();
  },
  
  delegateCompleteAjaxForm: function(form,request) {
    var mood = this.getRequestMood(request);
    this.completeAjaxForm(form,{mood:mood});
    if (mood == 'good') { 
      this.clearFlashes();
      switch (form) { 
        case this.supportForm : this.completeSupportForm(request);
        case this.loginForm   : this.completeLoginForm(request); 
        case this.signupForm  : this.completeSignupForm(request); 
      }
    }
    else { 
      form.enable();
      var flashHTML = DIV([H2('Errors:'),this.messagesToList(request)]);
      this.flashModal('bad',flashHTML);
    };
  },
  
  completeAjaxForm: function(form) {
    var options = Object.extend({loadId:'form_loading',mood:'good'}, arguments[1] || {});
    var completeId = 'complete_ajax_form_' + options.loadId;
    var imgSrc = '/images/'+options.mood+'.png';
    var moodHtml = SPAN({id:completeId,className:'m0 p0'}, [IMG({src:imgSrc})]);
    $(options.loadId).update(moodHtml);
    setTimeout(function() { $(completeId).fade(); },3000);
  },
  
  submitSupportForm: function(event) { 
    this.startAjaxForm(event,{imgSrc:'loading.gif'});
  },
  
  completeSupportForm: function(request) {
    setTimeout(function(){ this.supportForm.reset(); this.supportForm.enable(); }.bind(this),2000);
    this.toggleAjaxFormBlind();
    this.flash('good','Thanks for submitting a support request!');
  },
  
  completeLoginForm: function(request) {
    window.location = '/myhome'
  },
  
  completeSignupForm: function(request) {
    var flashHTML = DIV([H2('Signup Complete:'),P('We have sent an email with a link to verify and activate your account. You can not login unless you verify your email address.')]);
    this.flash('good',flashHTML);
  },
  
  initEvents: function() {
    if (this.supportForm) { this.supportForm.observe('submit', this.submitSupportForm.bindAsEventListener(this)); };
    if (this.loginForm) { this.loginForm.observe('submit', this.startAjaxForm.bindAsEventListener(this)); };
    if (this.signupForm) { this.signupForm.observe('submit', this.startAjaxForm.bindAsEventListener(this)); };
    this.ajaxFromLinks.each(function(element){ 
      element.observe('click', this.toggleAjaxFormBlind.bindAsEventListener(this)); 
    }.bind(this));
  }

});


