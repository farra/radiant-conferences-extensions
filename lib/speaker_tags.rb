module SpeakerTags

  include Radiant::Taggable
  include FileColumnHelper

  # SPEAKERS

  desc %{ Speakers for this conference }
  tag "speakers" do |tag|
    unless tag.locals.conference
      shortname = get_conference_from_url
      tag.locals.conference = Conference.find_by_short_name(shortname)
    end
    tag.locals.speakers = tag.locals.conference.presenters.uniq
    tag.expand
  end

  desc %{ Speakers for this conference }
  tag "speakers:each" do |tag|
    output = ""
    tag.locals.speakers.each do | speaker |
      tag.locals.speaker = speaker
      output << tag.expand
    end
    output
  end

  [:name, :url, :notes, :id].each do |column|
    desc %{  Renders the '#{column}' attribute of the current speaker.}
    tag "speakers:each:#{column}" do |tag|
      tag.locals.speaker[column]
    end
  end

  desc %{ Image for speakers }
  tag "speakers:each:photo" do |tag|
    @speaker = tag.locals.speaker
    "<img src='#{url_for_file_column("speaker", "photo")}' alt='#{@speaker.name}'/>"
  end

  desc %{ Scheduled session names for this speaker }
  tag "speakers:each:sessions" do |tag|
    delimiter = tag.attr['delim']? tag.attr['delim'] : ","
    sessions = tag.locals.speaker.scheduled_sessions(tag.locals.conference)
    presentation_names = [ ]
    sessions.each do |session|
      presentation_names << session.submission.presentation.name
    end
    presentation_names.join(delimiter)
  end

  desc %{ Associated activities for this presenter }
  tag "speakers:each:activities" do |tag|
    delimiter = tag.attr['delim']? tag.attr['delim'] : ","
    activities = Activity.find(:all, :conditions => ['conference_id = ? and presenter_id = ?',
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

   def get_conference_from_url
     m = request_uri.match /^\/([^\/]*)\/.*$/
     m[1] if m
   end

   def get_date_from_url
     year, month, day = $1, $2, $3 if request_uri =~  %r{#{parent.url}(\d{4})/(\d{2})/(\d{2})$}
     Date.new(year,month,day)
   end


end
