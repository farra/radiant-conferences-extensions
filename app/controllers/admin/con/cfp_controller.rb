class Admin::Con::CfpController < ApplicationController
  
  layout "cfp"  

  def index
    # need to redo this
    # because we aren't getting conferences to which the person hasn't submitted anything
    # so need to do that query and merge
    
    @conferences = Conference.find(:all, :order => 'conferences.start_date DESC')

    @submissions = Submission.find(:all, :include => [:presentation, :conference],
                                   :conditions => ['presentations.presenter_id = ?',current_user.id]
                                   )
    
    @submissions_per_conference = @conferences.collect do | c |
     [c, @submissions.select{|s| s.conference_id == c.id}]
    end
            
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @submissions }
    end
  end
    
  def show
    @submission = Submission.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @submission }
    end
  end
  
  def new   
    @submission = Submission.new
    @submission.presentation = Presentation.new
    @presentations = Presentation.find(:all,
                                       :conditions => ['presentations.presenter_id = ?',current_user.id])
    
    if params[:cid]
      @submission.conference_id = params[:cid]      
    end
    @submission.presentation.presenter_id = current_user.id
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @submission }
    end
  end
  
  def edit
    @submission = Submission.find(params[:id])
  end
  
  def create
    @submission = Submission.new(params[:submission])
  
    respond_to do |format|
      if @submission.save
        flash[:notice] = 'Presentation was successfully created.'
        format.html { redirect_to :action => :index }
        format.xml  { render :xml => @submission, :status => :created, :location => @submission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @submission.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @submission = Submission.find(params[:submission][:id])
  
    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        @submission.presentation.save
        flash[:notice] = 'Presentation was successfully updated.'
        format.html { redirect_to :action => :index }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @submission.errors, :status => :unprocessable_entity }
      end
    end
  end
  
#   def destroy
#     @presentation = Presentation.find(params[:id])
#     @presentation.destroy
  
#     respond_to do |format|
#       format.html { redirect_to(admin_presentations_url) }
#       format.xml  { head :ok }
#     end
#   end  
  
end
