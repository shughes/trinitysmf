
class PictureController < ApplicationController
	layout 'account'
	before_filter :authorize 

	def get
		@picture = Picture.new
	end

	def delete
		if params[:id] == session[:user_id].to_s
			user = User.find(session[:user_id])
			picture = user.picture
			if picture
				Picture.delete ["id = ?", picture.id]
				flash[:notice] = "Picture successfully deleted."
			else
				flash[:notice] = "Picture could not be deleted."
			end
		else
			flash[:notice] = "Picture could not be deleted."
		end
		redirect_to :controller => 'account', :action => 'edit'
	end

	def clean_up 
		pictures = Picture.find(:all, :conditions => ["id > 0"])
		pictures.each { |picture|
			if !picture.user_id
				Picture.delete ["id = ?", picture.id]
			end
		}
	end

	def save
		@user = User.find(session[:user_id])
		@picture = Picture.new(params[:picture])
		if @picture.save
			@user.picture = @picture
			flash[:notice] = "New picture successfully uploaded."
			redirect_to(:controller => 'account', :action => 'edit')
		else
			flash[:notice] = "Picture not proper format."
			redirect_to(:controller => 'account', :action => 'edit', :id => 'picture')
		end
	end

	def picture
		@picture = Picture.find(params[:id])
		send_data(@picture.data, 
		:filename => @picture.name, 
		:type => @picture.content_type,
		:disposition => "inline")
	end

	def show
		@picture = picture.find(params[:id])
	end

end
