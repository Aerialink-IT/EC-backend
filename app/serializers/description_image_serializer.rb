class DescriptionImageSerializer < ActiveModel::Serializer
  attributes :id, :description, :image

  def image
    object.image.url
  end
end