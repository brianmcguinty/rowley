Spree::BaseHelper.module_eval do

  def link_to_cart_without_sum(text = nil)
    return "" if current_spree_page?(spree.cart_path)

    text = text ? h(text) : t('cart')
    css_class = nil

    if current_order.nil? or current_order.line_items.empty?
      text = "#{text}: (0)"
      css_class = 'empty'
    else
      text = "#{text}: (#{current_order.item_count})".html_safe
      css_class = 'full'
    end

    link_to text, "#shopping_cart_modal", :class => css_class, :rel => "modal:open"
  end

  def link_to_hto_cart(text = nil)
    return "" if current_spree_page?(spree.cart_path)

    text = text ? h(text) : t('hto_cart')
    css_class = nil

    if current_hto_order.nil? or current_hto_order.line_items.empty?
      text = "#{text}: (0)"
      css_class = 'empty'
    else
      text = "#{text}: (#{current_hto_order.item_count})".html_safe
      css_class = 'full'
    end

    link_to text, "#hto_cart_modal", :class => css_class, :rel => "modal:open"
  end  

end
