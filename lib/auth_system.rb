
module AuthSystem
  
  module Helpers
    
    def user?
      return true if !session[:user].nil?
      # Is the user being authenticated by a token?
      id = params[:user_id]
      token = params[:token]
      if id and token and verify_jumpin
        u = User.authenticate_by_token(id, token)
        if !u.blank?
          session[:user] = u.id
          session[:demo] = u.email == HmConfig.demo[:email] ? true : false
          u.logged_in_at = Time.now ; u.save
          return true
        end
      end
      # Everything failed
      session[:user] = nil
      return false
    end
    
  end
  
  module ControllerMethods
    
    include AuthSystem::Helpers
    
    def nil_demo_account
      if session[:demo] == true
        session[:user] = nil
        session[:demo] = nil
      end
    end
    
    def verify_jumpin
      controller_name == 'user' and action_name == 'jumpin'
    end
    
    def login_required
      if user?
        return true
      end
      store_location
      access_denied
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def access_denied
      redirect_to login_url
    end

    def find_user_object
      if !@user.nil? && (session[:user] == @user.id)
        return @user
      else
        @user = User.find(session[:user])
        return @user
      end
    rescue
      return nil
    end
    
  end
  
  
end

