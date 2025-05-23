class AddEmailSubscriptionsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :notify_fraud_simulators, :boolean
    add_column :users, :notify_blog_posts, :boolean
  end
end
