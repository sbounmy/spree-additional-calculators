require 'spree_core'
require 'spree_additional_calculators_hooks'

module SpreeAdditionalCalculators
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      # Not sure if this is needed
      # # Register all the calculators
      # [
      #   Calculator::WeightAndQuantity
      # ].each(&:register)

    end

    config.to_prepare &method(:activate).to_proc
  end
end