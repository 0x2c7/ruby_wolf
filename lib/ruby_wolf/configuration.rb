module RubyWolf
  class Configuration < BasicObject
    def initialize
      @configs = {}
    end

    def []=(key, value)
      @configs[key] = value
    end

    def [](key)
      @configs[key]
    end
  end
end
