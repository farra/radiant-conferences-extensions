class RefactorConferences < ActiveRecord::Migration
  def self.up

    add_column :conferences, :logo, :string
    add_column :conferences, :tagline, :string
    add_column :conferences, :registration_link, :string
    add_column :conferences, :community_link, :string
    add_column :conferences, :wiki_link, :string
    add_column :conferences, :mailing_list, :string
    add_column :conferences, :mailing_list_link, :string

    add_column :conferences, :registration_open, :boolean
    add_column :conferences, :cfp_open, :boolean

  end

  def self.down

  end
end
