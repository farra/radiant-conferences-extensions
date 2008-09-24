class Admin::Con::PresentationTypesController < ApplicationController

  layout "configuration"

  active_scaffold :presentation_type do |config|
    config.list.columns =  [ :name ]
    config.create.columns =  [:name]
    config.update.columns =  [:name]
    config.show.columns = [ :name ]
  end

end
