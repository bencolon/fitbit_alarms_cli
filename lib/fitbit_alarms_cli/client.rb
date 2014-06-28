require 'yaml'
require 'fitgem'

module FitbitAlarmsCli
  class Client
    MAX_ALARMS_COUNT = 8

    def initialize
      unless File.exists?(Setup::AUTH_FILE_PATH)
        puts "You haven't setup FitbitAlarmsCli."
        puts "Please run `fac setup` before."
        exit
      end

      auth = YAML.load_file(Setup::AUTH_FILE_PATH)
      unless auth[:consumer_key] && auth[:consumer_secret] && auth[:token] && auth[:secret]
        puts "FitbitAlarmsCli configuration seems corrupted."
        puts "Please run `fac setup` again."
        exit
      end

      @client = Fitgem::Client.new({ :consumer_key => auth[:consumer_key],
                                     :consumer_secret => auth[:consumer_secret],
                                     :token => auth[:token],
                                     :secret => auth[:secret] })
    end

    def list_alarms(options)
      if options[:device]
        puts_device_alarms(options[:device])
      else
        check_response(devices = @client.devices)
        devices.each do |device|
          puts_device_alarms(device['id'])
        end
      end
    end

    def add_alarm(time, options)
      device_id = options[:device] || first_device

      check_time_format(time)
      check_alarms_count(device_id)

      settings = { :device_id => device_id,
                   :time => time,
                   :enabled => true,
                   :recurring => false,
                   :weekDays => Time.now.strftime("%A").upcase
                 }

      # symbolize_keys and update weird week_days API params
      options = options.each_with_object({}) do |(k,v), h|
        k = "weekDays" if k == "week_days"
        h[k.to_sym] = v
      end

      settings.merge!(options)
      check_response(@client.add_alarm(settings))

      list_alarms(options)
    end

    def remove_alarm(alarm_id, options)
      device_id = options[:device] || first_device
      check_response(@client.delete_alarm(alarm_id, device_id))
      list_alarms(options)
    end

    private

    def first_device
      @client.devices.first["id"]
    end

    def check_time_format(time)
      unless /^\d{2}:\d{2}\+\d{2}:\d{2}$/.match(time)
        puts_and_exit "ERROR: Invalid time. Time should be HH:MM+TZ:00 formatted (ex: 23:30+02:00)."
      end
    end

    def check_alarms_count(device_id)
      alarms = @client.get_alarms(device_id)
      puts_and_exit "ERROR: You reached the maximum alarms count (8) on this device." if alarms["trackerAlarms"].count == MAX_ALARMS_COUNT
    end

    def check_response(response)
      puts_and_exit "ERROR: #{response["errors"]}" if response.is_a?(Hash) && response["errors"]
    end

    def puts_device_alarms(device_id)
      puts "Device ##{device_id}\n--------------------------------"
      check_response(response = @client.get_alarms(device_id))
      format_alarms(response["trackerAlarms"])
    end

    def format_alarms(alarms)
      puts_and_exit "  Device not found." unless alarms
      puts_and_exit "  No alarms set on this device." if alarms.empty?

      alarms.each do |alarm|
        label = alarm['label'] ? " (#{alarm['label']})" : ""
        time = alarm['time']
        day = alarm['recurring'] ? "" : today_or_tomorrow(time[0..1], time[3..4], time[5..10])
        recurring = alarm['recurring'] ? " every #{alarm['weekDays']}" : ""
        enabled = alarm['enabled'] ? 'enabled' : 'disabled'
        synced = alarm['syncedToDevice'] ? "synced" : "not synced"

        puts "  Alarm ##{alarm['alarmId']}#{label}, #{day}at #{alarm['time']}#{recurring} is #{enabled}/#{synced}."
      end
    end

    def today_or_tomorrow(h, m, tz)
      now = Time.now
      alarm = Time.new(now.year, now.month, now.day, h, m, 0, tz)
      now < alarm ? "today " : "tomorrow "
    end

    def puts_and_exit(message)
      puts message
      exit
    end
  end
end
