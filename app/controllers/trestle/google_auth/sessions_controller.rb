module Trestle
  module GoogleAuth
    class SessionsController < Trestle::ApplicationController
      def destroy
        logout!
        redirect_to instance_exec(&Trestle.config.google_auth.redirect_on_logout)
      end
    end
  end
end
