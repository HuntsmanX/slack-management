require "yaml"
module SlackUiBlocks
  def create_password_modal(trigger_id, response_url, data)
    private_metadata = {
      response_url:,
      data:
    }.to_json
    {
      trigger_id:,
      view: {
        type: "modal",
        callback_id: "password_modal",
        private_metadata:,
        title: {
          type: "plain_text",
          text: "Enter Password"
        },
        blocks: [
          {
            type: "input",
            block_id: "password_block",
            element: {
              type: "plain_text_input",
              action_id: "password_input",
              placeholder: {
                type: "plain_text",
                text: "Enter Password"
              }
            },
            label: {
              type: "plain_text",
              text: "Password"
            }
          }
        ],
        submit: {
          type: "plain_text",
          text: "Confirm"
        }
      }
    }
  end

  def create_leaves_modal(trigger_id)
    {
      trigger_id:,
      view: {
        type: "modal",
        callback_id: "modal_with_inputs",
        title: {
          type: "plain_text",
          text: "My Modal"
        },
        blocks: [
          {
            type: "input",
            block_id: "input_block_1",
            element: {
              type: "plain_text_input",
              action_id: "input_action_1",
              placeholder: {
                type: "plain_text",
                text: "Enter first text"
              }
            },
            label: {
              type: "plain_text",
              text: "First Text Input"
            }
          },
          {
            type: "input",
            block_id: "input_block_2",
            element: {
              type: "plain_text_input",
              action_id: "input_action_2",
              placeholder: {
                type: "plain_text",
                text: "Enter second text"
              }
            },
            label: {
              type: "plain_text",
              text: "Second Text Input"
            }
          },
          {
            type: "input",
            block_id: "dropdown_block",
            element: {
              type: "static_select",
              action_id: "dropdown_action",
              placeholder: {
                type: "plain_text",
                text: "Select an option"
              },
              options: [
                {
                  text: {
                    type: "plain_text",
                    text: "Option 1"
                  },
                  value: "value_1"
                },
                {
                  text: {
                    type: "plain_text",
                    text: "Option 2"
                  },
                  value: "value_2"
                },
                {
                  text: {
                    type: "plain_text",
                    text: "Option 3"
                  },
                  value: "value_3"
                }
              ]
            },
            label: {
              type: "plain_text",
              text: "Dropdown"
            }
          }
        ],
        submit: {
          type: "plain_text",
          text: "Submit"
        },
        close: {
          type: "plain_text",
          text: "Cancel"
        }
      }
    }
  end

  def add_people_modal(trigger_id, response_url)
    private_metadata = {
      response_url:
    }.to_json
    options_teams = Team.all.map do |option|
      {
        text: {
          type: "plain_text",
          text: option.name
        },
        value: option.id.to_s
      }
    end
    {
      trigger_id:,
      view: {
        type: "modal",
        callback_id: "add_people",
        private_metadata:,
        title: {
          type: "plain_text",
          text: "Example Modal",
          emoji: true
        },
        submit: {
          type: "plain_text",
          text: "Submit",
          emoji: true
        },
        close: {
          type: "plain_text",
          text: "Cancel",
          emoji: true
        },
        blocks: [
          {
            type: "input",
            block_id: "dropdown_block_team",
            element: {
              type: "static_select",
              action_id: "dropdown_action",
              placeholder: {
                type: "plain_text",
                text: "Select a Team"
              },
              options: options_teams
            },
            label: {
              type: "plain_text",
              text: "Dropdown"
            }
          },
          {
            type: "input",
            block_id: "text_area_block",
            element: {
              type: "plain_text_input",
              multiline: true,
              action_id: "text_area_action",
              placeholder: {
                type: "plain_text",
                text: "Enter your emails here",
                emoji: true
              }
            },
            label: {
              type: "plain_text",
              text: "Your Input",
              emoji: true
            }
          }
        ]
      }
    }
  end

  def create_team_modal(trigger_id, response_url)
    private_metadata = {
      response_url:
    }.to_json
    options_business_units = BusinessUnit.all.map do |option|
      {
        text: {
          type: "plain_text",
          text: option.name
        },
        value: option.id.to_s
      }
    end

    options_teams = Team.all.map do |option|
      {
        text: {
          type: "plain_text",
          text: option.name
        },
        value: option.id.to_s
      }
    end

    checkboxes = channel_from_file.keys.map do |option|
      {
        text: {
          type: "plain_text",
          text: option
        },
        value: option
      }
    end

    {
      trigger_id:,
      view: {
        type: "modal",
        callback_id: "team_callback",
        private_metadata:,
        title: {
          type: "plain_text",
          text: "My Modal"
        },
        blocks: [
          {
            type: "input",
            block_id: "dropdown_block",
            element: {
              type: "static_select",
              action_id: "dropdown_action",
              placeholder: {
                type: "plain_text",
                text: "Select an option"
              },
              options: options_business_units
            },
            label: {
              type: "plain_text",
              text: "Dropdown"
            }
          },
          {
            type: "input",
            block_id: "dropdown_block_team",
            element: {
              type: "static_select",
              action_id: "dropdown_action",
              placeholder: {
                type: "plain_text",
                text: "Select an option"
              },
              options: options_teams
            },
            label: {
              type: "plain_text",
              text: "Dropdown"
            }
          },
          {
            type: "input",
            block_id: "checkboxes_block",
            element: {
              type: "checkboxes",
              action_id: "checkboxes_action",
              options: checkboxes
            },
            label: {
              type: "plain_text",
              text: "Checkboxes"
            }
          }
        ],
        submit: {
          type: "plain_text",
          text: "Submit"
        },
        close: {
          type: "plain_text",
          text: "Cancel"
        }
      }
    }
  end

  def channel_from_file
    YAML.load_file(Constants::TEAM_UNIT_MAPPING_PLACE)
  rescue StandardError => e
    puts e.inspect
  end
end
