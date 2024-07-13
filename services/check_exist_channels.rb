# frozen_string_literal: true

class CheckExistChannels
  include Strum::Service

  def call
    template = templates[channel_prefix]
    if template
      channels = template.keys.map { |i| "#{channel_prefix}_#{i}" }
      result = channels.reduce({}) { |h, e| h.merge(e => channel_exists?(e)) }
      add_error(message(result), :exist) if result.values.include?(true)
    elsif template.nil?
      add_error(:no_template, :not_found)
    end
  end

  private

  def audit
    required(:channel_prefix)
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
