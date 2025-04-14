class WishlistSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :product, serializer: ProductSerializer
end
