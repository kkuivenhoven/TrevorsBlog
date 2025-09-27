class CorpusInverseDocFrequencyScore < ApplicationRecord
  belongs_to :word
  belongs_to :prompt # category

end
