require 'http/parser'

module RubyWolf
  class Handler
    attr_reader :app, :env, :connection, :response

    def initialize(app, connection, &callback)
      @app = app
      @env = {}
      @connection = connection
      @response = ''

      @callback = callback
    end

    def process
      prepare_rack_env
      log_request
      process_request
      compose_response
      log_response

      @callback.call(response) if @callback
      @response
    end

    private

    def prepare_rack_env
      @connection.headers.each do |key, value|
        @env[rack_key(key)] = value
      end

      @env = @env.merge(
        'rack.version' => ::Rack::VERSION,
        'rack.errors' => STDERR,
        'rack.multithread'  => false,
        'rack.multiprocess' => true,
        'rack.runonce'      => true,
        'rack.url_scheme'   => ENV['HTTPS'] ? 'https' : 'http',

        'REQUEST_METHOD' => @connection.method,
        'REQUEST_PATH' => @connection.path,
        'PATH_INFO' => @connection.path,
        'QUERY_STRING' => @connection.query,

        'SERVER_PROTOCOL' => 'HTTP/1.1',
        'SERVER_NAME' => 'Ruby Wolf',
        'HTTP_VERSION' => 'HTTP/1.1',

        'rack.input' => StringIO.new(@connection.read_chunk)
      )
    end

    def process_request
      @status, @headers, @body = @app.call(env)
    rescue => e
      message = "Error while processing the request: #{e.message}\n#{e.backtrace.join("\n")}"
      @status = 500
      @body = [message]
      @headers = [
        ['Content-Length', message.bytesize],
        ['Content-Type', 'text/plain; charset=utf-8']
      ]
      RubyWolf.logger.error(message)
    end

    def compose_response
      @response += "HTTP/1.1 #{@status} #{RubyWolf::CRLF}"
      @headers.each do |key, value|
        @response += "#{key}: #{value}#{RubyWolf::CRLF}"
      end

      @response += RubyWolf::CRLF
      @body.each do |part|
        @response += part
      end
    ensure
      @body.close if @body.respond_to? :close
    end

    private

    def log_request
      RubyWolf.logger.info("HTTP/1.1 #{@connection.method} #{request_path}")
    end

    def log_response
      RubyWolf.logger.info("Response HTTP/1.1 #{@status}")
    end

    def request_path
      if @connection.query
        "#{@connection.path}?#{@connection.query}"
      else
        @connection.path
      end
    end

    def rack_key(key)
      "HTTP_#{key.upcase.gsub(/[^0-9A-Z]/, '_')}"
    end
  end
end
