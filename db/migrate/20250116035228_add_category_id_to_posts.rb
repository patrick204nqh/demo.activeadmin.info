class AddCategoryIdToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :category_id, :integer
  end
end
