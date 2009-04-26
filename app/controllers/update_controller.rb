class UpdateController < ApplicationController
	layout 'account'
	before_filter :authorize 

	def delete
		@user = User.find(session[:user_id])
		@update = Update.find(params[:id])
		if @user.id != @update.user_id
			flash[:notice] = "Error editing update"
		else
			Update.delete ["id = ?", params[:id]]
			flash[:notice] = "Announcement successfully edited"
		end
		redirect_to :action => 'index'
	end

	def edit
		@user = User.find(session[:user_id])
		@update = Update.find(params[:id])
		if @user.id != @update.user_id
			flash[:notice] = "Error editing update"
			redirect_to :action => 'index'
		end

		if request.post?
			temp_update = Update.new(params[:update])
			@update.update_attributes(:subject => temp_update[:subject],
			:message => temp_update[:message])
			
			flash[:notice] = "Announcement successfully edited"
			redirect_to :action => 'index'
		end
	end

	def index
		@updates = Update.find(:all, :conditions => ["id > 0 and update_type = 'announcement'"],
		:order => 'date_sent DESC, id DESC')
	end

	def post
		@user = User.find(session[:user_id])
		@update = Update.new

		if request.post?
			@update = Update.new(params[:update])
			@update.date_sent = Date.today
			@update.update_type = "announcement"
			@update.user = @user
			if @update.save
				flash[:notice] = "Announcement successfully posted"
				redirect_to :action => 'index'
			end
		end
	end

	def read
		@update = Update.find(params[:id])
	end

end
