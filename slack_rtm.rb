require 'slack-ruby-client'
require 'dotenv'
Dotenv.load
require './lib/bot_helpers'
require 'rspotify'
require 'redis'
require 'yaml'

$stdout.sync = true

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

@client = Slack::RealTime::Client.new
@redis_client = Redis.new(url: ENV['REDIS_URL'])

RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

def add_track_to_playlist(track_id)
  user_data = JSON.parse(@redis_client.get(ENV['SPOTIFY_CLIENT_ID']))
  original_access_token = user_data["credentials"]["token"]
  spotify_user = RSpotify::User.new(user_data)
  playlist = RSpotify::Playlist.find(spotify_user.id, ENV['SPOTIFY_PLAYLIST'])
  track = RSpotify::Track.find(track_id)
  pages = (playlist.tracks.size / 100) + 1
  tracks = []
  pages.times { |index|
    tracks.concat playlist.tracks(offset: index * 100)
  }
  result = playlist.add_tracks! [track] unless tracks.map { |trk| trk.id }.include? track_id
  @redis_client.set(ENV['SPOTIFY_CLIENT_ID'], spotify_user.to_hash.to_json) unless spotify_user.instance_variable_get("@credentials")["token"] == original_access_token
  result
end

def add_reaction(data, emoji_name)
  @client.web_client.reactions_add(name: emoji_name, timestamp: data.ts, channel: data.channel)
end

@client.on :hello do
  puts "Successfully connected, welcome '#{@client.self.name}' to the '#{@client.team.name}' team at https://#{@client.team.domain}.slack.com."
end

@client.on :message do |data|
  begin
    unless data.text.nil?
      if Spotifried::SpotifyHelpers.message_has_spotify_track?(data)
        begin
          spotify_track_id = Spotifried::SpotifyHelpers.spotify_track(data)
          if spotify_track_id
            puts "Spotify Track ID: #{spotify_track_id}"
            if add_track_to_playlist(spotify_track_id)
              add_reaction(data, "floppy_disk")
            else
              add_reaction(data, "no_entry_sign")
            end
          end
        rescue => e
          puts "Minor fail!"
          puts e
          puts e.backtrace
          add_reaction(data, "skull")
        end
      elsif Spotifried::SlackHelpers.message_for_bot?(data, @client.self.id)
        puts "The message it is for me: #{data}"
        if (data.text.downcase.include? 'hi') || (data.text.downcase.include? 'yo') || (data.text.downcase.include? 'hey') || (data.text.downcase.include? 'hello')
          @client.web_client.chat_postMessage username: @client.self.name, channel: data.channel, text: "#{['Hi', 'Hello', 'Hey'].sample} <@#{data.user}>!", icon_emoji: ENV['SLACK_ICON_EMOJI'] || ":robot_face:"
        else
          @client.web_client.chat_postMessage username: @client.self.name, channel: data.channel, text: "Sorry <@#{data.user}>, what?", icon_emoji: ENV['SLACK_ICON_EMOJI'] || ":robot_face:"
        end
      end
    end
  rescue => e
    puts "Major fail!"
    puts e
    puts e.backtrace
  end
end

@client.start!