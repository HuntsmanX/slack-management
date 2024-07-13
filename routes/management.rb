# frozen_string_literal: true

class SlackManagement
  hash_branch "slack" do |req|
    req.on("users") do
      req.is(method: :get) do
        users = SlackConfig.client.users_list
        users.members.map do |user|
          {
            id: user.id,
            name: user.name,
            real_name: user.real_name,
            is_bot: user.is_bot
          }
        end
      rescue Slack::Web::Api::Errors::SlackError => e
        { error: e.message }
      end
    end

    req.on("commands") do
      payload = req.params
      if payload["command"] == "/add_general_channels"
        Strum::Pipe.call(ChannelTemplates,
                         CheckExistChannels,
                         AddGeneralChannels,
                         input: { channel_prefix: payload["text"] }) do |m|
          m.success do |result|
            send_back(payload["response_url"], result)
          end
          m.failure(:empty) do |_errors|
            { text: "Prefix can not be empty" }
          end
          m.failure(:exist) do |errors|
            send_back(payload["response_url"], errors.keys.first)
          end
          m.failure do |error|
            { text: "Check Logs for error #{error}" }
          end
        end
      else
        { text: "No Command" }
      end
    end
  end
end
