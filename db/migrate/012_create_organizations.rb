class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :url
      t.text   :description
      t.string :logo

      t.timestamps
    end

    remove_column :sponsors, :person_id
    add_column :sponsors, :organization_id, :integer

  end

  def self.down
    drop_table :organizations
    add_column :sponsors, :person_id, :integer
    remove_column :sponsors, :organization_id
  end
end
