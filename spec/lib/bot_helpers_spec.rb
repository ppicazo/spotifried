require 'bot_helpers'
require 'hashie/mash'

describe Spotifried::Helpers do
  describe "#message_for_bot?" do
    it "should return true if the message is for the bot" do
      expect(Spotifried::Helpers.message_for_bot?(Hashie::Mash.new({ text: "<@def> : abc" }), "def")).to be_truthy
    end

    it "should return true if the message is for the bot and others" do
      expect(Spotifried::Helpers.message_for_bot?(Hashie::Mash.new({ text: "<@ghi> :  <@def> abc" }), "def")).to be_truthy
    end

    it "should return false if the message is not for the bot" do
      expect(Spotifried::Helpers.message_for_bot?(Hashie::Mash.new({ text: "<@ghi> abc" }), "def")).to be_falsey
    end
  end

  describe "#message_has_spotify_track?" do
    it "should call text_has_spotify_track? and return the result" do
      expect(Spotifried::Helpers).to receive(:text_has_spotify_track?).with("abc").and_return("xyz")
      expect(Spotifried::Helpers.message_has_spotify_track?(Hashie::Mash.new({ text: "abc" }))).to eq("xyz")
    end
  end

  describe "#text_has_spotify_track?" do
    it "should return true on play urls" do
      expect(Spotifried::Helpers.text_has_spotify_track?("hi https://play.spotify.com/track/6BivCuyKJtgLa9ooFsvUoZ there")).to be_truthy
    end

    it "should return true on open urls" do
      expect(Spotifried::Helpers.text_has_spotify_track?("hi https://open.spotify.com/track/6BivCuyKJtgLa9ooFsvUoZ there")).to be_truthy
    end

    it "should return true on spotify uri" do
      expect(Spotifried::Helpers.text_has_spotify_track?("spotify:track:6BivCuyKJtgLa9ooFsvUoZ there")).to be_truthy
    end

    it "should return false on google.com links" do
      expect(Spotifried::Helpers.text_has_spotify_track?("hi https://www.google.com/track/6BivCuyKJtgLa9ooFsvUoZ there")).to be_falsey
    end

    it "should return false on strings without tracks" do
      expect(Spotifried::Helpers.text_has_spotify_track?("hi there")).to be_falsey
    end

    it "should return false on empty strings" do
      expect(Spotifried::Helpers.text_has_spotify_track?("")).to be_falsey
    end
  end

  describe "#spotify_track" do
    it "should call text_has_spotify_track? and return the result" do
      expect(Spotifried::Helpers).to receive(:extract_spotify_track).with("abc").and_return("xyz")
      expect(Spotifried::Helpers.spotify_track(Hashie::Mash.new({ text: "abc" }))).to eq("xyz")
    end
  end

  describe "#extract_spotify_track" do
    before do
      @track_id = "6BivCuyKJtgLa9ooFsvUoZ"
    end

    it "should return true on play urls" do
      expect(Spotifried::Helpers.extract_spotify_track("hi https://play.spotify.com/track/#{@track_id} there")).to eq(@track_id)
      expect(Spotifried::Helpers.extract_spotify_track("hi http://play.spotify.com/track/#{@track_id} there")).to eq(@track_id)
    end

    it "should return true on open urls" do
      expect(Spotifried::Helpers.extract_spotify_track("hi https://open.spotify.com/track/#{@track_id} there")).to eq(@track_id)
    end

    it "should return true on spotify uri" do
      expect(Spotifried::Helpers.extract_spotify_track("spotify:track:#{@track_id} there")).to eq(@track_id)
    end

    it "should return false on google.com links" do
      expect(Spotifried::Helpers.extract_spotify_track("hi https://www.google.com/track/#{@track_id} there")).to be_falsey
    end

    it "should return nil on strings without tracks" do
      expect(Spotifried::Helpers.extract_spotify_track("hi there")).to be_falsey
    end

    it "should return nil on empty strings" do
      expect(Spotifried::Helpers.extract_spotify_track("")).to be_falsey
    end

    it "should return nil on nil" do
      expect(Spotifried::Helpers.extract_spotify_track(nil)).to be_falsey
    end
  end
end