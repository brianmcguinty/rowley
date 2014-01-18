module Spree
  Order.class_eval do
    belongs_to :locked_by_user, :class_name => 'Spree::User', :foreign_key => 'locked_by'
    attr_accessor :edit_by_user
    validate :disable_edit_if_locked

    def locked?
      locked_by.present?
    end

    def can_unlock?(user)
      user.id == locked_by || Ability.new(user).can?(:manage, :all)
    end

    def lock(user, save = true)
      if complete? && !locked?
        self.locked_at = DateTime.now
        self.locked_by = user.id
        self.save if save
      end
    end

    def unlock(user, save = true)
      if locked? && can_unlock?(user)
        self.locked_at = nil
        self.locked_by = nil
        self.save if save
        true
      end
    end

    def locked_for?(user)
      locked? && locked_by != user.id
    end

    def disable_edit_if_locked
      if complete? && edit_by_user.present? && locked_for?(edit_by_user)
        errors.add(:order, "This order locked by #{locked_by_user.email} and cannot be modified") 
      end
    end
  end
end
