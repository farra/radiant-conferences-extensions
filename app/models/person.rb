class Person < ActiveRecord::Base

  acts_as_cache_clearing

  file_column :photo

  has_one :user

  has_many :conference_roles
  has_many :conferences, :through => :conferences_roles
  has_many :presentations
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

end
