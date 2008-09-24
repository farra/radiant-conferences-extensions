class Admin::Con::OrganizationsController < ApplicationController

  layout "configuration"

  active_scaffold :organizations do |config|
    config.list.columns = [:name, :url]
    config.create.columns = [:name, :url, :logo, :description, :sponsors]
    config.update.columns = [:name, :url, :logo, :description, :sponsors]
    config.show.columns = [:name, :url, :logo, :description, :sponsors]
  end

end
