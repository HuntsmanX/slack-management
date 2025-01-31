# frozen_string_literal: true

require "helpers/slak_ui_blocks"
class SlackManagement
  include SlackUiBlocks

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
        trigger_id = payload["trigger_id"]
        response_url = payload["response_url"]
        account_pattern = payload["text"]
        begin
          SlackConfig.client.views_open(create_password_modal(trigger_id, response_url, account_pattern))
        rescue Slack::Web::Api::Errors::SlackError => e
          puts "Error is: #{e.message}"
        end
      elsif payload["command"] == "/add_business_unit"
        AddBusinessUnit.call({ unit_name: payload["text"] })
      elsif payload["command"] == "/leaves"
        trigger_id = payload["trigger_id"]
        begin
          SlackConfig.client.views_open(create_leaves_modal(trigger_id))
          status 200
          body "Modal opened"
        rescue Slack::Web::Api::Errors::SlackError => e
          status 500
          body "Error opening modal: #{e.message}"
        end
      else
        { text: "No Command" }
      end
    end

    req.on("interactions") do
      req.is(method: :post) do
        request_data = JSON.parse(req.params["payload"])

        payload = request_data["payload"] ? JSON.parse(request_data["payload"]) : request_data

        case payload["type"]
        when "view_submission"
          password = payload["view"]["state"]["values"]["password_block"]["password_input"]["value"]
          private_metadata = JSON.parse(payload["view"]["private_metadata"])
          response_url = private_metadata["response_url"]
          data = private_metadata["data"]

          if password == Constants::MANAGER_PASSWORD
            Strum::Pipe.call(ChannelTemplates,
                             CheckExistChannels,
                             AddGeneralChannels,
                             input: { channel_prefix: data }) do |m|
              m.success do |result|
                send_back(response_url, result)
                { response_action: "clear" }
              end
              m.failure(:not_found) do
                message = { text: "Template is not found <@#{payload['user']['id']}>" }
                Faraday.post(response_url, message.to_json, "Content-Type" => "application/json")
                { response_action: "clear" }
              end
              m.failure(:empty) do |_errors|
                message = { text: "Template can not be empty <@#{payload['user']['id']}>" }
                Faraday.post(response_url, message.to_json, "Content-Type" => "application/json")
                { response_action: "clear" }
              end
              m.failure(:exist) do |errors|
                send_back(response_url, errors.keys.first)
                { response_action: "clear" }
              end
              m.failure do |error|
                { text: "Check Logs for error #{error}" }
              end
            end
          else
            message = { text: "Password is incorrect <@#{payload['user']['id']}>" }
            Faraday.post(response_url, message.to_json, "Content-Type" => "application/json")
            { response_action: "clear" }
          end
        end
      end
    end
  end
end
