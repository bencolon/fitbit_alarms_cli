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

    desc "setup", "Run the setup of Fitbit Alarms CLI"
    long_desc <<-LONGDESC
      Guide you to setup Fitbit Alarms CLI across authentication process.
    LONGDESC
    def setup
      Setup.start
    end

    desc "list", "List all alarms"
    long_desc <<-LONGDESC
      List all Fitbit alarms. By default, list all alarms from ALL you devices.

      With -D option, you can specify a device ID to get only device's alarms.
    LONGDESC
    option :device, :aliases => :"-D", :type => :numeric
    def list
      client = Client.new
      client.list_alarms(options)
    end

    desc "add TIME", "Add a new alarm"
    long_desc <<-LONGDESC
      Add a new alarm with <time>. <time> should be HH:MM+TZ:00 formatted.
  \x5 By default, the new alarm is assigned to the first device with these settings: today, enabled and no recurring.

      With -e option, you can enabled/disabled the alarm (true or false).

      With -d option, you can set the day(s) the alarm will be active for recurring alarm only.
  \x5 You have to pass coma separated values (MONDAY,FRIDAY,...).

      With -r option, you can set if it's a one time alarm or a recurring alarm (true or false).

      With -l option, you can add a label to the alarm.
  \x5 Unfortunately, this label will not be displayed on you're Fitbit :(
  \x5 I really hope this feature will be added asap to the Fitbit firmware.

      With -D option, you can specify a device ID to specify on which device the alarm has to be added.
    LONGDESC
    option :enabled,   :aliases => :"-e", :type => :boolean
    option :week_days, :aliases => :"-d", :type => :array
    option :recurring, :aliases => :"-r", :type => :boolean
    option :label,     :aliases => :"-l", :type => :string
    option :device_id, :aliases => :"-D", :type => :numeric
    def add(time)
      client = Client.new
      client.add_alarm(time, options)
    end

    desc "remove ALARM_ID", "Remove an alarm"
    long_desc <<-LONGDESC
      Remove the alarm with the corresponding <alarm_id>.
  \x5 By default, try to remove the alarm from the first device.

      With -D option, you can specify the device ID from where the alarm has to be removed.
    LONGDESC
    option :device, :aliases => :"-D", :type => :numeric
    def remove(alarm_id)
      client = Client.new
      client.remove_alarm(alarm_id, options)
    end
  end
end
