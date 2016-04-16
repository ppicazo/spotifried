module Spotifried
  class SlackHelpers
    def self.message_for_bot?(data, id)
      data.text.include? "<@#{id}>"
    end
  end
end