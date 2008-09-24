class Admin::Con::ActivitiesController  < Admin::Con::CurrentConferenceController

  active_scaffold :activities do |config|
    config.list.columns = [:name, :presenter, :start_time_local, :end_time_local, :location, :track, :type]
    columns = [:name, :start_time, :end_time, :description, :presenter, :location, :track, :type, :conference]
    config.create.columns = columns
    config.update.columns = columns
    config.show.columns = [:name, :start_time_local, :end_time_local, :description, :presenter, :location, :track, :type, :conference]

    config.columns[:conference].ui_type = :select
    config.columns[:track].ui_type = :select
    config.columns[:location].ui_type = :select
    config.columns[:presenter].ui_type = :select
    config.columns[:type].ui_type = :select
    config.columns[:location].label = "Location (Optional)"
    config.columns[:presenter].label = "Presenter (Optional)"
    config.columns[:track].label = "Conference Track (Optional)"
    config.columns[:type].label = "Activity Type (Optional)"
  end


  def conditions_for_collection
    if @current_conference
      ids = @current_conference.activity_ids
      if ids.size > 0
        return ['activities.id in (?)', ids]
      else
        return [ ]
      end
    end
  end

  def do_new
    @record = Activity.new
    apply_constraints_to_record(@record)
    if @current_conference
      @record.conference = @current_conference
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
    # Convert the timezone before saving
    # doing this here instead of a callback
    # to ensure the conversion happens only ONCE

    [:start_time, :end_time].each do |time|
      # first convert from local to utc
      tz = TimeZone[ record.conference.time_zone ]
      record[time] = tz.local_to_utc record[time]
    end
  end

end
