require 'yaml'
require 'rubygems'
gem 'engineyard', '1.4.17'
require 'engineyard'
require 'optparse'
require 'erb'
require 'pp'
require File.expand_path("../version", __FILE__)
require File.expand_path("../text_injector", __FILE__)

module EyInfo
  class CLI
    def self.run(args)
      cli = new(args)
      cli.parse_options!
      cli.run
    end
    
    # The array of (unparsed) command-line options
    attr_reader :args
    # The hash of (parsed) command-line options
    attr_reader :options
    
    def initialize(args)
      @args = args.dup
    end
    
    def option_parser
      # @logger = Logger.new
      @option_parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} ssh_config"
    
        opts.on("-i", "--identity-file [IDENTITY_FILE]", "ssh key default id_rsa.") do |value|
          options[:ssh_key] = value
        end
    
        opts.on("-u", "--user [USER]", "ssh key default root.") do |value|
          options[:user] = value
        end
    
        opts.on("-t", "--template [TEMPLATE]", "path to template.") do |value|
          options[:template] = value
        end
    
        opts.on("-h", "--help", "Display this help message.") do
          puts opts
          exit
        end
    
        opts.on("-V", "--version",
          "Display the ey_info version, and exit."
        ) do
          puts "EyInfo Version #{EyInfo::Version}"
          exit
        end
    
      end
    end
    
    def parse_options!
      # defaults
      @options = {:actions => [], :user => 'root', :ssh_key => 'id_rsa'}
    
      if args.empty?
        warn "Please specifiy an action to execute."
        warn option_parser
        exit 1
      end
    
      option_parser.parse!(args)
      extract_environment_variables!
    
      options[:actions].concat(args)
    end
    
    # Extracts name=value pairs from the remaining command-line arguments
    # and assigns them as environment variables.
    def extract_environment_variables! #:nodoc:
      args.delete_if do |arg|
        next unless arg.match(/^(\w+)=(.*)$/)
        ENV[$1] = $2
      end
    end
    
    def run
      write_ssh_config
      puts "Your #{ENV['HOME']}/.ssh/config now has shortcuts your ey cloud servers."
    end
    
    def write_ssh_config
      @ssh_config = "#{ENV['HOME']}/.ssh/config"
      @info = EyInfo::Hosts.new
      
      # clear out old known_hosts
      `grep -v 'compute-1.amazonaws.com' ~/.ssh/known_hosts > ~/.ssh/known_hosts.tmp`
      `mv ~/.ssh/known_hosts.tmp ~/.ssh/known_hosts`
      
      # for erb template
      @identify_file = "~/.ssh/#{options[:ssh_key]}"
      @user = options[:user]
      
      if File.exist?(@ssh_config)
        injector = TextInjector.new(
          :file => @ssh_config,
          :update => true,
          :content => ssh_servers
        )
      else
        injector = TextInjector.new(
          :file => @ssh_config,
          :write => true,
          :content => ssh_servers
        )
      end
      injector.run
    end
    
    def ssh_servers
      @hosts = {}
      @info = EyInfo::Hosts.new
      all_hosts = @info.all_hosts
      all_hosts.keys.each do |env_name|
        all_hosts[env_name].each do |server|
          @hosts["#{server[:ssh_key]}"] = server[:hostname]
        end
      end
      path = options[:template] || File.expand_path("../templates/default_ssh_config.erb", __FILE__)
      content = IO.readlines(path).join("")
      template = ERB.new(content)
      template.result(binding)
    end
    
  end
  
  class Hosts
    def initialize(options = {})
      path = File.expand_path("~/.eyrc")
      if File.exist?(path)
        @api_token = YAML.load_file(File.expand_path("~/.eyrc"))["api_token"]
      else
        raise "~/.eyrc file does not exist, need to run 'engineyard environments' at least once and log in"
      end
      @api = EY::API.new(@api_token)
      @envs = @api.environments.to_a
    end
    
    def all_hosts
      hosts = {}
      @envs.map{|x| x.name}.sort.uniq.each do |env_name, index|
        env_name = env_name.to_sym
        arr = []
        app_count = 0
        db_count  = 0

        @api.environments.match_one!(env_name.to_s).instances.sort_by {|x| x.hostname}.each do |i, idx|
          # if i.role == 'app_master'
          #   key = "app0"
          # elsif i.role == 'app'
          #   app_count += 1
          #   key = "app#{app_count}"
          # elsif i.role == 'db_master'
          #   key = "db0"
          # elsif i.role == 'db_slave'
          #   db_count += 1
          #   key = "db#{db_count}"
          # elsif i.role == 'util'
          #   key = "#{i.name}"
          # elsif i.role == 'solo'
          #   key = "solo"
          # end
          
          key = i.role == 'util' ? i.name : i.role
          if key == 'app'
            app_count += 1
            key = "app#{app_count}"
          elsif key == 'db_slave'
            db_count += 1
            key = "db_slave#{db_count}"
          end
          
          arr << {
            :ssh_key => "#{env_name}_#{key}",
            :hostname => i.hostname,
            :role => i.role,
            :name => i.name
          }
        end
        
        hosts[env_name] = arr
      end
      hosts
    end
    
    def hosts(env_name)
      all_hosts[env_name.to_sym]
    end
    
  end
end