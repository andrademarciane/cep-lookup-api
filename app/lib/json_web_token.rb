require 'jwt'

class JsonWebToken
  class << self
    def encode(payload)
      JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
    end

    def decode(token)
      JWT.decode(
        token, Rails.application.secret_key_base, true, algorithm: 'HS256'
      )
    end

    # @param [String] token
    # @return [Hash]
    def get_payload(token)
      payload, _header = JWT.decode(token, nil, false, { verify_expiration: false })
      payload
    rescue JWT::DecodeError
      {}
    end

    def user_token(user)
      encode({ user_id: user.id })
    end
  end
end

