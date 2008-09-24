class CreateSponsorTypes < ActiveRecord::Migration
  def self.up
    create_table :sponsor_types do |t|
      t.string :name
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsor_types
  end
end
