class CreateBlogPostSources < ActiveRecord::Migration[8.0]
  def change
    create_table :blog_post_sources do |t|
      t.references :blog_post, null: false, foreign_key: true
      t.string :source_url

      t.timestamps
    end
  end
end
