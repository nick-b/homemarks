
var HomeMarksSite = Class.create(HomeMarksBase,{ 
  
  initialize: function() {
    this.ajaxFrom = $('ajaxforms_wrapper');
    this.ajaxFromLinks = $$('a.ajaxform_link');
    this.supportForm = $('support_form');
    this.loginArea = $('login_area'); this.loginForm = $('login_form'); 
    this.forgotPwArea = $('forgotpw_area'); this.forgotPwForm = $('forgotpw_form'); 
    this.forgotPwButton = $('forgotpw_button'); this.forgotPwCancel = $('forgotpw_cancel'); 
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
    var moodColor = this.flashMoodColors.get(mood);
    
    HmModal.show(html,{color:moodColor});
  },
  
  toggleAjaxFormBlind: function(event) {
    if (event) { event.stop(); event.element().blur(); };
    Effect.toggle(this.ajaxFrom, 'blind', {duration:0.4});
  },
  
  startAjaxForm: function(event) {
    event.stop();
    var form = event.findElement('form');
    var options = Object.extend({imgSrc:'loading_invert.gif'}, arguments[1] || {});
    var loadArea = form.down('#form_loading');
    var imgTag = IMG({src:('/images/'+options.imgSrc)});
    $(loadArea).update(imgTag);
    new Ajax.Request(form.action,{
      onComplete: function(request){ this.delegateCompleteAjaxForm(form,request) }.bind(this),
      parameters: form.serialize(true)
    });
    form.disable();
  },
  
  delegateCompleteAjaxForm: function(form,request) {
    var mood = this.getRequestMood(request);
    this.completeAjaxForm(form,{mood:mood});
    this.clearFlashes();
    if (mood == 'good') { 
      switch (form) { 
        case this.supportForm   : this.completeSupportForm(request); break;
        case this.loginForm     : this.completeLoginForm(request); break;
        case this.forgotPwForm  : this.completeForgotPwForm(request); break;
        case this.signupForm    : this.completeSignupForm(request); break;
      }
    }
    else { 
      form.enable();
      if (!request.responseText.blank()) {
        var flashHTML = DIV([H2('Errors On Form!'),this.messagesToList(request)]);
        this.flashModal('bad',flashHTML);
      };
    };
  },
  
  completeAjaxForm: function(form) {
    var options = Object.extend({mood:'good'}, arguments[1] || {});
    var loadArea = form.down('#form_loading');
    var completeId = 'complete_ajax_form_' + form.id;
    var imgSrc = '/images/'+options.mood+'.png';
    var moodHtml = SPAN({id:completeId,className:'m0 p0'}, [IMG({src:imgSrc})]);
    $(loadArea).update(moodHtml);
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
    window.location = '/myhome';
  },
  
  completeForgotPwForm: function(request) {
    var message = "Please check your email for a link that will allow you to automatically login and " +
      "and reset your password. If you still have problems, use our support form on the help page.";
    var flashHTML = DIV([H2('Forgot Password Email Sent:'),P(message)]);
    this.flash('good',flashHTML);
  },
  
  completeSignupForm: function(request) {
    var message = "Thank your for signing up for your own HomeMarks page. An email has been sent to " +
      "your address along with a link to activate your account. If you have not done so already, please " +
      "take a moment to read the HomeMarks documentation.";
    var flashHTML = DIV([H2('Signup Complete:'),P(message)]);
    this.flash('good',flashHTML);
  },
  
  toggleLoginForgotPwForms: function(event) {
    if (this.loginArea.visible()) { this.loginArea.hide(); this.forgotPwArea.show(); }
    else { this.loginArea.show(); this.forgotPwArea.hide(); };
  },
  
  initEvents: function() {
    if (this.supportForm) { this.supportForm.observe('submit', this.submitSupportForm.bindAsEventListener(this)); };
    if (this.signupForm) { this.signupForm.observe('submit', this.startAjaxForm.bindAsEventListener(this)); };
    if (this.loginArea) {
      this.loginForm.observe('submit', this.startAjaxForm.bindAsEventListener(this));
      this.forgotPwForm.observe('submit', this.startAjaxForm.bindAsEventListener(this));
      this.forgotPwButton.observe('click',this.toggleLoginForgotPwForms.bindAsEventListener(this));
      this.forgotPwCancel.observe('click',this.toggleLoginForgotPwForms.bindAsEventListener(this));
    };
    this.ajaxFromLinks.each(function(element){ 
      element.observe('click', this.toggleAjaxFormBlind.bindAsEventListener(this)); 
    }.bind(this));
  }

});


