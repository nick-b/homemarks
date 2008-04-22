module SiteHelper
  
  def site_nav_for(name,options={})
    options.assert_valid_keys :url
    img = image_tag "/stylesheets/images/site/nav_#{options[:img] || name.underscore}.png", :alt => name, :border => 'none'
    link_to img+name, options[:url], :onclick => 'this.blur();'
  end
  
  
end