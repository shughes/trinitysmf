# Methods added to this helper will be available to all templates in the application.
require 'yahoofinance'
require 'net/http'
require 'csv'

module ApplicationHelper

	def stock_quotes(symbols)
	  quote_type = YahooFinance::StandardQuote
		quotes = YahooFinance::get_quotes(quote_type, symbols) 
		return quotes
	end

	def search_helper
		@my_string = params[:user][:first_name]
		@my_string = @my_string.downcase
		@my_string = @my_string.sub(/looking for /, '')
		search_data = @my_string.split(/\s+/)
		@users = Array.new()

		for new_string in search_data
			date = Date.civil(new_string.to_i)
			new_string = "%"+new_string+"%"
			temp = User.find_by_sql ["select * from users where "+
			"first_name like ?"+
			"or last_name like ?"+
			"or grad_school like ?"+
			"or email like ?"+
			"or address like ?"+
			"or city like ?"+
			"or state like ?"+
			"or graduation_year like ?"+
			"or employer like ?"+
			"or previous_employer like ?"+
			"or job_title like ?"+
			"or job_description like ?"+
			"or mobile_phone like ?"+
			"or employment_status like ?"+
			"or major like ?"+
			"order by last_name",
			new_string, new_string, new_string, new_string, new_string, new_string,
			new_string, new_string, new_string, new_string, new_string, new_string,
			new_string, new_string, new_string] 
			@users = temp + @users
		end

		@users = @users.uniq
	end
end
