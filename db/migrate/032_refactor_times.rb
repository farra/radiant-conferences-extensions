class RefactorTimes < ActiveRecord::Migration

  def self.up
   change_column :scheduled_sessions, :start_time, :datetime
   change_column :scheduled_sessions, :end_time, :datetime

   add_column :conferences, :time_zone, :string

  end

  def self.down
    change_column :scheduled_sessions, :end_time, :time
    change_column :scheduled_sessions, :start_time, :time

    remove_column :conferences, :time_zone
  end

end
