module Admin::Con::DescriptionColumnHelper

 def description_column(record)
   sanitize(record.description)
 end


end
