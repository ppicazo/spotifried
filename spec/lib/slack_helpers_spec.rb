require 'slack_helpers'
require 'hashie/mash'

describe Spotifried::SlackHelpers do
  describe "#message_for_bot?" do
    it "should return true if the message is for the bot" do
      expect(Spotifried::SlackHelpers.message_for_bot?(Hashie::Mash.new({ text: "<@def> : abc" }), "def")).to be_truthy
    end

    it "should return true if the message is for the bot and others" do
      expect(Spotifried::SlackHelpers.message_for_bot?(Hashie::Mash.new({ text: "<@ghi> :  <@def> abc" }), "def")).to be_truthy
    end

    it "should return false if the message is not for the bot" do
      expect(Spotifried::SlackHelpers.message_for_bot?(Hashie::Mash.new({ text: "<@ghi> abc" }), "def")).to be_falsey
    end
  end
end