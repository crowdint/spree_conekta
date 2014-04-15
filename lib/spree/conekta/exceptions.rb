module Spree
  module Conekta
    module Exceptions
      extend self

      class MalformedRequestError < StandardError

      end

      class AuthenticationError < StandardError

      end

      class CardError < StandardError

      end

      class ResourceNotFound < StandardError

      end

      class ParameterValidationError < StandardError

      end

      class ApiError < StandardError

      end

      class ConektaError < StandardError

      end

      def create(code, message)
        raise "Spree::Conekta::Exceptions::#{(code || 'ConektaError').camelize}".constantize, message
      end
    end
  end
end
