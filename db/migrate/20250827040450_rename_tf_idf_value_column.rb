class RenameTfIdfValueColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :word_term_frequency_scores, :TfIdfValue, :tf_idf_value
  end
end
