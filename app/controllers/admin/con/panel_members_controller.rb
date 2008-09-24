class Admin::Con::PanelMembersController < Admin::Con::CurrentConferenceController

  active_scaffold :panel_members do | config |
    config.list.columns = [:presenter, :submission]
    config.show.columns = [:presenter, :submission]
    config.create.columns = [:presenter, :submission]
    config.update.columns = [:presenter, :submission]
  end

  def conditions_for_collection
    if @current_conference
      ids = @current_conference.submissions.collect{|s| s.panel_member_ids }
      ids.flatten!
      ids.uniq!
      if ids.size > 0
        return ['panel_members.id in (?)', ids]
      else
        return [ ]
      end
    end
  end

end

