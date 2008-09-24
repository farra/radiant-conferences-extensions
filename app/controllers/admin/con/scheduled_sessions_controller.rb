class Admin::Con::ScheduledSessionsController  < Admin::Con::CurrentConferenceController

  # handles the time zone convertion from local to UTC here
  # uses the tzinfo_timezone plugin and tzinfo gem

  active_scaffold :scheduled_sessions do | config |
    columns = [:submission, :track, :start_time_local, :end_time_local]    
    config.list.columns =  columns
    config.show.columns = columns
    config.create.columns = [:submission, :track, :start_time]
    config.update.columns = [:submission, :track, :start_time]
    config.search.columns << :submission
    config.columns[:submission].ui_type = :select
    config.columns[:track].ui_type = :select
  end

  def conditions_for_collection
    if @current_conference
      ids = @current_conference.scheduled_sessions.collect{|s| s.id }
      if ids.size > 0
        return ['scheduled_sessions.id in (?)', ids]
      else
        return [ ]
      end
    end
  end

  def do_new
    @record = ScheduledSession.new
    apply_constraints_to_record(@record)
    if @current_conference
      @record.start_time = @current_conference.start_date.to_time
      @record.end_time = @record.start_time + (60 * 60)
    end
  end

  def before_create_save(record)
    convert_times_from_local_to_utc record
  end

  def before_update_save(record)
    convert_times_from_local_to_utc record
  end

  def convert_times_from_local_to_utc(record)

      if record.duration
        record.end_time = record.start_time + (record.duration * 60)
      end


      [:start_time, :end_time].each do |time|

        # now set the date portion to the same date
        # as the associated track

        record[time] = Time.utc( record.track.date.year,
                                  record.track.date.month,
                                  record.track.date.day,
                                  record[time].hour,
                                  record[time].min,
                                  record[time].sec,0)
      end


    # Convert the timezone before saving
    # doing this here instead of a callback
    # to ensure the conversion happens only ONCE

    [:start_time, :end_time].each do |time|
      # first convert from local to utc
      tz = TimeZone[ record.track.conference.time_zone ]
      record[time] = tz.local_to_utc record[time]
    end
  end

end
