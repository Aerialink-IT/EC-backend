class AddDeliveryAddressToFreeSamplesRequests < ActiveRecord::Migration[7.1]
  def change
    add_reference :free_samples_requests, :delivery_address, null: false, foreign_key: true
  end
end
