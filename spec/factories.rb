FactoryGirl.define do

  # -------------------------------------- calculators --------------------------------------


  factory :weight_and_quantity_calculator, :class => Spree::AdditionalCalculator::WeightAndQuantity do
    calculable { Spree::ShippingMethod.first }
    is_additional_calculator true
  end


  # -------------------------------------- additional_calculator_rate --------------------------------------


  factory :additional_calculator_rate_for_weight, :class => Spree::AdditionalCalculatorRate do
    calculator { Spree::Calculator.where(:is_additional_calculator => true).order(:id).last }
    calculator_type 'Calculator'
    rate_type Spree::AdditionalCalculatorRate::WEIGHT
  end


  factory :additional_calculator_rate_for_qnty, :class => Spree::AdditionalCalculatorRate do
    calculator { Spree::Calculator.where(:is_additional_calculator => true).order(:id).last }
    calculator_type 'Calculator'
    rate_type Spree::AdditionalCalculatorRate::QNTY
  end


  # -------------------------------------- orders --------------------------------------


  factory :order_with_one_item, :parent => :order do
    after_create { |order| FactoryGirl.create(:line_item, :order => order) }
  end

  factory :order_with_two_items, :parent => :order do
    after_create do |order|
      FactoryGirl.create(:line_item, :order => order)
      FactoryGirl.create(:line_item, :order => order)
    end
  end

  factory :order_with_items_without_weight, :parent => :order do
    after_create { |order| FactoryGirl.create(:line_item_without_weight, :order => order) }
  end


  # -------------------------------------- line_items --------------------------------------


  factory :line_item_without_weight, :parent => :line_item do
    # associations:
    association(:order, :factory => :order)
    association(:variant, :factory => :variant_without_weight)
  end


  # -------------------------------------- variants --------------------------------------


  factory :variant_without_weight, :parent => :variant do
    weight nil
  end


end