class RequestController < ApplicationController
  layout 'account'
  before_filter :authorize

  def accept_request
    # send viewer info they requested
    @r_request = Request.find(params[:id])
    @user = User.find(@r_request.viewer_id)
    if request.get?
    else
      @r_request.request_accepted = true
      @r_request.save
      flash[:notice] = "A link to your resume sent to #{@user.first_name} #{@user.last_name}"
      redirect_to :controller => 'account', :action => 'show', :id => session[:user_id]
    end
  end
  
  def drop_request
  end

  def send_request
    if request.get?
      @user = User.find(params[:id])
    else
      @user = User.find(params[:id])
      r_request = Request.new
      r_request.viewer_id = session[:user_id]
      r_request.date_requested = Date.today
      @user.requests << r_request
      @user.save 
      flash[:notice] = "Request for resume sent."
      redirect_to :controller => 'account', :action => 'show', :id => params[:id]
    end
  end

  def view_requests
    @user = User.find(session[:user_id])
    @requests = Request.find(:all, 
                             :conditions => ["request_accepted != '1' and user_id = ?", @user.id])
  end
end
