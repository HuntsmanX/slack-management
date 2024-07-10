# frozen_string_literal: true

require "roda"
require "slack-ruby-client"

unless defined?(Unreloader)
  require "rack/unreloader"
  Unreloader = Rack::Unreloader.new(reload: false)
end


# API entry point
class SlackManagement < Roda
  plugin :json
  plugin :json_parser
  plugin :all_verbs
  plugin :symbol_status
end