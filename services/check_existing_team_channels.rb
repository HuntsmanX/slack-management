# frozen_string_literal: true

class CheckExistingTeamChannels
  include Strum::Service

  def call
    unit_name = BusinessUnit.find(id: business_account_id).name.downcase
    team_name = Team.find(id: team_id).name.downcase
    team_name.gsub!(" ", "_") if team_name.include?(" ")
    channels_names = needed_channels.map { |i| "#{unit_name}_#{team_name}_#{i}" }
    result = channels_names.reduce({}) { |h, e| h.merge(e => channel_exists?(e)) }
    if result.values.include?(true)
      add_error(message(result), :exist)
    else
      output(needed_channels_full: channels_names)
    end
  end

  private

  def audit
    required(:team_id, :needed_channels, :business_account_id)
  end

  def message(hash)
    message = String.new("These channels exist\n")
    message << "----------------------------\n"
    message << "channel | Value\n"
    message << "----------------------------\n"
    hash.each do |key, value|
      message << "#{key} | #{value}\n"
    end
    message
  end

  def channel_exists?(channel_name)
    response = SlackConfig.client.conversations_list(types: "public_channel,private_channel")
    channels = response["channels"]
    channels.any? { |channel| channel["name"] == channel_name }
  end
end
