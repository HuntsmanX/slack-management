# frozen_string_literal: true

source "https://rubygems.org"

ruby ">= 3.2.2"

gem "irb", "~> 1.3"
gem "puma", "~> 6.4.1"
gem "rake", "~> 12.0"
gem "roda", "3.81.0"
gem 'slack-ruby-bot'
gem 'async-websocket', '~>0.8.0'


group :development do
  gem "rubycritic", "~> 4.8", ">= 4.8.1", require: false
  gem "rubocop", "~> 1.56", ">= 1.56.1", require: false
end

group :development, :test do
  gem "byebug", "~> 11.1", platforms: %i[mri mingw x64_mingw]
  gem "pry", "~> 0.14"
  gem "rspec", "~> 3.12"
  gem "ruby-debug-ide", "~> 0.7"
  gem "dotenv", "~> 2.7"
end

