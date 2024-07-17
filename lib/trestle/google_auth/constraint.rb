# frozen_string_literal: true

module Trestle
  module GoogleAuth
    class Constraint
      def matches?(request)
        request.session[:trestle_user].present?
      end

      private

      def authentication_backend_for(request)
        Backend.new(controller: self, request: request, session: request.session, cookies: request.cookie_jar)
      end
    end
  end
end
