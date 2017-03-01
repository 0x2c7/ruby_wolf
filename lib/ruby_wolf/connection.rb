module RubyWolf
  class Connection
    attr_reader :socket, :read_chunk, :write_chunk, :headers, :body, :path, :query, :method

    def initialize(socket)
      @socket = socket
      @read_chunk = ''
      @write_chunk = ''
      @reading = true

      @headers = {}
    end

    def need_to_read?
      @reading
    end

    def read
      @read_chunk << socket.read_nonblock(RubyWolf::READ_SIZE)
      if @content_length.nil?
        read_headers
      else
        read_body
      end
    rescue EOFError
      @reading = false
    end

    def enqueue_write(data)
      @write_chunk += data
    end

    def write
      writen = socket.write_nonblock(@write_chunk)
      @write_chunk = @write_chunk.byteslice(writen, @write_chunk.bytesize)
    end

    def need_to_write?
      !@write_chunk.bytesize.zero?
    end

    def to_io
      @socket
    end

    def close
      @socket.close
    end

    private

    def read_headers
      header_ending = @read_chunk.index(RubyWolf::HEADER_ENDING)
      return if header_ending.nil?

      headers_chunk = @read_chunk.slice!(
        0, header_ending + RubyWolf::HEADER_ENDING.size
      )
      parse_headers(headers_chunk)
      @content_length = @headers['Content-Length'].to_i
      read_body
    end

    def parse_headers(headers_chunk)
      parser = Http::Parser.new
      parser.on_headers_complete = proc do
        @headers = parser.headers
        @method = parser.http_method
        uri = URI.parse(parser.request_url)
        @path = uri.path
        @query = uri.query
        :stop
      end
      parser << headers_chunk
    end

    def read_body
      @reading = false if @read_chunk.bytesize >= @content_length
    end
  end
end
