require 'logger'

module RubyWolf
  class Server
    attr_reader :app, :configs, :socket, :workers

    def initialize(rack_file, configs)
      @rack_file = rack_file
      @configs = configs
      @workers = []
    end

    def start
      trap_signal
      setup_rack
      setup_socket
      configs[:worker].times do
        workers << RubyWolf::Worker.new(self)
      end
      Process.detach if configs[:daemon]
      workers.each(&:start)
      handle_loop
    end

    private

    def setup_rack
      RubyWolf.log('~~~ Ruby Wolf ~~~')
      RubyWolf.log('Loading Rack application')
      @app, _rack_options = ::Rack::Builder.parse_file(@rack_file)
      Rails.logger = RubyWolf.logger if defined?(Rails)
      ActiveRecord::Base.logger = RubyWolf.logger if defined?(ActiveRecord)
    end

    def setup_socket
      @socket = TCPServer.new(configs[:host], configs[:port])
      RubyWolf.log("Server is running on #{configs[:host]}:#{configs[:port]}")
      RubyWolf.log("Process pid is #{Process.pid}")
      RubyWolf.log("Number of worker: #{configs[:worker]}")
    end

    def handle_loop
      while stopped_pid = Process.wait do
        stopped_worker = workers.find { |w| w.pid == stopped_pid }
        next unless stopped_worker

        RubyWolf.log("Worker with pid #{stopped_pid} suddenly stopped", :error)

        sleep(1)
        worker = RubyWolf::Worker.new(self)
        worker.start

        workers << worker
      end
    end

    def trap_signal
      Signal.trap(:INT) do
        if RubyWolf::MAIN_PID == Process.pid
          puts "Stopping server\n"
        else
          puts "Stopping worker #{Process.pid} \n"
        end
        exit
      end

      Signal.trap(:TERM) do
        if RubyWolf::MAIN_PID == Process.pid
          puts "Stopping server\n"
          workers.each do |w|
            Process.kill(:TERM, w.pid)
          end
        else
          puts "Stopping worker #{Process.pid} \n"
        end
        sleep 1
        exit
      end
    end
  end
end
