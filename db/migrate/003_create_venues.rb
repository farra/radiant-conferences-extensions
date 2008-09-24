class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name
      t.text :address
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end
