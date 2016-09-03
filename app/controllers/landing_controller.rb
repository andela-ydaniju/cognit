class LandingController < ApplicationController
  before_action :client

  def index
    request_token = @client.request_token oauth_callback: "#{request.env['REQUEST_URI']}auth/token/callback"

    session[:oauth] = request_token
    session[:oauth_url] = request_token.authorize_url
    @authorize_url = request_token.authorize_url
  end

  def show
  end

  def display
    # @personality = session[:p_data]
    # @values = session[:v_data]
    # @needs = session[:n_data]

    pb = File.read("config/problem.json")
    cred = {
    url: "https://gateway.watsonplatform.net/tradeoff-analytics/api",
    password: "T41CufPA1r8s",
    username: "15a89132-602f-429d-a2b2-83f54102f281"
}

    @res = JSON.parse Excon.post("#{cred[:url]}/v1/dilemmas?generate_visualization=true",
                                 body: pb,
                                 headers: {"Content-Type": "application/json"},
                                 user: cred[:username],
                                 password: cred[:password]
                                ).body

    binding.pry

  end
end
