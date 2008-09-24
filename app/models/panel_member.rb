class PanelMember < ActiveRecord::Base

  acts_as_cache_clearing

  belongs_to :presenter, :class_name => "User", :foreign_key => "presenter_id"
  belongs_to :submission

  def to_label
    "#{self.presenter.name} on #{self.submission.presentation.name}"
  end

end
