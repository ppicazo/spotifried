require 'sinatra/base'
require 'slack-ruby-client'
require 'rspotify'
require 'redis'
require 'yaml'
require 'omniauth'
require 'rspotify/oauth'

module Spotifried
  class Web < Sinatra::Base
    use Rack::Session::Cookie, secret: 'blah!'
    use OmniAuth::Builder do
      provider :spotify, ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'], provider_ignores_state: true, scope: "playlist-read-collaborative playlist-modify-public"
    end

    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
      fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
    end

    RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

    get '/' do
      'Picaboo is good for yoo.'
    end

    get '/auth/:name/callback' do
      if params[:name] == 'spotify'
        user = RSpotify::User.new(request.env['omniauth.auth'])
        redis_client.set(ENV['SPOTIFY_CLIENT_ID'], user.to_hash.to_json)
        redis_client.get(ENV['SPOTIFY_CLIENT_ID'])
      end
    end

    before '/api/*' do
      content_type :json
      headers('Access-Control-Allow-Origin' => '*')
    end

    get '/api/slack/auth_test' do
      client = Slack::Web::Client.new
      client.auth_test.to_json
    end

    private

    def redis_client
      @redis_client ||= Redis.new(url: ENV['REDIS_URL'])
    end

  end
end