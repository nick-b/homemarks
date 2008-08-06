class UserMailer < ActionMailer::Base
  
  def signup(user)
    setup_email(user)
    @subject += 'Welcome to HomeMarks'
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject += 'Forgotten password notification'
  end
  
  def change_account(user, recipient, changed_attr)
    setup_email(user)
    @recipients = recipient
    @subject += 'Changed account notification'
    @body['changed_attr'] = changed_attr
  end
  
  def pending_delete(user)
    setup_email(user)
    @subject += 'Delete account notification'
    @body['days'] = HmConfig.app[:delayed_delete_days]
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
    @body['user']         = user
    @body['support_url']  = "#{@host_uri}/support_requests/new?show_form=true"
    @body['jumpin_url']   = "#{@host_uri}/session/jumpin?token=#{user.security_token}"
    @body['recover_url']  = "#{@host_uri}/users/#{user.id}/undelete?token=#{user.security_token}"
  end
    
end
