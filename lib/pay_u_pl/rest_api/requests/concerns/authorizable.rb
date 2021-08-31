# frozen_string_literal: true

module PayUPl
  module RestApi
    module Requests
      module Concerns
        module Authorizable
          extend ActiveSupport::Concern

          def before_request
            @access_token = PayUPl::RestApi::Requests::Authorize.call.to_json[:access_token]
          end
        end
      end
    end
  end
end
