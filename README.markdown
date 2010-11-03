Ey Info
=======

Summary
-------
Provides more detailed information about your ey environments.  Quickly set up your ~/.ssh/config shortcuts.

Install
-------

<pre>
gem install --no-ri --no-rdoc ey_info # sudo if you need to
</pre>

Usage Command Line
-------

<pre>
# information about all of your environments
$ ey_info list
$ ey_info hosts
$ ey_info uptime
$ ey_info describe <instance-id>

# information only about one environment
$ ey_info -e beta uptime
</pre>

Usage Quickly Setup Your .ssh/config shortcuts
-------

I like to be able to go

<pre>
$ ssh prod_app0
vs
$ ssh -i ~/.ssh/id-rsa-flex-br root@ec2-xxx-xxx-xxx-xxx.compute-1.amazonaws.com
</pre>

$ ey_info setup # will set up your ~/ssh/config shortcuts.

Usage With Capistrano
-------

I still find capistrano a very useful utility for debugging and still use wanted to use it with EY's cloud.

<pre>
$ cap invoke COMMAND="..." is extremely useful.
</pre>

So, you can use this gem to dynammically grab the ec2 hosts information from your ey environment and set up your
capistrano roles.  

Here are a few examples of how you can use it in your config/deploy.rb:

<pre>
require 'ey_info'
task :production do
  ey_env_name = "prod1" # this is the environment name in EY's gui interface
  ey_info = EyInfo.new(:env => ey_env_name, :private_key => "~/.ssh/id-rsa-flex-key")

  role :db, ey_info.app_master, :primary => true
  # web and app instances
  ey_info.apps.each do |info|
    role :web, info.host
    role :app, info.host, :sphinx => true
  end

  # utility instances
  ey_info.utils.each do |info|
    role :app, info.host, :sphinx => true
  end
end
</pre>

If you have some different usages for your EY utility instances, you filter the utils instances.


<pre>
require 'ey_info'
task :production do
  ey_env_name = "prod1" # this is the environment name in EY's gui interface
  ey_info = EyInfo.new(:env => ey_env_name, :private_key => "~/.ssh/id-rsa-flex-key")

  role :db, ey_info.app_master, :primary => true
  # web and app instances
  ey_info.apps.each do |info|
    role :web, info.host
    role :app, info.host, :sphinx => true
  end

  # utility instances
  ey_info.utils.select{|i| i.name =~ /sphinx/ }.each do |info|
    role :app, info.host, :sphinx => true
  end
  ey_info.utils.select{|i| i.name =~ /cron/ }.each do |info|
    role :app, info.host, :sphinx => false
  end
end
</pre>

If you have already set up your ~/.ssh/config with ey_info setup

<pre>
require 'ey_info'
task :production do
  ey_env_name = "prod1" # this is the environment name in EY's gui interface
  ey_info = EyInfo.new(:env => ey_env_name, :private_key => "~/.ssh/id-rsa-flex-key")

  role :db, ey_info.app_master, :primary => true
  # web and app instances
  ey_info.apps.each do |info|
    role :web, info.ssh_shortcut
    role :app, info.ssh_shortcut, :sphinx => true
  end

  # utility instances
  ey_info.utils.select{|i| i.name =~ /sphinx/ }.each do |info|
    role :app, info.ssh_shortcut, :sphinx => true
  end
  ey_info.utils.select{|i| i.name =~ /cron/ }.each do |info|
    role :app, info.ssh_shortcut, :sphinx => false
  end
end
</pre>

