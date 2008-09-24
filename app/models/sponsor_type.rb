class SponsorType < ActiveRecord::Base

  acts_as_cache_clearing

  has_many :sponsors

  validates_presence_of :name
  validates_uniqueness_of :name

end
