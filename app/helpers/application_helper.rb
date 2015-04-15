module ApplicationHelper

  include CacheMasters::UrlPaths

  def title(title)
    content_for(:title) { h(title) }
  end

  def site_nav_for(name, nav_url)
    id_filename = "nav_#{name.sub(/\s/,'').underscore}"
    options = {:id => id_filename}
    options.merge!(:method => :delete) if name =~ /logout/i
    img = image_tag "/stylesheets/images/site/#{id_filename}.png", :alt => name, :border => 'none'
    link_to img+name, nav_url, options
  end

  def app_nav_for(title, id, nav_url, options={})
    content = content_tag(:span, '', :id => id, :class => 'user_buttons') + options[:xtra_content].to_s
    link_options = {:class => 'tooltipable', :title => title}
    link_options.merge!(:method => :delete) if id =~ /button_logout/
    link_to(content, nav_url, link_options)
  end

  def auth_params_js_var
    unless RAILS_ENV == 'test'
      %|var authParams = $H({#{request_forgery_protection_token}:#{form_authenticity_token.inspect}});|
    end
  end

  def stylesheet_tags
    stylesheet_link_tag 'application','bookmarklet','utility_styles', :cache => 'homemarks_styles'
  end

  def javascript_vendor_tags
    javascript_include_tag 'prototype','effects','dragdrop','builder', :cache => 'homemarks_vendor'
  end

  def javascript_application_tags
    javascript_include_tag 'homemarks/base','homemarks/sortable','homemarks/app','homemarks/modal','homemarks/tooltip',
                           'homemarks/bookmark','homemarks/box','homemarks/column','homemarks/page','homemarks/inbox',
                           'homemarks/trashbox', :cache => 'homemarks_app'
  end

  def javascript_core_tags
    cache = 'homemarks_core'
    do_caching = ActionController::Base.perform_caching
    if Rails.env =~ /development|test/
      file = File.join(Rails.root,'public','javascripts',"#{cache}.js")
      File.delete(file) if File.exist?(file)
      ActionController::Base.perform_caching = true
      ['stylesheet_expansions','javascript_expansions','file_exist_cache'].each do |mivar|
        ActionView::Helpers::AssetTagHelper.module_eval("@@#{mivar} = {}")
      end
    end
    javascript_include_tag 'homemarks/base','homemarks/modal', :cache => cache
  ensure
    ActionController::Base.perform_caching = do_caching
  end

  def render_bookmarklet
    js = render :partial => 'bookmarklets/bookmarklet'
    js.gsub!('<script>','')
    js.gsub!('</script>','')
    js.gsub!(/ {2,}/,'')
    js.gsub!(/\n/,'')
    js.gsub!(/ /,'%20')
    js
  end

  def render_bookmarklet_save_button
    js = render :partial => 'bookmarklets/add_button'
    js.gsub!('<script>','')
    js.gsub!('</script>','')
    js.gsub!(/ {2,}/,'')
    js.gsub!(/\n/,'')
    js
  end




end
