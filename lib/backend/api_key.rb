module Eveauth
  class APIKey
    include Mongoid::Document

    field :k_id, as: :key_id, type: Integer
    field :vcode, type: String
    field :am, as: :access_mask, type: String
    field :exp, as: :expires, type: Date, default: nil
    field :c_ids, as: :character_ids, type: Array

  end
end
