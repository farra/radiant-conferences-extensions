class RefactorSchedule < ActiveRecord::Migration
  def self.up

    add_column :presentations, :presenter_id, :integer

#     presenters = Presenter.find(:all)
#     presenters.each do |presenter|
#       presenter.presentation.presenter = presenter.person
#       presenter.presentation.save
#       presenter.save
#    end

    remove_column :scheduled_sessions, :presentation_id
    add_column :scheduled_sessions, :submission_id, :integer

    remove_column :submissions, :reviewed
    drop_table :presenters

  end

  def self.down

  end
end
