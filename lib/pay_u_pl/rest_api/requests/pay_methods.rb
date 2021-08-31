# frozen_string_literal: true

module PayUPl
  module RestApi
    module Requests
      # List pay methods.
      #
      # https://developers.payu.com/en/restapi.html#Transparent_retrieve
      #
      # @param args [Hash]
      # @return [PayUPl::RestApi::Responses::Base] response class.
      #
      # === Examples:
      #
      #   response = PayUPl::RestApi::Requests::PayMethods.call # Default lang == "pl"
      #   response = PayUPl::RestApi::Requests::PayMethods.call(lang: "en")
      #
      # === Sample response (HTTP 200)
      #
      #   response.to_json
      #   {
      #      pay_by_links: [
      #        {
      #           value: "c",
      #           name: "Platnosc online karta platnicza",
      #           brand_image_url: "http://static.payu.com/images/mobile/logos/pbl_c.png",
      #           status: "ENABLED",
      #           min_amount: 50,
      #           max_amount: 100000
      #        },
      #        {
      #           value: "o",
      #           name: "Pekao24Przelew",
      #           brand_image_url: "http://static.payu.com/images/mobile/logos/pbl_o.png",
      #           status: "DISABLED",
      #           min_amount: 50,
      #           max_amount: 100000
      #        },
      #        {
      #           value: "ab",
      #           name: "Place z Alior Bankiem",
      #           brand_image_url: "http://static.payu.com/images/mobile/logos/pbl_ab.png",
      #           status: "TEMPORARY_DISABLED",
      #           min_amount: 50,
      #           max_amount: 100000
      #        }
      #     ]
      #   }
      class PayMethods < PayUPl::RestApi::Requests::Base
        include PayUPl::RestApi::Requests::Concerns::Authorizable

        private

        def defaults
          {
            lang: "pl"
          }
        end

        def validation
          @validation = PayUPl::RestApi::Validations::PayMethods.call(**data)
        end

        def http_class
          Net::HTTP::Get
        end

        def path
          "/api/v2_1/paymethods?lang=%<lang>s"
        end

        def uri_args
          { lang: data.delete(:lang) }
        end
      end
    end
  end
end
