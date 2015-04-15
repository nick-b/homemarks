module AuthenticatedTestHelper

  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods

    def should_require_login(actions={})
      actions.each do |action,options|
        should "Require login for '#{action}' action" do
          logout
          params = options[:params] || {}
          xhr options[:method], action, params
          assert_redirected_to(new_session_path)
        end
      end
    end

  end

  module InstanceMethods

    def login_as(user)
      @request.session[:user_id] = user ? users(user).id : nil
    end

    def logout
      @request.reset_session
    end

    def authorize_as(user, password='test')
      @request.env["HTTP_AUTHORIZATION"] = user ?
        ActionController::HttpAuthentication::Basic.encode_credentials(users(user).email,password) : nil
    end

    def create_user(overrides={})
      attributes = {:email => 'user@test.com', :password => 'test', :password_confirmation => 'test'}.merge!(overrides)
      User.create(attributes)
    end

    def assert_redirected_to_login
      assert_redirected_to new_session_url
    end

    def assert_current_user
      assert_not_nil session[:user_id], 'The session[:user_id] should not be nil'
      assert_instance_of User, assigns(:current_user)
    end

    def assert_logged_out
      assert_nil session[:user_id]
      assert_indif_flash('logged out')
      assert_redirected_to root_url
    end

    def assert_no_current_user
      assert_nil session[:user_id], 'The session[:user_id] should be nil'
      assert_contains [false,nil], assigns(:current_user)
    end

  end


end
