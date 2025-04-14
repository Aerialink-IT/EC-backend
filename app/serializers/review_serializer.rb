class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :content, :rating, :name, :email, :images, :created_at, :updated_at

  def images
    object.images.map { |image| image.url }
  end

  belongs_to :user, serializer: UserSerializer
end
