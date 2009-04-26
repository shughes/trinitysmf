class UploadController < ApplicationController
  before_filter :authorize 
  
  def get
    @resume = Resume.new
  end
  
  def save
    @user = User.find(session[:user_id])
    @resume = Resume.new(params[:resume])
    if @resume.save
      @user.resume = @resume
      flash[:notice] = "New resume successfully uploaded."
      redirect_to(:controller => 'account', :action => 'edit')
    else 
      render(:action => :get)
    end
  end
  
  def resume
    @resume = Resume.find(params[:id])
    requests = Request.find(:all, 
      :conditions => ["viewer_id = ? and user_id = ? and "+
      "request_accepted = '1'", session[:user_id], params[:id]])

    if @resume.public == '1' or (requests.length > 0)
      send_data(@resume.data, 
        :filename => @resume.name, 
        :type => @resume.content_type,
        :disposition => "inline")
    end
  end
  
  def show
    @resume = Resume.find(params[:id])
  end
end
