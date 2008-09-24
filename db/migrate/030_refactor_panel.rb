class RefactorPanel < ActiveRecord::Migration
  def self.up
    rename_column :panel_members, :presentation_id, :submission_id
  end

  def self.down

  end
end
