class AddFileNameToBlogPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :blog_posts, :file_name, :string
  end
end
