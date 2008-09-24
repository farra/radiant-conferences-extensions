class RefactorRoles < ActiveRecord::Migration
  def self.up
    drop_table :roles
    drop_table :presentation_capacities
    drop_table :capacities

    sqlite_version = <<SQL
CREATE VIEW 'conference_roles' AS
 select "2" || tracks.conference_id || presentations.presenter_id || scheduled_sessions.id as id,
        tracks.conference_id as conference_id, presentations.presenter_id as person_id,
        scheduled_sessions.id as event_id , "scheduled_session" as event_type
 from tracks, scheduled_sessions, submissions, presentations
 where
   tracks.id = scheduled_sessions.track_id
   and scheduled_sessions.submission_id  = submissions.id
   and submissions.presentation_id = presentations.id
 UNION
 select "3" || activities.conference_id || activities.person_id || activities.id as id,
        activities.conference_id as conference_id, activities.person_id as person_id,
        activities.id as event_id, "activity" as event_type
   from activities
 UNION
 select "4" || tracks.conference_id || panel_members.person_id || scheduled_sessions.id as id,
        tracks.conference_id as conference_id, panel_members.person_id as person_id,
        scheduled_sessions.id as event_id, "panel_member" as event_type
 from tracks, scheduled_sessions, submissions, panel_members, people
 where
   tracks.id = scheduled_sessions.track_id
   and scheduled_sessions.submission_id  = submissions.id
   and panel_members.submission_id = submissions.id
SQL

    mysql_version = <<SQL
CREATE VIEW conference_roles AS
 select CONCAT('2',tracks.conference_id,presentations.presenter_id,scheduled_sessions.id) as id,
        tracks.conference_id as conference_id, presentations.presenter_id as person_id,
        scheduled_sessions.id as event_id , "scheduled_session" as event_type
 from tracks, scheduled_sessions, submissions, presentations
 where
   tracks.id = scheduled_sessions.track_id
   and scheduled_sessions.submission_id  = submissions.id
   and submissions.presentation_id = presentations.id
 UNION
 select CONCAT('3', activities.conference_id, activities.person_id, activities.id) as id,
        activities.conference_id as conference_id, activities.person_id as person_id,
        activities.id as event_id, "activity" as event_type
   from activities
 UNION
A select CONCAT("4",tracks.conference_id,panel_members.person_id,scheduled_sessions.id) as id,
        tracks.conference_id as conference_id, panel_members.person_id as person_id,
        scheduled_sessions.id as event_id, "panel_member" as event_type
 from tracks, scheduled_sessions, submissions, panel_members, people
 where
   tracks.id = scheduled_sessions.track_id
   and scheduled_sessions.submission_id  = submissions.id
   and panel_members.submission_id = submissions.id
SQL

    #!! TODO really shouldn't hardcode this...


    execute mysql_version

  end

  def self.down

  end
end
