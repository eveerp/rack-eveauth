lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "rack-eveauth"
  s.version     = "0.42.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marvin Frick"]
  s.email       = ["marv@marvinfrick.me"]
  s.homepage    = "https://github.com/eveerp/rack-eveauth"
  s.summary     = "Rack middleware to create and authenticate users and connect sessions with their EvE Online capsuleers using the IGB"
  s.description = "It could be quite usefull..."
  s.required_rubygems_version = ">= 1.3.6"
  s.required_ruby_version = '>= 1.8.7'

  s.files        = Dir.glob("{lib}/**/*") + Dir.glob("{test/**/*}") + %w(README.md)
  s.require_path = 'lib'

  s.add_dependency "evestatic"
  s.add_dependency "rake"
  s.add_dependency 'mongoid'
  s.add_dependency "bcrypt-ruby"
  s.add_dependency 'sinatra'
  s.add_development_dependency 'rspec'
  s.add_development_dependency "shotgun"
end
