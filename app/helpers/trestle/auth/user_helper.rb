# frozen_string_literal: true

module Trestle
  module Auth
    module UserHelper
      def format_user_name(user)
        instance_exec(user, &Trestle.config.auth.format_user_name)
      end
    end
  end
end
