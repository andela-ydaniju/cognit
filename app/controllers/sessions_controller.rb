class SessionsController < ApplicationController
  def create
    client = TwitterOAuth::Client.new consumer_key: ENV['TWITTER_KEY'], consumer_secret: ENV['TWITTER_SECRET']
    access_token = client.authorize session[:oauth]['token'], session[:oauth]['secret'], oauth_verifier: params[:oauth_verifier]
    @tweets = client.user_timeline({ count: 500 })
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

    res = Excon.post("#{hash['url']}/v2/profile", body: data, headers: {"Content-Type": "application/json"}, user: hash["username"], password: hash["password"])
  end
end
