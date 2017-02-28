module RubyWolf
  class Worker
    attr_reader :pid, :server, :app, :socket, :connections

    def initialize(server)
      @server = server
      @app = server.app
      @socket = server.socket
      @connections = []
    end

    def start
      @pid = fork do
        RubyWolf.log('Worker is ready')
        handle_loop
      end
    end

    private

    def handle_loop
      loop do
        need_to_read = connections.select(&:need_to_read?)
        need_to_write = connections.select(&:need_to_write?)

        ready_to_read, ready_to_write, = IO.select(
          need_to_read + [socket],
          need_to_write
        )

        handle_read(ready_to_read)
        handle_write(ready_to_write)
      end
    end

    def handle_read(ready_to_read)
      ready_to_read.each do |connection|
        if connection == socket
          accept_connection
        else
          connection.read
          handle_request(connection) unless connection.need_to_read?
        end
      end
    end

    def handle_write(ready_to_write)
      ready_to_write.each do |connection|
        connection.write
        close_connection(connection) unless connection.need_to_write?
      end
    end

    def handle_request(connection)
      handler = RubyWolf::Handler.new(app, connection) do |response|
        connection.enqueue_write(response)
      end
      handler.process
    end

    def accept_connection
      @connections << RubyWolf::Connection.new(socket.accept_nonblock)
    rescue IO::WaitReadable, Errno::EINTR
    end

    def close_connection(connection)
      connection.close
      @connections.delete(connection)
    end
  end
end
