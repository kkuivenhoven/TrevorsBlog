class WordTermFrequencyScore < ApplicationRecord
  belongs_to :word
  belongs_to :prompt_for_training # document

end
