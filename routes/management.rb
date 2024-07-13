# frozen_string_literal: true

class SlackManagement
hash_branch "slack" do |req|
    req.on("users") do
      req.is(method: :get) do
        begin
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
    end

    req.on("commands") do
      payload = req.params
      if payload["command"] == "/takamol_general_channels"
        AddGeneralChannels.call({ channel_prefix: payload["text"] })
      elsif payload["command"] == "/add_business_unit"
        AddBusinessUnit.call({ unit_name: payload["text"] })
      else
        { text: "Unknown command" }
      end
    end
  end
end
