# frozen_string_literal: true

require "support/shared/context/configuration"
require "support/shared/context/authorization"
require "support/shared/examples/requests"

RSpec.describe PayUPl::RestApi::Requests::Order do
  subject { described_class.call(**data) }

  include_context "set rest_api configuration"

  let(:path) { "/api/v2_1/orders" }
  let(:http_method) { :post }
  let(:body) do
    {
      "currencyCode": "usd",
      "merchantPosId": "123456",
      "validityTime": 86_400,
      "extOrderId": "1111-1111-1111-1111",
      "notifyUrl": "https://your.eshop.com/notify",
      "continueUrl": "https://your.eshop.com/continue",
      "customerIp": "127.0.0.1",
      "description": "RTV market",
      "additionalDescription": "RTV market description",
      "totalAmount": "21000",
      "buyer": {
        "email": "john.doe@example.com",
        "phone": "654111654",
        "firstName": "John",
        "lastName": "Doe",
        "language": "pl"
      },
      "products": [
        {
          "name": "Wireless Mouse for Laptop",
          "unitPrice": "15000",
          "quantity": "1"
        },
        {
          "name": "HDMI cable",
          "unitPrice": "6000",
          "quantity": "1"
        }
      ],
      "payMethods": {
        "payMethod": {
          "type": "PBL", # PBL | CARD_TOKEN | PAYMENT_WALL
          "value": "blik", # for PBL, CARD_TOKEN
          "authorizationCode": "123456" # 6-digit BLIK code
        }
      }
    }
  end
  let(:response) do
    {
      "status": {
        "statusCode": "SUCCESS"
      },
      "redirectUri": "{payment_summary_redirection_url}",
      "orderId": "WZHF5FFDRJ140731GUEST000P01",
      "extOrderId": "{YOUR_EXT_ORDER_ID}"
    }.to_json
  end

  include_context "set rest_api authorization"

  context "when data is valid" do
    let(:data) do
      {
        ext_order_id: "1111-1111-1111-1111",
        notify_url: "https://your.eshop.com/notify",
        continue_url: "https://your.eshop.com/continue",
        customer_ip: "127.0.0.1",
        description: "RTV market",
        additional_description: "RTV market description",
        total_amount: "21000",
        buyer: {
          email: "john.doe@example.com",
          phone: "654111654",
          first_name: "John",
          last_name: "Doe",
          language: "pl"
        },
        products: [
          {
            name: "Wireless Mouse for Laptop",
            unit_price: "15000",
            quantity: "1"
          },
          {
            name: "HDMI cable",
            unit_price: "6000",
            quantity: "1"
          }
        ],
        pay_methods: {
          pay_method: {
            type: "PBL", # PBL | CARD_TOKEN | PAYMENT_WALL
            value: "blik", # for PBL, CARD_TOKEN
            authorization_code: "123456" # 6-digit BLIK code
          }
        }
      }
    end

    include_examples "base valid rest_api requests"
  end

  context "when data is invalid" do
    let(:data) do
      {
        ext_order_id: "1111-1111-1111-1111",
        notify_url: "https://your.eshop.com/notify",
        continue_url: "https://your.eshop.com/continue",
        customer_ip: "127.0.0.1",
        description: "RTV market",
        additional_description: "RTV market description",
        buyer: {
          email: "john.doe@example.com",
          phone: "654111654",
          first_name: "John",
          last_name: "Doe",
          language: "pl"
        },
        products: [
          {
            name: "Wireless Mouse for Laptop",
            unit_price: "15000",
            quantity: "1"
          },
          {
            name: "HDMI cable",
            unit_price: "6000",
            quantity: "1"
          }
        ],
        pay_methods: {
          pay_method: {
            type: "",
            value: "c"
          }
        }
      }
    end
    let(:class_name) { described_class.name }
    let(:error_messages) do
      {
        status: {
          status_code: "ERROR_ATTRIBUTES_NOT_VALID",
          errors: {
            pay_methods: {
              pay_method: {
                type: ["must be filled"]
              }
            },
            total_amount: ["is missing"]
          }
        },
        response_status: 422
      }
    end

    include_examples "base invalid rest_api requests"
  end
end
