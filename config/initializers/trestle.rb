Trestle.configure do |config|
    config.hook("stylesheets") do
      stylesheet_link_tag("trestle/google_auth/userbox")
    end
  
    config.hook("view.header") do
      render "trestle/google_auth/userbox"
    end
  end