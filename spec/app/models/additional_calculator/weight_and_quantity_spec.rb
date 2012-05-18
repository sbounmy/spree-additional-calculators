require 'spec_helper'

describe Spree::AdditionalCalculator::WeightAndQuantity do
  before(:all) do
    # @shipping_method = Factory(:shipping_method)
    @calculator = FactoryGirl.create(:weight_and_quantity_calculator)
  end

  before(:each) do
    @weight_rate1 = FactoryGirl.build(:additional_calculator_rate_for_weight, :from_value => 0, :to_value => 100, :rate => 100)
    @weight_rate2 = FactoryGirl.build(:additional_calculator_rate_for_weight, :from_value => 100.1, :to_value => 500, :rate => 500)
    @qnty_rate1 = FactoryGirl.build(:additional_calculator_rate_for_qnty, :from_value => 1, :to_value => 10, :rate => 10)
    @qnty_rate2 = FactoryGirl.build(:additional_calculator_rate_for_qnty, :from_value => 11, :to_value => 20, :rate => 20)
    @qnty_rate3 = FactoryGirl.build(:additional_calculator_rate_for_qnty, :from_value => 21, :to_value => 50, :rate => 50)
    @empty_order = FactoryGirl.create(:order)
    @order_with_one_item = FactoryGirl.create(:order_with_one_item).reload
    @order_with_items_without_weight = FactoryGirl.create(:order_with_items_without_weight).reload
  end


  context "there are no items in the order" do
    before(:each) do
      @empty_order.item_count.should == 0
    end

    it "the rate should be nil" do
      rate = @calculator.compute(@empty_order)
      rate.should be_nil
    end

    it "the calculator should not be available" do
      @calculator.available?(@empty_order).should be_false
    end
  end


  context "the weight table is empty" do
    before(:each) do
      @order_with_one_item.item_count.should_not == 0
    end

    it "the calculator should not be available" do
      @calculator.available?(@order_with_one_item).should be_false
    end

    it "the rate should not be valid" do
      rate = @calculator.compute(@order_with_one_item)
      rate.should be_nil
    end
  end


  context "just weight" do
    before(:each) do
      @weight_rate1.save!
      @weight_rate2.save!
      # default_item_weight
    end

    after(:each) do
      # reset the default item weight
      @calculator.preferred_default_item_weight = 0
      @calculator.save!
    end

    it "should use the default item weight 0" do
      @calculator.preferred_default_item_weight = 0
      @calculator.save!

      rate = @calculator.compute(@order_with_items_without_weight)
      rate.should_not be_nil
      rate.should == 100 # 0..100 => 100
    end

    it "should use the default item weight 50" do
      @calculator.preferred_default_item_weight = 50
      @calculator.save!

      rate = @calculator.compute(@order_with_items_without_weight)
      rate.should_not be_nil
      rate.should == 100 # 0..100 => 100
    end

    it "should use the default item weight 99" do
      @calculator.preferred_default_item_weight = 99
      @calculator.save!

      rate = @calculator.compute(@order_with_items_without_weight)
      rate.should_not be_nil
      rate.should == 100 # 0..100 => 100
    end

    it "should use the default item weight 100" do
      @calculator.preferred_default_item_weight = 100
      @calculator.save!

      rate = @calculator.compute(@order_with_items_without_weight)
      rate.should_not be_nil
      rate.should == 100 # 0..100 => 100
    end

    it "should use the default item weight 101" do
      @calculator.preferred_default_item_weight = 101
      @calculator.save!

      rate = @calculator.compute(@order_with_items_without_weight)
      rate.should_not be_nil
      rate.should == 500 # 100.1..500 => 500
    end

    it "should use the default item weight 499" do
      @calculator.preferred_default_item_weight = 499
      @calculator.save!

      rate = @calculator.compute(@order_with_items_without_weight)
      rate.should_not be_nil
      rate.should == 500 # 100.1..500 => 500
    end

    it "should use the default item weight 500" do
      @calculator.preferred_default_item_weight = 500
      @calculator.save!

      rate = @calculator.compute(@order_with_items_without_weight)
      rate.should_not be_nil
      rate.should == 500 # 100.1..500 => 500
    end

    it "should use the default item weight 501" do
      @calculator.preferred_default_item_weight = 501
      @calculator.save!

      rate = @calculator.compute(@order_with_items_without_weight)
      rate.should be_nil
    end


    context "items with specific weight" do
      before(:each) do
        @order = FactoryGirl.create(:order_with_one_item).reload
      end

      it "should calculate correct rate for 1 item with weight 0" do
        @order.line_items[0].variant.weight = 0
        @order.save!

        rate = @calculator.compute(@order)
        rate.should_not be_nil
        rate.should == 100 # 0..100 => 100
      end

      it "should calculate correct rate for 1 item with weight 50" do
        @order.line_items[0].variant.weight = 50
        @order.save!

        rate = @calculator.compute(@order)
        rate.should_not be_nil
        rate.should == 100 # 0..100 => 100
      end

      it "should calculate correct rate for 1 item with weight 99" do
        @order.line_items[0].variant.weight = 99
        @order.save!

        rate = @calculator.compute(@order)
        rate.should_not be_nil
        rate.should == 100 # 0..100 => 100
      end

      it "should calculate correct rate for 1 item with weight 100" do
        @order.line_items[0].variant.weight = 100
        @order.save!

        rate = @calculator.compute(@order)
        rate.should_not be_nil
        rate.should == 100 # 0..100 => 100
      end

      it "should calculate correct rate for 1 item with weight 101" do
        @order.line_items[0].variant.weight = 101
        @order.save!

        rate = @calculator.compute(@order)
        rate.should_not be_nil
        rate.should == 500 # 100.1..500 => 500
      end

      it "should calculate correct rate for 1 item with weight 499" do
        @order.line_items[0].variant.weight = 499
        @order.save!

        rate = @calculator.compute(@order)
        rate.should_not be_nil
        rate.should == 500 # 100.1..500 => 500
      end

      it "should calculate correct rate for 1 item with weight 500" do
        @order.line_items[0].variant.weight = 500
        @order.save!

        rate = @calculator.compute(@order)
        rate.should_not be_nil
        rate.should == 500 # 100.1..500 => 500
      end

      it "should calculate correct rate for 1 item with weight 501" do
        @order.line_items[0].variant.weight = 501
        @order.save!

        rate = @calculator.compute(@order)
        rate.should be_nil
      end
    end
  end


  context "weight and qnty" do
    before(:each) do
      @weight_rate1.save!
      @weight_rate2.save!
      @qnty_rate1.save!
      @qnty_rate2.save!
      @qnty_rate3.save!
      @order1 = FactoryGirl.create(:order_with_one_item).reload
      @order2 = FactoryGirl.create(:order_with_two_items).reload
    end

    it "should calculate correct rate for weight 10 and quantity 1" do
      @order1.line_items[0].variant.weight = 10
      @order1.line_items[0].quantity = 1
      @order1.save!

      rate = @calculator.compute(@order1)
      rate.should_not be_nil
      rate.should == 100 + 10 # weight: 0..100 => 100, qnty: 1..10 => 10
    end

    it "should calculate correct rate for weight 10 and quantity 5" do
      @order1.line_items[0].variant.weight = 10
      @order1.line_items[0].quantity = 5
      @order1.save!

      rate = @calculator.compute(@order1)
      rate.should_not be_nil
      rate.should == 100 + 10 # weight: 0..100 => 100, qnty: 1..10 => 10
    end

    it "should calculate correct rate for weight 10 and quantity 10" do
      @order1.line_items[0].variant.weight = 10
      @order1.line_items[0].quantity = 10
      @order1.save!

      rate = @calculator.compute(@order1)
      rate.should_not be_nil
      rate.should == 100 + 10 # weight: 0..100 => 100, qnty: 1..10 => 10
    end

    it "should calculate correct rate for weight 10 and quantity 11" do
      @order1.line_items[0].variant.weight = 10
      @order1.line_items[0].quantity = 11
      @order1.save!

      rate = @calculator.compute(@order1)
      rate.should_not be_nil
      rate.should == 500 + 20 # weight: 100.1..500 => 500, qnty: 11..20 => 20
    end

    it "should calculate correct rate for weight 10 and quantity 20" do
      @order1.line_items[0].variant.weight = 10
      @order1.line_items[0].quantity = 20
      @order1.save!

      rate = @calculator.compute(@order1)
      rate.should_not be_nil
      rate.should == 500 + 20 # weight: 100.1..500 => 500, qnty: 11..20 => 20
    end

    it "should calculate correct rate for weight 10 and quantity 21" do
      @order1.line_items[0].variant.weight = 10
      @order1.line_items[0].quantity = 21
      @order1.save!

      rate = @calculator.compute(@order1)
      rate.should_not be_nil
      rate.should == 500 + 50 # weight: 100.1..500 => 500, qnty: 21..50 => 50
    end

    it "should calculate nil rate and not be available when quantity is exceeded" do
      @order1.line_items[0].variant.weight = 1
      @order1.line_items[0].quantity = 100
      @order1.save!

      @calculator.available?(@order1).should be_false
      rate = @calculator.compute(@order1)
      rate.should be_nil # weight: 0..100 => 100, qnty: 21..50 => 50 (when qnty is exceeded and there are qnty rates, return nil)
    end

  end
end
