class CategorySerializer < ActiveModel::Serializer
  attributes :id, :uuid, :name, :description, :name_jp, :description_jp, :image

  def image
    # object.image.blob
    object.image.url
  end
end