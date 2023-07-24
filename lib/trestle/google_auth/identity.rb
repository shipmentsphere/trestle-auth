require "google-id-token"

module Trestle
  module GoogleAuth
    class Identity
      class ValidationError < StandardError; end

      def initialize(token)
        extract_payload(token)
      end

      def user_id
        @payload["sub"]
      end

      def name
        @payload["name"]
      end

      def email_address
        @payload["email"]
      end

      def email_verified?
        @payload["email_verified"] == true
      end

      def avatar_url
        @payload["picture"]
      end

      def locale
        @payload["locale"]
      end

      def hosted_domain
        @payload["hd"]
      end

      def given_name
        @payload["given_name"]
      end

      def family_name
        @payload["family_name"]
      end

      private

      def validator
        @validator ||= GoogleIDToken::Validator.new
      end

      def extract_payload(token)
        @payload = validator.check(token, Trestle.config.google_auth.client_id)
      rescue GoogleIDToken::ValidationError => e
        raise ValidationError, e.message
      end
    end
  end
end
