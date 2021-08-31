# frozen_string_literal: true

module PayUPl
  module RestApi
    module Requests
      # Authorization.
      #
      # https://developers.payu.com/en/restapi.html#references_api_signature
      #
      # @param args [Hash]
      # @return [PayUPl::RestApi::Responses::Base] response class.
      #
      # === Examples:
      #
      #   response = PayUPl::RestApi::Requests::Authorize.call
      #
      # === Sample response (HTTP 200)
      #
      #   response.to_json
      #   {
      #      access_token: "7524f96e-2d22-45da-bc64-778a61cbfc26",
      #      token_type: "bearer",
      #      expires_in: 43199, # expiration time in seconds
      #      grant_type: "client_credentials"
      #   }
      class Authorize < PayUPl::RestApi::Requests::Base
        private

        def defaults
          {
            grant_type: "client_credentials",
            client_id: configuration.client_id,
            client_secret: configuration.client_secret
          }
        end

        def validation
          @validation = PayUPl::RestApi::Validations::Authorize.call(**data)
        end

        def camelize_data_keys?
          false
        end

        def path
          "/pl/standard/user/oauth/authorize?grant_type=%<grant_type>s&client_id=%<client_id>s&client_secret=%<client_secret>s"
        end

        def uri_args
          {
            grant_type: data.delete(:grant_type),
            client_id: data.delete(:client_id),
            client_secret: data.delete(:client_secret)
          }
        end
      end
    end
  end
end
