class Box < ActiveRecord::Base

  BOX_COLORS = [ 'white',      'aqua',     'melon',  'limeade',      'lavender', 'postit', 'bisque',
                 'timberwolf', 'sky_blue', 'salmon', 'spring_green', 'wistera',  'yellow', 'apricot',
                 'black',      'cerulian', 'red',    'yellow_green', 'violet',   'orange', 'raw_sienna' ].freeze
    
  belongs_to    :column
  acts_as_list  :scope => :column_id
  has_many      :bookmarks, :order => :position, :dependent => :delete_all
  
  validates_inclusion_of  :style, :in => BOX_COLORS, :allow_nil => true, :if => Proc.new { |box| box.attribute_present? :style }
  validates_length_of     :title, :within => 0..64, :on => :save, :if => Proc.new { |box| box.attribute_present? :title }
  validates_presence_of   :column_id, :if => Proc.new { |box| box.attribute_present? :column_id }
  validates_presence_of   :position, :if => Proc.new { |box| box.attribute_present? :position }
  
  attr_protected          :column_id, :position
  
  
  
  
  
end

