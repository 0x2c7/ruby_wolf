require 'http/parser'

module RubyWolf
  class Handler

    attr_reader :app, :env, :connection, :response, :callback

    def initialize(app, connection, &callback)
      @app = app
      @connection = connection
      @callback = callback
      @env = {}
      @response = ''
    end

    def process
      prepare_rack_env
      parse_request
      generate_response
      callback.call(response) if callback
      response
    end

    private

    def prepare_rack_env
      @env = ENV.to_h
      @env.delete 'HTTP_CONTENT_LENGTH'
      url_scheme = %w(yes on 1).include?(ENV[::Rack::HTTPS]) ? 'https' : 'http'
      @env.update(
        ::Rack::RACK_VERSION      => ::Rack::VERSION,
        ::Rack::RACK_INPUT        => STDIN,
        ::Rack::RACK_ERRORS       => STDERR,
        ::Rack::RACK_MULTITHREAD  => false,
        ::Rack::RACK_MULTIPROCESS => true,
        ::Rack::RACK_RUNONCE      => true,
        ::Rack::RACK_URL_SCHEME   => url_scheme,
        ::Rack::SERVER_PROTOCOL   => 'HTTP/1.1'
      )
    end

    def parse_request
      parser = Http::Parser.new
      parser.on_headers_complete = proc do
        env[::Rack::HTTP_VERSION] = parser.http_version
        env[::Rack::REQUEST_METHOD] = parser.http_method

        uri = URI.parse(parser.request_url)
        env[::Rack::REQUEST_PATH] = uri.path
        env[::Rack::QUERY_STRING] = uri.query
      end
      parser << connection.read_data
      RubyWolf.log(
        [
          "HTTP/#{env[::Rack::HTTP_VERSION].join('.')}",
          env[::Rack::REQUEST_METHOD],
          "#{env[::Rack::REQUEST_PATH]}?#{env[::Rack::QUERY_STRING]}"
        ].join(' ')
      )
    end

    def generate_response
      status, headers, body = app.call(env)
      RubyWolf.log(
        "Response #{env[::Rack::SERVER_PROTOCOL]} #{status}"
      )
      compose_response(status, headers, body)
    end

    def compose_response(status, headers, body)
      @response += "#{env[::Rack::SERVER_PROTOCOL]} #{status} #{RubyWolf::CRLF}"
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
  end
end
