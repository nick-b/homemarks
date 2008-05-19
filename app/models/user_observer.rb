class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    UserMailer.deliver_signup(user)
  end
  
  def after_update(user)
    if email_changes = user.custom_changed_cache[:email]
      email_changes.each { |email| UserMailer.deliver_change_account(user,email,'email') }
    end
  end
  
  
end
