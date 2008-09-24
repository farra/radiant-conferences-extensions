class Admin::Con::PresentationsController  < ApplicationController

  layout "configuration"

  active_scaffold :presentations do | config |
    columns = [:name, :description, :duration, :type, :tag_list, :materials, :presenter]
    config.list.columns = [:name, :presenter, :type, :duration, :submissions ]
    config.create.columns = columns
    config.update.columns = columns
    config.update.columns << :submissions
    config.show.columns = columns
    config.nested.add_link("Submit Presentation", [:submissions])
    config.columns[:type].ui_type = :select
    config.columns[:presenter].ui_type = :select
  end

  def conditions_for_collection
    if @current_conference
      ids = @current_conference.submissions.collect{|s| s.presentation.id }
      if ids.size > 0
        return ['presentations.id in (?)', ids]
      else
        return [ ]
      end
    end

  end

end
