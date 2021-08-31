# frozen_string_literal: true

module PayUPl
  module RestApi
    module Responses
      class Base
        attr_reader :response

        ERRORS_INFO_URL = "https://developers.payu.com/en/restapi.html#references_statuses"

        def initialize(response)
          @response = response
        end

        def to_json(*_args)
          case code
          when 200
            response_body
          when 400...500
            raise PayUPl::ProcessFailed.new(error_message, response_body)
          when 500..511
            raise PayUPl::HostIsDownError.new(error_message, response_body)
          else
            response_body
          end
        end

        def success?
          !error?
        end

        def error?
          (400..511).include?(code)
        end

        def response_body
          parsed_body.merge(response_status: code)
        end

        def parsed_body
          JSON.parse(body).underscore_keys.deep_symbolize_keys
        rescue JSON::ParserError
          { data: to_s }
        end

        def to_s
          body.to_s
        end

        def body
          @body ||= response.body
        end

        def code
          obj_to_code[response.class.to_s].to_i
        end

        private

        def error_message
          @error_message ||= "PayU responds (#{code}) #{body} see #{ERRORS_INFO_URL}"
        end

        def obj_to_code
          code_to_obj = Net::HTTPResponse::CODE_TO_OBJ
          Hash[code_to_obj.values.map(&:to_s).zip code_to_obj.keys]
        end
      end
    end
  end
end
