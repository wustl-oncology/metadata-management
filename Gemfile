source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~>3.3.0'

gem 'rails', '~> 8.0.0'

gem 'sprockets-rails'

gem 'bootsnap', require: false
gem 'importmap-rails'
gem 'jbuilder'
gem 'json-schema'
gem 'kramdown'
gem 'octicons_helper'
gem 'omniauth-github', '~> 2.0.1'
gem 'omniauth-rails_csrf_protection'
gem 'pagy'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.0'
gem 'pundit'
gem 'ransack'
gem 'requestjs-rails'
gem 'stimulus-rails'
gem 'textacular'
gem 'trestle'
gem 'turbo-rails'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'dockerfile-rails', '>= 1.2'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

gem 'mission_control-jobs'
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_errors'
gem 'solid_queue'

gem "openssl", "~> 3.3"
