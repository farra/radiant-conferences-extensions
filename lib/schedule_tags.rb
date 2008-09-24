module ScheduleTags

  include Radiant::Taggable

  desc %{ Renders the schedule for the conference }
  tag "schedule" do |tag|
    unless tag.locals.conference
      shortname = get_conference_from_url
      tag.locals.conference = Conference.find_by_short_name(shortname)
    end
    tag.expand
  end

  tag "schedule:each_day" do |tag|
    output = ""
    dates = Range.new(tag.locals.conference.start_date, tag.locals.conference.end_date)
    dates.each do | date |
      tag.locals.schedule_date = date
      output << tag.expand
    end
    output
  end

  tag "schedule_date" do |tag|
    unless tag.locals.schedule_date
      if tag.globals.schedule_date
        tag.locals.schedule_date = tag.globals.schedule_date
      elsif
        tag.locals.schedule_date = get_date_from_url
      end
    end
    if tag.attr['datefmt']
      time = tag.locals.schedule_date.to_time
      time.strftime(tag.attr['datefmt'])
    else
      tag.locals.schedule_date
    end
  end

  tag "time_slots" do |tag|
    output = ""
    begining = tag.locals.conference.start_time_for_date(tag.locals.schedule_date)
    ending = tag.locals.conference.end_time_for_date(tag.locals.schedule_date)
    if begining and ending
      slots = Range.new(0, ending - begining)
      interval = tag.attr['interval'] ? tag.attr['interval'].to_i : 30
      tag.locals.time_slot_interval = interval * 60
      slots.step(tag.locals.time_slot_interval) do | step |
        tag.locals.current_time_slot = begining + step
        output << tag.expand
      end
    end
    output
  end

  tag "time_slot" do |tag|
    fmt = tag.attr['datefmt'] ? tag.attr['datefmt'] : "%H:%M"
    tz = TimeZone[tag.locals.conference.time_zone]
    time = tz.utc_to_local tag.locals.current_time_slot
    time.strftime(fmt)
  end

  tag "schedule_date_link" do |tag|
    prefix = tag.attr['prefix'] ? tag.attr['prefix'] : "#{get_conference_from_url}/schedule"
    unless tag.locals.schedule_date
      if tag.globals.schedule_date
        tag.locals.schedule_date = tag.globals.schedule_date
      elsif
        tag.locals.schedule_date = get_date_from_url
      end
    end
    time = tag.locals.schedule_date.to_time
    fmt = tag.attr['datefmt'] ? tag.attr['datefmt'] : "%A, %d %b %Y"
    time.strftime("<a href='/#{prefix}/%Y/%m/%d'>#{fmt}</a>")
  end

  tag "tracks" do |tag|
    unless tag.locals.conference
      shortname = get_conference_from_url
      tag.locals.conference = Conference.find_by_short_name(shortname)
    end
    unless tag.locals.schedule_date
      tag.locals.schedule_date = get_date_from_url
    end

    tracks = Track.find(:all, :order => ["locations.name"], :include => [:location],
                        :conditions => ["tracks.conference_id = ? and tracks.date = ?",
                                         tag.locals.conference.id,
                                         tag.locals.schedule_date])

    output = ""
    tag.locals.tracks_size = tracks.size
    tracks.each do | track |
      tag.locals.track = track
      output << tag.expand
    end
    output
  end

  tag "tracks:count" do |tag|
    tag.locals.tracks_size
  end

  tag "tracks:name" do |tag|
    tag.locals.track.name
  end


  tag "tracks:location" do |tag|
    tag.locals.track.location.name
  end

  tag "tracks:session" do |tag|
    output = ""
    sessions = tag.locals.track.all_events
    tag.locals.sessions = sessions
    sessions.each_with_index do | session, index |
      tag.locals.session = session
      tag.locals.session_index = index
      output << tag.expand
    end
    output
  end

  tag "tracks:session:preceding_free_minutes" do |tag|
    minutes = 0
    prev_index = tag.locals.session_index - 1
    if prev_index >= 0
      prev_session = tag.locals.sessions[ prev_index ]
      seconds = tag.locals.session.start_time - prev_session.end_time
      # to closest 10 minute interval
      minutes = (seconds / 600.0).round * 10
    else
      seconds = tag.locals.session.start_time - tag.locals.conference.start_time_for_date(tag.locals.schedule_date)
      minutes = (seconds / 600.0).round * 10
    end
    minutes
  end

  tag "tracks:session:following_free_minutes" do |tag|
    minutes = 0
    next_index = tag.locals.session_index + 1
    if next_index < tag.locals.sessions.size
      next_session = tag.locals.sessions[ next_index ]
      seconds = next_session.start_time - tag.locals.session.end_time
      # to closest 10 minute interval
      # minutes = (seconds / 600.0).round * 10
      minutes = 0
    else
      seconds =  tag.locals.conference.end_time_for_date(tag.locals.schedule_date) - tag.locals.session.end_time
      minutes = (seconds / 600.0).round * 10
    end
    minutes
  end

  tag "tracks:session:duration" do |tag|
    tag.locals.session.duration
  end

  tag "tracks:session:title" do |tag|
    tag.locals.session.name
  end

  tag "tracks:session:id" do |tag|
    tag.locals.session.id
  end

  tag "tracks:session:type" do |tag|
    tag.locals.session.type.name if tag.locals.sessions.type
  end
  tag "tracks:session:type_class" do |tag|
    tag.locals.session.type.name.tableize if tag.locals.sessions.type
  end


  tag "tracks:session:link" do |tag|
    s_prefix = tag.attr['session_prefix'] ? tag.attr['session_prefix'] : "#{tag.locals.conference.short_name}/sessions"
    a_prefix = tag.attr['activity_prefix'] ? tag.attr['activity_prefix'] : "#{tag.locals.conference.short_name}/activities"
    prefix = (tag.locals.session.is_a? ScheduledSession) ?  s_prefix : a_prefix
    output = "<a href='/#{prefix}/#{tag.locals.session.id}'>"
    output << "#{tag.locals.session.name}</a>"
  end

  tag "tracks:session:presenter" do |tag|
    if tag.locals.session.is_a? ScheduledSession
      tag.locals.presenter = tag.locals.session.presenter
    else
      tag.locals.presenter = tag.locals.session.presenter
    end
    tag.expand
  end


  tag "tracks:session:presenter:name" do |tag|
    tag.locals.presenter.name if tag.locals.presenter
  end

  tag "tracks:session:presenter:link" do |tag|
    output = ""
    if tag.locals.presenter
      prefix = tag.attr['prefix'] ? tag.attr['prefix'] : "#{tag.locals.conference.short_name}/speakers"
      output << "<a href='/#{prefix}/#{tag.locals.presenter.id}'>"
      output << tag.locals.presenter.name
      output << "</a>"
    end
    output
  end


  [:start_time, :end_time].each do | column |
    tag "tracks:session:#{column}" do |tag|
      if tag.attr['datefmt']
        tz = TimeZone[tag.locals.conference.time_zone]
        time = tz.utc_to_local tag.locals.session[column]
        time.strftime(tag.attr['datefmt'])
      else
        tag.locals.session[column]
      end
    end
  end


  tag "tracks:if_session_in_slot" do |tag|
    output = ""
    slot_start = tag.locals.current_time_slot
    slot_end   = slot_start + tag.locals.time_slot_interval
    slot_events = tag.locals.track.events_starting_in_slot slot_start, slot_end
    slot_events.each do |slot_event|
      tag.locals.session = slot_event
      output << tag.expand
    end
    output
  end

  tag "tracks:if_session_in_slot:interval_span" do |tag|
    span = 0
    if tag.locals.session and tag.locals.time_slot_interval
      span = (tag.locals.session.end_time - tag.locals.session.start_time) / tag.locals.time_slot_interval
    end
    span
  end

  tag "tracks:if_session_in_slot:link" do |tag|
    s_prefix = tag.attr['session_prefix'] ? tag.attr['session_prefix'] : "#{tag.locals.conference.short_name}/sessions"
    a_prefix = tag.attr['activity_prefix'] ? tag.attr['activity_prefix'] : "#{tag.locals.conference.short_name}/activities"
    prefix = (tag.locals.session.is_a? ScheduledSession) ?  s_prefix : a_prefix
    output = "<a href='/#{prefix}/#{tag.locals.session.id}'>"
    output << "#{tag.locals.session.name}</a>"
  end

  tag "tracks:if_session_in_slot:type" do |tag|
    tag.locals.session.type.name.tableize if tag.locals.sessions.type
  end

  tag "tracks:if_session_in_slot:presenter" do |tag|
    if tag.locals.session.is_a? ScheduledSession
      tag.locals.presenter = tag.locals.session.presenter
    else
      tag.locals.presenter = tag.locals.session.presenter
    end
    tag.expand
  end

  tag "tracks:if_session_in_slot:presenter:link" do |tag|
    output = ""
    if tag.locals.presenter
      prefix = tag.attr['prefix'] ? tag.attr['prefix'] : "#{tag.locals.conference.short_name}/speakers"
      output << "<a href='/#{prefix}/#{tag.locals.presenter.id}'>"
      output << tag.locals.presenter.name
      output << "</a>"
    end
    output
  end

  tag "tracks:if_empty_slot" do |tag|
    output = ""
    slot_start = tag.locals.current_time_slot
    slot_end   = slot_start + tag.locals.time_slot_interval
    unless tag.locals.track.events_in_slot? slot_start, slot_end
      slot_events = tag.locals.track.events_starting_in_slot slot_start, slot_end
      output << tag.expand if slot_events.size == 0
    end
    output
  end

 private
    def request_uri
      request.request_uri unless request.nil?
    end

   def get_conference_from_url
     m = request_uri.match /^\/([^\/]*)\/.*$/
     m[1] if m
   end

   def get_date_from_url
     year, month, day = $1, $2, $3 if request_uri =~  %r{#{parent.url}(\d{4})/(\d{2})/(\d{2})$}
     Date.new(year,month,day)
   end

end
