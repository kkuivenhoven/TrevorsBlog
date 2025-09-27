class TfidfService
	# usage:
	# scores = TfidfCalculator.new(PromptText.all).calculate

	def initialize()
	end

	def call
		compute_term_frequencies()
		compute_inverse_document_frequencies()
		compute_tf_idf_value()
	end

	# TF = (# of times the word appears in the document)
	#      divided by 
 	#      (total # of terms in the document)
	def compute_term_frequencies(document)
		word_lookup = setup_word_lookup()
		word_count = Hash.new
		total_num_words = 0
		full_text = document.prompt_text
		normalized_text = normalize_prompt_text(full_text)
		split_text = normalized_text.split
		split_text.each do |word|
			if word_count.has_key?(word)
				word_count[word] += 1
			else
				word_count[word] = 1
			end
			total_num_words += 1
		end
		
		word_count.each do |key, value|
			word = word_lookup[key]
			tf_value = (word_count[key].to_f/total_num_words)
			@word_TF = WordTermFrequencyScore.find_by(prompt_for_training_id: document.id, word_id: word.id)
			if @word_TF.nil?
				WordTermFrequencyScore.new(word_id: word.id, tf_value: tf_value, prompt_for_training_id: document.id).save
			else
				@word_TF.tf_value = tf_value
				@word_TF.save
			end
		end
	end

	# compute the term frequencies for the user input
	def user_text_compute_term_frequencies(document)
		tf_array = Hash.new
		word_count = Hash.new
		total_num_words = 0
		full_text = document
		word_lookup = setup_word_lookup()
		normalized_text = normalize_prompt_text(full_text)
		split_text = normalized_text.split
		split_text.each do |word|
			if word_count.has_key?(word)
				word_count[word] += 1
			else
				word_count[word] = 1
			end
			total_num_words += 1
		end
		
		word_count.each do |key, value|
			word = word_lookup[key]
			tf_value = (word_count[key].to_f/total_num_words)
			tf_array[key] = tf_value
		end
		return tf_array
	end

	def compute_inverse_document_frequencies
		categories = Prompt.all # Prompt is where my categories are stored
		word_lookup = setup_word_lookup()
		categories.each do |category|
			docs_with_word = Hash.new
			all_documents = PromptForTraining.where(prompt_id: category.id)
			all_documents.each do |document|
				full_text = document.prompt_text
				normalized_text = normalize_prompt_text(full_text)
				split_text = normalized_text.split
				wordsInDoc = split_text.uniq
				wordsInDoc.each do |word|
					if docs_with_word.has_key?(word)
						docs_with_word[word] += 1
					else
						docs_with_word[word] = 1
					end
				end
			end

			docs_with_word.each do |key, value|
				# below line may have the potential to be a slow look up
				word = word_lookup[key]
				idf_value = Math.log((all_documents.count.to_f)/(value + 1)) + 1
				@corpusIDF = CorpusInverseDocFrequencyScore.find_by(prompt_id: category.id, word_id: word.id)
				if @corpusIDF.nil?
					CorpusInverseDocFrequencyScore.new(word_id: word.id, idf_value: idf_value, prompt_id: category.id).save
				else
					@corpusIDF.idf_value = idf_value
					@corpusIDF.save
				end
			end
		end
	end

	def compute_tf_idf_value(document)
		categories = Prompt.all # Prompt is where my categories are stored
		@wordsPerDoc = WordTermFrequencyScore.where(prompt_for_training_id: document.id)
		@wordsPerDoc.each do |wordDoc|
			@corpusIDF = CorpusInverseDocFrequencyScore.find_by(prompt_id: document.prompt_id, word_id: wordDoc.word_id)
			# idf_value stored as decimal
			# tf_value stored as decimal
			tf_idf_value = (@corpusIDF.idf_value * wordDoc.tf_value)
			wordDoc.update(tf_idf_value: tf_idf_value)
		end
	end

	def eliminate
		missing_words = []
		Word.find_each do |word|
			exists = PromptForTraining.find_each.any? do |prompt|
				normalized = normalize_prompt_text(prompt.prompt_text)
				normalized.include?(word.word)
			end
			missing_words << word unless exists
		end

		missing_words.each do |missing_word|
			WordTermFrequencyScore.where(word_id: missing_word.id).delete_all
			CorpusInverseDocFrequencyScore.where(word_id: missing_word.id).delete_all
			Word.where(word: missing_word.word).delete_all
		end
	end

	# This computes the average tf_idf value for each corpus of documents
	def compute_similarity
		@corpus = Hash.new
		categories = Prompt.all
		categories.each do |cat|
			ids = PromptForTraining.where(prompt_id: cat.id).pluck(:id)
			@matchingScores = WordTermFrequencyScore.where(prompt_for_training_id: ids)
			@scores_by_word = @matchingScores.group_by { |element| element.word_id }
			sub_words = Hash.new
			@scores_by_word.each do |word_id, scores|
				tf_idf_scores = scores.map { |element| element.tf_idf_value.to_f }.compact
				calculated_average = 0
				if !tf_idf_scores.empty?
					calculated_average = (tf_idf_scores.sum.to_f/tf_idf_scores.size)
				end
				sub_words[word_id] = calculated_average
			end
			@corpus[cat.id] = sub_words
		end
		return @corpus
	end

	def cosine_similarity(user_text)
		stop_words = ["a","about","above","after","again","against","all","am","an","and","any","are","as","at","be","because","been","before","being","below","between","both","but","by","can","cannot","could","did","do","does","doing","down","during","each","few","for","from","further","had","has","have","having","he","her","here","hers","herself","him","himself","his","how","i","if","in","into","is","it","its","let","me","more","most","my","no","nor","not","of","off","on","once","only","or","other","ought","our","ours","ourselves","out","over","own","same","she","should","so","some","such","than","that","the","their","theirs","them","themselves","then","there","these","they","this","those","through","to","too","under","until","up","very","was","we","were","what","when","where","which","while","who","whom","why","with","would","you","your","yours","yourself","yourselves"]
		common_keys = []
		normalize_text = normalize_prompt_text(user_text)
		# tf_values_array is the 
		words = setup_word_lookup()
		tf_values_array = user_text_compute_term_frequencies(normalize_text)
		corpus_similarity = Hash.new
		avg_corpus = compute_similarity()
		avg_corpus.each do |corpus|
			# get common words between a corpus and tf_values_array
			keys_one = tf_values_array.keys
			word_values = corpus[1]
			corpus_words = Hash.new
			word_values.each do |key, value|
				word = Word.find_by(id: key).word
				corpus_words[word] = value
			end
			# common_keys = tf_values_array.keys & corpus.keys
			common_keys = tf_values_array.keys & corpus_words.keys
			dot_product = []
			corpus_squared = []
			tf_squared = []
			corpus_magnitude = 0
			tf_magnitude = 0
			similarity = 0

			tf_values_array.each do |word|
				if !stop_words.include?(word[0])
					tf_squared.push(word[1] * word[1])
				end
			end

			countOfWords = corpus_words.count
			corpus_words.each do |word|
				if !stop_words.include?(word[0])
					corpus_squared.push(word[1] * word[1])
				end
			end

			common_keys.each do |word|
				# dot product should only use terms that exist in both vectors 
				# since non-overlapping terms contribue to 0
				if !stop_words.include?(word[0])
					dot_product.push((tf_values_array[word] * corpus_words[word]).to_f)
				end
			end

			tf_magnitude = Math.sqrt(tf_squared.sum)
			corpus_magnitude = Math.sqrt(corpus_squared.sum)
			dot_product_sum = dot_product.sum

			if tf_magnitude.zero? || corpus_magnitude.zero?
				similarity = 0
			else
				similarity = (dot_product_sum/(tf_magnitude * corpus_magnitude).to_f)
			end
			corpus_similarity[corpus[0]] = similarity
		end
		best_corpus, best_score = corpus_similarity.max_by { |corpus, score| score }
		return best_corpus
		# return prompt.title
	end

	private

	def setup_word_lookup
		all_words = Word.all
		word_lookup = Hash.new
		all_words.each do |word_record|
			word_lookup[word_record.word] = word_record
		end
		word_lookup
	end

	def normalize_prompt_text(document_text)
		stop_words = ["a","about","above","after","again","against","all","am","an","and","any","are","as","at","be","because","been","before","being","below","between","both","but","by","can","cannot","could","did","do","does","doing","down","during","each","few","for","from","further","had","has","have","having","he","her","here","hers","herself","him","himself","his","how","i","if","in","into","is","it","its","let","me","more","most","my","no","nor","not","of","off","on","once","only","or","other","ought","our","ours","ourselves","out","over","own","same","she","should","so","some","such","than","that","the","their","theirs","them","themselves","then","there","these","they","this","those","through","to","too","under","until","up","very","was","we","were","what","when","where","which","while","who","whom","why","with","would","you","your","yours","yourself","yourselves"]
      normalized = document_text.downcase
      # match anything that is not a character a-z and 0-9
      normalized = normalized.gsub(/[^a-z0-9\-\s]/i, '') 
      normalized = normalized.gsub(/\b(\w+)'s\b/, '\1')
      normalized = normalized.gsub(/\b(\w+)'\b/, '\1')
      normalized = normalized.squeeze(" ").strip
	  words = normalized.downcase.split(" ")
      filtered = words.reject { |w| stop_words.include?(w) }
      normalized = filtered.join(" ")
	  normalized
	end

end
