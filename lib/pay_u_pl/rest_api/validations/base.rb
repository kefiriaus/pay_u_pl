# frozen_string_literal: true

# frozen_string_literal: true

module PayUPl
  module RestApi
    module Validations
      class Base < Dry::Validation::Contract
        def self.call(**args)
          new.call(**args)
        end
      end
    end
  end
end
