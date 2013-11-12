module Eveauth
  class Capsuleer
    include Mongoid::Document

    attr_accessor :authenticated
    @authenticated = false
    # TODO: before save callback to check if atheticated, DO NOT SAVE otherwise

    field :n, as: :name, type: String
    field :pw, as: :password_digest, type: String
    field :c_id, as: :capsuleer_id, type: Integer
    field :ll, as: :last_login, type: DateTime, default: ->{ DateTime.now }
    field :srmt, as: :secret_remember_me_token, type: String

    field :corp, as: :corporation, type: String
    embeds_many :api_keys, class_name: "Eveauth::APIKey"
    accepts_nested_attributes_for :api_keys

    index({ n: 1}, { unique: true })
    index({ srmt: 1}, { unique: true })

    def authenticated?
      @authenticated
      # TODO: before save callback to check if atheticated, DO NOT SAVE otherwise
    end

    def password=(pw)
      self.password_digest = BCrypt::Password.create(pw)
    end

    def is_this_your_password?(pass)
      BCrypt::Password.new(self.password_digest) == pass
    end

    def secret_remember_me_token!
      # abitrarily choosing 32 as the length to be "secure enough"
      s = SecureRandom.hex(32)
      self.srmt = s
      self.save
      s
    end

    def api_keys_character_ids
      # TODO: check if the access mask for each individual key allows the usage of the data you intend to present to the client.
      # otherwise someone mallicious could add a limited api key of someone else who uses your service (however he/she gets that..)
      # and an all-access key of himself and view all access data of the other guy that way
      api_keys.collect {|api_key| api_keys.character_id}
    end

  end
end