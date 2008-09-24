class CreateSponsorClasses < ActiveRecord::Migration
  def self.up
    create_table :sponsor_classes do |t|
      t.string :name
      t.integer :sponsor_type_id
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsor_classes
  end
end
