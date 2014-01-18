Spree::OrderUpdater.class_eval do
  def update
    update_totals
    update_payment_state

    # give each of the shipments a chance to update themselves
    shipments.each { |shipment| shipment.update!(order) }#(&:update!)
    update_shipment_state
    update_adjustments
    # update totals a second time in case updated adjustments have an effect on the total
    update_totals

    order.update_attributes_without_callbacks({
      :payment_state => order.payment_state,
      :shipment_state => order.shipment_state,
      :item_total => order.item_total,
      :adjustment_total => order.adjustment_total,
      :payment_total => order.payment_total,
      :total => order.total
    })

    #ensure checkout payment always matches order total (excl. HTO)
    if order.payment and order.payment.checkout? and order.payment.amount != order.total && !order.hto?
      order.payment.update_attributes_without_callbacks(:amount => order.total)
    end

    update_hooks.each { |hook| order.send hook }
  end
end
