class RemoveCalculatorTypeToAdditionalCalculatorRates < ActiveRecord::Migration
  def up
    remove_column :spree_additional_calculator_rates, :calculator_type
  end

  def down
    add_column :spree_additional_calculator_rates, :calculator_type, :string
  end
end
