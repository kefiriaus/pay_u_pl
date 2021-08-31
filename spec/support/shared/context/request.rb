# frozen_string_literal: true

RSpec.shared_context "stub rest_api request" do
  let(:url) { "https://www.example.com#{path}" }
  let(:stubed_request) { stub_request(http_method, url) }
end
