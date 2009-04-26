module MessageHelper
  def display_menu
    return "#{link_to 'inbox', :action => 'inbox'} | "+
      "#{link_to 'compose', :action => 'compose'} | "+
      "#{link_to 'sent messages', :action => 'sent'}"    
	end
end
