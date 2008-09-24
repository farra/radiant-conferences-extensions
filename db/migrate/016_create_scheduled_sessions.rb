class CreateScheduledSessions < ActiveRecord::Migration
  def self.up
    create_table :scheduled_sessions do |t|
      t.integer :presentation_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :track_id

      t.timestamps
    end
  end

  def self.down
    drop_table :scheduled_sessions
  end
end
