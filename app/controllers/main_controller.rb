class MainController < ApplicationController
  
  def home
    respond_to do |format|
      format.any{ render text: "Welcome #{current_user.name}"}
    end
  end
  
end
