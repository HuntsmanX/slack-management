# frozen_string_literal: true

module Constants
  SLACK_API_TOKEN = ENV.fetch("SLACK_API_TOKEN", "")
  BUSINESS_UNIT_MAPPING_PLACE = "config/templates/business_unit_channels.yml"
  TEAM_UNIT_MAPPING_PLACE = "config/templates/team_channels_template.yml"
  MANAGER_PASSWORD = ENV.fetch("MANAGER_PASSWORD", "")
end