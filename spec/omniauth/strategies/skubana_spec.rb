require "spec_helper"

describe OmniAuth::Strategies::Skubana do
  def app
    lambda do |_env|
      [200, {}, ["Hello."]]
    end
  end
  let(:strategy) { Class.new(OmniAuth::Strategies::Skubana) }

  describe "#client_options" do
    subject { strategy.new(app).options.client_options }

    it 'should have correct site' do
      expect(subject.site).to eq("https://app.skubana.com")
    end

    it 'should have correct authorize url' do
      expect(subject.authorize_url).to eq('/oauth/authorize')
    end

    it 'should have correct token url' do
      expect(subject.token_url).to eq('/oauth/token')
    end
  end
=begin
  describe "#authorize_params" do
    subject { fresh_strategy }

    it "includes any authorize params passed in the :authorize_params option" do
      instance = subject.new("abc", "def", :authorize_params => {:foo => "bar", :baz => "zip"})
      expect(instance.authorize_params["foo"]).to eq("bar")
      expect(instance.authorize_params["baz"]).to eq("zip")
    end

    it "includes top-level options that are marked as :authorize_options" do
      instance = subject.new("abc", "def", :authorize_options => [:scope, :foo, :state], :scope => "bar", :foo => "baz")
      expect(instance.authorize_params["scope"]).to eq("bar")
      expect(instance.authorize_params["foo"]).to eq("baz")
    end

    it "includes random state in the authorize params" do
      instance = subject.new("abc", "def")
      expect(instance.authorize_params.keys).to eq(["state"])
      expect(instance.session["omniauth.state"]).not_to be_empty
    end
  end

  describe "#token_params" do
    subject { fresh_strategy }

    it "includes any authorize params passed in the :authorize_params option" do
      instance = subject.new("abc", "def", :token_params => {:foo => "bar", :baz => "zip"})
      expect(instance.token_params).to eq("foo" => "bar", "baz" => "zip")
    end

    it "includes top-level options that are marked as :authorize_options" do
      instance = subject.new("abc", "def", :token_options => [:scope, :foo], :scope => "bar", :foo => "baz")
      expect(instance.token_params).to eq("scope" => "bar", "foo" => "baz")
    end
  end

  describe "#callback_phase" do
    subject { fresh_strategy }
    it "calls fail with the client error received" do
      instance = subject.new("abc", "def")
      allow(instance).to receive(:request) do
        double("Request", :params => {"error_reason" => "user_denied", "error" => "access_denied"})
      end

      expect(instance).to receive(:fail!).with("user_denied", anything)
      instance.callback_phase
    end
  end
end

describe OmniAuth::Strategies::OAuth2::CallbackError do
  let(:error) { Class.new(OmniAuth::Strategies::OAuth2::CallbackError) }
  describe "#message" do
    subject { error }
    it "includes all of the attributes" do
      instance = subject.new("error", "description", "uri")
      expect(instance.message).to match(/error/)
      expect(instance.message).to match(/description/)
      expect(instance.message).to match(/uri/)
    end
    it "includes all of the attributes" do
      instance = subject.new(nil, :symbol)
      expect(instance.message).to eq("symbol")
    end
  end
=end
end
