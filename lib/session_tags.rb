module SessionTags

  include Radiant::Taggable
  include FileColumnHelper


  tag "conference:sessions" do |tag|
    output = ""
    type = tag.attr["type"] ? tag.attr["type"] : "scheduled_sessions"
    if type == "activities"
      tag.locals.sessions = tag.locals.conference.activities
    else
      tag.locals.sessions = tag.locals.conference.scheduled_sessions
    end

    tag.locals.sessions.each do | session |
      tag.locals.session = session
      output << tag.expand
    end
    output
  end

  [:start_time, :end_time].each do | column |
    tag "conference:sessions:#{column}" do |tag|
      if tag.attr['datefmt']
        tz = TimeZone[tag.locals.conference.time_zone]
        time = tz.utc_to_local tag.locals.session[column]
        time.strftime(tag.attr['datefmt'])
      else
        tag.locals.session[column]
      end   
    end
  end

  [:name, :description, :duration, :presentation_type].each do |column|
    tag "conference:sessions:#{column}" do |tag|
      tag.locals.session[column]
    end
  end

  tag "conference:sessions:tags" do |tag|
    delim = tag.attr['delim'] ? tag.attr['delim'] : ","
    tag.locals.session.tag_list.join(delim)
  end


    
  tag "conference:sessions:link" do |tag|
    prefix = tag.attr['prefix'] ? tag.attr['prefix'] : "#{tag.locals.conference.short_name}/sessions"
    "<a href='/#{prefix}/#{tag.locals.session.id}'>#{tag.locals.session.name}</a>"
  end

  tag "conference:sessions:presenter" do |tag|
    prefix = tag.attr['prefix'] ? tag.attr['prefix'] : "#{tag.locals.conference.short_name}/speakers"
    if tag.locals.session.is_a? ScheduledSession
      output = "<a href='/#{prefix}/#{tag.locals.session.presenter.id}'>"
      output << "#{tag.locals.session.presenter.name}</a>"
    else
      output = "<a href='/#{prefix}/#{tag.locals.session.presenter.id}'>"
      output << "#{tag.locals.session.presenter.name}</a>"
    end
  end  
  

 tag "conference:session" do |tag|
    type = tag.attr["type"] ? tag.attr["type"] : "scheduled_session"

    unless tag.locals.scheduled_session
      if tag.globals.scheduled_session
        tag.locals.scheduled_session = tag.globals.scheduled_session
      else
        if type == "activity"
          tag.locals.scheduled_session = Activity.find(get_session_from_url.to_i)
        else
          tag.locals.scheduled_session = ScheduledSession.find(get_session_from_url.to_i)
        end
      end
    end
    tag.expand
  end


  [:start_time, :end_time].each do | column |
    tag "conference:session:#{column}" do |tag|
      time = tag.locals.scheduled_session[column]
      tz = TimeZone[tag.locals.conference.time_zone]
      time = tz.utc_to_local time
      if tag.attr['datefmt']
        time.strftime(tag.attr['datefmt'])
      end
    end
  end

  [:name, :description, :duration, :presentation_type].each do |column|
    tag "conference:session:#{column}" do |tag|
      tag.locals.scheduled_session.send column
    end
  end

  tag "conference:session:tags" do |tag|
    delim = tag.attr['delim'] ? tag.attr['delim'] : ","
    tag.locals.scheduled_session.tag_list.join(delim)
  end

  tag "conference:session:materials_link" do |tag|
    text = tag.attr['text'] ? tag.attr['text'] : "Download Materials"
    output = 'No Materials Available'
    if tag.locals.scheduled_session.submission.presentation.materials
     output = "<a href='#{url_for_file_column tag.locals.scheduled_session.submission.presentation, 'materials', :absolute => true}'>#{text}</a>"      
    end
    output
  end  
  
  tag "conference:session:link" do |tag|
    prefix = tag.attr['prefix'] ? tag.attr['prefix'] : "#{tag.locals.conference.short_name}/sessions"
    "<a href='/#{prefix}/#{tag.locals.scheduled_session.id}'>#{tag.locals.scheduled_session.submission.presentation.name}</a>"
  end

  tag "conference:session:presenter" do |tag|
    prefix = tag.attr['prefix'] ? tag.attr['prefix'] : "#{tag.locals.conference.short_name}/speakers"
    output = "<a href='/#{prefix}/"
    output << "#{tag.locals.scheduled_session.presenter.id}'>"
    output << "#{tag.locals.scheduled_session.presenter.name}</a>"
  end



  private
    def request_uri
      request.request_uri unless request.nil?
    end

   def get_conference_from_url
     m = request_uri.match /^\/([^\/]*)\/.*$/
     m[1] if m
   end

   def get_session_from_url
      $1 if request_uri =~ %r{#{parent.url}/?(\w+)/?$}
   end

   def get_date_from_url
     year, month, day = $1, $2, $3 if request_uri =~  %r{#{parent.url}(\d{4})/(\d{2})/(\d{2})$}
     Date.new(year,month,day)
   end

end
