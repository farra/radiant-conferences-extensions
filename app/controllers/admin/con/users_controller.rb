class Admin::Con::UsersController <  ApplicationController

  layout "configuration"

  active_scaffold :user do | config |
    config.columns.exclude :login, :password, :admin, :developer, :salt, :lock_versino
    config.list.columns = [:name, :email]
    config.update.columns = [:name, :email, :url, :photo, :notes]
    config.create.columns = [:name, :email, :url, :photo, :notes]
    config.show.columns = [:name, :email, :url, :photo, :notes, :conference_roles, :presentations, :submissions]
  end

end
