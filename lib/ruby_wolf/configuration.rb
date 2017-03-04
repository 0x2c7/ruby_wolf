module RubyWolf
  class Configuration < BasicObject
    DEFAULT_DAEMON = false
    DEFAULT_HOST = '0.0.0.0'.freeze
    DEFAULT_PORT = 3000
    DEFAULT_WORKER = 4
    DEFAULT_ENVIRONMENT = 'development'.freeze

    def initialize
      @configs = {
        daemon: DEFAULT_DAEMON,
        worker: DEFAULT_WORKER,
        host: DEFAULT_HOST,
        port: DEFAULT_PORT,
        environment: DEFAULT_ENVIRONMENT
      }
    end

    def []=(key, value)
      @configs[key] = value
    end

    def [](key)
      @configs[key]
    end
  end
end
