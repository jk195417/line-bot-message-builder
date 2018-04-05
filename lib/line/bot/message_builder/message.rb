module Line
  module Bot
    module MessageBuilder
      class Message < Base; end
    end
  end
end


require 'line/bot/message_builder/messages/image'
require 'line/bot/message_builder/messages/text'
require 'line/bot/message_builder/messages/video'
require 'line/bot/message_builder/messages/audio'
require 'line/bot/message_builder/messages/sticker'
require 'line/bot/message_builder/messages/location'
require 'line/bot/message_builder/messages/template'
# require 'line/bot/message_builder/messages/imagemap'
