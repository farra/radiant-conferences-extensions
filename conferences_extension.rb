# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

require File.dirname(__FILE__) + "/lib/acts_as_cache_clearing"

class ConferencesExtension < Radiant::Extension
  version "1.0"
  description "Manage conference events, speakers, presentations and tracks."
  url "http://cubiclemuses.com/cm"

  define_routes do |map|
    map.connect 'admin/con/activities/:action', :controller => 'admin/con/activities'
    map.connect 'admin/con/conferences/:action', :controller => 'admin/con/conferences'
    map.connect 'admin/con/conference_roles/:action', :controller => 'admin/con/conference_roles'
    map.connect 'admin/con/dashboard/:action/:id', :controller => 'admin/con/dashboard'
    map.connect 'admin/con/locations/:action', :controller => 'admin/con/locations'
    map.connect 'admin/con/organizations/:action', :controller => 'admin/con/organizations'
    map.connect 'admin/con/users/:action', :controller => 'admin/con/users'
    map.connect 'admin/con/presentations/:action', :controller => 'admin/con/presentations'
    map.connect 'admin/con/presentation_types/:action', :controller => 'admin/con/presentation_types'
    map.connect 'admin/con/panel_members/:action', :controller => 'admin/con/panel_members'
    map.connect 'admin/con/schedule/:action', :controller => 'admin/con/schedule'
    map.connect 'admin/con/scheduled_sessions/:action', :controller => 'admin/con/scheduled_sessions'
    map.connect 'admin/con/session_types/:action', :controller => 'admin/con/session_types'
    map.connect 'admin/con/speakers/:action', :controller => 'admin/con/speakers'
    map.connect 'admin/con/sponsors/:action', :controller => 'admin/con/sponsors'
    map.connect 'admin/con/sponsor_types/:action', :controller => 'admin/con/sponsor_types'
    map.connect 'admin/con/sponsor_levels/:action', :controller => 'admin/con/sponsor_levels'
    map.connect 'admin/con/submissions/:action', :controller => 'admin/con/submissions'
    map.connect 'admin/con/tracks/:action', :controller => 'admin/con/tracks'
    map.connect 'admin/con/venues/:action', :controller => 'admin/con/venues'
    map.connect 'admin/con/cfp/:action', :controller => 'admin/con/cfp'    
  end

  def activate
    
    admin.tabs.add "Conferences", "/admin/con/dashboard", :before => "Pages", :visibility => [:developer, :admin]
    admin.tabs.add "Submissions", "/admin/con/cfp", :before => "Conferences", :visibility => [:all]    

    ActiveRecord::Base.send(:include, Con::CacheClearing)
    Page.send :include, ConferenceTags    
    
    User.class_eval {

      acts_as_cache_clearing      
      
      has_many :conference_roles, :foreign_key => 'presenter_id'
      has_many :conferences, :through => :conferences_roles, :foreign_key => 'presenter_id'
      has_many :presentations, :foreign_key => 'presenter_id'
      has_many :panel_members
      has_many :submissions, :through => :presentations
      has_many :activities

      def scheduled_sessions(conference=nil, include_panels=true)
        sessions = [ ]
        conference_roles.each do |role|
          inc = true
          if conference
            inc = role.conference == conference
          end
          
          case role.session
            when ScheduledSession then sessions << role.session if inc
            when PanelMember
              if include_panels and inc
                sessions << role.session.submission.scheduled_session
              end
           end
         end
        return sessions
      end  
      
    }


    SpeakersPage
    SpeakerPage
    SponsorsPage
    SponsorTypePage
    SchedulePage
    ScheduleDayPage
    SessionsPage
    SessionPage

  end

  def deactivate
     admin.tabs.remove "Conferences"
  end

end
