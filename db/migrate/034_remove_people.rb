class RemovePeople < ActiveRecord::Migration
  
  def self.up
    populate_users(Presentation)
    populate_users(Activity)
    populate_users(PanelMember)
    
    remove_column :users, :person_id
    remove_column :activities, :person_id
    remove_column :panel_members, :person_id
    remove_column :presentation, :person_id
        
    drop_table :people    

    puts "recreating conference_roles view..."

    execute "DROP VIEW conference_roles"
    
    mysql_version = <<SQL

CREATE VIEW `conference_roles` AS select concat(_latin1'2',`apachecon_production`.`tracks`.`conference_id`,`apachecon_production`.`presentations`.`presenter_id`,`apachecon_production`.`scheduled_sessions`.`id`) AS `id`,`apachecon_production`.`tracks`.`conference_id` AS `conference_id`,`apachecon_production`.`presentations`.`presenter_id` AS `presenter_id`,`apachecon_production`.`scheduled_sessions`.`id` AS `event_id`,_latin1'scheduled_session' AS `event_type` from (((`tracks` join `scheduled_sessions`) join `submissions`) join `presentations`) where ((`apachecon_production`.`tracks`.`id` = `apachecon_production`.`scheduled_sessions`.`track_id`) and (`apachecon_production`.`scheduled_sessions`.`submission_id` = `apachecon_production`.`submissions`.`id`) and (`apachecon_production`.`submissions`.`presentation_id` = `apachecon_production`.`presentations`.`id`)) 
union select concat(_latin1'3',`apachecon_production`.`activities`.`conference_id`,`apachecon_production`.`activities`.`presenter_id`,`apachecon_production`.`activities`.`id`) AS `id`,`apachecon_production`.`activities`.`conference_id` AS `conference_id`,`apachecon_production`.`activities`.`presenter_id` AS `presenter_id`,`apachecon_production`.`activities`.`id` AS `event_id`,_latin1'activity' AS `event_type` from `activities` 
union select concat(_latin1'4',`apachecon_production`.`tracks`.`conference_id`,`apachecon_production`.`panel_members`.`presenter_id`,`apachecon_production`.`scheduled_sessions`.`id`) AS `id`,`apachecon_production`.`tracks`.`conference_id` AS `conference_id`,`apachecon_production`.`panel_members`.`presenter_id` AS `presenter_id`,`apachecon_production`.`scheduled_sessions`.`id` AS `event_id`,_latin1'panel_member' AS `event_type` from ((((`tracks` join `scheduled_sessions`) join `submissions`) join `panel_members`) join `users`) where ((`apachecon_production`.`tracks`.`id` = `apachecon_production`.`scheduled_sessions`.`track_id`) and (`apachecon_production`.`scheduled_sessions`.`submission_id` = `apachecon_production`.`submissions`.`id`) and (`apachecon_production`.`panel_members`.`submission_id` = `apachecon_production`.`submissions`.`id`))

SQL

     execute mysql_version
    
  end
  

  def self.populate_users(model)
    models = model.find(:all)
    models.each do | m |
      person_id = m.person_id
      if person_id
        user_id = Person.find(person_id).user_id
        puts "#{m.id} ; #{m.person_id} ; #{user_id}" 
        m.presenter_id = user_id
        m.person_id = nil
        m.save!        
      else
        puts "no person_id for #{m.to_s} : #{m.id}" unless person_id
      end
    end
  end    

  
end
