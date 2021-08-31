# frozen_string_literal: true

RSpec.shared_context "set rest_api authorization" do
  let(:access_token) { "7524f96e-2d22-45da-bc64-778a61cbfc26" }
  let(:headers) { { "Authorization" => "Bearer #{access_token}" } }

  before do
    allow(PayUPl::RestApi::Requests::Authorize).to receive_message_chain(:call, :to_json) do
      {
        access_token: access_token,
        token_type: "bearer",
        expires_in: 43_199,
        grant_type: "client_credentials"
      }
    end
  end
end
