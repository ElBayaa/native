class MainController < ApplicationController
  
  def home
    @languages = Language.all
    @online_friends = current_user.friends.online
    @current_channels = Channel.where(id: current_user.current_channels_ids)
  end
  
end
