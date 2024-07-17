# frozen_string_literal: true

module Trestle
  module GoogleAuth
    class Configuration
      include Configurable

      option :client_id
      option :client_secret

      option :allowed_domains, -> { [] }

      option :user_class, -> { ::Administrator }
      option :user_scope, -> { Trestle.config.google_auth.user_class }

      option :find_user, lambda { |id|
        Trestle.config.google_auth.user_scope.find_by(id: id)
      }

      option :human_attribute_name, lambda { |field|
        model = begin
          Trestle.config.google_auth.user_class
        rescue StandardError
          nil
        end

        if model && model.respond_to?(:human_attribute_name)
          model.human_attribute_name(field)
        else
          field.to_s.humanize
        end
      }

      option :format_user_name, lambda { |user|
        if user.respond_to?(:first_name) && user.respond_to?(:last_name)
          safe_join([user.first_name, content_tag(:strong, user.last_name)], " ")
        else
          display(user)
        end
      }, evaluate: false

      option :login_url, -> { login_url }, evaluate: false

      option :redirect_on_login, -> { Trestle.config.path }, evaluate: false
      option :redirect_on_logout, -> { login_url }, evaluate: false

      option :logo
    end
  end
end
