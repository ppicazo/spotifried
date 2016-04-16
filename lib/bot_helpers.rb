module Spotifried
  class Helpers
    SPOTIFY_TRACK_REGEX = /(?:(?:http(?:s?):\/\/(?:open|play)\.spotify\.com\/track\/)|(?:spotify:track:))(\w*)/

    def self.message_for_bot?(data, id)
      data.text.include? "<@#{id}>"
    end

    def self.message_has_spotify_track?(data)
      text_has_spotify_track?(data.text)
    end

    def self.text_has_spotify_track?(text)
      extract_spotify_tracks(text).count > 0
    end

    def self.spotify_track(data)
      extract_spotify_tracks(data.text).first
    end

    def self.extract_spotify_tracks(text)
      text.is_a?(String) ? text.scan(SPOTIFY_TRACK_REGEX).map { |m| m.first } : []
    end
  end
end