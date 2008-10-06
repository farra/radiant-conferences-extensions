class AddSubmissionNotificationToConference < ActiveRecord::Migration
  def self.up
    add_column :conferences, :submission_notification_email, :string
  end
  
  def self.down
    remove_column :conferences, :submission_notification_email
  end
end