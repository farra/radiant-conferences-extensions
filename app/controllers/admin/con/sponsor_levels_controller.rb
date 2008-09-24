class Admin::Con::SponsorLevelsController < ApplicationController

  layout "configuration"

  active_scaffold :sponsor_levels do | config |
    config.list.columns = [:name, :rank]
    config.list.sorting = { :rank => :asc }
    config.update.columns = [:name, :rank]
    config.create.columns = [:name, :rank]
    config.show.columns = [:name, :rank]
  end

end
