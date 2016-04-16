module Spotifried
  class Helpers

    def self.message_for_bot?(data, id)
      data.text.include? "<@#{id}>"
    end

    def self.message_has_spotify_track?(data)
      text_has_spotify_track?(data.text)
    end

    def self.text_has_spotify_track?(text)
      (text.include? "https://open.spotify.com/track/") || (text.include? "https://play.spotify.com/track/") || (text.include? "spotify:track:")
    end

    def self.spotify_track(data)
      extract_spotify_track(data.text)
    end

    def self.extract_spotify_track(text)
      tracks = /https:\/\/(?:open|play)\.spotify\.com\/track\/(\w*)/.match(text) || /spotify:track:(\w*)/.match(text)
      tracks.is_a?(MatchData) && tracks.size > 1 ? tracks[1] : nil
    end
  end
end