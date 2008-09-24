module Admin::Con::CfpHelper

  def options_for_association_conditions(association)
    if association.name == :conference
      ['conferences.cfp_open = ?',true]
    else
      super
    end
  end  

end
