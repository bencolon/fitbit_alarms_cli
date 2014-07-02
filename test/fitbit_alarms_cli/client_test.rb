require 'test_helper'

class FitbitAlarmsCli::ClientTest < MiniTest::Test
  def test_initialize_failed_without_auth_file
    File.expects(:exists?).returns(false)
    $stdout.expects(:puts).twice

    assert_raises SystemExit do
      FitbitAlarmsCli::Client.new
    end
  end

  def test_initialize_failed_with_invalid_auth_file
    File.expects(:exists?).returns(true)
    $stdout.expects(:puts).twice
    YAML.expects(:load_file).returns({})

    assert_raises SystemExit do
      FitbitAlarmsCli::Client.new
    end
  end

  def test_initialize_success
    File.expects(:exists?).returns(true)
    YAML.expects(:load_file).returns({ :consumer_key => 1234, :consumer_secret => 1234,
                                      :token => 1234, :secret => 1234 })

    fc = FitbitAlarmsCli::Client.new
    assert_instance_of Fitgem::Client, fc.instance_variable_get(:@client)
  end
end
