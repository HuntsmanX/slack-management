#!/usr/bin/env ruby
# frozen_string_literal: true


require "irb"
require "./config/env"
require "logger"
require "config/constants"
require "config/slack_config"
require "strum/service"
require "strum/pipe"


unless defined?(Unreloader)
  require "rack/unreloader"
  Unreloader = Rack::Unreloader.new(logger: Logger.new($stdout), reload: true) { SlackManagement }
end

IRB.start
