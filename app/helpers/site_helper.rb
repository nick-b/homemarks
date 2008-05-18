module SiteHelper
  
  def site_nav_for(name, nav_url)
    id_filename = "nav_#{name.sub(/\s/,'').underscore}"
    options = {:id => id_filename}
    options.merge!(:method => :delete) if name =~ /logout/i
    img = image_tag "/stylesheets/images/site/#{id_filename}.png", :alt => name, :border => 'none'
    link_to img+name, nav_url, options
  end
  
  
end