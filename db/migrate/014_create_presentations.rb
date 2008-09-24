class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      t.string   :name
      t.text     :description
      t.integer  :type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :presentations
  end
end
