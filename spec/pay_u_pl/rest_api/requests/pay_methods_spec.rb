# frozen_string_literal: true

require "support/shared/context/configuration"
require "support/shared/context/authorization"
require "support/shared/examples/requests"

RSpec.describe PayUPl::RestApi::Requests::PayMethods do
  subject { described_class.call(**data) }

  include_context "set rest_api configuration"

  let(:path) { "/api/v2_1/paymethods?lang=en" }
  let(:http_method) { :get }
  let(:body) { nil }
  let(:response) do
    {
      "payByLinks": [
        {
          "value": "c",
          "name": "Płatność online kartą płatniczą",
          "brandImageUrl": "https://static.payu.com/images/mobile/logos/pbl_c.png",
          "status": "ENABLED",
          "minAmount": 50,
          "maxAmount": 100_000
        },
        {
          "value": "o",
          "name": "Pekao24Przelew",
          "brandImageUrl": "https://static.payu.com/images/mobile/logos/pbl_o.png",
          "status": "DISABLED",
          "minAmount": 50,
          "maxAmount": 100_000
        },
        {
          "value": "ab",
          "name": "Płacę z Alior Bankiem",
          "brandImageUrl": "https://static.payu.com/images/mobile/logos/pbl_ab.png",
          "status": "TEMPORARY_DISABLED",
          "minAmount": 50,
          "maxAmount": 100_000
        }
      ]
    }.to_json
  end

  include_context "set rest_api authorization"

  context "when data is valid" do
    let(:data) do
      {
        lang: "en"
      }
    end

    include_examples "base valid rest_api requests"
  end

  context "when data is invalid" do
    let(:data) do
      {
        lang: ""
      }
    end
    let(:class_name) { described_class.name }
    let(:error_messages) do
      {
        status: {
          status_code: "ERROR_ATTRIBUTES_NOT_VALID",
          errors: {
            lang: ["must be filled"]
          }
        },
        response_status: 422
      }
    end

    include_examples "base invalid rest_api requests"
  end
end
