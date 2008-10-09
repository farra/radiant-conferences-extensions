class AddAgreementFormReceivedToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :agreement_form_received, :boolean, :default => false
  end
  
  def self.down
    remove_column :submissions, :agreement_form_received
  end
end