module BxBlockFavourites
  class FavouritesController < ApplicationController

    def index
      favourites = BxBlockFavourites::Favourite.where(favourite_by_id: current_user.id)

      if params[:favouriteable_type]
        favourites = favourites.where(favouriteable_type: params[:favouriteable_type])
      end

      if favourites.present?
        serializer = BxBlockFavourites::FavouriteSerializer.new(favourites)
        render json: serializer.serializable_hash,
          status: :ok
      else
        render json: [],
            status: :not_found
      end
    end

    def create
      begin
        favourite = BxBlockFavourites::Favourite.new(
          favourites_params.merge({favourite_by_id: current_user.id})
        )
        if favourite.save
          serializer = BxBlockFavourites::FavouriteSerializer.new(favourite)
          render json: serializer.serializable_hash,
            status: :ok
        else
          return render json: { message: "Not Found" },
            status: :not_found
        end
      rescue Exception => favourite
        render json: {errors: [{favourite: favourite.message}]},
          status: :unprocessable_entity
      end
    end

    def destroy
      favourite =
        BxBlockFavourites::Favourite.find_by(id: params[:id], favourite_by_id: current_user.id)
      if favourite.present?
        favourite.destroy
        render json: { message: "Destroy successfully" },
            status: :ok
      else
        render json: { errors: ["Not Found"] },
            status: :not_found
      end
    end

    private

      def favourites_params
        params.require(:data).permit \
          :favouriteable_id, :favouriteable_type
      end
  end
end
