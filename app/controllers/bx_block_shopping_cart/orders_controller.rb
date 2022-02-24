module BxBlockShoppingCart
  class OrdersController < ApplicationController
    before_action :get_user, only: %i(create)
    before_action :order_params, only: [:create]
    before_action :get_service_provider, only: %i(get_booked_time_slots)

    def create
      @order = BxBlockShoppingCart::Order.new(order_params)
      if @order.save
        render json: BxBlockShoppingCart::OrderSerializer.new(@order, meta: {
          message: 'Order Created Successfully',
        }).serializable_hash, status: :created
      else
        render json: {errors: format_activerecord_errors(@order.errors)},
               status: :unprocessable_entity
      end
    end

    def show
      order = BxBlockShoppingCart::Order.find(params[:id])
      render json: {errors: 'Order dose not present'} and return unless order.present?
      render json: BxBlockShoppingCart::OrderSerializer.new(order)
    end

    #========================================================================
    # Route is not created for this action
    #========================================================================

    def get_booked_time_slots
      unless params[:service_provider_id].blank? || params[:booking_date].blank?
        render json: BxBlockShoppingCart::OrderSerializer.new(
          BxBlockShoppingCart::Order.where(
            service_provider_id: params[:service_provider_id],
            booking_date: params[:booking_date].to_datetime
          ),
          meta: {
            availability: @service_provider.availabilities
          }
        ).serializable_hash
      else
        render json: {errors: [
            {availability: 'Date or Service provider Account id is empty'},
        ]}, status: :unprocessable_entity
      end
    end

    private
    def order_params
      params.require(:order).permit(:service_provider_id, :address_id, :booking_date,
                                    :slot_start_time, :order_type, :total_fees, :instructions,
                                    :service_total_time_minutes, :coupon_id, :is_coupon_applied,
                                    :discount, sub_category_ids: []
      ).merge(status: 'scheduled', customer_id: @customer.id)
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end

    def get_user
      @customer = AccountBlock::Account.find(@token.id)
      render json: {errors: 'Customer is invalid'} and return unless @customer.present?
    end

    def get_service_provider
      unless params[:service_provider_id].present?
        render json: {errors: 'Please enter service_provider'} and return
      end
      @service_provider = AccountBlock::Account.find(params[:service_provider_id])
    end
  end
end
