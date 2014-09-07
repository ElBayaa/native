module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action  :verify_authenticity_token

      respond_to :json

      def online_friends
        respond_with current_user.friends.online
      end

      def update_current_user
        current_user.update user_params
        respond_with {}
      end
      
      private
      def user_params
        params.require(:user).permit(current_channels_ids: [])
      end

    end
  end
end
