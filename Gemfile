source 'https://rubygems.org'
ruby '2.2.8'

gem 'rails', '~> 5.0.0'

gem 'unicorn'
gem 'capistrano', '~> 2.15', '>= 2.15.9'
# gem 'capistrano'
gem 'rvm-capistrano', require: false

gem 'sass-rails', '~> 5.0'
gem 'slim'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.7'
# gem 'jbuilder', '~> 1.2'
gem 'yajl-ruby'

group :doc do
  gem 'sdoc', require: false
end

gem 'mysql2'
gem 'net-ldap', git: 'git://github.com/ruby-ldap/ruby-net-ldap.git', branch: 'master'

gem 'sentry-raven'

# gem 'activerecord', '~> 5.0.0'
gem 'activemodel-serializers-xml', '~> 1.0'

# devise
gem 'devise', '~> 4'
gem 'devise_invitable'
gem 'devise_ldap_authenticatable'
gem 'cancan'

gem 'bootstrap-sass', '~> 3.1.0'
gem 'active_link_to'
gem 'figaro', github: 'laserlemon/figaro'
gem 'rolify', github: 'EppO/rolify'
gem 'draper', '~> 3'
# gem 'draper', '~> 1.0'
gem 'simple_form', git: 'git://github.com/plataformatec/simple_form.git'
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'
gem 'whenever'
gem 'nokogiri', '~> 1.6', '>= 1.6.8.1'
gem 'redcarpet'
gem 'validate_url'
gem 'paperclip', '~> 4.1'
gem 'rails-settings-cached', '0.3.1'

# time helpers
gem 'chronic'
gem 'tod'
gem 'ice_cube'
gem 'ri_cal'

group :development do
  gem 'guard', '>=2.1.0'
  gem 'unicorn-rails'
  gem 'better_errors'
  gem 'annotate', '>= 2.5.0'
  gem 'binding_of_caller'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'haml-rails'
  gem 'haml2slim'
  gem 'html2haml'
# gem 'quiet_assets'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'letter_opener'
end

group :development, :test do
  gem 'simplecov', require: false
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor' # For asset compilation
end

# optional, only useful for playlists/AudioVault: `bundle install --without=oracle`
# https://github.com/wrekatlanta/wrektranet/wiki/Installing-Oracle-adapters
group :oracle do
  gem 'activerecord-oracle_enhanced-adapter', '~> 1.7.0'
# gem 'activerecord-oracle_enhanced-adapter', git: 'git://github.com/rsim/oracle-enhanced.git'
  gem 'ruby-oci8', '~> 2.1.0'
end
