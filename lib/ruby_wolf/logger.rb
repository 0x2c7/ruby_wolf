require 'logger'

module RubyWolf
  class Logger < ::Logger
    def initialize(*args)
      super(*args)
      @formatter = proc do |severity, datetime, _progname, msg|
        date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
        "[#{severity.to_s[0]}] [#{date_format}] #{msg}\n"
      end
    end

    def info(contents = '')
      pre_process(contents) do |content|
        super(content)
      end
    end

    def warn(contents = '')
      pre_process(contents) do |content|
        super(content)
      end
    end

    def debug(contents = '')
      pre_process(contents) do |content|
        super(content)
      end
    end

    def error(contents = '')
      pre_process(contents) do |content|
        super(content)
      end
    end

    def fatal(contents = '')
      pre_process(contents) do |content|
        super(content)
      end
    end

    private

    def pre_process(contents)
      object = Process.pid == MAIN_PID ? '[Main]' : "[Worker #{Process.pid}]"
      contents.to_s.split("\n").each do |line|
        yield("#{object} #{line}")
      end
    end
  end
end
