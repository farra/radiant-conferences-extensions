class Location < ActiveRecord::Base

  acts_as_cache_clearing

  belongs_to :venue
  has_many   :activities

  validates_presence_of :name, :venue


end
