# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tinfoil/version'

Gem::Specification.new do |spec|
  spec.name          = "tinfoil"
  spec.version       = Tinfoil::VERSION
  spec.authors       = ["Scott Brown"]
  spec.email         = ["scott@justplainsimple.com"]
  spec.description   = %q{A gem to scan a Web server and report whether it contains any or all secure headers}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
end
