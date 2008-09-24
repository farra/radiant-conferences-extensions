require File.dirname(__FILE__) + '/../../../spec_helper'

describe Admin::Con::LocationsHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the Admin::Con::LocationsHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(Admin::Con::LocationsHelper)
  end
  
end
