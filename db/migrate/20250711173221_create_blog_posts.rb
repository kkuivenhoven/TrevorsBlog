class CreateBlogPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :blog_posts do |t|
      t.boolean :is_visible
      t.string :file_name
      t.datetime :date_published
      t.string :title
      t.text :excerpt
      t.text :content

      t.timestamps
    end
  end
end
