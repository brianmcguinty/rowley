Spree::Shipment.class_eval do
  def determine_state(order)
    return 'pending' unless order.can_ship?
    return 'pending' if inventory_units.any? &:backordered?
    return 'shipped' if state == 'shipped'
    (order.paid? || order.hto?) ? 'ready' : 'pending'
  end
end
