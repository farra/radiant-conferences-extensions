class UpdateConferences < ActiveRecord::Migration
  def self.up
    remove_column :conferences, :host
    add_column :conferences, :short_name, :string
  end

  def self.down

  end
end
