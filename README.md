rack-eveauth
=================
This is a prototype of a Rack middleware to create and authenticate users and connect sessions with their EvE Online capsuleers using the IGB.


settings:
===

*   :mongo_uri => nil (required)

Examples:
===
```ruby
require 'rack-eveauth'
Rack::Eveauth.set :mongo_uri, ENV['MONGO_URI']+"_#{ENV['RACK_ENV'] || "development"}"
use Rack::Eveauth
```
