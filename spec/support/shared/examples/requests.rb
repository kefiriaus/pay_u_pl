# frozen_string_literal: true

require "support/shared/context/request"
require "support/shared/examples/configuration"
require "support/shared/examples/responses"

RSpec.shared_examples "base valid rest_api requests" do
  include_context "stub rest_api request"

  let!(:stubed_request_with_options) do
    stubed_request.with(request_options).to_return(status: response_code, body: response, headers: {})
  end
  let(:request_options) do
    options = { headers: { "Content-Type" => "application/json" } }
    options[:headers].merge!(headers)
    options[:body] = body.to_json if body
    options
  end
  let(:response_json) { JSON.parse(response).underscore_keys.deep_symbolize_keys.merge(response_status: response_code) }

  context "with success response" do
    let(:response_code) { 200 }

    it "makes http request" do
      subject
      expect(stubed_request_with_options).to have_been_requested
    end

    context "with wrong configuration" do
      include_examples "wrong rest_api configuration"
    end

    context "with valid json" do
      let(:response_success) { true }
      let(:response_error) { false }

      include_examples "base rest_api responses"
    end

    context "with not json response" do
      let(:response_success) { true }
      let(:response_error) { false }
      let(:response) { "ERROR" }
      let(:response_json) { { data: "ERROR", response_status: response_code } }

      include_examples "base rest_api responses"
    end
  end

  context "with error response" do
    let(:response_code) { 400 }
    let(:response) do
      {
        "status": {
          "statusCode": "ERROR_SYNTAX"
        }
      }.to_json
    end
    let(:error_messages) do
      {
        status: {
          status_code: "ERROR_SYNTAX"
        },
        response_status: 400
      }
    end

    it "raises error" do
      expect { subject.to_json }.to raise_error(PayUPl::ProcessFailed)
    end

    it "raises error with messages" do
      expect { subject.to_json }.to(
        raise_error { |error| expect(error.messages).to eq(error_messages) }
      )
    end

    context "with wrong configuration" do
      include_examples "wrong rest_api configuration"
    end
  end

  context "with server error response" do
    let(:response_code) { 500 }
    let(:response) do
      {
        "status": {
          "statusCode": "BUSINESS_ERROR"
        }
      }.to_json
    end
    let(:error_messages) do
      {
        status: {
          status_code: "BUSINESS_ERROR"
        },
        response_status: 500
      }
    end

    it "raises error" do
      expect { subject.to_json }.to raise_error(PayUPl::HostIsDownError)
    end

    it "raises error with messages" do
      expect { subject.to_json }.to(
        raise_error { |error| expect(error.messages).to eq(error_messages) }
      )
    end

    context "with wrong configuration" do
      include_examples "wrong rest_api configuration"
    end
  end

  context "with other response code" do
    let(:response_code) { 100 }
    let(:response_success) { true }
    let(:response_error) { false }
    let(:response) { "OK" }
    let(:response_json) { { data: "OK", response_status: response_code } }

    include_examples "base rest_api responses"

    context "with wrong configuration" do
      include_examples "wrong rest_api configuration"
    end
  end
end

RSpec.shared_examples "base invalid rest_api requests" do
  include_context "stub rest_api request"

  let!(:stubed_request_without_options) { stubed_request }

  it "raises validation error" do
    expect { subject }.to raise_error(PayUPl::ValidationError, "#{class_name}: wrong attributes")
  end

  it "raises error with messages" do
    expect { subject }.to(
      raise_error { |error| expect(error.messages).to eq(error_messages) }
    )
  end

  context "with wrong configuration" do
    include_examples "wrong rest_api configuration"
  end
end
