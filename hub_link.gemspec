# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hub_link/version'

Gem::Specification.new do |spec|
  spec.name          = "hub_link"
  spec.version       = HubLink::VERSION
  spec.authors       = ["Jens Balvig"]
  spec.email         = ["jens@balvig.com"]

  spec.summary       = %q{Fetch raw data from GitHub for metrics}
  spec.homepage      = "https://github.com/balvig/hub_link"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "dotenv"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "octokit"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
end
