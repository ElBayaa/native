module Api
  module V1
    class UsersController < ApplicationController
    
      respond_to :json

      def online_friends
        respond_with current_user.friends.online
      end

    end
  end
end
