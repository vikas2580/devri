module BxBlockShoppingCart
  class CustomerAppointmentsController < ApplicationController
    def customer_orders
      if params[:filter_by].present? && params[:filter_by].downcase == 'history'
        orders = BxBlockShoppingCart::Order.where(
          customer_id: @token.id, status: ['completed', 'cancelled']
        )
      else
        orders = BxBlockShoppingCart::Order.where(
          customer_id: @token.id, status: params[:filter_by]
        ) if params[:filter_by].present?
      end
      render json: {message: 'No order present'} and return unless orders.present?
      render json: BxBlockShoppingCart::OrderSerializer.new(
        orders, meta: {message: "List for #{params[:filter_by]}"}
      ).serializable_hash
    end

    def update_notification_setting
      @order = BxBlockShoppingCart::Order.find(params[:id])
      @order.update(order_notification_params)
      render json: {
        message: "Update notify me #{params[:notify_me]}"
      } and return @order.update(order_notification_params)
      render json: { errors: format_activerecord_errors(order.errors) }
    end

    private

    def order_notification_params
      fields = params.permit(:notify_me)
      fields.merge(:job_status => true) if !@order.job_status and params[:notify_me]
      fields
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
