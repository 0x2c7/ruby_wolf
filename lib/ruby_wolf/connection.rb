module RubyWolf
  class Connection
    CRLF = "\r\n".freeze
    READ_SIZE = 16 * 1024

    attr_reader :socket, :read_data, :write_data

    def initialize(socket)
      @socket = socket
      @read_data = ''
      @write_data = ''

      @reading = true
    end

    def need_to_read?
      @reading
    end

    def read
      @read_data << socket.read_nonblock(READ_SIZE)
      @reading = false if @read_data.end_with?(CRLF)
    end

    def enqueue_write(data)
      @write_data += data
    end

    def write
      writen = socket.write_nonblock(@write_data)
      @write_data[0..writen] = ''
    end

    def need_to_write?
      !@write_data.length.zero?
    end

    def to_io
      @socket
    end

    def close
      @socket.close
    end
  end
end
