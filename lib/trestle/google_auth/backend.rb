# frozen_string_literal: true

require "oauth2"
require "securerandom"

require "trestle/google_auth/identity"

module Trestle
  module GoogleAuth
    class Backend
      ACTIVITY_REFRESH_RATE = 1.hour

      attr_reader :controller, :request, :session, :cookies

      def initialize(controller:, request:, session:, cookies:)
        @controller = controller
        @request = request
        @session = session
        @cookies = cookies
      end

      # Stores the previous return location in the session to return to after logging in.
      def store_location(url)
        session[:trestle_return_to] = url
      end

      # Returns (and deletes) the previously stored return location from the session.
      def previous_location
        session.delete(:trestle_return_to)
      end

      # Returns the current logged in user (after #authentication).
      attr_reader :user

      def restore_authentication
        return unless (@user = find_authenticated_user)

        resume_session(@user)
      end

      def request_authentication
        session[:return_to_after_authenticating] = request.fullpath
        redirect_to_login
      end

      def resume_session(user)
        user.update!(last_active_at: Time.now) if user.last_active_at.before?(ACTIVITY_REFRESH_RATE.ago)
        cookies.signed.permanent[:trestle_user] = { value: user.id, httponly: true }
      end

      # Authenticates a user from a login form request.
      def authenticate!
        @user = Trestle.config.google_auth.user_class.find_or_create_by(email: google_identity.email_address,
                                                                       first_name: google_identity.given_name,
                                                                       last_name: google_identity.family_name)

        resume_session(@user)
        @user
      end

      # Logs out the current user.
      def logout!
        cookies.delete(:trestle_user)
        @user = nil
      end

      def redirect_to_login
        controller.redirect_to login_url(scope: "openid profile email", state: state), flash: { state: state },
                                                                                       allow_other_host: true
      end

      protected

      def find_authenticated_user
        if user_id = cookies.signed[:trestle_user]
          Trestle.config.google_auth.find_user(user_id)
        end
      end

      private

      def login_url(**params)
        client.auth_code.authorize_url(prompt: "login", **params)
      end

      def client
        @client ||= ::OAuth2::Client.new(
          Trestle.config.google_auth.client_id,
          Trestle.config.google_auth.client_secret,
          authorize_url: "https://accounts.google.com/o/oauth2/auth",
          token_url: "https://oauth2.googleapis.com/token",
          redirect_uri: controller.callback_url
        )
      end

      def state
        @state ||= SecureRandom.base64(24)
      end

      def google_identity
        @google_identity ||= Trestle::GoogleAuth::Identity.new(id_token)
      end

      def id_token
        @id_token ||= client.auth_code.get_token(controller.params[:code])["id_token"]
      end
    end
  end
end
