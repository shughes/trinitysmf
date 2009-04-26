class Message < ActiveRecord::Base
  belongs_to :user
  #, :order => 'id DESC'
  
  # used for sending email in the admin section.
  attr_accessor :from
  
end
