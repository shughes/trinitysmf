class MessageController < ApplicationController
	layout 'account'
	before_filter :authorize

	def compose
		@user = User.find(session[:user_id])
		if params[:id]
			@to_user = User.find(params[:id])
			@to_name = "#{@to_user.first_name} #{@to_user.last_name}"
		end
	end

	def clean_up
		Message.delete_all "from_deleted = 1 and user_deleted = 1"
	end
	
	def delete 
		@message = Message.find(params[:id])
		@from_user = User.find(@message.from_id)
		if request.post?
			if params[:sent_folder].to_i == 1
				if @message.from_id != session[:user_id].to_i
					flash[:notice] = 'There was an error deleting requested message.'
					redirect_to :action => 'inbox'
				else
					@message.has_read_sent = 1
					@message.from_deleted = 1

					if @message.save 
						flash[:notice] = "Message successfully deleted."
						redirect_to :action => 'sent'
					end
				end
			else
				if @message.user_id != session[:user_id].to_i
					flash[:notice] = 'There was an error deleting requested message.'
					redirect_to :action => 'inbox'
				else
					@message.has_read = 1
					@message.user_deleted = 1

					if @message.save 
						flash[:notice] = "Message successfully deleted."
						redirect_to :action => 'inbox'
					end
				end
			end
		end
	end

	def home
	end

	def inbox
		@user = User.find(session[:user_id])
		@messages = Message.find(:all, 
		  :conditions => ["user_id = ? and user_deleted = 0", @user.id],
		  :order => 'date_sent DESC, id DESC')
	end

	def read
		@message = Message.find(params[:id])
		@from_user = User.find(@message.from_id)
		if params[:sent_folder].to_i == 1
			if @message.from_id != session[:user_id].to_i
				flash[:notice] = 'There was an error searching for requested message.'
				redirect_to :action => 'inbox'
			else
				@message.update_attribute(:has_read_sent, true)
			end
		else
			if @message.user_id != session[:user_id].to_i
				flash[:notice] = 'There was an error searching for requested message.'
				redirect_to :action => 'inbox'
			else
				@message.update_attribute(:has_read, true)
			end
		end
	end

	def send_message
		@message = Message.new(params[:message])
		@message.user_id = params[:id]
		@message.from_id = session[:user_id]
		@message.date_sent = Date.today
		if @message.subject == ''
		  @message.subject = '(no subject)'
	  end
    
		@message.save

		flash[:notice] = 'Message successfully sent.'
		redirect_to :action => 'inbox'
	end

	def sent
		@user = User.find(session[:user_id])
		@messages = Message.find(:all, :conditions => ["from_id = ? and from_deleted = 0", session[:user_id]])
	end

end
