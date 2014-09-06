class MainController < ApplicationController
  
  def home
    @languages = Language.all
    @online_friends = current_user.friends.online
  end
  
end
