require "thor"
require "fitbit_alarms_cli/version"
require "fitbit_alarms_cli/setup"
require "fitbit_alarms_cli/client"

module FitbitAlarmsCli
  class Commands < Thor
    desc "version", "Fitbit Alarms CLI version"
    def version
      puts "Fitbit Alarms CLI - v#{VERSION}"
    end

    desc "setup", "Start the setup of Fitbit Alarms CLI"
    def setup
      Setup.run
    end

    desc "list", "List all alarms"
    option :device, :aliases => :"-D"
    def list
      client = Client.new
      client.alarms(options)
    end

    desc "add", "Add a new alarm"
    option :enabled,   :aliases => :"-e"
    option :week_days, :aliases => :"-d"
    option :recurring, :aliases => :"-r"
    option :label,     :aliases => :"-l"
    option :device,    :aliases => :"-D"
    def add(time)
      client = Client.new
      client.add_alarm(time, options)
    end

    desc "remove", "Remove an alarm"
    def remove(alarm_id)
      client = Client.new
      client.remove_alarm(alarm_id)
    end
  end
end
