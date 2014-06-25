require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'fitbit_alarms_cli'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/mini_test'

