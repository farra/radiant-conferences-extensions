class Presentation < ActiveRecord::Base

  acts_as_cache_clearing

  acts_as_taggable
  file_column :materials

#  belongs_to :presenter, :class_name => "Person", :foreign_key => "presenter_id"

  belongs_to :presenter, :class_name => "User", :foreign_key => "presenter_id"
  belongs_to :type, :class_name => "PresentationType", :foreign_key => "type_id"

  has_many :submissions
  
  validates_presence_of :presenter

end
