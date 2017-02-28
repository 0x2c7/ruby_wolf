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

## Benchmark

Benchmark with some Hello world application:

### RubyWolf

```
  50%      7
  66%     11
  75%     14
  80%     15
  90%     19
  95%     24
  98%     31
  99%     33
 100%     51 (longest request)
```

### Puma

```
  50%     25
  66%     27
  75%     28
  80%     29
  90%     31
  95%     32
  98%     35
  99%     37
 100%     39 (longest request)
```

### Thin

```
  50%     22
  66%     23
  75%     24
  80%     24
  90%     28
  95%     30
  98%     34
  99%     36
 100%    227 (longest request)
```

Note that Hello world application is not considered to be a real application. Thus this benchmark doesn't mean much

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

