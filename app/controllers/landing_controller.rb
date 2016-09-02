class LandingController < ApplicationController
  def index
    client = TwitterOAuth::Client.new consumer_key: ENV['TWITTER_KEY'],
      consumer_secret: ENV['TWITTER_SECRET']
    request_token = client.request_token oauth_callback: "http://127.0.0.1:3000/auth/token/callback"
    session[:oauth] = request_token
    @authorize_url = request_token.authorize_url
  end
end
