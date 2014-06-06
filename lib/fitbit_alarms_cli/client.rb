require 'yaml'
require 'fitgem'

module FitbitAlarmsCli
  class Client
    def initialize
      raise "ERROR" unless File.exists?(Setup::AUTH_FILE_PATH)

      auth = YAML.load_file(Setup::AUTH_FILE_PATH)
      @client = Fitgem::Client.new({ :consumer_key => auth[:consumer_key],
                                     :consumer_secret => auth[:consumer_secret],
                                     :token => auth[:token],
                                     :secret => auth[:secret] })
    end

    def list_alarms(options)
      #@client.get_alarms(5528551)
    end

    def add_alarm(time, options)
      # client.add_alarm({
      #   :device_id => 12345678,
      #   :time => "12:25+02:00",
      #   :enabled => true,
      #   :weekDays => "THURSDAY",
      #   :recurring => false,
      #   :label => "BIM"
      # })
    end

    def remove_alarm(alarm_id)
      #@client.delete_alarm(alarm_id, device_id)
    end
  end
end
