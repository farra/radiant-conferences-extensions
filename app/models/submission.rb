class Submission < ActiveRecord::Base

  acts_as_cache_clearing

  belongs_to :presentation
  belongs_to :conference
  has_many   :scheduled_sessions
  has_many   :panel_members

  after_create :send_notification
  after_update :update_agreement_form_received
#  do we want to check if they've already submitted a presentation to a conference?
#  validates_uniqueness_of :presentation, :scope => [:conference_id]
  
  def presenter
    self.presentation ? self.presentation.presenter.name : nil    
  end
  
  def name
    self.presentation ? self.presentation.name : nil
  end

  def to_label
    "#{self.presentation.name} to #{self.conference.name}"
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

  def send_notification
    if conference && !conference.submission_notification_email.blank?
      SubmissionNotifier.deliver_notification(:submission => self, :to => conference.submission_notification_email)
    end
  end

  def update_agreement_form_received
    presentation_ids = presentation.presenter.presentation_ids
    Submission.update_all({:agreement_form_received => agreement_form_received}, 
                        :conference_id => conference_id, :presentation_id => presentation_ids)
  end
end
