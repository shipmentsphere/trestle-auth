# frozen_string_literal: true

require_relative "lib/trestle/auth/version"

Gem::Specification.new do |spec|
  spec.name = "trestle-auth"
  spec.version = Trestle::Auth::VERSION
  spec.authors = ["Mikko Kokkonen"]
  spec.email = ["mikko@shipmentsphere.com"]

  spec.summary = "Add authentication via Google SSO for Trestle."
  spec.homepage = "https://github.com/shipmentsphere/trestle-auth"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.required_ruby_version = ">= 3.3.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "google-id-token", ">= 1.4.0"
  spec.add_dependency "oauth2", ">= 2.0.9"
  spec.add_dependency "trestle", ">= 0.9.3"
end
