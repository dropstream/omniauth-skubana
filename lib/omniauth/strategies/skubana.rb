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

      # Set on a provider registered for App Store installs, with its
      # callback_path at the callback URI registered for the app with Skubana.
      # An install is started by Skubana, not by us: it redirects there with
      # `?cid=...&code=...` and no state to check. Accepting that means anyone
      # can deliver a code of their choosing to a signed-in user's callback, so
      # installs are only handled when the host app sets this.
      option :app_store_install, false

      def callback_phase
        # Safe to change: OmniAuth dups the options for every request.
        options.provider_ignores_state = true if app_store_install?
        super
      end

      # OmniAuth::Strategy#callback_url appends the callback request's own query
      # string, which would send those params to Skubana as part of redirect_uri.
      # Skubana requires redirect_uri to exactly match the URI registered for the
      # app. Note that omniauth 2's `callback_path` already carries SCRIPT_NAME,
      # so mount prefixes must not be added again.
      #
      # An App Store install's code must be exchanged with
      # `redirect_uri=<registered URI>?cid=<cid>`.
      def callback_url
        url = options[:callback_url] || (full_host + callback_path)
        app_store_install? ? "#{url}?cid=#{request.params["cid"]}" : url
      end

      private

      def app_store_install?
        return false unless options.app_store_install && @env

        cid = request.params["cid"]
        cid.is_a?(String) && !cid.empty? && request.params["state"].to_s.empty?
      end
    end
  end
end
