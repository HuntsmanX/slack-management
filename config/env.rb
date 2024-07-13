# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("..", __dir__), File.expand_path("../lib", __dir__))

ENV["ROOT"] = __dir__

unless ENV["RACK_ENV"] == "production"
  ENV["RACK_ENV"] ||= "development"
  require "pry"
  require "dotenv"
  Dotenv.load(".env.#{ENV['RACK_ENV'].downcase}", ".env.local")
end

ENV["STRUM_ROOT"] = File.expand_path("..", __dir__)
