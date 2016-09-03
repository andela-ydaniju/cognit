class SessionsController < ApplicationController
  before_action :client, only: [:create]
  before_action :access_token, only: [:create]

  def create
    session[:oauth_token] = params[:oauth_token]
    session[:oauth_verifier] = params[:oauth_verifier]
    @tweets = @client.user_timeline({ count: 500 })
    data = { contentItems: @tweets.map do |tweet|
        {
          content: tweet['text'],
          contenttype: "text/plain",
          id: tweet['id_str'],
          language: "en",
          sourceid: "Twitter API",
          userid: "@#{tweet['user']['screen_name']}",
          created: Time.parse(tweet["created_at"]).to_i
        }
      end
    }.to_json

    config = File.read("config/personality.json")
    hash = JSON.parse(config)["personality_insights"][0]["credentials"]

    @res = JSON.parse Excon.post("#{hash['url']}/v2/profile", body: data, headers: {"Content-Type": "application/json"}, user: hash["username"], password: hash["password"]).body

    @personality = @res['tree']['children'][0]
    @needs = @res['tree']['children'][1]
    @values = @res['tree']['children'][2]

    @p_data = @personality['children'].map do |x|
      {
        cat: x["name"],
        percent: x["percentage"],
        children: x['children'].map { |e| { name: e['name'], percent: e['percentage']}  }
      }
    end

    @n_data = @needs['children'].map do |x|
      {
        cat: x["name"],
        percent: x["percentage"],
        children: x['children'].map { |e| { name: e['name'], percent: e['percentage']}  }
      }
    end

    @v_data = @values['children'].map do |x|
      {
        cat: x["name"],
        percent: x["percentage"],
        children: x['children'].map { |e| { name: e['name'], percent: e['percentage']}  }
      }
    end

    session[:p_data] = @p_data.to_json
    session[:n_data] = @n_data.to_json
    session[:v_data] = @v_data.to_json

    redirect_to personality_insights_path
  end

  def process_insights
    redirect_to root_path
  end
end
