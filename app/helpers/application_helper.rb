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
  
  def render_bookmarklet
    js = render :partial => 'bookmarklet/bookmarklet'
    js.gsub!('<script>','')
    js.gsub!('</script>','')
    js.gsub!(/ {2,}/,'')
    js.gsub!(/\n/,'')
    js.gsub!(/ /,'%20')
    js
  end
  
  def render_bookmarklet_save_button
    js = render :partial => 'bookmarklet/add_button'
    js.gsub!('<script>','')
    js.gsub!('</script>','')
    js.gsub!(/ {2,}/,'')
    js.gsub!(/\n/,'')
    js
  end
  

  
  
end
