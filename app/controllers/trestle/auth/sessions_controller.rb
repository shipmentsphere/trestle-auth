# frozen_string_literal: true

module Trestle
  module Auth
    class SessionsController < Trestle::ApplicationController
      def destroy
        reset_authentication
        redirect_to instance_exec(&Trestle.config.auth.redirect_on_logout)
      end

      def stop_impersonating
        session.delete(:impersonated_user_id)
        redirect_to Trestle.config.path
      end
    end
  end
end
