class ConferenceRole < ActiveRecord::Base

  acts_as_cache_clearing

  belongs_to :conference
  belongs_to :presenter, :class_name => "User", :foreign_key => "presenter_id"

  def session
    clazz = Object::const_get(self.event_type.camelize)
    if clazz == PanelMember
      return ScheduledSession.find(self.event_id.to_i)
    else
      return clazz.find(self.event_id.to_i)      
    end
  end

  def session_name
    clazz = Object::const_get(self.event_type.camelize)
    cap = clazz.find(self.event_id.to_i)
    case cap
      when ScheduledSession: cap.submission.presentation.name
      when Activity: cap.name
      when PanelMember: "#{cap.submission.presentation.name} [PANEL]"
    end
  end

  def to_label
    "#{presenter.name}: #{session_name}"
  end

end
