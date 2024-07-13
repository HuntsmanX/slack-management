# frozen_string_literal: true

require "yaml"
class AddGeneralChannels
  include Strum::Service

  def call
    #handle error if channel_prefix not in keys
    #

    channel_from_file[channel_prefix].to_a.each do |i|
      response = SlackConfig.client.conversations_create(
        name: "#{channel_prefix}_#{i[0]}",
        is_private: false
      )
      puts "Channel created: #{response['channel']['name']} (ID: #{response['channel']['id']})"

    end
  rescue StandardError
  end


  def channel_from_file
    YAML.load_file(Constants::MAPPING_PLACE)
  rescue StandardError => e
    puts e.inspect
  end
end

