class Conference < ActiveRecord::Base

  acts_as_cache_clearing

  file_column :logo

  belongs_to :venue

  has_many :conference_roles
  has_many :presenters, :through => :conference_roles, :order => ['name'], :class_name => 'User', :foreign_key => 'presenter_id'
  has_many :capacities, :through => :roles
  has_many :sponsors
  has_many :submissions
  has_many :tracks, :order => ["date"]
  has_many :scheduled_sessions, :through => :tracks, :order => 'start_time'
  has_many :activities, :order => ['start_time']

  validates_presence_of :name, :short_name, :venue
  validates_uniqueness_of :short_name

  after_create :generate_pages

  def validate
    if end_date < start_date
      errors.add_to_base "The end_date must be after the start_date"
    end
  end


 def first_session(date=self.start_date)
   first_session = ScheduledSession.find(:first, :include => [:track],
                     :order => ["scheduled_sessions.start_time"],
                     :conditions => ["tracks.conference_id = ? and tracks.date = ?",
                                  self.id, date])
   first_activity = Activity.find(:first, :order => ['activities.start_time'],
                                  :conditions => ["activities.conference_id = ? and activities.start_time > ? ",
                                                 self.id, date])
   if first_session and first_activity
     if first_session.start_time < first_activity.start_time
       return first_session
     else
       return first_activity
     end
   elsif first_session
     return first_session
   elsif first_activity
     return first_activity
   else
     return nil
   end
 end

 def last_session(date=self.start_date)
   first_session = ScheduledSession.find(:first, :include => [:track],
                     :order => ["scheduled_sessions.start_time DESC"],
                     :conditions => ["tracks.conference_id = ? and tracks.date = ?",
                                  self.id, date])
 end


  def start_time_for_date(date=self.start_date)
    session = first_session(date)
    return session.start_time if session
  end

  def end_time_for_date(date=self.start_date)
    session = last_session(date)
    return session.end_time if session
  end

  def cross_track_activities(day=nil)
    where = "conference_id = ? and track_id is NULL "
    where << " and start_time >= ? and start_time < ? " if day
    conditions = [where, self.id ]
    if day
      conditions << day if day
      conditions << (day + 1)
    end
    return Activity.find(:all,:order => 'activities.start_time', :conditions => conditions)
  end

  def cross_track_activities_in_range(start_time,end_time,inclusive=false)
    where = "conference_id = ? and track_id is NULL "
    if inclusive
      where << " and start_time <= ? and end_time > ? "
    else
      where << " and start_time >= ? and start_time < ? "
    end
    conditions = [where, self.id ]
    if inclusive
      conditions << end_time
      conditions << start_time
    else
      conditions << start_time
      conditions << end_time
    end
    return Activity.find(:all,:order => 'activities.start_time', :conditions => conditions)
  end

  def generate_pages
    ConferenceGenerator.new(self).generate
  end
end
