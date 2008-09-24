class Admin::Con::ConferencesController < ApplicationController

  layout "configuration"

  active_scaffold :conferences do | config |
    columns = [ :name, :short_name, :start_date, :end_date, :time_zone,
                :tagline, :description, :logo, :registration_link,
                :community_link, :wiki_link, :mailing_list, :mailing_list_link,
                :registration_open, :cfp_open, :venue]
    config.list.columns = [ :name, :short_name, :start_date, :end_date, :venue]
    config.create.columns = columns
    config.update.columns = columns
    config.show.columns = columns
  end

end
