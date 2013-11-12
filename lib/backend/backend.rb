require 'bcrypt'
require 'mongoid'

Mongoid.raise_not_found_error  = false

require_relative 'api_key'
require_relative 'capsuleer'