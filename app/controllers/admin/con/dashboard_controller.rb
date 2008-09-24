class Admin::Con::DashboardController < ApplicationController

  layout "conferences"

  def index
    @conferences = Conference.find(:all, :order => 'start_date')
    if @conferences
      if params[:id]
        @current_conference = Conference.find(params[:id])
      else
        #!! should default to _next_ conference, not first
        @current_conference = @conferences[0]
      end
    else
      @conferences = Array.new
    end
  end

  def help
    if params[:con_id]
      @current_conference = Conference.find(params[:con_id])
    end
  end

end
