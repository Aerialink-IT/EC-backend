class BillingDetailSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :phone_number, :street_address, :postal_code, :user_id, :is_default, :created_at, :updated_at
end
