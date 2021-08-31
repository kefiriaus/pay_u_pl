# frozen_string_literal: true

module PayUPl
  module RestApi
    module Requests
      class Base
        def self.call(**args)
          new(**args).call
        end

        def initialize(**args)
          @options = args.delete(:options) || {}
          @data = defaults.deep_merge(args)
        end

        def call
          check_configuration!
          validate!

          before_request
          prepare_request
          make_request

          response
        end

        private

        attr_reader :data, :options, :request

        def defaults
          {}
        end

        def check_configuration!
          return unless PayUPl::RestApi::Configuration::PARAMS.any? { |key| configuration.send(key).to_s.empty? }

          raise PayUPl::ConfigurationNotFound
        end

        def validate!
          return unless validation.is_a?(Dry::Validation::Result) && validation.failure?

          raise PayUPl::ValidationError.new("#{self.class.name}: wrong attributes", validation.errors.to_h)
        end

        def validation
          @validation = nil
        end

        def before_request; end

        def prepare_request
          @request = http_class.new(uri)
          set_request_headers
          set_request_body
        end

        def set_request_headers
          @request["Content-Type"] = "application/json"
          @request["Authorization"] = "Bearer #{access_token}" unless access_token.empty?
        end

        def set_request_body
          return if data.empty?

          @request.body = camelize_data_keys? ? data.camelize_keys.to_json : data.to_json
        end

        def camelize_data_keys?
          true
        end

        def make_request
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true if uri.scheme == "https"
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          @response = http.request(request)
        rescue StandardError => e
          raise PayUPl::ProcessFailed, e.message
        end

        def response
          response_class.new(@response)
        end

        def http_class
          Net::HTTP::Post
        end

        def uri
          @uri ||= URI(format(configuration.gateway + path + params, uri_args))
        end

        def path
          raise PayUPl::PathNotFound
        end

        def params
          ""
        end

        def uri_args
          {}
        end

        def response_class
          PayUPl::RestApi::Responses::Base
        end

        def access_token
          @access_token ||= ""
        end

        def configuration
          PayUPl::RestApi.configuration
        end
      end
    end
  end
end
