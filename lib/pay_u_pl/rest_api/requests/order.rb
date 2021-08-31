# frozen_string_literal: true

module PayUPl
  module RestApi
    module Requests
      # Making an order.
      #
      # https://developers.payu.com/en/restapi.html#creating_new_order
      #
      # @param args [Hash]
      # @return [PayUPl::RestApi::Responses::Base] response class.
      #
      # === Errors:
      #
      # https://developers.payu.com/en/restapi.html#references_statuses
      #
      # === Example:
      #
      #   response = PayUPl::RestApi::Requests::Order.call(
      #     ext_order_id: "1111-1111-1111-1111",
      #     notify_url: "https://your.eshop.com/notify",
      #     customer_ip: "127.0.0.1",
      #     merchant_pos_id: "300746",
      #     validity_time: 86400,
      #     description: "Description of the an order",
      #     additional_description: "Additional description of the order",
      #     visible_description: "Text visible on the PayU payment page (max. 80 chars)",
      #     currency_code: "PLN",
      #     total_amount: "21000",
      #     continue_url: "https://your.eshop.com/continue",
      #     buyer: {
      #       ext_customer_id: "123456",
      #       email: "john.doe@example.com",
      #       phone: "654111654",
      #       first_name: "John",
      #       last_name: "Doe",
      #       nin: "987654321-01",
      #       language: "pl"
      #     },
      #     products: [
      #       {
      #         name: "Wireless Mouse for Laptop",
      #         unit_price: "15000",
      #         quantity: "1"
      #       },
      #       {
      #         name: "HDMI cable",
      #         unit_price: "6000",
      #         quantity: "1"
      #       }
      #     ],
      #     pay_methods: {
      #       pay_method: {
      #         type: "PBL", # PBL | CARD_TOKEN | PAYMENT_WALL
      #         value: "blik", # for PBL, CARD_TOKEN
      #         authorization_code: "123456" # 6-digit BLIK code
      #       }
      #     }
      #   )
      #
      # === Sample response (HTTP 200)
      #
      #   response.to_json
      #   {
      #      status: {
      #         status_code: "SUCCESS",
      #      },
      #      redirect_uri: "{payment_summary_redirection_url}",
      #      order_id: "WZHF5FFDRJ140731GUEST000P01",
      #      ext_order_id: "{YOUR_EXT_ORDER_ID}",
      #   }
      class Order < PayUPl::RestApi::Requests::Base
        include PayUPl::RestApi::Requests::Concerns::Authorizable

        private

        def defaults
          {
            currency_code: configuration.currency_code,
            merchant_pos_id: configuration.pos_id,
            validity_time: 86_400
          }
        end

        def validation
          @validation = PayUPl::RestApi::Validations::Order.call(**data)
        end

        def path
          "/api/v2_1/orders"
        end
      end
    end
  end
end
