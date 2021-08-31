# frozen_string_literal: true

RSpec.shared_examples "wrong rest_api configuration" do
  before { PayUPl::RestApi.reset }

  it "raises error" do
    expect { subject }.to raise_error(PayUPl::ConfigurationNotFound)
  end
end
