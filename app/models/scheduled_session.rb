class ScheduledSession < ActiveRecord::Base

  # NOTES
  # stored times should ALWAYS be in UTC in the database
  # timezone convertion happens in the active_scaffold controller
  # callbacks keep the end_time in-synch with the duration
  # and the dates in-synch with the track date

  # uses the tzinfo_timezone plugin and tzinfo gem
  # http://tzinfo.rubyforge.org/

  acts_as_cache_clearing

  belongs_to :submission
#  has_one :presentation, :through => :submission
  belongs_to :track

  before_validation :update_date_and_times

  [:name, :description, :duration ].each do |field|
    define_method field do
      if submission && submission.presentation
        return submission.presentation[field]
      end
    end
  end   

  def presenter
    if submission && submission.presentation
      return submission.presentation.presenter
    end
  end

  def type
    if submission && submission.presentation
      return submission.presentation.type
    end
  end

  def tag_list
    if submission && submission.presentation
      return submission.presentation.tag_list
    end
  end


  def validate

#    if start_time > end_time
#      errors.add_to_base("The start time must be before the end time.")
#    end

#    if start_time.to_date != track.date or end_time.to_date != track.date
#      errors.add_to_base("The start and end time dates must match the date of the track (#{track.date}).")
#    end

    if submission.conference != track.conference
      errors.add_to_base("The presentation was submitted to a different conference than the selected track. (#{submission.conference.name} vs. #{track.conference.name}")
    end
  end

  def to_label
    "#{self.submission.presentation.name} @ #{self.track.conference.name}"
  end

  def start_time_local
    if track
      tz = TimeZone[track.conference.time_zone]
      return tz.utc_to_local(start_time)
    else
      return start_time
    end
  end

  def end_time_local
    if track
      tz = TimeZone[track.conference.time_zone]
      return tz.utc_to_local(end_time)
    else
      return end_time
    end
  end


  def update_date_and_times
    # issue with doing this after local/utc conversion
    # what happens when the converted date is after midnight?
    # calculate_end_time_from_duration
    # calculate_dates_from_track
  end

  def calculate_end_time_from_duration
    if duration
      self.end_time = start_time + (duration * 60)
    end
  end

  def calculate_dates_from_track
    if track

      [:start_time, :end_time].each do |time|

        # now set the date portion to the same date
        # as the associated track

        self[time] = Time.utc( track.date.year,
                                  track.date.month,
                                  track.date.day,
                                  self[time].hour,
                                  self[time].min,
                                  self[time].sec,0)
      end
    end
  end

end
