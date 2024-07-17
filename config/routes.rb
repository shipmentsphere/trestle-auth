# frozen_string_literal: true

Trestle::Engine.routes.draw do
  controller "trestle/google_auth/sessions" do
    get "logout" => :destroy, as: :logout
  end

  controller "trestle/google_auth/callbacks" do
    get "callback" => :show, as: :callback
  end
end
