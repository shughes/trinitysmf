module AccountHelper
  def message_update
    @user = User.find(session[:user_id])
    if user.requests
      return true
    else
      return false
    end
  end

  def get_states
    return [["Alabama", "Alabama"],["Alaska", "Alaska"], ["Arizona", "Arizona"],
            ["Arkansas", "Arkansas"],["California", "California"],["Colorado", "Colorado"],
            ["Connecticut", "Connecticut"], ["Deleware", "Deleware"],["Florida","Florida"],
            ["Georgia","Georgia"],["Hawaii","Hawaii"],["Idaho","Idaho"],["Illinois","Illinois"],
            ["Indiana","Indiana"],["Iowa","Iowa"],["Kansas","Kansas"],
            ["Kentucky","Kentucky"],["Louisiana","Louisiana"],["Maine","Maine"],
            ["Maryland","Maryland"],["Massachusetts","Massachusetts"],["Michigan","Michigan"],
            ["Minnesota","Minnesota"],["Mississippi","Mississippi"],["Missouri","Missouri"],
            ["Montana","Montana"],["Nebraska","Nebraska"],["Nevada","Nevada"],
            ["New Hampshire","New Hampshire"],["New Jersey","New Jersey"],
            ["New Mexico","New Mexico"],["New York","New York"],["North Carolina"],
            ["North Dakota"],["Ohio","Ohio"],
            ["Oklahoma","Oklahoma"],["Oregon","Oregon"],["Pennsylvania","Pennsylvania"],
            ["Rhode Island","Rhode Island"],
            ["South Carolina","South Carolina"],["South Dakota","South Dakota"],
            ["Tennessee","Tennessee"],
            ["Texas","Texas"],["Utah","Utah"],["Vermont","Vermont"],["Virginia","Virginia"],
            ["Washington","Washington"],
            ["West Virginia","West Virginia"],["Wisconsin","Wisconsin"],["Wyoming","Wyoming"]]
  end
end