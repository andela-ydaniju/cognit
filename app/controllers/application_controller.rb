class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def client
    @client ||= TwitterOAuth::Client.new consumer_key: ENV['TWITTER_KEY'], consumer_secret: ENV['TWITTER_SECRET']
  end

  def access_token
    @access_token ||= @client.authorize(
                                        params['oauth_token'] || session[:oauth_token],
                                        session[:oauth].secret,
                                        oauth_verifier: params[:oauth_verifier] || session[:oauth_verifier]
                                      )
  end
end
