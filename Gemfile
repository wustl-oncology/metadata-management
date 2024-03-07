source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

gem "rails", "~> 7.1.0"

gem "sprockets-rails"

gem "pg", "~> 1.5"
gem "puma", "~> 6.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "bootsnap", require: false
gem 'octicons_helper'
gem 'kramdown'
gem 'pagy'
gem 'ransack'
gem 'json-schema'
gem 'pundit'
gem 'trestle'
gem 'requestjs-rails'
gem 'textacular'

gem "omniauth-rails_csrf_protection"
gem 'omniauth-github', '~> 2.0.1'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'pry-byebug'
end

group :development do
  gem "web-console"
  gem 'solargraph'
  gem 'solargraph-rails'
  gem "dockerfile-rails", ">= 1.2"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end


gem "solid_errors", "~> 0.3.5"

gem "solid_queue", "~> 0.2.2"

gem "mission_control-jobs", "~> 0.1.1"

gem "solid_cache", "~> 0.5.3"
