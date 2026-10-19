require 'omniauth-oauth2'
require 'base64'

module OmniAuth
  module Strategies
    class Skubana < OmniAuth::Strategies::OAuth2

      option :client_options, {
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/token',
        :site => 'https://app.skubana.com'
      }

      option :callback_url
      
      option :provider_ignores_state, true

      # OmniAuth::Strategy#callback_url appends the callback request's own query
      # string, which would send those params to Skubana as part of redirect_uri.
      # Skubana requires redirect_uri to exactly match the URI registered for the
      # app. Note that omniauth 2's `callback_path` already carries SCRIPT_NAME,
      # so mount prefixes must not be added again.
      def callback_url
        options[:callback_url] || (full_host + callback_path)
      end

      protected 

      def build_access_token
        options.token_params.merge!(:headers => {'Authorization' => basic_auth_header })
        super
      end
      
      private

      def basic_auth_header
        "Basic " + Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")
      end      
    end
  end
end
