# RubyWolf

Ruby wolf is a tiny ruby web server for rack-based application. This server follows pre-forked and event driven with kqueue / epoll approach. Honestly, this web server is written for study and research purpose. I'm sure it could be used anywhere. So, don't use it in real world :)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_wolf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_wolf

## Usage

Start your rack-based application with the following command:

`ruby_wolf -p 3000`

To explore the provided options, please use `ruby_wolf --help`

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

