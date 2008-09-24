class Admin::Con::SponsorsController  <  Admin::Con::CurrentConferenceController

  active_scaffold :sponsors do |config|
    config.list.columns = [:conference, :organization, :sponsor_type, :sponsor_level]
    config.create.columns = [:conference, :organization, :sponsor_type, :sponsor_level]
    config.update.columns = [:conference, :organization, :sponsor_type, :sponsor_level]
    config.show.columns = [:conference, :organization, :sponsor_type, :sponsor_level]
    config.list.sorting = { :sponsor_type => :desc }, { :sponsor_level => :desc }
    config.nested.add_link("Edit Organization", [:organization])
    config.columns[:conference].ui_type = :select
    config.columns[:sponsor_type].ui_type = :select
    config.columns[:sponsor_level].ui_type = :select
  end

  def do_new
    @record = Sponsor.new
    apply_constraints_to_record(@record)
    if @current_conference
      @record.conference = @current_conference
    end
  end

end
