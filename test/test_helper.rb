require 'simplecov'
require 'coveralls'
require 'hashie'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

SimpleCov.start do
  add_filter 'test'
  #minimum_coverage 100
end

require 'fitbit_alarms_cli'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/mini_test'

