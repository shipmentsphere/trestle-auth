require "oauth2"

module Trestle
  module GoogleAuth
    class CallbacksController < Trestle::ApplicationController
      skip_before_action :authenticate_user, only: [:show]
      skip_before_action :require_authenticated_user

      def show
        if authentication_backend.authenticate!
          redirect_to authentication_backend.previous_location || instance_exec(&Trestle.config.google_auth.redirect_on_login)
        else
          flash[:error] = t("admin.auth.error", default: "Incorrect login details.")
          redirect_to action: :new
        end

      end

      private

      # def google_sign_in_response
      #   if valid_request? && params[:code].present?
      #     { id_token: id_token }
      #   else
      #     { error: error_message_for(params[:error]) }
      #   end
      # rescue OAuth2::Error => e
      #   { error: error_message_for(e.code) }
      # end

      # def valid_request?
      #   flash[:state].present? && params[:state] == flash[:state]
      # end

      # def id_token
      #   @_id_token ||= client.auth_code.get_token(params[:code])["id_token"]
      # end

      # def error_message_for(error_code)
      #   error_code.presence_in(Trestle::GoogleAuth::OAUTH2_ERRORS) || "invalid_request"
      # end

      # def client
      #   @client ||= OAuth2::Client.new \
      #     Trestle.config.google_auth.client_id,
      #     Trestle.config.google_auth.client_secret,
      #     authorize_url: "https://accounts.google.com/o/oauth2/auth",
      #     token_url: "https://oauth2.googleapis.com/token",
      #     redirect_uri: (Trestle.config.google_auth.oauth_proxy || callback_url)
      # end
    end
  end
end
