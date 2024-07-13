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
end
