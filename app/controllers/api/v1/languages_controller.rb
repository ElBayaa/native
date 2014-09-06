module Api
  module V1
    class LanguagesController < ApplicationController
      respond_to :json

      def index
        respond_with Language.all
      end

      def show
        respond_with Language.find(params[:id])
      end

      def channels
        respond_with Language.find(params[:id]).channels
      end

      def channel
        respond_with Language.find(params[:id]).channels.find(params[:channel_id])
      end

    end
  end
end