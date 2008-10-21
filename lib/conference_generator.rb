class ConferenceGenerator
  attr_reader :con
  def initialize(conference)
    @con = conference
    @confs_root = @current_page = Page.find_by_url('/c/')
  end

  def generate
    page(con.name, :slug => con.short_name) do
      page("About") do
        part(:body, about)
        page("Venue") do
          part(:body, venue)
        end
      end
      page("Articles", :class_name => "ArchivePage") do
        part(:body, %Q{<ul><r:children:each><li><r:link/> <span class="article-date"><r:date/></span></li></r:children:each></ul>})
        page("%b %Y Archives", :class_name => "ArchiveMonthIndexPage") do
          part(:body, %Q{<ul><r:archive:children:each><li><r:link/> <span class="article-date"><r:date/></span></li></r:archive:children:each></ul>})
        end
      end
      page("Export") do
        part(:body, export_root, :filter_id => "Markdown")
        page("Article Newsfeed", :slug => "atom.xml",              :layout => layout("Atom"))       { part(:body, article_newsfeed) }
        page("iCalendar",        :slug => "#{con.short_name}.ics", :layout => layout("iCalendar"))  { part(:body, icalendar) }
        page("Sponsors",         :slug => "sponsors.xml",          :layout => layout("Atom"))       { part(:body, sponsors_feed) }
        page("Sponsors JSON",    :slug => "sponsors.json",         :layout => layout("JavaScript")) { part(:body, sponsors_json) }
      end
      page("Speakers", :class_name => "SpeakersPage") do
        part(:body, speakers)
        page("Speaker", :class_name => "SpeakerPage") { part(:body, speaker) }
      end
      page("Schedule", :class_name => "SchedulePage") do
        part(:body, schedule)
        page("Schedule Day", :class_name => "ScheduleDayPage") { part(:body, schedule_day) }
      end
      page("Sessions", :class_name => "SessionsPage") do
        part(:body, sessions)
        page("Session", :class_name => "SessionPage") { part(:body, session) }
      end
      page("Sponsors", :class_name => "SponsorsPage") do
        part(:body, sponsors)
        page("Conference Sponsors", :class_name => "SponsorTypePage") { part(:body, sponsor) }
      end
    end
  end

  private

  def page(title, options={})
    defaults = {
      :title => title,
      :slug => title.underscore.gsub(/[_\s\W]+/, '-').sub(/-+$/, '').sub(/^-+/, ''),
      :breadcrumb => title,
      :status_id => 100
    }
    options = defaults.merge(options)
    page = @current_page.children.create!(options)
    if block_given?
      old_page = @current_page
      @current_page = page
      yield
      @current_page = old_page
    end
  rescue Exception => e
    @current_page.logger.warn("PAGE CREATE FAILED: #{e.message}")
    raise e
  end

  def part(name, content, options={})
    defaults = {
      :name => name.to_s,
      :content => content
    }
    options = defaults.merge(options)
    @current_page.parts.create!(options)
  rescue Exception => e
    @current_page.logger.warn("PART CREATE FAILED: #{e.message}")
    raise e
  end

  def layout(name)
    Layout.find_by_name(name)
  end

  def about
    <<-ABOUT
    <h1>#{con.name}</h1>
    #{con.description}
    ABOUT
  end

  def venue
    <<-VENUE
    <h1>Venue</h1>
    <h2>#{con.venue.name}</h2>
    #{con.venue.description}
    #{con.venue.address}
    VENUE
  end

  def export_root
    <<-EXPORT
    Site Export Services
    ====================

    We publish much of the conference information in various export formats:

     - [ATOM News Feed](/c/#{con.short_name}/export/atom.xml)
     - [iCalendar Schedule](/c/#{con.short_name}/export/acus2008.ics)
     - [Sponsor XML Feed](/c/#{con.short_name}/export/sponsors.xml)
    EXPORT
  end

  def article_newsfeed
    <<-FEED
    <feed xmlns="http://www.w3.org/2005/Atom">

     <title>#{con.name}</title>
     <subtitle>Official User Conference of the Apache Software Foundation</subtitle>
     <link href="http://us.apachecon.com/c/#{con.short_name}/export/atom.xml" rel="self"/>
     <link href="http://us.apachecon.com/c/#{con.short_name}"/>
     <updated><r:date for="updated_at" format="%Y-%m-%dT%H:%M:%SZ"/></updated>
     <author>
       <name>ApacheCon Team</name>
       <email>info@apachecon.com</email>
     </author>
     <id>http://us.apachecon.com/c/#{con.short_name}/export/atom.xml</id>

     <r:find url="/c/#{con.short_name}/articles">
      <r:children:each order="asc">
      <entry>
        <title><r:title/></title>
        <link href="http://us.apachecon.com<r:url/>" />
        <id>http://us.apachecon.com<r:url/></id>
        <updated><r:date for="updated_at" format="%Y-%m-%dT%H:%M:%SZ"/></updated>
        <content type="html">
         <r:content/>
        </content>
      </entry>
      </r:children:each>
     </r:find>

    </feed>
    FEED
  end

  def icalendar
    <<-ICAL
    <r:conference shortname="#{con.short_name}">
    <r:schedule:each_day>
    <r:tracks>
    <r:session>
    BEGIN:VEVENT
    SUMMARY:<r:title/>
    DTSTART;TZID=US-Central:<r:start_time datefmt="%Y%m%dT%H%M%S"/>
    DTEND;TZID=US-Central:<r:end_time datefmt="%Y%m%dT%H%M%S"/>
    LOCATION:<r:venue:name/>, <r:location/>
    URL:http://us.apachecon.com/c/#{con.short_name}/sessions/<r:id/>
    END:VEVENT
    </r:session>
    </r:tracks>
    </r:schedule:each_day>
    </r:conference>
    ICAL
  end

  def sponsors_feed
    <<-SPONSORS
    <feed xmlns="http://www.w3.org/2005/Atom">

     <title>#{con.name} Sponsors</title>
     <subtitle>Official sponsor list for #{con.name}</subtitle>
     <link href="http://us.apachecon.com/c/#{con.short_name}/export/sponsors.xml" rel="self"/>
     <link href="http://us.apachecon.com/c/#{con.short_name}"/>
     <updated><r:date for="updated_at" format="%Y-%m-%dT%H:%M:%SZ"/></updated>
     <author>
       <name>ApacheCon Team</name>
       <email>info@apachecon.com</email>
     </author>
     <id>http://us.apachecon.com/c/#{con.short_name}/export/sponsors.xml</id>

     <r:conference shortname="#{con.short_name}">
     <r:sponsors:each>
      <entry>
        <title><r:name/></title>
        <id>uri:#{con.short_name.upcase}SPONSOR<r:id/></id>
        <updated><r:date for="updated_at" format="%Y-%m-%dT%H:%M:%SZ"/></updated>
        <link rel="alternate" href="<r:url/>" />
        <link rel="logo" href="http://us.apachecon.com:3000<r:logo type="url"/>"/>
        <category term="<r:level/>" scheme="http://us.apachecon.com/c/#{con.short_name}/export/sponsor_levels.xml"/>
        <category term="<r:type/>"  scheme="http://us.apachecon.com/c/#{con.short_name}/export/sponsor_types.xml" />
        <summary type="xhtml" xml:lang="en" xml:base="http://us.apachecon.com/c/#{con.short_name}/">
         <div xmlns="http://www.w3.org/1999/xhtml">
          <h2><img src="http://us.apachecon.com:3000<r:logo type="url"/>" alt="<r:name/>"/></h2>
          <h3>#{con.name} <r:level/> <r:type/></h3>
          <div class="description">
           <r:description/>
          </div>
         </div>
        </summary>
      </entry>
     </r:sponsors:each>
     </r:conference>

    </feed>
    SPONSORS
  end

  def sponsors_json
    <<-SPJSON
    {"sponsors" : [
     <r:conference shortname="#{con.short_name}">
     <r:sponsors:each>
    {
     "title": "<r:name/>",
     "url"  : "<r:url/>",
     "logo" : "http://us.apachecon.com:3000<r:logo type="url"/>",
     "level": "<r:level/>",
     "type" : "<r:type/>"
    },
     </r:sponsors:each>
     </r:conference>
    ]}
    SPJSON
  end

  def speakers
    <<-SPEAKERS
    <h1>Speakers</h1>

    <r:conference shortname="#{con.short_name}">
     <ul>
      <r:speakers:each>
       <li><strong><a href="/c/#{con.short_name}/speakers/<r:id/>"><r:name/></a></strong><br/> <r:sessions/> <r:activities/></li>
      </r:speakers:each>
     </ul>
    </r:conference>
    SPEAKERS
  end

  def speaker
    <<-SPEAKER
    <r:conference shortname="#{con.short_name}">
     <r:speaker>
     <h4>#{con.name}</h4>
     <h1><r:name/></h1>

     <div class="span-4" style="text-align:center;">
       <r:photo/><br/>
       <a href="<r:url/>">Website</a>
     </div>

     <div class="span-14 last">
      <h4>Sessions</h4>
      <ul>
        <li>
          <r:sessions delim="</li><li>" prefix="c/#{con.short_name}/sessions" />
        </li>
      </ul>
     </div>
     <hr class="space"/>
     <div class="span-18 last">
      <r:bio/>
     </div>

     </r:speaker>
    </r:conference>
    SPEAKER
  end

  def schedule
    <<-SCHEDULE
    <h1>Schedule at a Glance</h1>
    <r:conference shortname="#{con.short_name}">
    <table>
      <tr>
        <r:schedule:each_day>
          <th><r:schedule_date_link /></th>
        </r:schedule:each_day>
      </tr>
      <tr>
        <td colspan="5">Insert schedule overview grid here</td>
      </tr>
    </table>
    </r:conference>
    SCHEDULE
  end

  def schedule_day
    <<-SDAY
    <r:conference shortname="#{con.short_name}">

      <div class="schedule-grid span-24 last">
       <h2><r:schedule_date_link prefix="c/#{con.short_name}/schedule" /> <a href="/c/#{con.short_name}/export/acus2008.ics"><img src="/images/ical.gif" border="0"></a></h2>

       <table style="border:1px solid black;">
         <tr>
          <th>&nbsp;</th>
          <r:tracks>
           <th><r:name/><br/><r:location/></th>
          </r:tracks>
         </tr>
         <r:time_slots interval="30">
          <tr>
            <td><r:time_slot/></td>
            <r:tracks>
              <r:if_session_in_slot>
                <td class="session track-<r:count/> <r:type/>" rowspan="<r:interval_span/>">
                 <span class="session-name"><r:link session_prefix="c/#{con.short_name}/sessions" activity_prefix="c/#{con.short_name}/activities" /></span>
                 <br/><br/>
                 <span class="session-presenter"><r:presenter:link prefix="c/#{con.short_name}/speakers" /></span>
                </td>
              </r:if_session_in_slot>
              <r:if_empty_slot>
               <td class="freetime track-<r:count/>">&nbsp;</td>
              </r:if_empty_slot>
            </r:tracks>
          </tr>
         </r:time_slots>
       </table>

      </div>

    </r:conference>
    SDAY
  end

  def sessions
    <<-SESSIONS
    <h1>Sessions</h1>

    <h3>
    See the <a href="/c/#{con.short_name}/schedule/">Schedule Grid</a> for the complete conference program.
    </h3>

    <table>
    <r:conference shortname="#{con.short_name}" >
    <r:sessions>
    <tr><td><r:start_time datefmt="%a %m %b %H:%M"/> </td><td> <div class="session-name"><r:link prefix="c/#{con.short_name}/sessions" /></div> by <r:presenter prefix="c/#{con.short_name}/speakers" /> </td></tr>
    </r:sessions>
    </r:conference>
    </table>
    SESSIONS
  end

  def session
    <<-SESSION
    <r:conference shortname="#{con.short_name}">
    <r:session>
    <h4>#{con.name} Session</h4>
    <h1><r:name/></h1>

    <ul>
    <li><r:presenter prefix="c/#{con.short_name}/speakers"/></li>
    <li><r:start_time datefmt="<a href='/c/#{con.short_name}/schedule/%Y/%m/%d'>%a, %d %B %Y %H:%M</a>"/></li>
    <li><r:tags/></li>
    </ul>

    <p>
    <r:description/>
    </p>

    </r:session>
    </r:conference>
    SESSION
  end
  
  def sponsors
    <<-SPONSORS
    <h1>Sponsors</h1>
    <h4>For information on becoming a Sponsor or Exhibitor, please contact INSERT EMAIL LINK HERE</h4>
    <r:conference shortname='#{con.short_name}'>
    <ul>
    <r:sponsor_types:each>
    <li> 
    <r:link/>
    </li>
    </r:sponsor_types:each> 
    </ul>
    </r:conference>
    SPONSORS
  end

  def sponsor
    <<-SPONSOR
    <r:conference shortname="#{con.short_name}">

    <h1><r:sponsor_type_name/></h1>
    <h3>For information on becoming a Sponsor or Exhibitor INSERT EMAIL LINK HERE/h3>
    <r:sponsors:each>
     <div class="sponsor-section">
       <a href="<r:url/>"><r:logo/></a>
       <h3><r:name/></h3>
       <h4 class="alt"><r:level/> <r:type/></h4>
      <p>
        <r:description/>
      </p>
      <hr/>
     </div>
    </r:sponsors:each>
    </r:conference>
    SPONSOR
  end
end