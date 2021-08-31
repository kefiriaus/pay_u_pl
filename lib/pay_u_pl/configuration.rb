# frozen_string_literal: true

module PayUPl
  class Configuration
    PARAMS = %i[rest_api].freeze

    attr_accessor(*PARAMS)

    def rest_api
      yield(PayUPl::RestApi.configuration)
    end
  end
end
