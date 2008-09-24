class Admin::Con::CurrentConferenceController < ApplicationController

  layout "conferences"
  before_filter :set_current_conference

  def set_current_conference
    if params[:con_id]
      @current_conference = Conference.find(params[:con_id])

      #!! Rails 2.1 approach
      # Time.zone = @current_conference.time_zone if @current_conference

    end
  end

end
