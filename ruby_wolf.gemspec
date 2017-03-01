# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_wolf/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_wolf'
  spec.version       = RubyWolf::VERSION
  spec.authors       = ['Nguyễn Quang Minh']
  spec.email         = ['nguyenquangminh0711@gmail.com']

  spec.summary       = 'A simple ruby web server using pre-fork and event loop'
  spec.description   = 'My simple implementation of Rack web server using pre-fork and event loop'
  spec.homepage      = 'https://github.com/nguyenquangminh0711/ruby_wolf'

  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = 'bin'
  spec.executables   = ['ruby_wolf']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '>=3.5.0'
  spec.add_development_dependency 'byebug', '>=9.0.0'

  spec.add_runtime_dependency 'rack', '>=1.4.0'
  spec.add_runtime_dependency 'http_parser.rb', '>=0.6.0'
end
