# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Skubana < OmniAuth::Strategies::OAuth2

      option :client_options, {
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/token',
        :site => 'https://app.skubana.com',
        # Skubana expects the client credentials as HTTP Basic auth on the token
        # request. Pinned so it doesn't depend on the oauth2 version's default
        # (oauth2 1.x defaulted to :request_body).
        :auth_scheme => :basic_auth
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
    end
  end
end
