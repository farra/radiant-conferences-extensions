require 'fastercsv'
class ConferenceRole < ActiveRecord::Base

  acts_as_cache_clearing

  belongs_to :conference
  belongs_to :presenter, :class_name => "User", :foreign_key => "presenter_id"
  # belongs_to :event, :polymorphic => true

  def event
    @event ||= event_type.singularize.camelize.constantize.find_by_id(event_id)
  end
  
  alias :session :event

  def self.to_csv(collection=[])
    field_names = %w(Name UploadedPhoto ReceivedAgreement UploadedPresentation)
    header_row = FasterCSV::Row.new(field_names, field_names, true)
    table = FasterCSV::Table.new([header_row])
    collection.each do |cr|
      table << [
        cr.to_label,
        (cr.presenter.photo? rescue false),
        (cr.event.submission.agreement_form_received? rescue false),
        (cr.event.submission.presentation.materials? rescue false)
        ]
    end
    table.to_csv
  end

  def session_name
    case self.event
      when ScheduledSession: self.event.submission.presentation.name
      when Activity: self.event.name
      when PanelMember: "#{self.event.submission.presentation.name} [PANEL]"
    end
  end

  def to_label
    if presenter
      "#{presenter.name}: #{session_name}"
    else
      session_name
    end
  end
end
