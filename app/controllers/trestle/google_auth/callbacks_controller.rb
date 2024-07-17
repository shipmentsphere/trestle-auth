# frozen_string_literal: true

require "oauth2"

module Trestle
  module GoogleAuth
    class CallbacksController < Trestle::ApplicationController
      skip_before_action :require_authentication, only: [:show]

      def show
        if authentication_backend.authenticate!
          redirect_to authentication_backend.previous_location || instance_exec(&Trestle.config.google_auth.redirect_on_login)
        else
          authentication_backend.redirect_to_login
        end
      end
    end
  end
end
