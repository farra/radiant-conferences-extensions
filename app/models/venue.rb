class Venue < ActiveRecord::Base

  acts_as_cache_clearing

  has_many :locations, :dependent => :destroy
  has_many :conferences

  validates_presence_of :name

end
