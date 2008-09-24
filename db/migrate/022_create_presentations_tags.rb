class CreatePresentationsTags < ActiveRecord::Migration
  def self.up
    create_table :presentations_tags do |t|
      t.integer :presentation_id
      t.integer :tag_id

      t.timestamps
    end
    drop_table :tags_presentations
  end

  def self.down
    drop_table :presentations_tags
  end
end
