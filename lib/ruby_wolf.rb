require 'byebug'
require 'rack'

require 'ruby_wolf/version'
require 'ruby_wolf/configuration'
require 'ruby_wolf/connection'
require 'ruby_wolf/connection_manager'
require 'ruby_wolf/server'
require 'ruby_wolf/worker'
require 'ruby_wolf/cli'

module RubyWolf
  MAIN_PID = Process.pid

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.log(content, mode = :info)
    contents = content.to_s.split("\n")
    object = Process.pid == MAIN_PID ? '[Main]' : "[Worker #{Process.pid}]"
    contents.each do |line|
      logger.send(mode, "#{object} #{line}")
    end
  end
end
