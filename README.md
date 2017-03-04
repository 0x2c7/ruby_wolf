# RubyWolf

[![Gem Version](https://badge.fury.io/rb/ruby_wolf.svg)](https://badge.fury.io/rb/ruby_wolf)
[![CircleCI](https://circleci.com/gh/nguyenquangminh0711/ruby_wolf.svg?style=svg)](https://circleci.com/gh/nguyenquangminh0711/ruby_wolf)

Ruby wolf is a tiny ruby web server for rack-based application. This server follows pre-forked and event driven approach. Honestly, this web server is written for study and research purpose. I'm sure it could be used anywhere. So, don't use it in real world :)

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

Benchmark with some Hello world application, tested with Apache Benchmark, 10000 requests, 12 concurrences under local environment (Macbook Pro 2015 - Core i7, 16gb Ram)

### RubyWolf

```
  50%      7ms
  66%     11ms
  75%     14ms
  80%     15ms
  90%     19ms
  95%     24ms
  98%     31ms
  99%     33ms
 100%     51ms (longest request)
```

### Puma

```
  50%     25ms
  66%     27ms
  75%     28ms
  80%     29ms
  90%     31ms
  95%     32ms
  98%     35ms
  99%     37ms
 100%     39ms (longest request)
```

### Thin

```
  50%     22ms
  66%     23ms
  75%     24ms
  80%     24ms
  90%     28ms
  95%     30ms
  98%     34ms
  99%     36ms
 100%    227ms (longest request)
```

Note that Hello world application is not considered to be a real application. Thus this benchmark doesn't mean much

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

