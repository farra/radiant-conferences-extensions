class Admin::Con::SpeakersController <  Admin::Con::CurrentConferenceController

  active_scaffold :user do | config |
    config.columns.exclude :login, :password, :admin, :developer, :salt, :lock_versino
    config.list.columns = [:name, :email]
    config.update.columns = [:name, :email, :url, :photo, :notes]
    config.create.columns = [:name, :email, :url, :photo, :notes]
    config.show.columns = [:name, :email, :url, :photo, :notes]  
  end

  def conditions_for_collection
    people_ids = @current_conference.presenters.collect{|p| p.id }
    ['id in (?)', people_ids]
  end

end
