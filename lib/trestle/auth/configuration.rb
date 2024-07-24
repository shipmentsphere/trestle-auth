# frozen_string_literal: true

module Trestle
  module Auth
    class Configuration
      include Configurable

      option :client_id
      option :client_secret

      option :allowed_domains, -> { [] }

      option :user_class, -> { ::Administrator }
      option :user_scope, -> { Trestle.config.auth.user_class }
      option :session_class, -> { ::Session }

      option :find_user, lambda { |id|
        Trestle.config.auth.user_scope.find_by(id:)
      }

      option :format_user_name, lambda { |user|
        if user.respond_to?(:first_name) && user.respond_to?(:last_name)
          safe_join([user.first_name, content_tag(:strong, user.last_name)], " ")
        else
          display(user)
        end
      }, evaluate: false

      option :redirect_on_login, -> { Trestle.config.path }, evaluate: false
      option :redirect_on_logout, -> { Trestle.config.path }, evaluate: false
    end
  end
end
