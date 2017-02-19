require 'optparse'

module RubyWolf
  class CLI
    attr_reader :configs

    def initialize(args)
      @args = args
      @configs = RubyWolf::Configuration.new
    end

    def run
      parse_options
      puts 'Start of something new'
    end

    def parse_options
      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: ruby_wolf [options]'

        opts.on('-d', '--daemon', 'Demonize this web server to run background') do
          @configs[:daemon] = true
        end

        opts.on('-p PORT', '--port=PORT', 'Port of the program') do |arg|
          @configs[:port] = arg.to_i
        end

        opts.on('-h', '--help', 'Show the usages') do
          puts opts
          exit
        end
      end

      opt_parser.parse!(@args)
    end
  end
end
