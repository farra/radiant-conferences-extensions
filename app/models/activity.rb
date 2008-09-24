class Activity < ActiveRecord::Base

  acts_as_taggable
  acts_as_cache_clearing

  belongs_to :type, :class_name => "PresentationType", :foreign_key => "presentation_type_id"
  belongs_to :presenter, :class_name => "User", :foreign_key => "presenter_id"  
  belongs_to :location
  belongs_to :track
  belongs_to :conference

  before_validation :update_conference

  def duration
    (end_time - start_time) / 60
  end

  def start_time_local
    if conference
      tz = TimeZone[conference.time_zone]
      return tz.utc_to_local(start_time)
    else
      return start_time
    end
  end

  def end_time_local
    if conference
      tz = TimeZone[conference.time_zone]
      return tz.utc_to_local(end_time)
    else
      return end_time
    end
  end

  def update_conference
    if track and not conference
      self.conference = track.conference
    end
    if track and not location
      self.location = track.location
    end
  end

  def validate

    if end_time < start_time
      errors.add_to_base "The ending time must be after the start time."
    end


    if track and conference
      if track.conference != conference
        errors.add_to_base "The selected track is not part of the selected conference."
      end
    end

    if track and location
      if track.location != location
        errors.add_to_base "The selected location differs from the selected track location."
      end
    end
  end


end
