class Admin::Con::SubmissionsController < Admin::Con::CurrentConferenceController

  active_scaffold :submissions do | config |
    config.list.columns = [:presentation, :presenter, :scheduled_sessions, :accepted]
    config.create.columns = [:presentation, :accepted, :votes, :score, :panel_members, :conference]    
    config.update.columns = [:presentation, :scheduled_sessions, :panel_members, :accepted, :votes, :score, :agreement_form_received]
    config.show.columns = [:presentation, :accepted, :votes, :score, :panel_members, :scheduled_sessions, :conference]
    config.subform.columns = [:presentation, :conference]
    
    config.columns[:agreement_form_received].ui_type = :checkbox
    config.columns[:conference].ui_type = :select
    config.nested.add_link("Schedule", [:scheduled_sessions])

    config.columns[:presentation].search_sql = 'presentations.name'
    config.search.columns << :presentation
  end

  def conditions_for_collection
    if @current_conference
      ids = @current_conference.submissions.collect{|p| p.id }
      if ids.size > 0
        return ['submissions.id in (?)', ids]
      else
        return [ ]
      end
    end
  end

  def do_new
    @record = Submission.new
    apply_constraints_to_record(@record)
    if @current_conference
      @record.conference = @current_conference
    end
  end

  def report
    @conference = Conference.find(params[:con_id])
    @submissions = @conference.submissions
    respond_to do |format|
      format.html { render :layout => 'report' }
      format.csv { send_data Submission.to_csv(@submissions), :filename => "#{@conference.short_name}-submissions.csv", :type => 'text/csv' }
    end
  end
end
