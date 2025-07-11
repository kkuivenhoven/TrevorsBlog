class RemoveFileNameFromBlogPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :blog_posts, :file_name, :string
  end
end
