# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plaid/version'

Gem::Specification.new do |spec|
  spec.name          = "plaid"
  spec.version       = Plaid::VERSION
  spec.authors       = ["Oleg Dashevskii"]
  spec.email         = ["olegdashevskii@gmail.com"]

  spec.summary       = %q{Ruby bindings for Plaid}
  spec.description   = %q{Ruby gem wrapper for the Plaid API. Read more at the homepage, the wiki, or the plaid documentation.}
  spec.homepage      = "https://github.com/plaid/plaid-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sdoc", "~> 0.4.1"
end
