Spree::CreditCard.class_eval do
  attr_encrypted :stored_number
  attr_encrypted :stored_verification_value

  def number=(num)
    @number = num.gsub(/[^0-9]/, '') rescue nil
    self.stored_number = @number
  end

  def number
    stored_number
  end

  def verification_value=(val)
    @verification_value = val
    self.stored_verification_value = @verification_value
  end

  def verification_value
    stored_verification_value
  end

  def set_last_digits
    number.to_s.gsub!(/\s/,'')
    verification_value.to_s.gsub!(/\s/,'')
    self.last_digits = number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1)
  end
end
