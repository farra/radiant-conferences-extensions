class SchedulePage < Page
  include ScheduleTags


  def find_by_url(url, live = true, clean = false)
    url = clean_url(url) if clean
    if url =~ %r{^#{ self.url }(\d{4})(?:/(\d{2})(?:/(\d{2}))?)?/?$}
      year, month, day = $1, $2, $3
      children.find_by_class_name(
        case
        when day
          'ScheduleDayPage'
        when month
          'ScheduleMonthPage'
        else
          'ScheduleYearPage'
        end
      )
    else
      super
    end
  end



end
