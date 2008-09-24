module Admin::Con::SpeakersHelper

  include Admin::Con::DescriptionColumnHelper

  def roles_column(record)
    record.roles.collect {|role| h("#{role.capacity.name} at #{role.conference.name}") }.join("<br/>")
  end

end
