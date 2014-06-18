module FitbitAlarmsCli
  module Setup
    AUTH_FILE_PATH = "#{Dir.home}/.fitbit_alarms_cli"

    def self.start
      if File.exists?(AUTH_FILE_PATH)
        puts "You already setup FitbitAlarmsCli."
        puts "Are you sure you want to setup it again? yes/no"
        response = $stdin.gets
        exit if response.strip != "yes"
      end
      run
    end

    private

    def self.run
      @auth = {}

      intro
      consumer_infos
      tokens
      congrats
    end

    def self.intro
      puts "First, go register a new Fitbit application at https://dev.fitbit.com/apps/new"
      puts "Fill the form and come back"
      puts "Press a key to continue..."
      $stdin.gets
    end

    def self.consumer_infos
      puts "Enter the consumer key you got and press enter:" until key = $stdin.gets.strip
      @auth[:consumer_key] = key

      puts "Enter the consumer secret you got and press enter:" until secret = $stdin.gets.strip
      @auth[:consumer_secret] = secret

      @client = Fitgem::Client.new({ :consumer_key => @auth[:consumer_key],
                                     :consumer_secret => @auth[:consumer_secret] })
    end

    def tokens
      request_token = @client.authentication_request_token

      puts "Your application is now set up, you now have to authorize this app access you data."
      puts "Visit the following link, log in if needed, and then authorize the app."
      puts request_token.authorize_url

      puts "When you've authorized that app, enter the verifier code you got and press enter:"
      verifier = $stdin.gets.strip
      access_token = @client.authorize(request_token.token, request_token.secret, :oauth_verifier => verifier)
      @auth[:token] = access_token.token
      @auth[:secret] = access_token.secret

      File.open(AUTH_FILE_PATH, "w") {|f| YAML.dump(@auth, f) }
    end

    def congrats
      puts "Congrats, FitbitAlarmsCli is setup!"
      puts "Have a look to the help to enjoy it: `fac help`"
    end
  end
end
