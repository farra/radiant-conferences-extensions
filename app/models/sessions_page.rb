class SessionsPage < Page
  include SessionTags

  def find_by_url(url, live=true,clean=false)
    url = clean_url(url) if clean
    if url =~ %r{#{self.url}(\w+)}
      prefix = $1
      children.find_by_class_name 'SessionPage'
    else
      super
    end
  end


end
