module Admin::Con::ScheduledSessionsHelper

  include Admin::Con::DescriptionColumnHelper

  def start_time_form_column(record, input_name)
    record.start_time = record.start_time_local
    time_select :record, :start_time, :name => input_name
  end


end
