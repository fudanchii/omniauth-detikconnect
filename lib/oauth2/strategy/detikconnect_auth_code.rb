require 'oauth2'

module OAuth2
  module Strategy
    class DetikConnectAuthCode < AuthCode
      def client_params
        { 'clientId' => @client.id, 'clientSecret' => @client.secret } 
      end

      def authorize_params(params={})
        params.merge('clientId' => @client.id) 
      end

      def get_token(code, params={}, opts={})
        params = {'code' => code}.merge(client_params).merge(params)
        @client.get_token(params, opts)
      end
    end
  end
end
