class CreatePrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :prompts do |t|
      t.string :title
      t.string :description
      t.string :system_message

      t.timestamps
    end
  end
end
