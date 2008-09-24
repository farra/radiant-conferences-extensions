class MigratePeople < ActiveRecord::Migration
  
  def self.up
    people = Person.find(:all)
    people.each do | person |
      if person.user
        user = person.user
        user.name = person.name
        user.email = person.email ? person.email : 'info@apachecon.com'
        user.notes = person.bio
        user.url = person.url
        user.login = person.name.downcase.gsub(/ /,'')        
        user.password = 'conference_speaker'
        user.person = person
        user.save!
        person.user = user
        person.save!
        puts "#{user.name};#{user.email};#{user.login}"         
      else
        user = User.new
        user.name = person.name
        user.email = person.email ? person.email : 'info@apachecon.com'
        user.notes = person.bio
        user.login = person.name.downcase.gsub(/ /,'')
        user.password = 'conference_speaker'
        user.password_confirmation = 'conference_speaker'
        user.person = person
        user.save!
        person.user = user
        person.save!        
        puts "#{user.name};#{user.email};#{user.login}"                      
      end
    end

    add_column   :activities, :presenter_id, :integer
    add_column   :panel_members, :presenter_id, :integer
    rename_column :presentations, :presenter_id, :person_id
    add_column   :presentations, :presenter_id, :integer
  end    

  
  def self.down

  end
  
end
