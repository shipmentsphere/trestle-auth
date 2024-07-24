# frozen_string_literal: true

module Trestle
  module Auth
    module ControllerMethods
      extend ActiveSupport::Concern

      include Trestle::Auth::Controller::Authentication
    end
  end
end
