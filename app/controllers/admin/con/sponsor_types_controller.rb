class Admin::Con::SponsorTypesController < ApplicationController

  layout "configuration"

  active_scaffold :sponsor_type do | config |
    config.list.columns = [:name]
    config.show.columns = [:name]
    config.create.columns = [:name]
    config.update.columns = [:name]
  end

end
