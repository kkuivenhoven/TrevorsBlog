class AddTitleToFraudSimulators < ActiveRecord::Migration[8.0]
  def change
    add_column :fraud_simulators, :title, :string
  end
end
