class Admin::Con::UsersController <  ApplicationController

  layout "configuration"

  active_scaffold :user do | config |
    config.columns.exclude :login, :password, :admin, :developer, :salt, :lock_version
    config.list.columns = [:name, :email]
    config.update.columns = [:name, :email, :url, :photo, :login, :password, :password_confirmation, :notes]
    config.create.columns = [:name, :email, :url, :photo, :login, :password, :password_confirmation, :notes]
    config.show.columns = [:name, :login, :email, :url, :photo, :notes, :conference_roles]
  end

end
