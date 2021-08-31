# frozen_string_literal: true

module PayUPl
  module RestApi
    module Validations
      class Authorize < PayUPl::RestApi::Validations::Base
        json do
          config.validate_keys = true

          required(:grant_type).filled(:string)
          required(:client_id) { filled? & (int? | str?) }
          required(:client_secret).filled(:string)
        end
      end
    end
  end
end
