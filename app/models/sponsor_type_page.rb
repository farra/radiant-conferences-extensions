class SponsorTypePage < Page
  include ConferenceTags

  before_validation {|r| r.virtual = true }

  def virtual?
    true
  end

  def render
    lazy_initialize_parser_and_context
    type_name = get_type_from_url.singularize.humanize.titlecase
    @context.globals.sponsor_type = SponsorType.find_by_name(type_name)
    super
  end

  desc %{ Prints the name of the current sponsor type }
  tag "sponsor_type_name" do |tag|
    tag.globals.sponsor_type.name
  end

  private
    def request_uri
      request.request_uri unless request.nil?
    end

   def get_type_from_url
      $1 if request_uri =~ %r{#{parent.url}/?(\w+)/?$}
   end

end
