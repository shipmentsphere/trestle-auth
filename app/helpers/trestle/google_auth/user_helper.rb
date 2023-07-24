module Trestle
  module GoogleAuth
    module UserHelper
      def format_user_name(user)
        instance_exec(user, &Trestle.config.google_auth.format_user_name)
      end
    end
  end
end