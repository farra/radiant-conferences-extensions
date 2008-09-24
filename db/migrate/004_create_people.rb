class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :url
      t.string :photo
      t.text :bio
      t.integer :user_id

      t.timestamps
    end

    add_column :users, :person_id, :integer

  end

  def self.down
    drop_table :people
  end
end
