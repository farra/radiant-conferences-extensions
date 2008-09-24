class CreatePresenters < ActiveRecord::Migration
  def self.up
    create_table :presenters do |t|
      t.integer :person_id
      t.integer :presentation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :presenters
  end
end
