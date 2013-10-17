require 'oauth2'

module OAuth2
  class DetikConnectAccessToken < AccessToken
    def self.from_hash(client, hash)
      self.new(client, hash.delete('accessToken') || hash.delete(:accessToken), hash)
    end

    def initialize(client, token, opts={})
      @client = client
      @token = token.to_s
      [:refresh_token, :expires_in, :expires_at].each do |arg|
        instance_variable_set("@#{arg}", opts.delete(arg) || opts.delete(arg.to_s))
      end
      @expires_in ||= opts.delete('expired')
      @expires_in &&= @expires_in.to_i
      @expires_at &&= @expires_at.to_i
      @expires_at ||= Time.now.to_i + @expires_in if @expires_in
      @options = {:mode          => opts.delete(:mode) || :header,
                  :header_format => opts.delete(:header_format) || 'Bearer %s',
                  :param_name    => opts.delete(:param_name) || 'accessToken'}
      @params = opts
    end

    def to_hash
      params.merge({:accessToken => token, :refreshToken => refresh_token, :expires_at => expires_at})
    end

  end
end
