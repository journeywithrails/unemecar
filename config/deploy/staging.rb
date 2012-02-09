set :application, "staging.racemenu.com"
set :deploy_to, "/home/#{user}/domains/#{application}"
set :mongrel_pid, "10020"
set :env, "development"
