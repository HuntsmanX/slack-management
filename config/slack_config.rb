# frozen_string_literal: true

require "slack-ruby-client"

module SlackConfig
  class << self
    Slack.configure do |config|
      config.token = Constants::SLACK_API_TOKEN
    end

    def client
      @client ||= Slack::Web::Client.new
    end
  end
end
