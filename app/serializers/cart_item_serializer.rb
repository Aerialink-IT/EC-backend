class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :unit_price, :total_price, :size

  attribute :product

  def product
    ProductSerializer.new(object.product)
  end
end
