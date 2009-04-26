require 'soap/wsdlDriver'
require 'yahoofinance'

class StockController < ApplicationController
	before_filter :authorize
	layout 'account'

	def add_stock
		symbols = params[:stock][:symbol].split(/\s/)
		for symbol in symbols
			symbol = symbol.upcase
			stock = Stock.new()
			stock.symbol = symbol
			stock.user_id = session[:user_id].to_i
			stock.save
		end
		flash[:notice] = "Stocks successfully added."
		redirect_to :action => 'search_form'
	end

	def remove_stock
		symbols = params[:stock][:symbol].split(/\s/)
		for symbol in symbols
			Stock.delete_all ["symbol = ? and user_id = ?", symbol, session[:user_id].to_i]
		end
		flash[:notice] = "Stocks successfully removed."
		redirect_to :action => 'search_form'
	end


	def delete
		@user = User.find(session[:user_id])
		@update = Update.find(params[:id])
		if @user.id != @update.user_id
			flash[:notice] = "Error editing update"
		else
			Update.delete ["id = ?", params[:id]]
			flash[:notice] = "Stock tip successfully deleted"
		end
		redirect_to :action => 'search_form'
	end

	def edit_tip
		@user = User.find(session[:user_id])
		@update = Update.find(params[:id])
		if @user.id != @update.user_id
			flash[:notice] = "Error editing stock tip"
			redirect_to :action => 'index'
		end

		if request.post?
			temp_update = Update.new(params[:update])
			@update.update_attributes(:subject => temp_update[:subject],
			:message => temp_update[:message])
			flash[:notice] = "Stock tip successfully edited"
			
			redirect_to :action => 'search_form'
		end
	end

	def post_tip
		@user = User.find(session[:user_id])
		@update = Update.new

		if request.post?
			@update = Update.new(params[:update])
			@update.date_sent = Date.today
			@update.user = @user
			@update.update_type = "stock"
			if @update.save
				flash[:notice] = "Stop tip successfully posted"
				redirect_to :action => 'search_form'
			end
		end
	end

	def read_tip
		@update = Update.find(params[:id])
	end

	def search_form
		@tips = Update.find(:all, :conditions => ["id > 0 and update_type = 'stock'"], 
		:order => 'date_sent DESC, id DESC')
	end

	def method_missing(method)
		key = method.id2name
	end

	def test
		t = stock_quotes("msft")
		@quote_type = YahooFinance::StandardQuote
		@quote_symbol = "goog,yhoo"
	end

	def stock_quotes(symbols)
		quote_type = YahooFinance::StandardQuote
		quotes = YahooFinance::get_quotes(quote_type, symbols) 
		return quotes
	end

	def search
		symbols = params[:stock]
		symbols = symbols.gsub(/\s/, ',')
		@quotes = stock_quotes(symbols)
	end

	def search!
		wsdl_url = "http://ws.invesbot.com/stockquotes.asmx?WSDL"
		soap = SOAP::WSDLDriverFactory.new(wsdl_url).create_rpc_driver
		stock_param = { "symbol" => params[:stock] }
		if soap.getQuote(stock_param).getQuoteResult.stockQuote.__xmlele.collect.length > 3
			@result = soap.getQuote(stock_param)
		else
			flash[:notice] = "Your search returned no matches"
			redirect_to :action => 'search_form'
		end
	end
end
