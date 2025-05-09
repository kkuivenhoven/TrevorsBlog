class AddQueryTrackingToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :query_count, :integer
    add_column :users, :last_query_at, :datetime
  end
end
