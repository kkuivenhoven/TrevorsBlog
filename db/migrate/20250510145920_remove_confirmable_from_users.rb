class RemoveConfirmableFromUsers < ActiveRecord::Migration[8.0]
  def change
	remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email
  end
end
