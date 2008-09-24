class Organization < ActiveRecord::Base

  acts_as_cache_clearing

  file_column :logo

  has_many :sponsors, :dependent => :destroy

  validates_presence_of  :name

  # regex wrong?
#  validates_format_of :url, :allow_nil => true, :allow_blank => true,
#                      :with =>  /(^(http|https):\/\/[a-z0-9]+([-.]{1}[a-z0-9]*)+. [a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/

end
