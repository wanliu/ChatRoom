require "yaml"

if File.exists?("config/deploy.yml")
    set :state,YAML::load(File.open("config/deploy.yml"))
    if state
        set :server_ip,state["server_ip"]
    else
        set :server_ip,nil
    end
else
    set :state, {}
end

set :application, "chatroom"
set :user, 			state["user"] 		|| "root" 
set :password, 		state["password"] 	|| "321654"
set :repository, 	state["git"] 		|| "git@github.com:wanliu/ChatRoom.git"
set :domain, 		state["server_ip"] 	|| "192.168.2.31"

set :branch do
  default_tag = `git tag`.split("\n").last
  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first): [#{default_tag}] "
  tag = default_tag if tag.empty?
  tag
end 

default_run_options[:pty] = true 

set :use_sudo,false
set :scm,"git"
set :scm_user,"root"
set :scm_passphrase,"asdfasdf"           
set :deploy_to,     state["deploy_to"]  || "/var/www/#{application}"

#set :branch,       state["branch"]     || "master"

set :rails_env,     state["rails_env"]  || 'production'

role :web, domain
role :app, domain
role :db, domain, :primary => true


set :rvm_path,"/usr/local/rvm"
set :rvm_bin_path,"/usr/local/rvm/bin"
set :rvm_ruby_string, state["ruby_string"] || 'ruby-1.9.3'   

require 'rvm/capistrano'
require "bundler/capistrano" 

namespace :deploy do

    task :start, :roles => :app do
        run "touch #{current_path}/tmp/restart.txt" 
    end

    desc "Restart Application"

    task :restart, :roles => :app do
        run "touch #{current_path}/tmp/restart.txt" 
    end

end


before 'deploy:setup' do 
    run 'echo insecure > ~/.curlrc', :shell => 'bash -c'
    find_and_execute_task "rvm:install_rvm"
    find_and_execute_task 'rvm:install_ruby'
end

after 'deploy' do
    run "mkdir -p #{release_path}/public/uploads"
    run "chown -R nobody:nobody #{release_path}/tmp"
    run "chown -R nobody:nobody #{release_path}/log"
    run "chown -R nobody:nobody #{shared_path}/log/"
    run "chown -R nobody:nobody #{release_path}/public/uploads"
end

before 'deploy:assets:precompile' do
    find_and_execute_task "deploy:assets:clean"
end

namespace :chatroom_setup do
    desc "load setup rake task"
    task :loads,:roles  =>  :app do
    # run "cd  #{current_path} && rake RAILS_ENV=production setup --trace"
    end
end

after 'deploy:migrate', 'chatroom_setup:loads'
after 'deploy:restart', 'deploy:migrate'
load 'deploy/assets'

