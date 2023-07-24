require "oauth2"
require "securerandom"

require "trestle/google_auth/identity"

module Trestle
  module GoogleAuth
    class Backend
      attr_reader :controller, :request, :session, :cookies

      def initialize(controller:, request:, session:, cookies:)
        @controller = controller
        @request = request
        @session = session
        @cookies = cookies
      end

      # Default params scope to use for the login form.
      def scope
        :user
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

      # Authenticates a user from a login form request.
      def authenticate!
        user = Trestle.config.google_auth.user_class.find_or_create_by(email: google_identity.email_address, first_name: google_identity.given_name, last_name: google_identity.family_name)

        login!(user)
        user
      end

      # Authenticates a user from the session or cookie. Called on each request via a before_action.
      def authenticate
        @user ||= find_authenticated_user || redirect_to_login
      end

      # Checks if there is a logged in user.
      def logged_in?
        !!user
      end

      # Stores the given user in the session as logged in.
      def login!(user)
        session[:trestle_user] = user.id
        @user = user
      end

      # Logs out the current user.
      def logout!
        session.delete(:trestle_user)
        @user = nil
      end

      protected

      def find_authenticated_user
        Trestle.config.google_auth.find_user(session[:trestle_user]) if session[:trestle_user]
      end

      def redirect_to_login
        controller.redirect_to login_url(scope: "openid profile email", state: state), flash: { state: state },
                                                                                       allow_other_host: true
      end

      def login_params
        controller.params.require(:user).permit!
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
          redirect_uri: (Trestle.config.google_auth.oauth_proxy || controller.callback_url)
        )
      end

      def state
        @state ||= if Trestle.config.google_auth.oauth_proxy
                     Base64.encode64(controller.callback_url)
                   else
                     SecureRandom.base64(24)
                   end
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
