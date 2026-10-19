# frozen_string_literal: true

module OmniAuth
  module Skubana
    # The release workflow writes VERSION from the release tag; the committed
    # value is a 0.0.0 placeholder.
    VERSION = File.read(File.expand_path("../../VERSION", __dir__)).strip
  end
end
