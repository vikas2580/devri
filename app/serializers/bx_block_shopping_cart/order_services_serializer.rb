module BxBlockShoppingCart
  class OrderServicesSerializer < BuilderBase::BaseSerializer

    attributes :service_provider_id do |data|
      data.service_provider_id
    end

    attributes :service_id do |data|
      data.id
    end
  end
end
