class UserObserver < ActiveRecord::Observer

  def after_create(user)
    @user = user
    UserMailer.deliver_signup(@user)
  end

  def after_update(user)
    @user = user
    email_changes.each { |email| UserMailer.deliver_change_account(@user,email,'email') } if email_changes
    UserMailer.deliver_pending_delete(@user) if user_deleted?
  end


  protected

  def email_changes
    @user.custom_changed_cache[:email]
  end

  def user_deleted?
    @user.deleted? && @user.custom_changed_cache[:deleted] && @user.custom_changed_cache[:delete_after]
  end


end
