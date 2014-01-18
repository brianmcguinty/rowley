module Spree
  class CrossLoginToken < ActiveRecord::Base
    validates_presence_of :user
    belongs_to :user
    before_validation :gen

    scope :actual, -> { where('spree_cross_login_tokens.expire_at > ? and spree_cross_login_tokens.used_at is null', DateTime.now) }

    def gen
      if new_record?
        self.value = SecureRandom.uuid
        self.expire_at = DateTime.now.utc + 5.minutes
      end
    end

    def deactivate
      self.used_at = DateTime.now
      save
    end
    
  end
end
