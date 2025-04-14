class CartSerializer < ActiveModel::Serializer
  attributes :id, :subtotal, :shipping_fee, :total

  has_many :cart_items, serializer: CartItemSerializer
end
