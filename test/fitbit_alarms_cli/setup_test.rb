require 'test_helper'

class FitbitAlarmsCli::SetupTest < MiniTest::Test

  def setup
    @module = FitbitAlarmsCli::Setup
  end

  def test_failed_start_and_no_rerun
    File.expects(:exists?).returns(true)
    $stdin.expects(:gets).returns('no')
    $stdout.expects(:puts).twice
    assert_raises SystemExit do
      @module.start
    end
  end

  def test_failed_start_and_rerun
    File.expects(:exists?).returns(true)
    $stdin.expects(:gets).returns(' yes   ')
    $stdout.expects(:puts).twice
    @module.expects(:run)
    @module.start
  end

  def test_success_start
    File.expects(:exists?).returns(false)
    @module.expects(:run)
    @module.start
  end

  def test_success_run
    @module.expects(:intro)
    @module.expects(:consumer_infos)
    @module.expects(:tokens)
    @module.expects(:congrats)

    @module.run
  end

  def test_failed_run
    @module.expects(:intro)
    @module.expects(:consumer_infos)
    @module.expects(:tokens)
    @module.expects(:congrats).raises(Exception)
    $stdout.expects(:puts).twice

    @module.run
  end
end
