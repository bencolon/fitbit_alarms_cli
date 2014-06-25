require 'test_helper'

class FitbitAlarmsCli::CommandsTest < MiniTest::Test

  def setup
    @commands = FitbitAlarmsCli::Commands.new
  end

  def test_version_command
    $stdout.expects(:puts)
    @commands.version
  end

  def test_setup_command
    FitbitAlarmsCli::Setup.expects(:start)
    @commands.setup
  end

  def test_list_command
    FitbitAlarmsCli::Client.any_instance.expects(:list_alarms)
    @commands.list
  end

  def test_add_command
    FitbitAlarmsCli::Client.any_instance.expects(:add_alarm)
    @commands.add("12:00+02:00")
  end

  def test_remove_command
    FitbitAlarmsCli::Client.any_instance.expects(:remove_alarm)
    @commands.remove("1234")
  end
end
