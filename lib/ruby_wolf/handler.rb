require 'http/parser'

module RubyWolf
  class Handler

    attr_reader :app, :env, :connection, :response, :callback, :body, :headers, :status

    def initialize(app, connection, &callback)
      @app = app
      @connection = connection
      @callback = callback
      @env = {}
      @response = ''
    end

    def process
      prepare_rack_env
      generate_response
      callback.call(response) if callback
      response
    end

    private

    def prepare_rack_env
      @env = ENV.to_h.merge(
        'rack.version' => ::Rack::VERSION,
        'rack.errors' => STDERR,
        'rack.multithread'  => false,
        'rack.multiprocess' => true,
        'rack.runonce'      => true,
        'rack.url_scheme'   => ENV['HTTPS'] ? 'https' : 'http',

        'REQUEST_METHOD' => connection.method,
        'REQUEST_PATH' => connection.path,
        'PATH_INFO' => connection.path,
        'QUERY_STRING' => connection.query,

        'SERVER_PROTOCOL' => 'HTTP/1.1',
        'SERVER_NAME' => 'Ruby Wolf',
        'HTTP_VERSION' => 'HTTP/1.1',
        'HTTP_HOST' => connection.headers['Host'],
        'HTTP_USER_AGENT' => connection.headers['User-Agent'],
        'HTTP_ACCEPT' => connection.headers['Accept'],
        'CONTENT_LENGTH' => connection.headers['Content-Length'],
        'CONTENT_TYPE' => connection.headers['Content-Type'],

        'rack.input' => StringIO.new(connection.read_chunk)
      )
      log_request
    end

    def generate_response
      @status, @headers, @body = app.call(env)
      compose_response
      log_response
    end

    def compose_response
      @response += "HTTP/1.1 #{status} #{RubyWolf::CRLF}"
      headers.each do |key, value|
        @response += "#{key}: #{value}#{RubyWolf::CRLF}"
      end

      @response += RubyWolf::CRLF
      body.each do |part|
        @response += part
      end
    ensure
      body.close if body.respond_to? :close
    end

    private

    def log_request
      RubyWolf.logger.info(
        [
          'HTTP/1.1',
          connection.method,
          request_path
        ].join(' ')
      )
    end

    def log_response
      RubyWolf.logger.info(
        "Response HTTP/1.1 #{status}"
      )
    end

    def request_path
      if connection.query
        "#{connection.path}?#{connection.query}"
      else
        connection.path
      end
    end
  end
end
