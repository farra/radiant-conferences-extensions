class Admin::Con::ConferenceRolesController <  Admin::Con::CurrentConferenceController

  active_scaffold :conference_roles do | config |
    config.actions = [:list, :show, :nested]
    config.list.columns = [:presenter, :session_name]
    config.show.columns = [:presenter, :session_name]

    config.nested.add_link("Edit Profile", [:presenter])
  end

  def conditions_for_collection
    if @current_conference
      ['conference_id = ?',@current_conference.id]
    else
      [ ]
    end
  end

end

