require 'sinatra/base'
require File.join(File.expand_path(File.dirname(__FILE__)), '../lib/eveauth')

class TestApp < Sinatra::Base
  # middleware will run before filters
  Rack::Eveauth.set :mongo_uri, ENV['MONGO_URI']+"_#{ENV['RACK_ENV'] || "development"}"
  use Rack::Eveauth

  before do
    unless env[:capsuleer]
      halt "Access denied, please <a href='/login'>login</a>."
    end
  end

  get('/') { "Hello #{env[:capsuleer].name}" }

end