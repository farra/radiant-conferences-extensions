class ScheduleDayPage < Page
  include ScheduleTags

  before_validation {|r| r.virtual = true }

  def virtual?
    true
  end

  def render
    lazy_initialize_parser_and_context
    year, month, day = $1, $2, $3 if request_uri =~  %r{#{parent.url}(\d{4})/(\d{2})/(\d{2})$}
    @context.globals.schedule_date = Date.new(year.to_i,month.to_i,day.to_i)
    super
  end


end
