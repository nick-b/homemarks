require File.dirname(__FILE__) + '/../test_helper'

class HomemarksTest < ActiveSupport::TestCase
  
  context 'after initialization' do

    setup do
      @js_dir = File.join(RAILS_ROOT,'public/javascripts')
    end

    should 'JsMin target files in public javascripts directory' do
      HmConfig::JSMIN_TARGETS.each do |target| 
        js_file = "#{@js_dir}/#{target}_min.js"
        assert File.exists?(js_file)
      end
    end

  end
  
  
  
end
