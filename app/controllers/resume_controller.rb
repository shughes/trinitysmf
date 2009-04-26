class ResumeController < ApplicationController
	layout 'account'
	before_filter :authorize 

	def get
		@resume = Resume.new
	end

	def clean_up 
		resumes = Resume.find(:all, :conditions => ["id > 0"])
		resumes.each {|resume|
			if !resume.user_id
				Resume.delete ["id = ?", resume.id]
			end
		}
	end

	def delete_resume_link
		@viewer = ResumeViewer.find(:first, :conditions => ["id = ? and viewer_id = ?", 
		params[:id], session[:user_id].to_i])
		@user = User.find(session[:user_id].to_i)
		if !@viewer
			redirect_to :action => 'resumes'
			flash[:notice] = "You do not have permission to delete this resume." 
		elsif request.post?
			ResumeViewer.delete ["user_id = ?", params[:id]]
			redirect_to :action => 'resumes'
			flash[:notice] = "Link to resume successfully deleted."
		end
	end

	def resumes
		@resume_users = ResumeViewer.find(:all, 
		:conditions => ["viewer_id = ?", session[:user_id]],
		:order => 'date_sent DESC, id DESC')
	end

	def send_resume
		@user = User.find(params[:id])
		@from_user = User.find(session[:user_id])
		if request.post?
			@viewer = ResumeViewer.new()
			@viewer.viewer_id = @user.id
			@viewer.date_sent = Date.today
			@viewer.user_id = session[:user_id]

			if @from_user.resume
				if @viewer.save
					flash[:notice] = "Resume sent successfully"
					redirect_to :controller => "account", :action => "home"
				end
			else
				flash[:notice] = "Resume was unable to send. Be sure you have a resume uploaded in your profile."
				redirect_to :controller => "account", :action => "home"
			end
		end
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

	def open_resume_link
		viewer = ResumeViewer.find(:first, :conditions => ["id = ? and viewer_id = ?", 
		params[:id], session[:user_id].to_i])
		viewer.viewed = 1
		viewer.save
		params[:id] = viewer.user.resume.id
		resume
	end

	def resume
		@resume = Resume.find(params[:id])
		viewer = ResumeViewer.find(:first, 
		:conditions => ["user_id = ? and viewer_id = ?", 
		@resume.user.id, session[:user_id].to_i])
		if @resume.public == '1' or viewer
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
