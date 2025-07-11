class CreateBlogPostImages < ActiveRecord::Migration[8.0]
  def change
    create_table :blog_post_images do |t|
      t.references :blog_post, null: false, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
