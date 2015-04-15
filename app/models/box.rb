class Box < ActiveRecord::Base

  OptGroup = Struct.new(:boxes,:col_name)

  COLORS = [ 'white',      'aqua',     'melon',  'limeade',      'lavender', 'postit', 'bisque',
             'timberwolf', 'sky_blue', 'salmon', 'spring_green', 'wistera',  'yellow', 'apricot',
             'black',      'cerulian', 'red',    'yellow_green', 'violet',   'orange', 'raw_sienna' ].freeze

  belongs_to    :column
  acts_as_list  :scope => :column_id
  has_many      :bookmarks, :as => :owner, :order => 'position'

  validates_inclusion_of  :style, :in => COLORS, :allow_nil => true, :allow_blank => true
  validates_length_of     :title, :within => 0..64, :on => :save, :allow_nil => true, :allow_blank => true
  validates_presence_of   :column_id

  attr_protected          :column_id, :position

  before_destroy :delete_all_associations


  def user
    column.user
  end


  private

  def delete_all_associations
    Bookmark.delete_all :owner_id => id, :owner_type => 'Box'
  end


end

