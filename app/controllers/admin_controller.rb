require 'csv'
require 'net/smtp'

class AdminController < ApplicationController
   before_filter :admin_authorize
   layout 'account'

   def test
      @emails = []
      users = User.find_by_sql("select * from users where email is not null order by id")
      users.each { |user| 
         @emails.push(user.email)
      }

      data = {
         :to => "samuel.hughes@trinity.edu",
         :from => "samuel.hughes@trinity.edu",
         :subject => "test",
         :message => "messsage",
         :bcc => ["samuel.hughes@trinity.edu", "samuel.jennings@gmail.com"]
      }

      email = UserMailer.create_email_all(data)
      UserMailer.deliver(email)
   end

   def send_emails
      form_email = Email.new(params[:email])
      email = Email.find(:first, "1")
      email.message = form_email.message
      email.from_email = form_email.from_email
      email.subject = form_email.subject
      email.send = 1
      email.save

      flash[:notice] = "Email successfully sent."
      redirect_to :action => "admin"
   end

   def send_all_users_a_message
      @me = User.find(session[:user_id])
      @users = User.find(:all)
      if params[:message]
         for user in @users
            message = Message.new(params[:message])
            message.user_id = user.id
            message.from_id = @me.id
            message.from_deleted = 1
            message.date_sent = Date.today
            message.save
         end
         flash[:notice] = "Message successfully sent."
         redirect_to :action => "admin"
      end
   end

   def admin
      @user = User.find(session[:user_id])
   end

   def export_to_csv
      users = User.find(:all, :conditions => "id > 0")
      StringIO.open() do |io|
         row = ["Last Name", "First Name", "Email Address1", "User Name", "id (do not edit)"]
         io.puts(CSV.generate_line(row))
         users.each { |user|
            row = []
            row.push user.last_name
            row.push user.first_name
            row.push user.email
            row.push user.login_name
            row.push user.id
            csv_row = CSV.generate_line row
            io.puts csv_row
         }

         io.rewind
         send_data(io.read,
                   :type => 'text/csv; charset=iso-8859-1; header=present',
                   :filename => 'users.csv')
      end
   end

   def export_emails
       #users = User.find(:all, :conditions => "id > 0")
       users = User.find_by_sql("select * from users where email is not null")
       StringIO.open() do |io|
           users.each { |user|
               io.print user.email, ";"
           }

           io.rewind
           send_data(io.read, :type => 'text/plain', :filename => 'temp.txt')
       end
   end


   def email_users(user)
      data = {
         :announcement => 0,
         :job_announcement => 0,
         :stock => 0, 
         :wall_post => 0,
         :profile_edit => 0
      }

      email = UserMailer.create_site_update(user, data)
      email.set_content_type("text/html")
      UserMailer.deliver(email)
   end

   def add_stock
      symbols = params[:stock][:symbol].split(/\s/)
      for symbol in symbols
         symbol = symbol.upcase
         stock = Stock.new()
         stock.symbol = symbol
         stock.user_id = -1
         stock.save
      end
      flash[:notice] = "Stocks successfully added."
      redirect_to :action => 'admin'
   end

   def remove_stock
      symbols = params[:stock][:symbol].split(/\s/)
      for symbol in symbols
         Stock.delete_all ["symbol = ?", symbol]
      end
      flash[:notice] = "Stocks successfully removed."
      redirect_to :action => 'admin'
   end

   def update_users
      spreadsheet = params[:file]
      File.open("temp.csv", "w+") do |file|
         spreadsheet.each_line { |line| file.puts line }
      end

      CSV.foreach("temp.csv") do |row|
         last_name = row[0]
         first_name = row[1]
         email = row[2]
         login_name = row[3]
         user_id = row[4]

         if !login_name
            login_name = first_name.gsub(/\s/,'')+last_name.gsub(/\s/,'')
            login_name = login_name.gsub(/.*\./, '')
            login_name = login_name.gsub(/\(.*\)/, '')
            login_name = login_name.downcase
         end

         user = User.find(:first, :conditions => ["id = ?", user_id])

         # we want to skip first row, so we make user be true
         if first_name == "First Name"
            user = User.new
         end

         first_name = first_name.gsub(/\s|.*\.|\(.*\)/,'')

         if !user
            user = User.new()
            user.login_name = login_name
            user.last_name = last_name
            user.first_name = first_name
            user.email = email
            user.password = "password"
            user.save

            temp = "#{login_name}%"
            users = User.find_by_sql(["select * from users where login_name like ?", temp])
            temp_users = []

            if users
               users.each { |u|
                  l = u.login_name.gsub(/\d/, '')
                  if l == login_name
                     temp_users.push(l)
                  end
               }
            end

            # if multiple users with same login name, get recently added one, and append
            # a number equivalent to the length of users with the same login name.
            if temp_users.length > 1
               user = User.find(:first,
                                :conditions =>
               ["id = ?", user.id])
               user.login_name = "#{user.login_name}#{temp_users.length}"
               user.save
            end
         end
      end

      flash[:notice] = "Users succesfully uploaded"
      redirect_to :action => "admin"
   end
end
