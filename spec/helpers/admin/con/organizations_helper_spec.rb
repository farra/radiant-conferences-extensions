require File.dirname(__FILE__) + '/../../../spec_helper'

describe Admin::Con::OrganizationsHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the Admin::Con::OrganizationsHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(Admin::Con::OrganizationsHelper)
  end
  
end
