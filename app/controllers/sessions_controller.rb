require 'csv'
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

    session[:p_data] = @p_data
    session[:n_data] = @n_data.to_json
    session[:v_data] = @v_data.to_json

    redirect_to personality_insights_path
  end

  def process_insights
    @personality = session[:p_data]
    @values = session[:v_data]
    @needs = session[:n_data]
    # pb = File.read("config/problem.json")
    cred = {
    url: "https://gateway.watsonplatform.net/tradeoff-analytics/api",
    password: "T41CufPA1r8s",
    username: "15a89132-602f-429d-a2b2-83f54102f281"
}
max_or_min = ["min", "max"]
names = @personality[0][:children].map {|e|
  {
    key: e[:name],
    type: "numeric",
    goal: max_or_min.sample,
    is_objective: true,
    full_name: e[:name].capitalize,
    range: {
      "low": 0,
      "high": 1
    }
  }
}


arr = []
personality = []
value = []
needs = []
count = 0
CSV.foreach('companylist-1.csv') do |row|
  arr << {
    key: count += 1,
    name: row[6],
    values: {
      Openness: rand(0..1.0),
      Conscientiousness: rand(0..1.0),
      Extraversion: rand(0..1.0),
      Agreeableness: rand(0..1.0),
      "Emotional range": rand(0..1.0)
    }
  }
end


pb = {
  subject: "finance",
  columns: names,
  options: arr
}


    @res = JSON.parse Excon.post("#{cred[:url]}/v1/dilemmas?generate_visualization=false",
                                 body: pb.to_json,
                                 headers: {"Content-Type": "application/json"},
                                 user: cred[:username],
                                 password: cred[:password]
                                ).body
    @companies = @res["resolution"]["solutions"].select{|d| d["status"] == "FRONT"}
    render json: @companies
  end
end
