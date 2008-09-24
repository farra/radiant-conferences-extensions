class SessionPage < Page
  include SessionTags

  before_validation {|r| r.virtual = true }

  def virtual?
    true
  end

  def render
    lazy_initialize_parser_and_context
   # @context.globals.scheduled_session = ScheduledSession.find(get_session_from_url)
    super
  end

end
