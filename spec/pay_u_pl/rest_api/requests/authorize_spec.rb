# frozen_string_literal: true

require "support/shared/context/configuration"
require "support/shared/examples/requests"

RSpec.describe PayUPl::RestApi::Requests::Authorize do
  subject { described_class.call(**data) }

  include_context "set rest_api configuration"

  let(:path) { "/pl/standard/user/oauth/authorize?client_id=12345&client_secret=1234567890&grant_type=client_credentials" }
  let(:http_method) { :post }
  let(:headers) { {} }

  let(:body) { nil }

  let(:response) do
    {
      "access_token": "7524f96e-2d22-45da-bc64-778a61cbfc26",
      "token_type": "bearer",
      "expires_in": 43_199,
      "grant_type": "client_credentials"
    }.to_json
  end

  context "when data is valid" do
    let(:data) { {} }

    include_examples "base valid rest_api requests"
  end

  context "when data is invalid" do
    let(:data) do
      {
        grant_type: ""
      }
    end
    let(:class_name) { described_class.name }
    let(:error_messages) do
      {
        status: {
          status_code: "ERROR_ATTRIBUTES_NOT_VALID",
          errors: {
            grant_type: ["must be filled"]
          }
        },
        response_status: 422
      }
    end

    include_examples "base invalid rest_api requests"
  end
end
