module Trestle
  module GoogleAuth
    class SessionsController < Trestle::ApplicationController
      skip_before_action :authenticate_user, only: [:create]
      skip_before_action :require_authenticated_user

      def destroy
        logout!
        redirect_to instance_exec(&Trestle.config.google_auth.redirect_on_logout)
      end
    end
  end
end
