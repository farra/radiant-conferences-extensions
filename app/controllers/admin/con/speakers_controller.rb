class Admin::Con::SpeakersController <  Admin::Con::CurrentConferenceController

  active_scaffold :user do | config |
    config.columns.exclude :login, :password, :admin, :developer, :salt, :lock_version
    config.list.columns = [:name, :email]
    config.update.columns = [:name, :email, :url, :photo, :login, :password, :password_confirmation, :notes]
    config.create.columns = [:name, :email, :url, :photo, :login, :password, :password_confirmation, :notes ]
    config.show.columns = [:name, :email, :url, :photo, :login, :notes]  
  end

  def conditions_for_collection
    people_ids = @current_conference.presenters.collect{|p| p.id }
    ['id in (?)', people_ids]
  end

end
