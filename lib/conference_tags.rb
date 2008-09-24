module ConferenceTags

  include Radiant::Taggable
  include FileColumnHelper

  # CONFERENCE
  desc %{ Access to conference data }
  tag "conference" do |tag|
    shortname = tag.attr['shortname']? tag.attr['shortname'] : get_conference_from_url
    conference = Conference.find_by_short_name(shortname)
    tag.locals.conference = conference
    tag.expand
  end

  #!! TODO format for start and end dates
  [:name, :start_date, :end_date, :tagline, :description, :registration_link,
   :community_link, :wiki_link, :mailing_list, :mailing_list_link].each do |column|
    desc %{ Renders the #{column} for the given conference.  Use the 'datefmt' attribute
            to format dates. }
    tag "conference:#{column}" do |tag|
      if tag.attr['datefmt']
        time = tag.locals.conference[column].to_time
        time.strftime(tag.attr['datefmt'])
      else
        tag.locals.conference[column]
      end
    end
  end

  desc %{ Conference logo }
  tag "conference:logo" do |tag|
    @conference = tag.locals.conference
    "<img src='#{url_for_file_column("conference", "logo")}' alt='#{@conference.name}'/>"
  end

  # VENUE
  desc %{ Access to the current venue }
  tag "conference:venue" do |tag|
    tag.locals.venue = tag.locals.conference.venue
    tag.expand
  end

  [:name, :address, :description].each do |column|
    desc %{ Renders the #{column} for the given venue }
    tag "conference:venue:#{column}" do |tag|
      tag.locals.venue[column]
    end
  end

  desc %{ Locations for this venue }
  tag "conference:venue:locations" do |tag|
    output = ""
    tag.locals.venue.locations.each do |location|
      tag.locals.location = location
      output << tag.expand
    end
    output
  end

  [:name,:description].each do | column|
    desc %{ Renders location #{column} }
    tag "conference:venue:locations:#{column}" do |tag|
      tag.locals.location[column]
    end
  end


  # SPONSORS

  desc %{ Sponsors for this conference.  Filter sponsor types by use of the
          <code>type</code> attribute. }
  tag "sponsors" do |tag|

    unless tag.locals.conference
      shortname = get_conference_from_url
      tag.locals.conference = Conference.find_by_short_name(shortname)
    end

    if tag.attr['type']
      type = tag.attr['type']
    elsif tag.globals.sponsor_type
      type = tag.globals.sponsor_type.name
    end


    find_by_type = type ? " and sponsor_types.name = ?" : " "
    conditions = ["conference_id = ? #{find_by_type}", tag.locals.conference.id]
    conditions << type if type

    order = "sponsor_types.name desc, sponsor_levels.rank, organizations.name"

    tag.locals.sponsors = Sponsor.find(:all, :conditions => conditions,
                                       :order => order, :include => [:sponsor_type, :sponsor_level, :organization] )
    tag.expand
  end

  desc %{ Sponsors for this conference }
  tag "sponsors:each" do |tag|
    output = ""
    tag.locals.sponsors.each do | sponsor |
      tag.locals.sponsor = sponsor
      output << tag.expand
    end
    output
  end


  desc %{ Sponsor type }
  tag "sponsors:each:type" do |tag|
    if tag.locals.sponsor.sponsor_type
      tag.locals.sponsor.sponsor_type.name
    end
  end

  desc %{ Sponsor level }
  tag "sponsors:each:level" do |tag|
    if tag.locals.sponsor.sponsor_level
      tag.locals.sponsor.sponsor_level.name
    end
  end


  [:name, :url, :description, :id].each do |column|
    desc %{ Sponsor #{column} }
    tag "sponsors:each:#{column}" do |tag|
      tag.locals.sponsor.organization[column]
    end
  end

  desc %{ Sponsor logo }
  tag "sponsors:each:logo" do |tag|
    @organization = tag.locals.sponsor.organization
    type = 'html'
    type = tag.attr['type'] if tag.attr['type']
    case type
      when "html"
        output = "<img src='#{url_for_file_column("organization", "logo")}' alt='#{@organization.name}'/>"      
      when "url"
        output = url_for_file_column("organization", "logo")      
    end
    output
  end

  desc %{ Sponsor types }
  tag "sponsor_types" do |tag|
    #!! TODO should filter for sponsor types in this conference
    tag.locals.sponsor_types = SponsorType.find(:all)
    tag.expand
  end

  desc %{ For each sponsor type }
  tag "sponsor_types:each" do |tag|
    output = ""
    tag.locals.sponsor_types.each do | type |
      tag.locals.sponsor_type = type
      output << tag.expand
    end
    output
  end

  desc %{ Sponsor type name }
  tag "sponsor_types:each:name" do |tag|
    tag.locals.sponsor_type.name
  end

  desc %{ Sponsor type url }
  tag "sponsor_types:each:link" do |tag|
    if tag.attr['prefix']
      prefix = tag.attr['prefix']
    else
      prefix = "#{tag.locals.conference.short_name}/sponsors"
    end
    output = "<a href='/#{prefix}/#{tag.locals.sponsor_type.name.tableize.gsub(/ /,'_')}'>"
    output << tag.locals.sponsor_type.name
    output << "</a>"
  end


  private
    def request_uri
      request.request_uri unless request.nil?
    end

   #!! TODO add an optional prefix
   def get_conference_from_url
     m = request_uri.match /^\/([^\/]*)\/.*$/
     m[1] if m
   end

   def get_date_from_url
     year, month, day = $1, $2, $3 if request_uri =~  %r{#{parent.url}(\d{4})/(\d{2})/(\d{2})$}
     Date.new(year,month,day)
   end

end
