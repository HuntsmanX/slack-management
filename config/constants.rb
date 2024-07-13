# frozen_string_literal: true

module Constants
  SLACK_API_TOKEN = ENV.fetch("SLACK_API_TOKEN", "")
  MAPPING_PLACE = "config/channels.yml"
  MANAGER_PASSWORD = ENV.fetch("MANAGER_PASSWORD", "")
end