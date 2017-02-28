module RubyWolf
  class ConnectionManager
    attr_reader :pool

    def initialize
      @pool = []
    end

    def need_to_read
      @pool.select(&:need_to_read?)
    end

    def need_to_write
      @pool.select(&:need_to_write?)
    end

    def register(socket)
      @pool << RubyWolf::Connection.new(socket)
    end

    def remove(connection)
      connection.close
      @pool.delete(connection)
    end
  end
end
