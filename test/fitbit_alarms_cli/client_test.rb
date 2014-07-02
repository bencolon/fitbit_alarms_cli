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
    stub_client_init
    fc = FitbitAlarmsCli::Client.new

    assert_instance_of Fitgem::Client, fc.instance_variable_get(:@client)
  end

  def test_list_alarms_of_all_devices
    stub_client_init
    Fitgem::Client.any_instance.expects(:devices).returns([{ :id => 1 }, { :id => 2 }])
    Fitgem::Client.any_instance.expects(:get_alarms).twice.returns(alarms_fixture)
    $stdout.expects(:puts).times(4)

    client = FitbitAlarmsCli::Client.new
    client.list_alarms({})
  end

  def test_list_alarms_of_a_specific_device
    stub_client_init
    Fitgem::Client.any_instance.expects(:get_alarms).returns(alarms_fixture)
    $stdout.expects(:puts).times(2)

    client = FitbitAlarmsCli::Client.new
    client.list_alarms({ :device => 1 })
  end

  def test_remove_alarm_of_the_first_device
    stub_client_init
    Fitgem::Client.any_instance.expects(:delete_alarm)
    Fitgem::Client.any_instance.expects(:devices).returns([{ :id => 1234 }])
    FitbitAlarmsCli::Client.any_instance.expects(:list_alarms)

    client = FitbitAlarmsCli::Client.new
    client.remove_alarm(1234, {})
  end

  def test_remove_alarm_of_a_specific_device
    stub_client_init
    Fitgem::Client.any_instance.expects(:delete_alarm)
    FitbitAlarmsCli::Client.any_instance.expects(:list_alarms)

    client = FitbitAlarmsCli::Client.new
    client.remove_alarm(1234, { :device => 1 })
  end

  private

  def stub_client_init
    File.expects(:exists?).returns(true)
    YAML.expects(:load_file).returns({ :consumer_key => 1234, :consumer_secret => 1234,
                                      :token => 1234, :secret => 1234 })
  end

  def alarms_fixture
    {
      "trackerAlarms" => [{
        "label" => "Alarm label",
        "time" => "12:00",
        "recurring" => "",
        "enabled" => "enabled",
        "syncedToDevice" => "synced"
      }]
    }
  end
end
