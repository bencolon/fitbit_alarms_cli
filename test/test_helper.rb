require 'simplecov'
#require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  #Coveralls::SimpleCov::Formatter,
]

SimpleCov.start do
  minimum_coverage 100
end

require 'fitbit_alarms_cli'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

