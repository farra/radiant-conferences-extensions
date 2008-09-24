class SponsorsPage < Page
  include ConferenceTags


  def find_by_url(url, live=true,clean=false)
    url = clean_url(url) if clean
    if url =~ %r{#{self.url}(\w+)}
      prefix = $1
      children.find_by_class_name 'SponsorTypePage'
    else
      super
    end
  end

  private
    def request_uri
      request.request_uri unless request.nil?
    end

   def get_conference_from_url
     m = request_uri.match /^\/([^\/]*)\/.*$/
     m[1] if m
   end

end
