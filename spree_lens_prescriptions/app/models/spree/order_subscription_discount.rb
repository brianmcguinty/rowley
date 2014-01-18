class Spree::OrderSubscriptionDiscount < ActiveRecord::Base
  belongs_to :order
  belongs_to :subscription

  has_one :adjustment2, :class_name => 'Spree::Adjustment', :foreign_key => :source_id, :as => :source, :dependent => :destroy
  attr_accessible :subscription, :discount_percent

  calculated_adjustments
  after_save :ensure_correct_adjustment

  def ensure_correct_adjustment
    if adjustment2
      adjustment2.label = "Discount #{discount_percent.round}%"
      adjustment2.save
    else
      self.create_adjustment("Discount #{discount_percent.round}%", order, self)
      reload #ensure adjustment is present on later saves
    end
  end

  def calculator
    Spree::Calculator::SubscriptionDiscount.new
  end
end
