# frozen_string_literal: true

require_relative "google_auth/version"

require "trestle"

module Trestle
  module GoogleAuth
    # https://tools.ietf.org/html/rfc6749#section-4.1.2.1
    authorization_request_errors = %w[
      invalid_request
      unauthorized_client
      access_denied
      unsupported_response_type
      invalid_scope
      server_error
      temporarily_unavailable
    ]

    # https://tools.ietf.org/html/rfc6749#section-5.2
    access_token_request_errors = %w[
      invalid_request
      invalid_client
      invalid_grant
      unauthorized_client
      unsupported_grant_type
      invalid_scope
    ]

    # Authorization Code Grant errors from both authorization requests
    # and access token requests.
    OAUTH2_ERRORS = authorization_request_errors | access_token_request_errors

    require_relative "google_auth/backend"
    require_relative "google_auth/configuration"
    require_relative "google_auth/constraint"

    module Controller
      require_relative "google_auth/controller/authentication"
    end

    require_relative "google_auth/controller_methods"
  end

  Configuration.option :google_auth, GoogleAuth::Configuration.new
end

require_relative "google_auth/engine" if defined?(Rails)
