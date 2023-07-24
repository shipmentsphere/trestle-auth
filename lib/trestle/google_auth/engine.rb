module Trestle
    module GoogleAuth
      class Engine < ::Rails::Engine
        config.assets.precompile << "trestle/google_auth/userbox.css"
  
        config.before_initialize do
          Trestle::Engine.paths["app/helpers"].concat(paths["app/helpers"].existent)
        end
                
        config.to_prepare do
          Trestle::ApplicationController.send(:include, Trestle::GoogleAuth::ControllerMethods)
        end
      end
    end
  end