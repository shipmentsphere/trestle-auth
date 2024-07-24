# frozen_string_literal: true

module Trestle
  module Auth
    class Engine < ::Rails::Engine
      config.assets.precompile << "trestle/auth/userbox.css"

      config.before_initialize do
        Trestle::Engine.paths["app/helpers"].concat(paths["app/helpers"].existent)
      end

      config.to_prepare do
        Trestle::ApplicationController.include Trestle::Auth::ControllerMethods
      end
    end
  end
end
