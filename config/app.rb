# frozen_string_literal: true

require "roda"
require "strum/service"
require "strum/pipe"
require "config/constants"
require "config/sequel"
require "config/models"
require "slack-ruby-client"
require "config/slack_config"

unless defined?(Unreloader)
  require "rack/unreloader"
  Unreloader = Rack::Unreloader.new(reload: false)
end
Unreloader.require("services")
Unreloader.require("helpers")

# API entry point
class SlackManagement < Roda
  plugin :json
  plugin :json_parser
  plugin :all_verbs
  plugin :symbol_status
  plugin :hash_routes
  Unreloader.require("routes") { }

  route do |r|
    @data = {

      path: r.path,
      method: r.request_method.to_s.downcase.to_sym,
      params: r.params,
      content_type: r.content_type,
    }
    r.hash_routes
  end

  def send_back(response_url, data)
    content = { text: "```\n#{data}\n```"}.to_json
    Faraday.post(response_url, content, "Content-Type" => "application/json")
  end
end
