# frozen_string_literal: true

RSpec.shared_context "set rest_api configuration" do
  before do
    PayUPl::RestApi.configure do |config|
      config.gateway = "https://www.example.com"
      config.currency_code = "usd"
      config.client_id = "12345"
      config.client_secret = "1234567890"
      config.pos_id = "123456"
    end
  end
end
