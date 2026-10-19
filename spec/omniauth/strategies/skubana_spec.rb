# frozen_string_literal: true

RSpec.describe OmniAuth::Strategies::Skubana do
  let(:inner_app) { ->(_env) { [200, {}, ["Hello."]] } }
  let(:strategy_options) { {} }
  let(:strategy) { described_class.new(inner_app, "app_key", "app_secret", **strategy_options) }

  def app
    described_class.new(inner_app, "app_key", "app_secret", **strategy_options)
  end

  describe "#client_options" do
    subject(:client_options) { strategy.options.client_options }

    it "points at the Skubana site" do
      expect(client_options.site).to eq("https://app.skubana.com")
    end

    it "has the correct authorize url" do
      expect(client_options.authorize_url).to eq("/oauth/authorize")
    end

    it "has the correct token url" do
      expect(client_options.token_url).to eq("/oauth/token")
    end

    it "sends client credentials with HTTP basic auth" do
      expect(client_options.auth_scheme).to eq(:basic_auth)
    end

    context "when the site is overridden" do
      let(:strategy_options) { {client_options: {site: "https://demo.skubana.com"}} }

      it "uses the configured site" do
        expect(client_options.site).to eq("https://demo.skubana.com")
      end
    end
  end

  describe "the request phase" do
    around do |example|
      previous = OmniAuth.config.request_validation_phase
      OmniAuth.config.request_validation_phase = proc {}
      example.run
      OmniAuth.config.request_validation_phase = previous
    end

    it "redirects to Skubana's authorize endpoint" do
      post "/auth/skubana", {}, "rack.session" => {}

      expect(last_response.status).to eq(302)
      location = URI.parse(last_response.headers["Location"])
      expect("#{location.scheme}://#{location.host}#{location.path}")
        .to eq("https://app.skubana.com/oauth/authorize")
      expect(URI.decode_www_form(location.query).to_h)
        .to include("client_id" => "app_key", "response_type" => "code")
    end

    context "when a scope is configured" do
      let(:strategy_options) { {scope: "read_inventory write_inventory"} }

      it "passes the scope through to the authorize url" do
        post "/auth/skubana", {}, "rack.session" => {}

        query = URI.decode_www_form(URI.parse(last_response.headers["Location"]).query).to_h
        expect(query["scope"]).to eq("read_inventory write_inventory")
      end
    end

    # The redirect_uri sent to Skubana must exactly match the registered one.
    it "sends a redirect_uri without the request's query params" do
      post "/auth/skubana?type=shopping", {}, "rack.session" => {}

      query = URI.decode_www_form(URI.parse(last_response.headers["Location"]).query).to_h
      expect(query["redirect_uri"]).to eq("http://example.org/auth/skubana/callback")
    end
  end

  describe "the callback phase" do
    # provider_ignores_state is set, so the callback needs no session state.
    let(:session) { {} }
    let(:token_url) { "#{strategy.options.client_options[:site]}/oauth/token" }

    before do
      stub_request(:post, token_url).to_return(
        status: 200,
        body: {access_token: "token123", token_type: "Bearer"}.to_json,
        headers: {"Content-Type" => "application/json"}
      )
    end

    def complete_callback(query = "", env = {})
      post "/auth/skubana/callback#{query}",
           {"code" => "auth_code"},
           {"rack.session" => session}.merge(env)
    end

    def token_request
      request = nil
      expect(WebMock).to have_requested(:post, token_url).with { |req| request = req; true }
      request
    end

    def token_request_body
      URI.decode_www_form(token_request.body).to_h
    end

    it "exchanges the code with the client credentials in an HTTP basic auth header" do
      complete_callback

      expect(token_request.headers["Authorization"])
        .to eq("Basic #{["app_key:app_secret"].pack("m0")}")
    end

    it "does not also send the client secret in the body" do
      complete_callback

      expect(token_request_body).not_to have_key("client_secret")
    end

    it "sends a redirect_uri without query params" do
      complete_callback("?type=shopping")

      expect(token_request_body["redirect_uri"]).to eq("http://example.org/auth/skubana/callback")
    end

    it "keeps the mount point in the redirect_uri only once" do
      complete_callback("", "SCRIPT_NAME" => "/users")

      expect(token_request_body["redirect_uri"]).to eq("http://example.org/users/auth/skubana/callback")
    end

    it "builds an auth hash carrying the token" do
      complete_callback

      credentials = last_request.env["omniauth.auth"]["credentials"]
      expect(credentials["token"]).to eq("token123")
      expect(credentials["expires"]).to be(false)
    end

    context "when configured for another site" do
      let(:strategy_options) { {client_options: {site: "https://demo.skubana.com"}} }

      it "exchanges the token against the configured host" do
        complete_callback

        expect(WebMock).to have_requested(:post, "https://demo.skubana.com/oauth/token")
        expect(last_request.env["omniauth.auth"]["credentials"]["token"]).to eq("token123")
      end
    end
  end

  describe "#callback_url" do
    subject(:callback_url) { strategy.callback_url }

    context "when callback_url is configured" do
      let(:strategy_options) { {callback_url: "https://app.example.com/auth/skubana/callback"} }

      it "uses the configured value verbatim" do
        expect(callback_url).to eq("https://app.example.com/auth/skubana/callback")
      end
    end
  end
end
