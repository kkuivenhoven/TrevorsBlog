class Word < ApplicationRecord
	has_many :word_term_frequency_scores
	has_many :corpus_inverse_doc_frequency_scores

end
