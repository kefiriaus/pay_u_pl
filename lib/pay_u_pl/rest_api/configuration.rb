# frozen_string_literal: true

module PayUPl
  module RestApi
    class Configuration
      PARAMS = %i[gateway currency_code client_id client_secret pos_id].freeze

      attr_accessor(*PARAMS)

      def initialize
        @gateway = nil
        @currency_code = nil
        @client_id = nil
        @client_secret = true
        @pos_id = nil
      end
    end
  end
end
