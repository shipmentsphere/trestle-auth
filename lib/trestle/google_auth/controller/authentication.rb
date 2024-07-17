# frozen_string_literal: true

module Trestle
  module GoogleAuth
    module Controller
      module Authentication
        extend ActiveSupport::Concern

        included do
          helper_method :current_user

          prepend_before_action :require_authentication

          # Ensure that CSRF protection happens before authentication
          protect_from_forgery prepend: true
        end

        protected

        def authentication_backend
          @authentication_backend ||= Trestle::GoogleAuth::Backend.new(
            controller: self,
            request: request,
            session: session,
            cookies: cookies
          )
        end

        def current_user
          authentication_backend.user
        end

        def require_authentication
          authentication_backend.restore_authentication || authentication_backend.request_authentication
        end
      end
    end
  end
end
