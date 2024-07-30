# frozen_string_literal: true

class AddPeople
  include Strum::Service

  def call
    users_data = []
    chanels_data = Team.find(id: team_id).channels_dataset.select(:channel_id, :name).map do |channel|
      channel.values
    end
    emails.split(",").each do |i|
      email = i.gsub(/[^\w@.]/, "")
      user = find_person_by_email(email)
      if user && chanels_data
        add_to_channels(user, chanels_data)
        users_data << i
        output(message: message(chanels_data, users_data))
      elsif chanels_data.empty?

      end
    end
  end

  def find_person_by_email(email)
    response = SlackConfig.client.users_lookupByEmail(email:)
    response["user"]
  rescue Slack::Web::Api::Errors::SlackError => e
    if e.message == "users_not_found"
      puts "Error: User with email #{email} not found."
      nil
    else
      puts "Error: #{e.message}"
      nil
    end
  end

  def add_to_channels(user, channels_data)
    channel_ids = channels_data.map { |channel| channel[:channel_id] }
    channel_ids.each do |i|
      response = SlackConfig.client.conversations_invite(channel: i, users: user["id"])
      if response.ok
        puts "User successfully invited to the channel."
      else
        puts "Failed to invite user: #{response.error}"
      end
    rescue Slack::Web::Api::Errors::SlackError => e
      puts "Error: #{e.message}"
    end
  end

  def message(channels, user_emails)
    message = String.new("These Users were Added to the channels\n")
    message << "----------------------------\n"
    message << "channel | user email\n"
    message << "----------------------------\n"
    user_emails_str = user_emails.join(", ")
    channels.each do |channel|
      message << "#{channel[:name]} | #{user_emails_str}\n"
    end
    message
  end

  def audit
    required(:emails, :team_id)
  end
end
