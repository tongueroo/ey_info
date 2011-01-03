Ey Info
=======

Summary
-------
Quickly set up your ~/.ssh/config shortcuts for your ey cloud servers.

Install
-------

<pre>
gem install --no-ri --no-rdoc ey_info # sudo if you need to
</pre>

Usage Command Line
-------

<pre>
# will set up your ~/ssh/config shortcuts.
$ ey_info -i "id_rsa" -u "root" # same as defaults
$ ey_info # same as above
</pre>

If you're environment in the ey cloud dashboard is called 'production' with an app_master, and 2 app instances.

<pre>
$ ssh production_app_master
vs
$ ssh -i ~/.ssh/id-rsa root@ec2-xxx-xxx-xxx-xxx.compute-1.amazonaws.com

$ ssh production_app1
$ ssh production_app2
$ ssh production_db_master
$ ssh production_db_slave1
</pre>

Usage With Capistrano
-------

I still find capistrano a very useful utility for debugging and still use wanted to use it with EY's cloud.

<pre>
$ cap invoke COMMAND="..." is extremely useful.  The engineyard gem provides a 
"ey ssh 'uptime' --all -e production" command but it loops through the servers one by one instead of running
the commands in parallel, which can be slow if you have lots of servers.
</pre>

You can use this gem to dynamically grab the ec2 hosts information from your ey environment and set up your
capistrano roles.  

Here are a few examples of how you can use it in your config/deploy.rb:

<pre>
require 'ey_info'
task :production do
	@info = EyInfo::Hosts.new
  hosts = @info.hosts("production") # parameter is the environment name in EY's gui interface

  role :db, hosts.find {|x| x[:role] == "app_master" }[:ssh_key], :primary => true
  # app instances
  hosts.select {|x| x[:role] =~ /app/ }.each do |h|
    role :web, h[:ssh_key]
    role :app, h[:ssh_key], :sphinx => true
  end
  # utility instances
  hosts.select {|x| x[:role] =~ /util/ }.each do |h|
    role :web, h[:ssh_key]
    role :app, h[:ssh_key], :sphinx => true
  end
end
</pre>

