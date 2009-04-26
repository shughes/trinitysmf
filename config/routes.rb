ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
				
	map.connect "messsage/delete/:id/:sent_folder",
		:controller => "message",
		:action => "delete",
		:id => nil,
		:sent_folder => nil
		
	map.connect "messsage/compose/:id/:last_page",
		:controller => "message",
		:action => "compose",
		:id => nil,
		:last_page => nil

	map.connect "messsage/read/:id/:sent_folder",
		:controller => "message",
		:action => "read",
		:id => nil,
		:sent_folder => nil

	map.connect "message/delete/:id/:sent_folder",
		:controller => "message",
		:action => "delete",
		:id => nil,
		:sent_folder => nil
      
  map.connect "account/search/:id/:search_one/:search_two",
    :controller => "account",
    :action => "search",
    :id => nil,
    :search_one => nil,
    :search_two => nil
    
  map.connect "",
    :controller => "login",
    :action => "login"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'

end
