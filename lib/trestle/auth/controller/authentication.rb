# frozen_string_literal: true

module Trestle
  module Auth
    module Controller
      module Authentication
        extend ActiveSupport::Concern

        included do
          before_action :require_authentication
          helper_method :current_user

          # Ensure that CSRF protection happens before authentication
          protect_from_forgery prepend: true
        end

        protected

        def current_user = Current.user

        def authentication_backend
          @authentication_backend ||= Trestle::Auth::Backend.new(
            controller: self,
            request:,
            session:,
            cookies:
          )
        end

        def find_session_by_cookie
          if token = cookies.signed[:session_token]
            Session.find_by(user_type: Trestle.config.auth.user_class.name, token: token)
          end
        end

        def require_authentication
          restore_authentication || request_authentication
        end

        def restore_authentication
          if session = find_session_by_cookie
            resume_session session
          end
        end

        def request_authentication
          session[:return_to_after_authenticating] = request.fullpath
          authentication_backend.request_authentication
        end

        def start_new_session_for(user)
          user.sessions.start!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
            authenticated_as session
          end
        end

        def resume_session(session)
          session.resume(user_agent: request.user_agent, ip_address: request.remote_ip)
          authenticated_as session
        end

        def authenticated_as(session)
          Current.session = session
          cookies.signed.permanent[:session_token] = { value: session.token, httponly: true }
        end

        def post_authenticating_url(url: nil)
          session.delete(:return_to_after_authenticating) || url
        end

        def reset_authentication
          cookies.delete(:session_token)
        end
      end
    end
  end
end
