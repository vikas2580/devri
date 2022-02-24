module BxBlockShoppingCart
  class ServiceProviderAppointmentsController < ApplicationController
    def filter_order
      if params[:filter_by].present? && params[:filter_by].downcase == 'history'
        orders = BxBlockShoppingCart::Order.where(
          service_provider_id: @token.id, status: ['completed', 'cancelled']
        )
      else
        orders = BxBlockShoppingCart::Order.where(
          service_provider_id: @token.id, status: params[:filter_by]
        ) if params[:filter_by].present?
      end
      render json: {message: 'No order present'} and return unless orders.present?
      render json: BxBlockShoppingCart::OrderSerializer.new(
        orders, meta: {message: "List for #{params[:filter_by]}"}
      ).serializable_hash
    end

    def start_order
      order = ::BxBlockShoppingCart::Order.find(params[:id])
      render json: {errors: 'Order dose not present'} and return unless order.present?
      render json: {message: 'Order is already started'} and return if order.status == 'on_going'
      render json: ::BxBlockShoppingCart::OrderSerializer.new(
        order, meta: {message: 'Order is started'}
      ) and return if order.update(status: 'on_going', ongoing_time: Time.now.strftime('%I:%M %p'))
      render json: {errors: format_activerecord_errors(order.errors)},
             status: :unprocessable_entity
    end

    def finish_order
      order = ::BxBlockShoppingCart::Order.find(params[:id])
      render json: {errors: 'Order dose not present'} and return unless order.present?
      render json: {
        message: 'Please start your order first'
      } and return if order.status != 'on_going' and order.status != 'completed'
      render json: {
        message: 'Your order is already finished'
      } and return if order.status == 'completed'
      render json: ::BxBlockShoppingCart::OrderSerializer.new(
        order, meta: {message: 'Order is finished'}
      ) and return if order.update(status: 'completed', finish_at: Time.now.strftime('%I:%M %p'))
      render json: {errors: format_activerecord_errors(order.errors)},
             status: :unprocessable_entity
    end

    def get_sp_details
      unless params[:service_provider_id].blank? || params[:availability_date].blank?
        render json: ::BxBlockCalendar::AvailabilitySerializer.new(
          BxBlockAppointmentManagement::Availability.sp_details(
            params[:service_provider_id],
            params[:availability_date]
          )
        )
      else
        render json: {errors: [
          {availability: 'Date or Service provider Account id is empty'},
        ]}, status: :unprocessable_entity
      end
    end

    private

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
