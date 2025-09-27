class DropWordCategoryScoresTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :word_category_scores
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
