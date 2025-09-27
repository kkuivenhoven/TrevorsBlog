class PromptForTrainingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_prompt_for_training, only: [:show, :edit, :update]

  def index
	@prompts = PromptForTraining.all
	@test_prompts = PromptForTraining.where(prompt_id: 2)
  end

  def new
	@prompt_for_training = PromptForTraining.new
  end

  def create
	@prompt_for_training = PromptForTraining.new(prompt_for_training_params)
	category = @prompt_for_training.prompt_id

	if @prompt_for_training.save
		@prompts = PromptForTraining.where(prompt_id: category)
		promptText = @prompt_for_training.prompt_text
		promptTextArray = promptText.split
		promptTextUnique = promptTextArray.uniq
		# corpusBagOfWords would be counting how many times a word
		# appears across the entire corpus of documents, so it cannot
		# be used to compute the entire corpus
		corpusBagOfWords = Hash.new
		promptTextUnique.each do |wordToCount|
			@prompts.each do |prompt|
				allSentence = prompt.prompt_text.split
				words = allSentence.uniq
				if words.include?(wordToCount)
					if corpusBagOfWords.key?(wordToCount)
						corpusBagOfWords[wordToCount] += 1
					else
						corpusBagOfWords[wordToCount] = 1
					end
				end
			end
		end

		# documentBagOfWords is document specific and will be for the new 
		# document at hand. We will count how many times each word occurs
		# for that document and then use that in the end to compute 
		# the TF-IDF term
		documentBagOfWords = Hash.new
		sentence = @prompt_for_training.prompt_text
		totalNumOfWords = 0
		sentence.split.each do |word|
			if documentBagOfWords.key?(word)
				documentBagOfWords[word] += 1
			else
				documentBagOfWords[word] = 1
			end
			totalNumOfWords += 1
		end

		documentTfValueForEachWord = Hash.new
		documentBagOfWords.each do |key, value|
			tf_value = (value.to_f/totalNumOfWords)
			documentTfValueForEachWord[key] = tf_value
			corpusCount = @prompts.count
			numOfDocsThatContainWord = corpusBagOfWords[key]
			# compute IDF(data) = log(@prompts.count/numOfDocsThatContainWord)
			# then multiple tf_value * IDF(data) value
		end
# byebug
		redirect_to @prompt_for_training, notice: "Prompt was successfully created."
	else
		render :new, status: :unprocessable_entity
	end
  end

  def edit
  end

  def show
  end

  def update
	@prompt_for_training = PromptForTraining.find(params[:id])
	if @prompt_for_training.update(prompt_for_training_params)
		redirect_to @prompt_for_training, notice: "Saved successfully."
	else
		render :edit
	end
  end

  private
	def require_admin
		redirect_to root_path, alert: "Not authorized" unless current_user.admin?
	end

	def set_prompt_for_training
		@prompt_for_training = PromptForTraining.find(params[:id])
	end

	def prompt_for_training_params
		params.require(:prompt_for_training).permit(:prompt_id, :prompt_text)
	end

end
