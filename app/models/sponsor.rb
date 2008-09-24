class Sponsor < ActiveRecord::Base

  acts_as_cache_clearing

  belongs_to :organization
  belongs_to :sponsor_type
  belongs_to :conference
  belongs_to :sponsor_level

  def to_label
    if organization
      return "#{organization.name} @ #{conference.name}"
    else
      return super.to_s
    end
  end

end
