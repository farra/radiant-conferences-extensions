class Submission < ActiveRecord::Base

  acts_as_cache_clearing

  belongs_to :presentation
  belongs_to :conference
  has_many   :scheduled_sessions
  has_many   :panel_members

  validates_presence_of :presentation
  validates_presence_of :conference 
  
  def presenter
    self.presentation ? self.presentation.presenter : nil    
  end
  
  def name
    self.presentation ? self.presentation.name : nil
  end

  def to_label
    "#{self.name} to #{self.conference ? self.conference.name : 'UNSPECIFIED CONFERENCE'}"
  end
  
  def new_presentation_attributes=(presentation_attributes)
    params = presentation_attributes.first
    self.presentation = Presentation.new
    self.presentation.build( params )
  end
  
  def existing_presentation_attributes=(presentation_attributes)
    params = presentation_attributes[self.presentation.id.to_s]
    self.presentation.update_attributes(params)
    self.presentation.save
  end

end
