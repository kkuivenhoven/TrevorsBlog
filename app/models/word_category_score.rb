class WordCategoryScore < ApplicationRecord
	belongs_to :word
	belongs_to :prompt, foreign_key: 'prompt_id' 
end
