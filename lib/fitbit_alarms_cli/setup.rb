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
      intro
      consumer_infos
      tokens
      congrats

      rescue Exception => e
        puts "An error has ocurred during authentication. Please try again."
        puts e.message
        #puts e.backtrace.inspect
    end

    def self.intro
      puts "First, go register a new Fitbit application at https://dev.fitbit.com/apps/new"
      puts "Fill the form and come back"
      puts "Press a key to continue..."
      $stdin.gets
    end

    def self.consumer_infos
      begin
        puts "Enter the consumer key you got and press enter:"
      end while (key = $stdin.gets.strip).empty?
      auth[:consumer_key] = key

      begin
        puts "Enter the consumer secret you got and press enter:"
      end while (secret = $stdin.gets.strip).empty?
      auth[:consumer_secret] = secret
    end

    def self.tokens
      request_token = client.authentication_request_token

      puts "Your application is now set up, you now have to authorize this app access you data."
      puts "Visit the following link, log in if needed, and then authorize the app."
      puts request_token.authorize_url

      puts "When you've authorized that app, enter the verifier code you got and press enter:"
      verifier = $stdin.gets.strip
      access_token = client.authorize(request_token.token, request_token.secret, :oauth_verifier => verifier)
      auth[:token] = access_token.token
      auth[:secret] = access_token.secret

      File.open(AUTH_FILE_PATH, "w") {|f| YAML.dump(auth, f) }
    end

    def self.congrats
      puts "Congrats, FitbitAlarmsCli is setup!"
      puts "Have a look to the help to enjoy it: `fac help`"
    end

    def self.auth
      @auth ||= {}
    end

    def self.client
      @client ||= Fitgem::Client.new({ :consumer_key => auth[:consumer_key],
                                       :consumer_secret => auth[:consumer_secret] })
    end
  end
end
