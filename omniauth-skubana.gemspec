# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-skubana/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-skubana"
  spec.version       = OmniAuth::Skubana::VERSION
  spec.authors       = ["Karl Falconer"]
  spec.email         = ["karl.falconer@falconerdevelopment.com"]

  spec.summary       = %q{OmniAuth strategy for Skubana}
  spec.description   = %q{In this gem you will find an OmniAuth Skubana strategy.}
  spec.homepage      = "https://github.com/dropstream/omniauth-skubana"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'omniauth-oauth2'

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
