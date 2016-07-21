module TwitterOauth
  class Client
    BASE_URL = 'https://api.twitter.com'
    OAUTH_RESERVED_CHARACTERS = /[^a-zA-Z0-9\-\.\_\~]/

    include HTTParty
    base_uri BASE_URL
    debug_output $stdout if Rails.env.development?

    def self.request_token callback
      path = '/oauth/request_token'
      params = { oauth_callback: callback }

      res = signed_post path, params
      hash = Rack::Utils.parse_nested_query(res)
      if res.ok?
        {
          oauth_token: hash['oauth_token'],
          oauth_token_secret: hash['oauth_token_secret'],
          oauth_callback_confirmed: hash['oauth_callback_confirmed'] == 'true'
        }
      else
        if hash['errors'].present? && hash['errors'].first.present?
          return { error: hash['errors'].first['message'] }
        end
        {}
      end
    end

    def self.exchange_access_token oauth_token, oauth_verifier
      path = '/oauth/access_token'
      params = { oauth_verifier: oauth_verifier }

      res = signed_post path, params, oauth_token
      hash = Rack::Utils.parse_nested_query(res)
      if res.ok?
        {
          oauth_token: hash['oauth_token'],
          oauth_token_secret: hash['oauth_token_secret'],
          user_id: hash['user_id'],
          screen_name: hash['screen_name']
        }
      else
        if hash['errors'].present? && hash['errors'].first.present?
          return { error: hash['errors'].first['message'] }
        end
        {}
      end
    end

    private

    def self.signed_post path, params, access_token = nil, access_token_secret = nil
      all_params = unsigned_headers(access_token).merge(params)
      signature = build_signature(:post, path, all_params, access_token_secret)
      all_params.merge!(oauth_signature: signature)

      body = params.select { |k, v| !k.to_s.start_with? "oauth" }
      post path, { headers: build_authorization_header(all_params), body: body }
    end

    def self.unsigned_headers access_token
      h = {
        oauth_consumer_key: ENV['TWITTER_CONSUMER_KEY'],
        oauth_signature_method: "HMAC-SHA1",
        oauth_version: "1.0",
        oauth_timestamp: Time.now.to_i,
        oauth_nonce: SecureRandom.hex,
      }
      h.merge!(oauth_token: access_token) if access_token
      h
    end

    def self.build_signature verb, path, headers, access_token_secret
      pstr = build_encoded_params_string(headers)

      base = [verb.to_s.upcase, BASE_URL + path, pstr].map { |s| urlencode(s) }.join("&")
      key = urlencode(ENV['TWITTER_CONSUMER_SECRET']) + "&" + urlencode(access_token_secret)
      digest = OpenSSL::Digest.new('sha1')
      hex = OpenSSL::HMAC.digest(digest, key, base)
      Base64.encode64(hex).chomp
    end

    def self.build_encoded_params_string params
      params
        .map { |key, value| [urlencode(key), urlencode(value)] }
        .sort { |lpair, rpair| lpair.first <=> rpair.first }
        .map { |pair| pair.join("=") }
        .join("&")
    end

    def self.build_authorization_header headers
      q = headers
        .select { |key, value| key.to_s.start_with? "oauth" }
        .map { |key, value| [urlencode(key), "\"#{urlencode(value)}\""] }
        .map { |pair| pair.join("=") }
        .join(", ")
      {"Authorization" => "OAuth #{q}"}
    end

    def self.urlencode input
      URI::escape(input.to_s, OAUTH_RESERVED_CHARACTERS)
    end
  end
end
