module Api
  module V1
    class ChannelsController < ApplicationController
      respond_to :json

      def index
        respond_with Channel.all.group_by(&:language_id)
      end

      def show
        respond_with Channel.find(params[:id])
      end

      def online_users
        respond_with Channel.find(params[:id]).online_users
      end

    end
  end
end