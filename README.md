# Line::Bot::MessageBuilder

Plain Old Ruby Object to [Line Messaging API](https://developers.line.me/en/docs/messaging-api/reference/#message-objects) hash format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'line-bot-message-builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install line-bot-message-builder

## Usage

require it:

```ruby
require 'line/bot/message_builder'
```

> if you using Rails, you can create a initiializer `config/initiializers/line_bot` and require

include `Line::Bot::MessageBuilder` for use shorter class name or not:

```ruby
# didn't include usage
Line::Bot::MessageBuilder::Message::Text.new do |m|
  m.text= '123'
end

# included usage
include Line::Bot::MessageBuilder
Message::Text.new do |m|
  m.text= '123'
end
```

more complex example:

```ruby
Message::Template.new do |t|
  t.alt_text = 'example1'
  t.template = Template::Buttons.new do |b|
    b.text = 'example2'
    b.actions << Action::Postback.new do |a|
      a.label = 'example3'
      a.data = 'action=example3'
    end
    b.actions << Action::Postback.new do |a|
      a.label = 'example4'
      a.data = 'action=example4'
    end
  end
end
```

use `to_h` method convert `MessageBuilder` instance to `hash`:

```ruby
m = Message::Template.new do |t|
  t.alt_text = 'example1'
  t.template = Template::Buttons.new do |b|
    b.text = 'example2'
    b.actions << Action::Postback.new do |a|
      a.label = 'example3'
      a.data = 'action=example3'
    end
    b.actions << Action::Postback.new do |a|
      a.label = 'example4'
      a.data = 'action=example4'
    end
  end
end

m.to_h
=> {"type"=>"template",
 "altText"=>"example1",
 "template"=>
  {"type"=>"buttons",
   "text"=>"example2",
   "actions"=>
    [{"type"=>"postback", "label"=>"example3", "data"=>"action=example3"},
     {"type"=>"postback", "label"=>"example4", "data"=>"action=example4"}]}}
```

### with line-bot-sdk-ruby

Example with [line-bot-sdk-ruby](https://github.com/line/line-bot-sdk-ruby) and service object.

create a service object:

```ruby
# services/line_bot_service
class LineBotService
  include Line::Bot::MessageBuilder
  attr_reader :bot, :chats, :request

  def initialize(request)
    @request = request
    @body = @request.raw_post
    @signature = @request.env['HTTP_X_LINE_SIGNATURE']
    @bot = Line::Bot::Client.new(Rails.application.config.line_bot)
    @chats = @bot.parse_events_from(@body)
    raise 'signature invalid' unless @bot.validate_signature(@body, @signature)
  end

  def perform
    @chats.each do |chat|
      token = chat['replyToken']
      message = bulid_msg_and_react(chat).to_h
      next if message.blank?

      @bot.reply_message token, message
    end
  end

  private

  def bulid_msg_and_react(chat)
    # write your reply logic here
    case chat
    when Line::Bot::Event::Message
      text = chat['message'].fetch('text') { '' }
      return message1 if conditions
      return message2 if conditions2
      return message3
    when Line::Bot::Event::Postback
      data = chat['postback'].fetch('data') { '' }
      data = ActionController::Parameters.new(Rack::Utils.parse_nested_query(data))
      return message4 if data[:action] == 'action'
    end
  end

  # messages and reactions
  def message1
    do_something1
    Message::Text.new(text: 'message1')
  end

  def message2
    do_something2
    Message::Template.new do |t|
      t.alt_text = 'message2'
      t.template = Template::Buttons.new do |b|
        b.text = 'message2'
        b.actions << Action::Postback.new do |a|
          a.label = 'action1'
          a.data = 'action=action1'
        end
      end
    end
  end

  def message3
    do_something3
    Message::Text.new(text: 'message3')
  end

  def message4
    do_something3
    Messages::Sticker.new(package_id: 1, sticker_id: 5)
  end
end
```

and use it like this in Rails

```ruby
# line_controller #webhook
def webhook
  service = LineBotService.new(request)
  service.perform
  render plain: 'Success', status: 200
end
```

## TODO

* [ ] messages
  * [x] image
  * [x] text
  * [x] video
  * [x] audio
  * [x] sticker
  * [x] location
  * [ ] template
* [ ] templates
  * [x] buttons
  * [ ] confirm
  * [ ] imagecarousel
  * [ ] carousel
* [ ] actions
  * [x] message
  * [x] postback
  * [x] uri
  * [ ] datetimepicker

Feel free to create a PR to contribute.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/jk195417/line-bot-message-builder>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Line::Bot::MessageBuilder project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/line-bot-message-builder/blob/master/CODE_OF_CONDUCT.md).
