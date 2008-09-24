class Admin::Con::TracksController < Admin::Con::CurrentConferenceController

  active_scaffold :tracks do |config|
    config.list.columns = [:name, :date, :location]
    config.create.columns = [:name, :date, :conference, :location]
    config.update.columns = [:name, :date, :conference, :location]
    config.show.columns = [:name, :date, :conference, :location, :scheduled_sessions]
    config.columns[:conference].ui_type = :select
    config.columns[:location].ui_type = :select
  end

  def conditions_for_collection
    ids = @current_conference.tracks.collect{|p| p.id }
    if ids.size > 0
      return ['tracks.id in (?)', ids]
    else
      return [ ]
    end
  end

  def do_new
    @record = Track.new
    apply_constraints_to_record(@record)
    if @current_conference
      @record.conference = @current_conference
      @record.date = @current_conference.start_date
    end
  end

end
