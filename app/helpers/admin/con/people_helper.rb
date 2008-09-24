module Admin::Con::PeopleHelper

  def bio_column(record)
   sanitize(record.description)
  end

  def roles_column(record)
    record.roles.collect {|role| h("#{role.capacity.name} at #{role.conference.name}") }.join("<br/>")
  end

end
