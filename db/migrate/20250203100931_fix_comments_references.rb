class FixCommentsReferences < ActiveRecord::Migration[6.1]
  def change
    remove_reference :comments, :review, foreign_key: true
    add_reference :comments, :product, foreign_key: true
  end
end
