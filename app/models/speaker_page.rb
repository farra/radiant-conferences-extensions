class SpeakerPage < Page
  include SpeakerTags

  before_validation {|r| r.virtual = true }

  def virtual?
    true
  end

  def render
    lazy_initialize_parser_and_context
    @context.globals.speaker = User.find(get_speaker_from_url)
    super
  end

  tag "conference:speaker" do |tag|
    if tag.globals.speaker
      tag.locals.speaker = tag.globals.speaker
    else
      tag.locals.speaker = User.find(get_speaker_from_url)
    end
    tag.expand
  end

  [:name, :url, :bio].each do |column|
    desc %{  Renders the '#{column}' attribute of the current speaker.}
    tag "conference:speaker:#{column}" do |tag|
      tag.locals.speaker[column] if tag.locals.speaker
    end
  end

  desc %{ Image for speakers }
  tag "conference:speaker:photo" do |tag|
    @speaker = tag.locals.speaker
    "<img src='#{url_for_file_column("speaker", "photo")}' alt='#{@speaker.name}'/>"
  end


  desc %{ Scheduled session names for this speaker }
  tag "conference:speaker:sessions" do |tag|
    delimiter = tag.attr['delim']? tag.attr['delim'] : ","
    if tag.attr['prefix']
      prefix = tag.attr['prefix']
    else
      prefix = "#{tag.locals.conference.short_name}/sessions"
    end
    sessions = tag.locals.speaker.scheduled_sessions(tag.locals.conference)
    presentation_names = [ ]
    sessions.each do | session |
      link =  "<a href='/#{prefix}/#{session.id}'>"
      link << "#{session.submission.presentation.name}</a>"
      presentation_names << link
    end
    presentation_names.join(delimiter)
  end

  desc %{ Associated activities for this presenter }
  tag "conference:speaker:activities" do |tag|
    delimiter = tag.attr['delim']? tag.attr['delim'] : ","
    activities = Activity.find(:all, :conditions => ['conference_id = ? and user_id = ?',
                                                     tag.locals.conference.id,
                                                     tag.locals.speaker.id])
    names = [ ]
    activities.each { |a| names << a.name }
    names.join(delimiter)
  end


  private
    def request_uri
      request.request_uri unless request.nil?
    end

   def get_speaker_from_url
      $1 if request_uri =~ %r{#{parent.url}/?(\w+)/?$}
   end

end
