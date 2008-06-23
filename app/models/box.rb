class Box < ActiveRecord::Base

  BOX_COLORS = [ 'white',      'aqua',     'melon',  'limeade',      'lavender', 'postit', 'bisque',
                 'timberwolf', 'sky_blue', 'salmon', 'spring_green', 'wistera',  'yellow', 'apricot',
                 'black',      'cerulian', 'red',    'yellow_green', 'violet',   'orange', 'raw_sienna' ].freeze
    
  belongs_to    :column
  acts_as_list  :scope => :column_id
  has_many      :bookmarks, :order => :position
  
  validates_inclusion_of  :style, :in => BOX_COLORS, :allow_nil => true, :allow_blank => true
  validates_length_of     :title, :within => 0..64, :on => :save, :allow_nil => true, :allow_blank => true
  validates_presence_of   :column_id
  
  attr_protected          :column_id, :position
  
  before_destroy :delete_all_associations
  
  
  
  private
  
  def delete_all_associations
    Bookmark.delete_all :box_id => id
  end
  
  
end

