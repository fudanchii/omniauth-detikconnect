require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class DetikConnect < OAuth2

      option :provider_ignores_state, true
      option :auth_token_params, {}

      option :client_options, {
        :site => 'https://connect.detik.com',
        :authorize_url => 'https://connect.detik.com/oauth/authorize',
        :token_url => 'https://connect.detik.com/oauth/accessToken'
      }

      def client
        ::OAuth2::DetikConnectClient.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
      end

      def request_phase
        redirect client.auth_code.authorize_url({:redirectUrl => callback_url}.merge(authorize_params))
      end

      def build_access_token
        verifier = request.params['code']
        client.auth_code.get_token(verifier, {
          :redirectUrl => callback_url
        }.merge(token_params.to_hash(:symbolize_keys => true)), \
          deep_symbolize(options.auth_token_params))
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid { raw_info['userId'].to_s }

      info do
        {
          'nickname' => raw_info['username'],
          'email' => raw_info['email'],
          'name' => raw_info['name'],
          'image' => raw_info['profilePicture']
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        access_token.options[:mode] = :query
        @raw_info ||= access_token.get('rest/user').parsed
      end

    end
  end
end

OmniAuth.config.add_camelization 'detikconnect', 'DetikConnect'
