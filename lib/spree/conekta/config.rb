module Spree
  module Conekta
    class Config < Preferences::Configuration
      preference :public_key, :string, default: ''
      preference :private_key, :string, default: ''
    end
  end
end
