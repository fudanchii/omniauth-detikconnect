require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class DetikConnect < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://connect.detik.com',
        :authorize_url => 'https://connect.detik.com/oauth/authorize',
        :token_url => '/oauth/accessToken'
      }

      def client
        OAuth2::DetikConnectClient.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
      end

      def request_phase
        super
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

      uid { raw_info['id'].to_s }

      info do
        {
          'nickname' => raw_info['login'],
          'email' => email,
          'name' => raw_info['name'],
          'image' => raw_info['avatar_url'],
          'urls' => {
            'GitHub' => "https://github.com/#{raw_info['login']}",
            'Blog' => raw_info['blog'],
          },
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        access_token.options[:mode] = :query
        @raw_info ||= access_token.get('user').parsed
      end

      end
    end
  end
end

OmniAuth.config.add_camelization 'detikconnect', 'DetikConnect'
