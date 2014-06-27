require 'test_helper'

class FitbitAlarmsCli::SetupTest < MiniTest::Test

  def setup
    @module = FitbitAlarmsCli::Setup
  end

  def test_start_failed_and_no_rerun
    File.expects(:exists?).returns(true)
    $stdin.expects(:gets).returns('no')
    $stdout.expects(:puts).twice

    assert_raises SystemExit do
      @module.start
    end
  end

  def test_start_failed_and_rerun
    File.expects(:exists?).returns(true)
    $stdin.expects(:gets).returns(' yes   ')
    $stdout.expects(:puts).twice
    @module.expects(:run)

    @module.start
  end

  def test_start_success
    File.expects(:exists?).returns(false)
    @module.expects(:run)

    @module.start
  end

  def test_run_success
    @module.expects(:intro)
    @module.expects(:consumer_infos)
    @module.expects(:tokens)
    @module.expects(:congrats)

    @module.run
  end

  def test_run_failed
    @module.expects(:intro)
    @module.expects(:consumer_infos)
    @module.expects(:tokens)
    @module.expects(:congrats).raises(Exception)
    $stdout.expects(:puts).twice

    @module.run
  end

  def test_intro
    $stdout.expects(:puts).times(3)
    $stdin.expects(:gets)

    @module.intro
  end

  def test_consumer_infos
    $stdout.expects(:puts).twice
    $stdin.expects(:gets).twice.returns("  123456       ")

    @module.consumer_infos
  end

  def test_tokens
    @module.stubs(:client).returns(
      Hashie::Mash.new(
        :authentication_request_token => Hashie::Mash.new(:authorize_url => "http://foo.bar", :token => "token", :secret => "secret"),
        :authorize => Hashie::Mash.new(:token => "token", :secret => "secret")
      )
    )
    $stdin.expects(:gets).returns("verifier")
    $stdout.expects(:puts).times(4)
    File.expects(:open)

    @module.tokens
  end

  def test_congrats
    $stdout.expects(:puts).twice

    @module.congrats
  end

  def test_client
    assert_equal Fitgem::Client, @module.client.class
  end
end
