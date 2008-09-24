class SponsorLevel < ActiveRecord::Base

  acts_as_cache_clearing

  validates_presence_of :name
  validates_uniqueness_of :name

end
