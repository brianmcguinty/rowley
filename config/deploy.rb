require 'rvm/capistrano' # Для работы rvm
require 'bundler/capistrano' # Для работы bundler. При изменении гемов bundler автоматически обновит все гемы на сервере, чтобы они в точности соответствовали гемам разработчика.
require 'capistrano-unicorn'

set :stages, %w(production production_row production_pow staging_row staging_pow production_row_hto)
set :default_stage, "staging_row"
require 'capistrano/ext/multistage'

set :application, 'rowley'
set :use_sudo, false

set :keep_releases, 3

#ssh_options[:user] = "qsuser"
#ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "qsuser@rowley.quartsoft.com")]

#set :ssh_options, {:forward_agent => true}
default_run_options[:pty] = true

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :repository,  "git@bitbucket.org:railsdrive/re.git"
#unless variables.include?(:branch)
#  set :branch, "master"
#end
set :deploy_via, :remote_cache

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"


after 'deploy:update_code', :create_symlinks

task :create_symlinks, :roles => :app do

  # Здесь для примера вставлен только один конфиг с приватными данными - data base.yml.
  # Обычно для таких вещей создают папку /srv/myapp/shared/config и кладут файлы туда.
  # При каждом деплое создаются ссылки на них в нужные места приложения.
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
  #run "rm -f #{current_release}/config/config.yml"
  #run "ln -s #{deploy_to}/shared/config/config.yml #{current_release}/config/config.yml"
  run "rm -f #{current_release}/config/unicorn.rb"
 # run "ln -s #{deploy_to}/shared/config/unicorn.rb #{current_release}/config/unicorn.rb"

  #create symlink to the directories from public folder
  run "rm -rf #{current_release}/public/spree"
  run "ln -s #{deploy_to}/shared/spree #{current_release}/public/spree"

  run "rm -rf #{current_release}/keys"
  run "ln -s #{deploy_to}/shared/keys #{current_release}/keys"
end


#before 'deploy:update_code', :prepare_site_codebase

task :prepare_site_codebase, :roles => :app do
  #system "echo 'theme_to_exclude: #{theme_to_exclude}'"
  system "bundle --without #{theme_to_exclude}"
  system 'git add .'
  system 'git commit -m "prepare Gemfile and Gemfile.lock to deploy"'
  system "git push origin #{branch}"
end


load 'deploy/assets'
before 'deploy:assets:precompile:primary', 'create_symlinks'


#after 'deploy:assets:precompile', 'precompile_overrides'


#after "deploy:assets",
after "deploy:update_code", "deploy:migrate"

#after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # app preloaded

after 'deploy', 'deploy:cleanup'


task :precompile_overrides, :roles => :app do
  run "cd #{current_release}"
  run "bundle exec rake deface:precompile"
end



# Далее идут правила для перезапуска unicorn. Их стоит просто принять на веру - они работают.
# В случае с Rails 3 приложениями стоит заменять bundle exec unicorn_rails на bundle exec unicorn
namespace :deploy do
  #task :restart do
  #  run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  #end
  #task :start do
  #  run "bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  #end
  #task :stop do
  #  run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  #end

  task :ln_assets do
    run <<-CMD
      rm -rf #{latest_release}/public/assets &&
      mkdir -p #{shared_path}/assets &&
      ln -s #{shared_path}/assets #{latest_release}/public/assets
    CMD
  end

  #task :assets do
  #  ln_assets
  #
  #  run_locally "rake assets:precompile RAILS_ENV=#{rails_env} RAILS_GROUPS=assets"
  #  run_locally "cd public; tar -zcvf assets.tar.gz assets"
  #  top.upload "public/assets.tar.gz", "#{shared_path}", :via => :scp
  #  run "cd #{shared_path}; tar -zxvf assets.tar.gz"
  #  run_locally "rm public/assets.tar.gz"
  #  run_locally "rm -rf public/assets"
  #
  #end
end
