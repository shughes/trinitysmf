# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

   def authorize
      unless session[:user_id]
         flash[:notice] = "Please log in"
         session[:jumpto] = request.parameters
         redirect_to(:controller => "login", :action => "login")
      end
   end

   def admin_authorize
      if !session[:user_id]
         flash[:notice] = "Please log in"
         session[:jumpto] = request.parameters
         redirect_to(:controller => "login", :action => "login")
      else
         user = User.find(session[:user_id])
         unless user.privilege > 0
            flash[:notice] = "You do not have permission to view."
            session[:jumpto] = request.parameters
            redirect_to(:controller => "account", :action => "home")
         end
      end
   end

   private

   def redirect_to_index(msg = nil)
      flash[:notice] = msg if msg
      redirect_to(:action => 'index')
   end
end
