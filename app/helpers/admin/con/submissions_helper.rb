module Admin::Con::SubmissionsHelper
  include Admin::Con::DescriptionColumnHelper
  
   def scheduled_sessions_column(record)
     sessions = []
     if record.scheduled_sessions
       record.scheduled_sessions.each do |session|
         track = session.track
         start = session.start_time_local
         sessions << h("#{start.to_formatted_s(:time)} on #{track.date.to_formatted_s(:short)} in #{track.name}")               
       end
     end
     return sessions.join(', ')
   end
   
 
   
end
