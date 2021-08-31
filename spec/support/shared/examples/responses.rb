# frozen_string_literal: true

RSpec.shared_examples "base rest_api responses" do
  it "is success?" do
    expect(subject.success?).to eq response_success
  end

  it "is error?" do
    expect(subject.error?).to eq response_error
  end

  it "returns json" do
    expect(subject.to_json).to eq response_json
  end

  it "returns code" do
    expect(subject.code).to eq response_code
  end
end
