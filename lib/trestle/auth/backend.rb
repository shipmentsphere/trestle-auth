# frozen_string_literal: true

require "oauth2"
require "securerandom"

require "trestle/auth/identity"

module Trestle
  module Auth
    class Backend
      attr_reader :controller, :request, :session, :cookies

      def initialize(controller:, request:, session:, cookies:)
        @controller = controller
        @request = request
        @session = session
        @cookies = cookies
      end

      def request_authentication
        redirect_to_login
      end

      # Authenticates a user from a login form request.
      def authenticate!
        return unless Trestle.config.auth.allowed_domains.include?(google_identity.hosted_domain)

        Trestle.config.auth.user_class.find_or_initialize_by(email: google_identity.email_address).tap do |user|
          user.update(
            {
              "first_name" => google_identity.given_name,
              "last_name" => google_identity.family_name,
            }.slice(*user.attribute_names)
          )
        end
      end

      def redirect_to_login
        controller.redirect_to login_url(scope: "openid profile email", state:), flash: { state: },
                                                                                       allow_other_host: true
      end

      private

      def login_url(**params)
        client.auth_code.authorize_url(prompt: "login", **params)
      end

      def client
        @client ||= ::OAuth2::Client.new(
          Trestle.config.auth.client_id,
          Trestle.config.auth.client_secret,
          authorize_url: "https://accounts.google.com/o/oauth2/auth",
          token_url: "https://oauth2.googleapis.com/token",
          redirect_uri: controller.callback_url
        )
      end

      def state
        @state ||= SecureRandom.base64(24)
      end

      def google_identity
        @google_identity ||= Trestle::Auth::Identity.new(id_token)
      end

      def id_token
        @id_token ||= client.auth_code.get_token(controller.params[:code])["id_token"]
      end
    end
  end
end
