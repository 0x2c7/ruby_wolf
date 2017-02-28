# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_wolf/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_wolf'
  spec.version       = RubyWolf::VERSION
  spec.authors       = ['Nguyễn Quang Minh']
  spec.email         = ['nguyenquangminh0711@gmail.com']

  spec.summary       = 'A simple ruby web server using pre-fork and epoll / kqueue'
  spec.description   = 'A simple ruby web server using pre-fork and epoll / kqueue'
  spec.homepage      = 'https://github.com/nguyenquangminh0711/ruby_wolf'

  spec.license       = 'MIT'

  spec.files         = Dir["#{File.expand_path('../lib', __FILE__)}/**/*.rb"]
  spec.bindir        = 'bin'
  spec.executables   = ['ruby_wolf']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'byebug'

  spec.add_runtime_dependency 'rack', '>2.0.0'
  spec.add_runtime_dependency 'http_parser.rb'
end
