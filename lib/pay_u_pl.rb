# frozen_string_literal: true

require "active_support/core_ext/hash"
require "active_support/concern"
require "awesome_print"
require "dry-validation"
require "json"
require "net/http"
require "uri"

require_relative "pay_u_pl/version"
require_relative "pay_u_pl/configuration"
require_relative "pay_u_pl/core_ext/hash/keys"
require_relative "pay_u_pl/rest_api"

module PayUPl
  # Error in PayU integration flow
  class Error < ::StandardError
    attr_reader :messages

    def initialize(msg = nil, messages = {})
      @messages = messages
      super(msg)
    end
  end

  # Error must be raised if some of configuration params are empty
  class ConfigurationNotFound < Error
    def messages
      {
        status: {
          status_code: "ERROR_CONFIGURATION_NOT_FOUND"
        },
        response_status: 400
      }
    end
  end

  # Error must be raised if api endpoint path not specified
  class PathNotFound < Error
    def messages
      {
        status: {
          status_code: "ERROR_PATH_NOT_FOUND"
        },
        response_status: 400
      }
    end
  end

  # Error must be raised if PayU is down
  class HostIsDownError < Error; end

  # Error must be raised if we can't succeed process
  # for example we provided invalid data, or PayU decided to decline clients request
  class ProcessFailed < Error; end

  # Error must be raised if validations failed
  class ValidationError < Error
    def messages
      {
        status: {
          status_code: "ERROR_ATTRIBUTES_NOT_VALID",
          errors: @messages
        },
        response_status: 422
      }
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= PayUPl::Configuration.new
    end

    def reset
      @configuration = PayUPl::Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
