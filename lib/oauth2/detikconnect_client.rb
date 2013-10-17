require 'oauth2'

module OAuth2
  class DetikConnectClient < Client

    def initialize(client_id, client_secret, opts={}, &block)
      super(client_id, client_secret, opts, &block)
      options[:token_method] = :get
    end
    def auth_code
      @auth_code ||= Strategy::DetikConnectAuthCode.new(self)
    end

    def get_token(params, access_token_opts={}, access_token_class = DetikConnectAccessToken)
      opts = {:raise_errors => options[:raise_errors], :parse => params.delete(:parse)}
      if options[:token_method] == :post
        headers = params.delete(:headers)
        opts[:body] = params
        opts[:headers] =  {'Content-Type' => 'application/x-www-form-urlencoded'}
        opts[:headers].merge!(headers) if headers
      else
        opts[:params] = params
      end
      response = request(options[:token_method], token_url, opts)
      raise Error.new(response) if options[:raise_errors] && !(response.parsed.is_a?(Hash) && response.parsed['accessToken'])
      access_token_class.from_hash(self, response.parsed.merge(access_token_opts))
    end
  end
end
