# frozen_string_literal: true

require "./config/env"
dev = ENV["RACK_ENV"] == "development"

if dev
  require "logger"
  logger = Logger.new($stdout)
end

require "rack/unreloader"
Unreloader = Rack::Unreloader.new(subclasses: %w[Roda],
                                  logger:,
                                  reload: dev) { SlackManagement }

Unreloader.require("config/app.rb") { "SlackManagement" }
run(dev ? Unreloader : SlackManagement.freeze.app)
