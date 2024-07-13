# frozen_string_literal: true

require "yaml"
class ChannelTemplates
  include Strum::Service

  def call
    if channel_prefix.strip.empty?
      add_error(:prefix, :empty)
    else
      output(templates: channel_from_file)
    end
  end

  private

  def audit
    required(:channel_prefix)
  end

  def channel_from_file
    YAML.load_file(Constants::MAPPING_PLACE)
  rescue StandardError => e
    puts e.inspect
  end
end
