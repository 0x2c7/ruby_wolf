module RubyWolf
  class Server
    attr_reader :app, :configs

    def initialize(app, configs)
      @app = app
      @configs = configs
    end

    def start

    end
  end
end
