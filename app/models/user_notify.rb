class UserNotify < ActionMailer::Base

  def signup(user, jumpinurl, support_url)
    setup_email(user)
    @subject += "Welcome to #{HmConfig.app[:dotcom]}"
    @body['jumpinurl'] = jumpinurl
    @body['support_url'] = support_url
  end

  def forgot_password(user, jumpinurl, support_url)
    setup_email(user)
    @subject += 'Forgotten password notification'
    @body['jumpinurl'] = jumpinurl
    @body['support_url'] = support_url
  end

  def change_account(user, support_url, email)
    setup_email(user)
    @recipients = email if !email.nil?
    @subject += 'Changed account notification'
    @body['email'] = email
    @body['support_url'] = support_url
  end

  def pending_delete(user, url, support_url)
    setup_email(user)
    @subject += 'Delete account notification'
    @body['days'] = HmConfig.app[:delayed_delete_days]
    @body['recover_url'] = url
  end

  def delete(user, support_url)
    setup_email(user)
    @subject += 'Deleted account permanently'
  end
  
  private
  
  def setup_email(user)
    @recipients = user.email
    @from       = HmConfig.app[:email_from].to_s
    @sent_on    = Time.now
    @subject    = %([#{HmConfig.app[:name]}] - )
    setup_body
  end
  
  def setup_body
    @body['app_name'] = HmConfig.app[:name]
    @body['app_url'] = HmConfig.app[:url]
    @body['app_dotcom'] = HmConfig.app[:dotcom]
  end
  
  
end
