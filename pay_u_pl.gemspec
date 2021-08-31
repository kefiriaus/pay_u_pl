# frozen_string_literal: true

require_relative "lib/pay_u_pl/version"

Gem::Specification.new do |spec|
  spec.name          = "pay_u_pl"
  spec.version       = PayUPl::VERSION
  spec.authors       = "kefiriaus"
  spec.email         = "kefiriaus@gmail.com"
  spec.homepage      = "https://github.com/kefiriaus/pay_u_pl"
  spec.summary       = "PayU integration."
  spec.description   = "PayU integration for Poland."
  spec.license       = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.8")

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
    spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 4.2"
  spec.add_runtime_dependency "awesome_print"
  spec.add_runtime_dependency "dry-container", "~> 0.7.2"
  spec.add_runtime_dependency "dry-core", "~> 0.6.0"
  spec.add_runtime_dependency "dry-inflector", "= 0.2.0"
  spec.add_runtime_dependency "dry-schema", "~> 1.6.2"
  spec.add_runtime_dependency "dry-struct", "~> 1.4"
  spec.add_runtime_dependency "dry-validation", "~> 1.6"

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_development_dependency "rubocop", ">= 0.80"
  spec.add_development_dependency "webmock"
end
