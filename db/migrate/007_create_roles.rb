class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :conference_id
      t.integer :person_id
      t.integer :capacity_id

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
