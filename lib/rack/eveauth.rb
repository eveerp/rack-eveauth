require 'sinatra/base'
require_relative '../backend/backend'

# TODO: write tests; run tests; do the same with specs or whatever

module Rack

  require_relative 'eveauth_helper'

  class Eveauth < Sinatra::Base
    enable :sessions
    helpers EveauthHelper

    set :views, ::File.join(::File.dirname(__FILE__), '..', '..', 'views')

    before do

      # check if this is the very first request and Mongoid has not yet connected
      if settings.mongo_uri
        ::Mongoid::Config.sessions = {default: {uri: settings.mongo_uri }}
        settings.mongo_uri = nil
      end

      # first: check for IGB and if present, encapsulate the igb object in the request
      def request.igb
        @igb = self.user_agent =~ /EVE-IGB/ ? IGBRequest.new(self.env) : nil unless @igb
        @igb
      end

      # secondly, check if we have a valid session running
      if session[:srmt]
        capsuleer = ::Eveauth::Capsuleer.where({secret_remember_me_token: session[:srmt]}).first
        if capsuleer
          capsuleer.authenticated=true
          session[:capsuleer] = capsuleer
          return
        else
          session[:srmt] = nil
        end
      end

      # third: build the capsuleer object for this session
      if request.igb and request.igb.trusted?
        session[:capsuleer] = ::Eveauth::Capsuleer.new(
            {name: request.igb.CHARNAME,
             capsuleer_id: request.igb.CHARID,
             corporation: request.igb.CORPNAME
            }
        )
      else
        session[:capsuleer] = ::Eveauth::Capsuleer.new(
            {name: "Anonymous",
             capsuleer_id: 42,
             corporation: "Anon Inc."
            }
        )
      end

    end

    get('/auth') { erb :authscreen }

    post('/auth') do
      if params["auth_or_register"] == "register"
        if register!(params["password"])
          erb :registered
        else
          redirect "/auth"
        end
      else
        auth_with_password(params["capsuleer_name"],params["password"])
      end
    end

  end

end
