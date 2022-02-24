module BxBlockFavourites
  class FavouriteSerializer < BuilderBase::BaseSerializer
    attributes *[
      :favouriteable_id,
      :favouriteable_type,
      :favourite_by_id,
      :created_at,
      :updated_at,
    ]
  end
end
