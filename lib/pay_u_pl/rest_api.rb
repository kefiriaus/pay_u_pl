# frozen_string_literal: true

require_relative "rest_api/configuration"

require_relative "rest_api/validations/base"
require_relative "rest_api/validations/authorize"
require_relative "rest_api/validations/order"
require_relative "rest_api/validations/pay_methods"

require_relative "rest_api/requests/concerns/authorizable"
require_relative "rest_api/requests/base"
require_relative "rest_api/requests/authorize"
require_relative "rest_api/requests/order"
require_relative "rest_api/requests/pay_methods"

require_relative "rest_api/responses/base"

module PayUPl
  module RestApi
    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= PayUPl::RestApi::Configuration.new
      end

      def reset
        @configuration = PayUPl::RestApi::Configuration.new
      end

      def configure
        yield(configuration)
      end
    end
  end
end
