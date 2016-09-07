require "excon"
require "json"
# data = {
#   input: {
#     text: "Hello"
#   } ,
  # context: {
  #   conversation_id: "1b7b67c0-90ed-45dc-8508-9488bc483d5b",
  #   system: {
  #     dialog_stack: ["root"],
  #     dialog_turn_counter: 1,
  #     dialog_request_counter: 1
  #   }
  # }
# }.to_json

# pt = Excon.post("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/db0ab7f7-8c5d-4b42-859b-25d2544d51c1/message?version=2016-07-11", body: data, headers: {"Content-Type": "application/json"},
#     user: "afe20af0-046a-48a3-b5a9-263a3e26e610", password: "PqQ1gPv3nmcb")
# puts pt.body

class WatsonConversation
  attr_reader :data, :header
  def set_request_data(data, context = {} )
    @data = {
      input: data
    }.merge context
    @header = {"Content-Type": "application/json"}
  end

  def send_watson
      url = "https://gateway.watsonplatform.net/conversation/api/v1/worksp"\
        "aces/#{ENV["WORKSPACE_ID"]}/message?version=2016-07-11"
      excon = Excon.post(
        url,
        body: data,
        headers: header,
        user: ENV["CONVO_USER"],
        password: ENV["CONVO_PASSWORD"]
      )
      JSON.parse(excon.body)
  end

end
