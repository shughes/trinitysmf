require "digest/sha1"

class User < ActiveRecord::Base
	has_one :resume
	has_one :picture
	has_many :resume_viewers
	has_many :messages, :order => "id DESC"
	has_many :updates
	has_many :stocks

	attr_accessor :password
	attr_accessor :confirm_password
	validates_uniqueness_of :login_name, :on => :update
	validates_presence_of :first_name, :last_name
	validates_presence_of :password, :on => :create
	#validates_format_of :email, :with => /.*\@.*\./, :message => "must be in proper format or not left blank."

	def before_create
		self.hashed_password = User.hash_password(self.password)
	end

	def validate_on_update
		if self.password and self.confirm_password
			if self.password == '' or self.confirm_password == ''
				errors.add(:password, "is blank")
			elsif self.password != self.confirm_password
				errors.add(:password, "does not match")
			end
		end
	end

	def before_update
		if self.password and self.confirm_password
			self.hashed_password = User.hash_password(self.password)
		end
	end

	def after_create
		@password = nil
	end

	def after_update
		@password = nil
	end

	def self.hash_password(password)
		Digest::SHA1.hexdigest(password)
	end

	def self.login(login_name, password)
		hashed_password = hash_password(password || "")
		find(:first,
		:conditions => ["login_name = ? and hashed_password = ?", login_name, hashed_password])
	end

	def try_to_login
		User.login(self.login_name, self.password)
	end

end
