# frozen_string_literal: true

Trestle::Engine.routes.draw do
  controller "trestle/auth/sessions" do
    get "logout" => :destroy, :as => :logout
    delete :stop_impersonating
  end

  controller "trestle/auth/callbacks" do
    get "callback" => :show, :as => :callback
  end
end
