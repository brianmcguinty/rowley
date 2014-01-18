source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.4'
end

gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-migrate-rails' # to fix compatibility with old scripts
gem 'capistrano'
gem 'rvm-capistrano'
gem 'capistrano-unicorn'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# To use debugger
# gem 'debugger'
gem 'spree', '1.3.2'
gem 'spree_gateway', :github => 'spree/spree_gateway', :branch => '1-3-stable'
gem 'spree_auth_devise', :github => 'spree/spree_auth_devise', :branch => '1-3-stable'
gem 'spree_reviews', :github => 'spree/spree_reviews', :branch => '1-3-stable'
gem 'spree_multi_domain', :github => 'spree/spree-multi-domain', :branch => '1-3-stable'
# gem 'spree_multi_domain', :github => 'd0m0v0y/spree-multi-domain'

group :rowley do
  gem 'spree_rowley_theme', :path => 'spree_rowley_theme'
end

group :mr_powers do
  gem 'spree_mr_powers_theme', :path => 'spree_mr_powers_theme'
end

gem 'spree_static_content', :github => 'spree/spree_static_content', :branch => '1-3-stable'
gem 'spree_locked_orders', :path => 'spree_locked_orders'
gem 'spree_lens_prescriptions', :path => 'spree_lens_prescriptions'
#gem 'spree_home_page', :path => 'spree_home_page'
gem 'spree_banner', :github => 'd0m0v0y/spree_banner'
#gem 'spree_banner', :path => '../spree_banner'
gem 'spree_simple_sales', :path => 'spree_simple_sales'

gem 'deface', :github => 'spree/deface'

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails', :require => false
  gem 'awesome_print'
  gem 'exceptional'
  gem 'letter_opener'
end

group :test do
  gem 'spork'
  gem 'database_cleaner'
end

group :development do
  gem 'pry'
  gem 'pry-stack_explorer'
  #gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'timecop'
end

group :production, :staging do
  # Use unicorn as the web server
  gem 'unicorn'
  gem 'exception_notification', :github => 'smartinez87/exception_notification'
  #gem 'memcache-client'
end

# gem 'spree_flexi_variants', :github=>'jsqu99/spree_flexi_variants', :branch => 'spree-1-3-stable'
gem 'ffaker'
gem 'spree_shipworks', :github=>'d0m0v0y/spree_shipworks'
#gem 'spree_shipworks', :path => '../spree_shipworks'

gem 'spree_mail_chimp', :github => 'd0m0v0y/spree-mail-chimp'
#gem 'spree_mail_chimp', :path => '../spree-mail-chimp'

gem 'spree_store_credits', :github => 'spree/spree_store_credits', :branch => '1-3-stable'

gem 'whenever', :require => false

gem 'jquery-form-rails', '~> 1.0.0'

gem 'fancybox2-rails'
gem 'jQuery-URL-Parser-Rails', :github => 'd0m0v0y/jQuery-URL-Parser-Rails'
gem 'symmetric-encryption'
# gem 'spree_advanced_reporting', :path => 'spree_advanced_reporting'
gem 'spree_additional_reporting', :path => 'spree_additional_reporting'
gem 'csv_builder', :git => 'git://github.com/teambox/csv_builder.git'

