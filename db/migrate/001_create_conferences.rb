class CreateConferences < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :venue_id
      t.text :description
      t.string :host

      t.timestamps
    end
  end

  def self.down
    drop_table :conferences
  end
end
