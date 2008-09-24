module Admin::Con::ConferencesHelper
  include Admin::Con::DescriptionColumnHelper

  def time_zone_form_column(record, input_name)
    time_zone_select :record, :time_zone, TimeZone.us_zones
  end

end
