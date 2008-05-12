class UserMailer < ActionMailer::Base
  
  def signup(user)
    setup_email(user)
    @subject += 'Welcome to HomeMarks'
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject += 'Forgotten password notification'
    @body['jumpinurl'] = jumpinurl
    @body['support_url'] = support_url
  end

  def change_account(user)
    setup_email(user)
    @recipients = email if !email.nil?
    @subject += 'Changed account notification'
    @body['email'] = email
    @body['support_url'] = support_url
  end

  def pending_delete(user)
    setup_email(user)
    @subject += 'Delete account notification'
    @body['days'] = HmConfig.app[:delayed_delete_days]
    @body['recover_url'] = url
  end

  def delete(user)
    setup_email(user)
    @subject += 'Deleted account permanently'
  end
  
  
  protected
  
  def setup_email(user)
    @recipients = user.email
    @from       = HmConfig.app[:email_from]
    @sent_on    = Time.now
    @subject    = %|[HomeMarks] |
    setup_body(user)
  end
  
  def setup_body(user)
    @host_uri             = "http://#{HmConfig.app[:host]}"
    @body['support_url']  = "#{@host_uri}/support_requests/new?show_form=true"
    @body['jumpin_url']   = "#{@host_uri}/users/#{user.id}/jumpin"
  end
    
end
