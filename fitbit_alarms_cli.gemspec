# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fitbit_alarms_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "fitbit_alarms_cli"
  spec.version       = FitbitAlarmsCli::VERSION
  spec.authors       = ["Ben Colon"]
  spec.email         = ["ben@colon.com.fr"]
  spec.summary       = "A CLI gem to setup Fitbit alarms"
  spec.description   = "A CLI gem to setup Fitbit alarms"
  spec.homepage      = "https://github.com/bencolon/fitbit_alarms_cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["fac"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
