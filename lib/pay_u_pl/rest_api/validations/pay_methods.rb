# frozen_string_literal: true

module PayUPl
  module RestApi
    module Validations
      class PayMethods < PayUPl::RestApi::Validations::Base
        params do
          config.validate_keys = true

          required(:lang).filled(:string)
        end
      end
    end
  end
end
