module Spree
  module Conekta
    module ControllerExceptionHandling
      extend ActiveSupport::Concern

      included do
        EXCEPTIONS = [
          Exceptions::MalformedRequestError,
          Exceptions::AuthenticationError,
          Exceptions::CardError,
          Exceptions::ParameterValidationError,
          Exceptions::ApiError,
          Exceptions::ConektaError
        ]

        rescue_from *EXCEPTIONS do |exception|
          flash[:error] = exception.to_s
          redirect_to :back
        end

        rescue_from Exceptions::ResourceNotFound do
          raise ActionController::RoutingError.new('Not Found')
        end
      end
    end
  end
end
