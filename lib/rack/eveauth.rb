require 'sinatra/base'
require_relative '../backend/backend'
require 'json'

# TODO: write tests; run tests; do the same with specs or whatever

module Rack

  require_relative 'eveauth_helper'

  class Eveauth < Sinatra::Base
    enable :sessions
    helpers EveauthHelper

    before do

      # check if this is the very first request and Mongoid has not yet connected
      if settings.mongo_uri
        ::Mongoid::Config.sessions = {default: {uri: settings.mongo_uri }}
        settings.mongo_uri = nil
      end

      # first: check for IGB and if present, encapsulate the igb object in the request environment
      # also make sure that there is no capsuleer set for whatever hackish reason
      env[:igb] = request.user_agent =~ /EVE-IGB/ ? IGBRequest.new(self.env) : nil
      env[:capsuleer] = nil

      # secondly, check if we have a valid session running
      if session[:srmt]
        capsuleer = ::Eveauth::Capsuleer.where({secret_remember_me_token: session[:srmt]}).first
        if capsuleer
          capsuleer.authenticated=true
          env[:capsuleer] = capsuleer
          return
        else
          session[:srmt] = nil
        end
      end

      # third: build the capsuleer object for this session
      if env[:igb] and env[:igb].trusted?
        env[:capsuleer] = ::Eveauth::Capsuleer.new(
            {name: env[:igb].CHARNAME,
             capsuleer_id: env[:igb].CHARID,
             corporation: env[:igb].CORPNAME
            }
        )
      else
        env[:capsuleer] = ::Eveauth::Capsuleer.new(
            {name: "Anonymous",
             capsuleer_id: 42,
             corporation: "Anon Inc."
            }
        )
      end
    end

  end

  require_relative '../controller/auth_controller'
  require_relative '../controller/apikey_controller'

end
