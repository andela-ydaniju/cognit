class LandingController < ApplicationController
  before_action :client

  def index
    request_token = @client.request_token oauth_callback: "#{request.env['REQUEST_URI']}auth/token/callback"

    session[:oauth] = request_token
    session[:oauth_url] = request_token.authorize_url
    @authorize_url = request_token.authorize_url
  end

  def show
    @personality = session[:p_data]
  end
end
