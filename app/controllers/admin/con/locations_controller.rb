class Admin::Con::LocationsController < ApplicationController

  layout "configuration"

  active_scaffold :location do |config|
    config.list.columns = [:name, :description]
    config.create.columns = [:name, :description]
    config.update.columns = [:name, :description]
    config.subform.columns = [:name, :description]
  end

end
