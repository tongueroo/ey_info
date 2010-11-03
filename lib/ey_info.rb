require 'right_aws'
require 'net/ssh'
require 'yaml'
require 'json'

module Ey
  class Info
    def initialize(options = {})
      @env = options[:env] || :all
      @home = ENV['HOME']
      @user = "root" # TODO: move out
      @private_key = options[:private_key] # TODO: move out
      
      @ey_cloud = "#{@home_dir}/.ey-cloud.yml"
      unless File.exist?(@ey_cloud)
        warn("You need to have an ~/.ey-cloud.yml file")
        exit(1)
      end
      @config = YAML.load(IO.read(@ey_cloud))
      
      @servers = {}
      @sessions = []
      @ec2 = setup_ec2
    end
    
    def hosts
      {}
    end
    
    def envs
      {}
    end


    def setup_ec2
      RightAws::Ec2.new(@config[:aws_secret_id], @config[:aws_secret_key])
    end
    
  end
end