module RubyWolf
  class Worker
    attr_reader :pid, :server, :app, :socket, :connections

    def initialize(server)
      @server = server
      @app = server.app
      @socket = server.socket
    end

    def start
      @pid = fork do
        @connections = ConnectionManager.new
        RubyWolf.log('Worker is ready')
        handle_loop
      end
    end

    private

    def handle_loop
      loop do
        need_to_read = connections.need_to_read
        need_to_write = connections.need_to_write

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
        connections.remove(connection) unless connection.need_to_write?
      end
    end

    def handle_request(connection)
      connections.remove(connection)
    end

    def accept_connection
      connections.register(socket.accept_nonblock)
    rescue IO::WaitReadable, Errno::EINTR
    end
  end
end
