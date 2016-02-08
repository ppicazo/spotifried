module Spotifried
  class Helpers

    def self.message_for_bot?(data, id)
      data.text.include? "<@#{id}>"
    end

    def self.message_has_spotify_track?(data)
      (data.text.include? "https://open.spotify.com/track/") || (data.text.include? "spotify:track:")
    end

    def self.spotify_track(data)
      (/https:\/\/open\.spotify\.com\/track\/(\w*)/.match(data.text) || /spotify:track:(\w*)/.match(data.text))[1]
    end

  end
end