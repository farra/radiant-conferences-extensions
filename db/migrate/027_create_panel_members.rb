class CreatePanelMembers < ActiveRecord::Migration
  def self.up
    create_table :panel_members do |t|
      t.integer :person_id
      t.integer :presentation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :panel_members
  end
end
