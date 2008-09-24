class Track < ActiveRecord::Base

  acts_as_cache_clearing

  belongs_to :conference
  belongs_to :location
  has_many   :scheduled_sessions, :order => ["start_time"]
  has_many   :activities, :order => ["start_time"]

  validates_presence_of :name, :date, :conference, :location
  validates_uniqueness_of :date, :scope => [:conference_id, :location_id]

  def to_label
    "#{name} [#{date.strftime('%a %b %d')}]"
  end

  def validate
    if date > conference.end_date or date < conference.start_date
      errors.add_to_base("The track date must be within the start and end dates of the conference")
    end

    unless conference.venue.locations.index(location)
      errors.add_to_base("The track location must be a location at the conference venue.")
    end
  end

  def all_events
    events = []
    events << self.scheduled_sessions
    events << self.activities
    events << self.conference.cross_track_activities( self.date )
    events.flatten!
    events.sort do |a,b|
      a.start_time <=> b.start_time
    end
  end

  def events_starting_in_slot(start_time, end_time)
    conditions = ["track_id = ? and (start_time >= ? and start_time < ?)",id,start_time, end_time]
    events = []
    events << ScheduledSession.find(:all,:conditions => conditions)
    events << Activity.find(:all, :conditions => conditions)
    events << conference.cross_track_activities_in_range( start_time, end_time )
    events.flatten!
    events.sort do |a,b|
      a.start_time <=> b.start_time
    end
  end

  def events_in_slot?(start_time, end_time)
    conditions = ["track_id = ? and (start_time <= ? and end_time > ?)",id,end_time, start_time]
    events = []
    events << ScheduledSession.find(:all,:conditions => conditions)
    events << Activity.find(:all, :conditions => conditions)
    events << conference.cross_track_activities_in_range( start_time, end_time, true )
    events.flatten!
    events.size > 0
  end

end
