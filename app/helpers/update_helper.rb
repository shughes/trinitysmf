module UpdateHelper
  def display_menu
    return "#{link_to 'post an announcement', :action => 'post'}"
  end
end
