class RefactorTables < ActiveRecord::Migration
  def self.up
    add_column :presentations, :duration, :integer
    add_column :presentations, :materials, :string
    add_column :submissions, :comments, :text

    remove_column :sponsor_types, :rank
    remove_column :sponsor_classes, :sponsor_type_id
    rename_column :sponsors, :sponsor_class_id, :sponsor_level_id
    rename_table :sponsor_classes, :sponsor_levels

    change_column :conferences, :start_date, :date
    change_column :conferences, :end_date, :date

    change_column :scheduled_sessions, :start_time, :time
    change_column :scheduled_sessions, :end_time, :time

  end

  def self.down

  end
end
