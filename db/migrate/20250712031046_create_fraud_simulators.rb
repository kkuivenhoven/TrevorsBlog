class CreateFraudSimulators < ActiveRecord::Migration[8.0]
  def change
    create_table :fraud_simulators do |t|
      t.json :data
      t.boolean :is_visible
      t.text :excerpt

      t.timestamps
    end
  end
end
