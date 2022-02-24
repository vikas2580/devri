module BxBlockPromoCodes
  class PromoCode < ApplicationRecord
    self.table_name = :promo_codes

    has_many :restaurant_promo_codes,
             class_name: 'BxBlockPromoCodes::RestaurantPromoCode', dependent: :destroy
    has_many :mall_promo_codes,
             class_name: 'BxBlockPromoCodes::MallPromoCode',dependent: :destroy
    has_many :account_promo_codes,
             class_name: 'BxBlockPromoCodes::AccountPromoCode',dependent: :destroy
    has_many :accounts, through: :account_promo_codes, class_name: 'AccountBlock::Account'

    enum discount_type: [:percentage, :fixed]
    enum status: [:active, :inactive]

    validates :name, uniqueness: true, presence: true
    validates :from, :to, :min_order_amount, :discount, :discount_type, :status, presence: true
    validates :redeem_limit, numericality: { greater_than: 0 }
    validates :min_order_amount, numericality: { greater_than_or_equal_to: 0 }
    validates :max_discount_amount, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

    validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
              if: :percentage?

    scope :available, -> {
      where(
        'promo_codes.from <= :current_time AND promo_codes.to >= :current_time',
        current_time: DateTime.current
      )
    }

    def validate_promocode(account, cart_bag_total)
      if !active?
        [false, 'is not currently available']
      elsif !validate_daterange?
        [false, "not applicable for #{Date.current.strftime("%d-%m-%Y")}"]
      elsif !validate_redeem_limits?(account.id)
        [false, 'has already availed' ]
      elsif !validate_minimum_amount?(cart_bag_total)
        [false, "minimum order value is #{min_order_amount}"]
      else
        [true, '']
      end
    end

    def validate_minimum_amount?(cart_bag_total)
      cart_bag_total >= min_order_amount
    end

    def discount_applied(account, cart_bag_total)
      valid, _ = validate_promocode(account, cart_bag_total)
      return 0 unless valid

      if fixed?
        cart_bag_total > discount ? discount : 0
      elsif percentage?
        percentange_amt = cart_bag_total * discount / 100
        if max_discount_amount.present?
          [max_discount_amount, percentange_amt].min
        else
          percentange_amt
        end
      end
    end

    def validate_daterange?
      from <= Date.current && to >= Date.current
    end

    def validate_redeem_limits?(account_id)
      account_promo_code = account_promo_codes.find_by(account_id: account_id)
      account_promo_code.present? ? (account_promo_code.redeem_count < redeem_limit) : true
    end

    def update_redeem_count(account_id)
      account_promo_code = account_promo_codes.find_or_initialize_by(account_id: account_id)
      account_promo_code.update(redeem_count: account_promo_code.redeem_count + 1)
    end

    def refund_promocode(account_id)
      account_promo_code = account_promo_codes.find_by(account_id: account_id)
      account_promo_code&.update(redeem_count: account_promo_code.redeem_count - 1)
    end
  end
end
