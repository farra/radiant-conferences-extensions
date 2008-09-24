class CreateTagsPresentations < ActiveRecord::Migration
  def self.up
    create_table :tags_presentations do |t|
      t.integer :tag_id
      t.integer :presentation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tags_presentations
  end
end
