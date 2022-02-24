module BxBlockFilterItems
  class FilteringController < ApplicationController
    def index
      @catalogues = CatalogueFilter.new(
        ::BxBlockCatalogue::Catalogue, params[:q]
      ).call

      render json: ::BxBlockCatalogue::CatalogueSerializer
                       .new(@catalogues, serialization_options)
                       .serializable_hash
    end

    private

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end

  end
end
