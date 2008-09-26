class PanelMember < ActiveRecord::Base

  acts_as_cache_clearing

  belongs_to :presenter, :class_name => "User", :foreign_key => "presenter_id"
  belongs_to :submission
  
  validates_presence_of :submission, :presenter

  def to_label
    "#{self.presenter.name} on #{self.submission ? self.submission.name : '*MISSING SUBMISSION*'}"
  end

end
