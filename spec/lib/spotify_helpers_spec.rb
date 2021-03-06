require 'spotify_helpers'
require 'hashie/mash'

describe Spotifried::SpotifyHelpers do
  describe "#message_has_spotify_track?" do
    it "should call text_has_spotify_track? and return the result" do
      expect(Spotifried::SpotifyHelpers).to receive(:text_has_spotify_track?).with("abc").and_return("xyz")
      expect(Spotifried::SpotifyHelpers.message_has_spotify_track?(Hashie::Mash.new({ text: "abc" }))).to eq("xyz")
    end
  end

  describe "#text_has_spotify_track?" do
    it "should return true on play urls" do
      expect(Spotifried::SpotifyHelpers.text_has_spotify_track?("hi https://play.spotify.com/track/6BivCuyKJtgLa9ooFsvUoZ there")).to be_truthy
    end

    it "should return true on open urls" do
      expect(Spotifried::SpotifyHelpers.text_has_spotify_track?("hi https://open.spotify.com/track/6BivCuyKJtgLa9ooFsvUoZ there")).to be_truthy
    end

    it "should return true on spotify uri" do
      expect(Spotifried::SpotifyHelpers.text_has_spotify_track?("spotify:track:6BivCuyKJtgLa9ooFsvUoZ there")).to be_truthy
    end

    it "should return false on google.com links" do
      expect(Spotifried::SpotifyHelpers.text_has_spotify_track?("hi https://www.google.com/track/6BivCuyKJtgLa9ooFsvUoZ there")).to be_falsey
    end

    it "should return false on strings without tracks" do
      expect(Spotifried::SpotifyHelpers.text_has_spotify_track?("hi there")).to be_falsey
    end

    it "should return false on empty strings" do
      expect(Spotifried::SpotifyHelpers.text_has_spotify_track?("")).to be_falsey
    end
  end

  describe "#spotify_track" do
    it "should call text_has_spotify_track? and return the result" do
      expect(Spotifried::SpotifyHelpers).to receive(:extract_spotify_tracks).with("abc").and_return(["xyz"])
      expect(Spotifried::SpotifyHelpers.spotify_track(Hashie::Mash.new({ text: "abc" }))).to eq("xyz")
    end
  end

  describe "#extract_spotify_track" do
    before do
      @track_id = "6BivCuyKJtgLa9ooFsvUoZ"
    end

    it "should return track id on play urls" do
      expect(Spotifried::SpotifyHelpers.extract_spotify_tracks("hi https://play.spotify.com/track/#{@track_id} there")).to eq([@track_id])
      expect(Spotifried::SpotifyHelpers.extract_spotify_tracks("hi http://play.spotify.com/track/#{@track_id} there")).to eq([@track_id])
    end

    it "should return track id on open urls" do
      expect(Spotifried::SpotifyHelpers.extract_spotify_tracks("hi https://open.spotify.com/track/#{@track_id} there")).to eq([@track_id])
    end

    it "should return track id on spotify uri" do
      expect(Spotifried::SpotifyHelpers.extract_spotify_tracks("spotify:track:#{@track_id} there")).to eq([@track_id])
    end

    it "should return track id on spotify uri more than one" do
      expect(Spotifried::SpotifyHelpers.extract_spotify_tracks("spotify:track:#{@track_id} spotify:track:second  there")).to eq([@track_id, "second"])
    end

    it "should return track id on google.com links" do
      expect(Spotifried::SpotifyHelpers.extract_spotify_tracks("hi https://www.google.com/track/#{@track_id} there")).to eq([])
    end

    it "should return nil on strings without tracks" do
      expect(Spotifried::SpotifyHelpers.extract_spotify_tracks("hi there")).to eq([])
    end

    it "should return nil on empty strings" do
      expect(Spotifried::SpotifyHelpers.extract_spotify_tracks("")).to eq([])
    end

    it "should return nil on nil" do
      expect(Spotifried::SpotifyHelpers.extract_spotify_tracks(nil)).to eq([])
    end
  end
end