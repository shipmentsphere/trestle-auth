# frozen_string_literal: true

module Trestle
  module GoogleAuth
    module ControllerMethods
      extend ActiveSupport::Concern

      include Trestle::GoogleAuth::Controller::Authentication
    end
  end
end
