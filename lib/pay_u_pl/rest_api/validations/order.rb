# frozen_string_literal: true

module PayUPl
  module RestApi
    module Validations
      class Order < PayUPl::RestApi::Validations::Base
        json do
          config.validate_keys = true

          optional(:ext_order_id) { !nil? > (int? | str?) }
          optional(:notify_url).maybe(:string)

          required(:customer_ip).filled(:string)
          required(:merchant_pos_id) { filled? & (int? | str?) }

          optional(:validity_time) { !nil? > (int? | str?) }

          required(:description).filled(:string)

          optional(:additional_description).maybe(:string)
          optional(:visible_description).maybe(:string)

          required(:currency_code).filled(:string)
          required(:total_amount) { filled? & (int? | str?) }

          optional(:continue_url).maybe(:string)

          optional(:buyer).maybe(:hash) do
            optional(:ext_customer_id) { !nil? > (int? | str?) }
            optional(:email).maybe(:string)
            optional(:phone).maybe(:string)
            optional(:first_name).maybe(:string)
            optional(:last_name).maybe(:string)
            optional(:nin).maybe(:string)
            optional(:language).maybe(:string)
          end

          required(:products).filled(:array, min_size?: 1).each do
            hash do
              required(:name).filled(:string)
              required(:unit_price) { filled? & (int? | str?) }
              required(:quantity) { filled? & (int? | str?) }
            end
          end

          optional(:pay_methods).maybe(:hash) do
            required(:pay_method).filled(:hash) do
              required(:type).filled(:string)
              optional(:value).maybe(:string)
              optional(:authorization_code) { !nil? > (int? | str?) }
            end
          end
        end
      end
    end
  end
end
