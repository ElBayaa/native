class MainController < ApplicationController
  
  def home
    @languages = Language.all
  end
  
end
