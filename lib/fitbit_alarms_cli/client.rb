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
      if options[:device]
        format_alarms(@client.get_alarms(options[:device])["trackerAlarms"])
      else
        @client.devices.each do |device|
          puts "Device ##{device['id']}"
          format_alarms(@client.get_alarms(device["id"])["trackerAlarms"])
        end
      end
    end

    def add_alarm(time, options)
      device_id = options[:device] || @client.devices.first["id"]
      settings = { :device_id => device_id, :time => time } #12:25+02:00

      settings[:enabled] = options[:enabled] if options[:enabled]
      settings[:weekDays] = options[:weekdays] if options[:weekdays]
      settings[:recurring] = options[:recurring] if options[:recurring]
      settings[:label] = options[:label] if options[:label]

      @client.add_alarm(settings)

      list_alarms(options)
    end

    def remove_alarm(alarm_id)
      device_id = options[:device] || @client.devices.first["id"]
      @client.delete_alarm(alarm_id, device_id)
      list_alarms(options)
    end

    private

    def format_alarms(alarms)
      alarms.each do |alarm|
        puts "    ##{alarm['alarmId']} at #{alarm['time']} on #{alarm['weekDays']}"
      end
    end
  end
end
