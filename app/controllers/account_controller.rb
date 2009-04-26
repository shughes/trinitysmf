require 'mini_magick.rb'

class AccountController < ApplicationController
	before_filter :authorize

	def did_you_notice
		flash[:notice] = 'Samuel Hughes did.'
		redirect_to :action => 'show', :id => 1
	end

	def index 
		params[:id] = User.find(:first, session[:user_id]).id
		show
		render :action => 'show', :id => params[:id]
	end 


    def home 
        @messages = Message.find(:all, 
        :conditions => ["user_id = ? and has_read = 0 and sent_folder = 0", 
        session[:user_id]], :order => 'date_sent DESC, id DESC')

        @user = User.find(session[:user_id].to_i)
        @resume_users = ResumeViewer.find(:all, 
        :conditions => ["viewer_id = ? and viewed = 0", @user.id],
        :order => 'date_sent DESC, id DESC')
        @updates = Update.find_by_sql("select * from updates where update_type='announcement' order by date_sent desc limit 10")
        @jobs = Update.find_by_sql("select * from updates where update_type='job announcement' order by date_sent desc limit 10")
        @tips = Update.find_by_sql("select * from updates where update_type='stock' order by date_sent desc limit 10")
    end 

    def list
        @user_pages, @users = paginate :users, :per_page => 10
    end

    def show
        @user = User.find(params[:id])
        @person_name = "#{@user.first_name} #{@user.last_name}"
        @profile_messages = Update.find(:all, 
        :conditions => ["user_id = ? and update_type = 'wall post'", params[:id]])
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(params[:user])
        if @user.save
            flash[:notice] = 'User successfully created.'
            redirect_to :action => 'list'
        else
            render :action => 'new'
        end
    end

    def edit
        @user = User.find(session[:user_id])
        @resume = @user.resume
    end

    def delete_profile_message
        update = Update.find(params[:id])
        user_id = update.user_id

        if update.viewer_id == session[:user_id] or update.user_id == session[:user_id]
            Update.delete(params[:id])
        else 
            flash[:notice] = "You may not delete this message"
        end

        redirect_to :action => 'show', :id => user_id
    end

    def profile_message_update
        @update = Update.new(params[:update])
        @update.update_type = "wall post"
        @update.viewer_id = session[:user_id].to_i
        @update.date_sent = Date.today
        @update.save
        redirect_to :action => 'show', :id => @update.user_id
    end

    def update
        @user = User.find(session[:user_id])
        if @user.update_attributes(params[:user])
            if @user.resume
                @user.resume.update_attributes(params[:resume])
            end
            @user.last_updated = Date.today
            @user.save

            flash[:notice] = 'User successfully updated.'
            redirect_to :action => 'show', :id => @user
        else
            render :action => 'edit'
        end
    end

    def destroy
        User.find(params[:id]).destroy
        redirect_to :action => 'list'
    end

    def search_form
    end

    def search
        case params[:id]
        when "all_users" then
            @users = User.find(:all, :conditions => ["id > 0"], :order => 'last_name')
        when "grad_school" then
            @users = User.find_all_by_grad_school(params[:search_one])
        when "rec_updated" then
            date = Date.today - 7
            @users = User.find(:all, :conditions => ["last_updated > ?", date], :order => 'last_name')
        when "name" then
            @users = User.find(:all, :conditions => ["first_name = '#{params[:search_one]}' "+
            "and last_name = '#{params[:search_two]}'"], :order => 'last_name')
        when "email" then
            @users = User.find_all_by_email(params[:search_one])
        when "address" then
            @users = User.find_all_by_address(params[:search_one])
        when "city" then
            @users = User.find_all_by_city(params[:search_one])
        when "state" then
            @users = User.find_all_by_state(params[:search_one])
        when "graduation_year" then
            @users = User.find_all_by_graduation_year(params[:search_one])
        when "employer" then
            @users = User.find_all_by_employer(params[:search_one])
        when "previous_employer" then
            @users = User.find_all_by_previous_employer(params[:search_one])
        when "employment_status" then
            @users = User.find_all_by_employment_status(params[:search_one])
        when "job_title" then
            @users = User.find_all_by_job_title(params[:search_one])
        when "job_description" then
            @users = User.find_all_by_job_description(params[:search_one])
        when "mobile_phone" then
            @users = User.find_all_by_mobile_phone(params[:search_one])
        when "major" then
            @users = User.find_all_by_major(params[:search_one])
        end
    end

    def show_picture
        @user = User.find(params[:id])
        send_data(@user.picture, :disposition => "inline")
    end

    def upload_picture
        @user = User.find(session[:user_id])
        if @user.update_attributes(params[:user])
            flash[:notice] = "New resume successfully uploaded."
            redirect_to(:controller => 'account', :action => 'edit')
        else
            render(:action => :get)
        end
    end

end
