module Line
  module Bot
    module MessageBuilder
      class Message::Text < Message
        attr_accessor :text

        def initialize(text: nil)
          super 'text' do
            @text = text
            yield self if block_given?
          end
        end

        def self.required
          {
            'type' => String,
            'text' => String
          }
        end
      end
    end
  end
end
