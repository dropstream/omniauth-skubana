# frozen_string_literal: true

RSpec.describe OmniAuth::Skubana do
  it "has a version number" do
    expect(OmniAuth::Skubana::VERSION).not_to be nil
  end

  it "reads the version from the VERSION file" do
    expect(OmniAuth::Skubana::VERSION).to eq(File.read(File.expand_path("../../VERSION", __dir__)).strip)
  end
end
