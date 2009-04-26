class LoginController < ApplicationController
  before_filter :authorize, :except => [:login, :add_user]
  
  def index
    redirect_to :action => 'login'
  end

  def add_user
    if request.get?
      @user = User.new
      flash[:notice] = "Register a new user name."
    else
      @user = User.new(params[:user])
      if @user.save
        redirect_to_index("User #{@user.email} created")
      end
    end
  end

  def login
    if request.get?
      session[:user_id] = nil
			@user = User.new
    else
      @user = User.new(params[:user])
      logged_in_user = @user.try_to_login
      
      if logged_in_user
        session[:user_id] = logged_in_user.id
        jumpto = session[:jumpto] || { :action => "index" }
        session[:jumpto] = nil
        redirect_to(:controller => 'account', :action => 'home')
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end

  def delete_user
    id = params[:id]
    if id && user = User.find(id)
      begin
        user.destroy
        flash[:notice] = "User #{user.name} deleted"
      rescue
        flash[:notice] = "Can't delete that user"
      end
    end
    redirect_to(:action => :list_users)
  end

  def list_users
  end
end
