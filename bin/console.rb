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
  Unreloader = Rack::Unreloader.new(subclasses: %w[Sequel::Model],
                                    logger: Logger.new($stdout),
                                    reload: true) { SlackManagement }
end

require "config/sequel"
Unreloader.require("models") { |f| Sequel::Model.send(:camelize, File.basename(f).sub(/.rb\z/, "")) }

IRB.start
