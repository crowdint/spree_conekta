module Spree
  module Conekta
    
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :installment_options, :installment_default

      def installment_options
        @installment_options ||= :installment_options
      end

      def installment_default
        @installment_default ||= :installment_default
      end
    end
  end
end