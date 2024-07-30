# frozen_string_literal: true

require "yaml"
class AddGeneralChannels
  include Strum::Service

  def call
    result_hash = {}
    channel_from_file[channel_prefix].each do |k, v|
      channel = create_channel("#{channel_prefix}_#{k}", false)
      set_topic(channel["channel"]["id"], v[0]) if v[0]
      set_purpose(channel["channel"]["id"], v[1]) if v[1]
      result_hash[channel["channel"]["name"]] = channel["ok"]
      store_channel(channel["channel"]["name"], channel["channel"]["id"])
    end
    output(message(result_hash))
  end

  private

  def audit
    required(:channel_prefix)
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

  def store_channel(name, channel_id)
    team = Team.find(name: "General")
    Channel.create(name:, team_id: team.id, channel_id:)
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
    YAML.load_file(Constants::BUSINESS_UNIT_MAPPING_PLACE)
  rescue StandardError => e
    puts e.inspect
  end
end
