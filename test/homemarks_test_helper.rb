module HomemarksTestHelper

  def self.included(klass)
    klass.class_eval do
      include ActionControllerAssertions
      include ActiveRecordAssertions
      include DomAssertions
      include SiteAssertions
    end
  end

  module ActionControllerAssertions

    def self.included(klass)
      klass.send :extend, ClassMethods
    end

    module ClassMethods

      def should_ignore_lost_sortable_requests
        klass = model_class
        should 'ignore lost sortable requests' do
          get :index, :lost_sortable => 'true'
          assert_response :multi_status
        end
      end

    end

    [:good,:bad,:indif].each do |mood|
      define_method "assert_#{mood}_flash" do |contents|
        assert_match contents, flash[mood]
      end
    end

    def assert_layout(expected=nil, message=nil)
      clean_backtrace do
        layout = @response.layout ? @response.layout.split('/').last : false
        msg = build_message(message, "expecting <?> but rendering with <?>", expected.to_s, layout)
        assert_block(msg) do
          expected.nil? ? @response.layout : expected.to_s == layout
        end
      end
    end

    def assert_json_response
      content_type = (@response.headers['Content-Type'] || @response.headers['type']).to_s
      json = 'application/json'
      msg = "Content Type #{content_type.inspect} doesn't match #{json.inspect}\n"
      msg += "Body: #{@response.body.first(100).chomp} ..."
      assert_match json, content_type, msg
    end

    protected

    def decode_json_response
      ActiveSupport::JSON.decode(@response.body)
    end

  end

  module ActiveRecordAssertions

    def self.included(klass)
      klass.send :extend, ClassMethods
    end

    module ClassMethods

      def should_allow_nil_and_blank_for(*attrs)
        klass = model_class
        attrs.each do |a|
          should "allow NIL for #{a}" do
            assert object = klass.find(:first), "Can not find first #{klass}"
            object.send("#{a}=",nil)
            assert object.save
          end
          should "allow BLANK for #{a}" do
            assert object = klass.find(:first), "Can not find first #{klass}"
            object.send("#{a}=",'')
            assert object.save
          end
        end
      end

    end

    def assert_valid(obj)
      assert obj.valid?, "Expected [#{obj.class}] to be valid. Errors: #{inspect_errors(obj)}"
    end

    def assert_not_valid(obj)
      assert !obj.valid?, "Expected [#{obj.class}] to not be valid"
    end

    def inspect_errors(obj)
      obj.errors.full_messages.inspect
    end

  end

  module DomAssertions

    def assert_title_heading(title=nil)
      assert_select 'h1', /#{h(title)}/i if title
    end

    def assert_element_visible(selector,visible=true)
      style_regexp = visible ? /display:(inline|block);/ : /display:none;/
      assert_select(selector) do
        assert_select '[style=?]', style_regexp
      end
    end

    def assert_element_hidden(selector)
      assert_element_visible(selector,visible=false)
    end

  end

  module SiteAssertions

    def assert_site_page_success(options={})
      assert_response :success
      assert_layout :site
      assert_site_navigation
      assert_title_heading(options[:title])
    end

    def assert_site_layout
      assert_select 'div#site_wrapper', {:count => 1}
    end

    def assert_site_navigation(logged_in=false)
      standard_nav_names = /Home|Help/
      stateful_nav_names = logged_in ? /My HomeMarks|Logout/ : /Login/
      all_nav_names      = Regexp.union(standard_nav_names,stateful_nav_names)
      navigation_count   = logged_in ? 4 : 3
      assert_select '#site_links a', { :count => navigation_count, :text => all_nav_names }
      assert_select '#site_links a' do
        assert_select 'img', true, 'should have an image tag inside all nav items'
        assert_select 'img[alt=?]', all_nav_names
      end
    end

  end

end