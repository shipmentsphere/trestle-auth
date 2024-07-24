# frozen_string_literal: true

module Trestle
  module Auth
    class CallbacksController < Trestle::ApplicationController
      skip_before_action :require_authentication, only: [:show]

      def show
        if user = authentication_backend.authenticate!
          start_new_session_for(user)
          redirect_to post_authenticating_url(url: instance_exec(&Trestle.config.auth.redirect_on_login))
        else
          authentication_backend.redirect_to_login
        end
      end
    end
  end
end
