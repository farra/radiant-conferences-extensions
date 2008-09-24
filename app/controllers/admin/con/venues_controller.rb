class Admin::Con::VenuesController < ApplicationController

  layout "configuration"

  active_scaffold :venue do |config|
    config.list.columns = [:name, :locations, :conferences]
    config.show.columns = [:name, :address, :description, :conferences, :locations]
    config.create.columns = [:name, :address, :description, :locations]
    config.update.columns = [:name, :address, :description, :locations]
  end

end
