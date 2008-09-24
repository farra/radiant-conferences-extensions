class PresentationType < ActiveRecord::Base

  acts_as_cache_clearing

  has_many :presentations, :class_name => "Presentation", :foreign_key => "type_id"
  has_one :presentation_capacity
  has_many :activities

end
