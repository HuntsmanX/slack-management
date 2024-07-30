# frozen_string_literal: true

require "yaml"
class AddTeamChannels
  include Strum::Service

  def call
    result_hash = {}
    needed_channels_full.each do |i|
      channel = create_channel(i, false)
      name = i.match(/_([^_]+)$/)[1]
      set_topic(channel["channel"]["id"], name) if name
      set_purpose(channel["channel"]["id"], name) if name
      store_channel(name, team_id, channel["channel"]["id"])
      result_hash[channel["channel"]["name"]] = channel["ok"]
    end
    output(message(result_hash))
  end

  private

  def audit
    required(:needed_channels, :team_id, :business_account_id, :needed_channels_full)
  end

  def store_channel(name, team_id, channel_id)
    Channel.create(name:, team_id:, channel_id:)
  end

  def message(hash)
    message = String.new("These channels were created\n")
    message << "----------------------------\n"
    message << "channel | Value\n"
    message << "----------------------------\n"
    hash.each do |key, value|
      message << "#{key} | #{value}\n"
    end
    message
  end

  def create_channel(name = "piu", private = false)
    response = SlackConfig.client.conversations_create(name:, is_private: private)
    puts "Channel created: #{response['channel']['name']} (ID: #{response['channel']['id']})"
    response
  end

  def set_topic(channel, topic)
    SlackConfig.client.conversations_setTopic(channel:, topic:)
    puts "Channel topic set."
  end

  def set_purpose(channel, purpose)
    SlackConfig.client.conversations_setPurpose(channel:, purpose:)
    puts "Channel purpose set."
  end

  def channel_exists?(channel_name)
    response = client.conversations_list(types: "public_channel,private_channel")
    channels = response["channels"]
    channels.any? { |channel| channel["name"] == channel_name }
  end

  def channel_from_file
    YAML.load_file(Constants::TEAM_UNIT_MAPPING_PLACE)
  rescue StandardError => e
    puts e.inspect
  end
end
