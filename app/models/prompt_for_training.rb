class PromptForTraining < ApplicationRecord
  belongs_to :prompt
  # before_save :normalize_prompt_text
  has_many :word_term_frequency_scores

  # after_create :extract_unique_words
  after_save :extract_unique_words
  after_save :after_save_callbacks
  # need to figure out a method for removing a word
  # from the Word table if it doesn't exist in any other 
  # document

  private

  def after_save_callbacks
	service = TfidfService.new
	service.compute_term_frequencies(self)
	service.compute_inverse_document_frequencies
	service.compute_tf_idf_value(self)
	service.eliminate
  end


  def normalize_prompt_text
      normalized = prompt_text.downcase
      # match anything that is not a character a-z and 0-9
      normalized = normalized.gsub(/[^a-z0-9\-\s]/i, '')
	  normalized = normalized.gsub(/\b(\w+)'s\b/, '\1')
      normalized = normalized.gsub(/\b(\w+)'\b/, '\1')
      normalized = normalized.squeeze(" ").strip
      self.prompt_text = normalized
	  normalized
  end

  def extract_unique_words
	promptText = normalize_prompt_text
	textCollection = promptText.split
	textUnique = textCollection.uniq
	textUnique.each do |word|
	  foundWord = Word.find_by(word: word)
	  if foundWord.nil?
	  	Word.create!(word: word)
	  end
	end
  end

end
