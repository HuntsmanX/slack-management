# frozen_string_literal: true

source "https://rubygems.org"

ruby ">= 3.2.2"

gem "async-websocket", "~>0.8.0"
gem "irb", "~> 1.3"
gem "puma", "~> 6.4.1"
gem "rack-unreloader"
gem "rake", "~> 12.0"
gem "roda", "3.81.0"
gem "slack-ruby-bot"

group :strum do
  gem "strum-pipe", "~> 0.0.4"
  gem "strum-pipeline", "~> 0.1.3"
  gem "strum-service", "~> 0.2.1"
end

group :development do
  gem "rubocop", "~> 1.56", ">= 1.56.1", require: false
  gem "rubycritic", "~> 4.8", ">= 4.8.1", require: false
end

group :development, :test do
  gem "byebug", "~> 11.1", platforms: %i[mri mingw x64_mingw]
  gem "dotenv", "~> 2.7"
  gem "pry", "~> 0.14"
  gem "rspec", "~> 3.12"
  gem "ruby-debug-ide", "~> 0.7"
end
