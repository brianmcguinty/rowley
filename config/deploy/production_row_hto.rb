set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, 'rowley_hto'
set :rails_env, "production"
set :branch, "develop"
set :user, "ubuntu"
set :domain, "ubuntu@54.245.96.201" # Это необходимо для деплоя через ssh. Именно ради этого я настоятельно советовал сразу же залить на сервер свой ключ, чтобы не вводить паролей.
set :ssh_options, {:forward_agent => true, :keys => [File.join(ENV["HOME"], ".ssh", "rowley_shop.pem")], :user=>'ubuntu'}
#set :deploy_to, "/home/#{application}/www"
set :deploy_to, "/home/#{user}/www/#{application}"
set :rvm_ruby_string, '1.9.3' # Это указание на то, какой Ruby интерпретатор мы будем использовать.
set :rvm_type, :user # Указывает на то, что мы будем использовать rvm, установленный у пользователя, от которого происходит деплой, а не системный rvm.
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :unicorn_env, 'production_row_hto'

role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :theme_to_exclude, 'mr_powers'
set :bundle_without, [:development, :test, theme_to_exclude.to_sym]