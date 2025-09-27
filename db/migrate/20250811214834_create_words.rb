class CreateWords < ActiveRecord::Migration[8.0]
  def change
    create_table :words do |t|
      t.string :word

      t.timestamps
    end
    add_index :words, :word, unique: true
  end
end
