class UpdatePeople < ActiveRecord::Migration
  def self.up

    add_column :people, :name, :string
    add_column :people, :email, :string

  end

  def self.down

  end
end
