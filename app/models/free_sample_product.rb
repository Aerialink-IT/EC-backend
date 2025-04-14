class FreeSampleProduct < ApplicationRecord
  belongs_to :free_samples_request
  belongs_to :product
end
