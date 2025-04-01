class DecisionTreeController < ApplicationController
  before_action :setup_questions_from_json, only: [:index, :next_question]

  def index
    # Start at the first question
    @current_question = find_question_by_id(1)
	session.delete(:choices_log)
	session.delete(:choices)
  end

  def show
  end

  def next_question
	selected_data = JSON.parse(params[:selected_option])
	current_id = params[:current_id].to_i
	if selected_data['next_id'].to_i != 0 
		selected_next_id = selected_data['next_id'] 
	else
		selected_next_id = selected_data['end_id'] 
	end

	# Check if it's the end of the decision tree
	if !selected_next_id.is_a?(Integer)
		tmpArray = [current_id, selected_next_id]
		session[:choices] << tmpArray
		@result = "You've reached the end of the decision tree."
	    @current_question = nil
		@choices_log = session[:choices_log]
		@choices = session[:choices]
		
		@ordered_hash = {}
		@selectedQuestions = []
	 	@choices.each do |choice|
			@selectedQuestions << find_question_by_id(choice)
			@tmpQuestion = find_question_by_id(choice[0])
			@tmpAnswerSelection = find_option_by_next_id(@tmpQuestion, choice[1])
			if !choice[1].is_a?(Integer) && choice[1].include?("end")
				@end_value = find_question_by_end_id(choice[1])
			end
			if @end_value.nil?
				@ordered_hash[@tmpQuestion['question']] ||= []
				@ordered_hash[@tmpQuestion['question']] << 
				[{
					'text' => @tmpAnswerSelection['text'],
					'explanation' => @tmpAnswerSelection['explanation'],
					'next_id' => choice[1]
				}]
			else
				@ordered_hash[@tmpQuestion['question']] ||= []
				@ordered_hash[@tmpQuestion['question']] << 
				[{
					'text' => @end_value['text'],
					'explanation' => @end_value['explanation'],
					'next_id' => choice[1]
				}]
			end
		end
		session.delete(:choices_log)
		session.delete(:choices)
    else
 	  # Find the next question
	  @current_question = find_question_by_id(selected_next_id.to_i)
	  session[:choices_log] ||= []
	  session[:choices_log] << { 
	  	question: @current_question['question'],
		selected_option: @current_question['text'],
		explanation: @current_question['explanation']
	  }
	  if !session.has_key?(:choices)
		  session[:choices] ||= []
	  end
	  tmpArray = [current_id, selected_next_id.to_i]
	  session[:choices] << tmpArray
	end
	render 'index'
  end

  def end
    render plain: "Scenario Completed!"
  end

  private

  def setup_questions_from_json
    file_path = Rails.root.join('app/assets/data/fraud_scenarios.json')
    file_content = File.read(file_path)
    @questions = JSON.parse(file_content)
  end

  def find_question_by_id(id)
    @questions.find { |q| q['id'] == id }
  end

  def find_question_by_end_id(end_id)
	@questions.each do |question|
		options = question['options']
		# next unless is a guard clause which means # "skip to the next 
		# iteration unless options is truthy (not nil or false)"
		next unless options && options.any?
		options.each do |option|
			if option.has_key?('end_id') && option['end_id'] == end_id
				return option
			end
		end
	end
	return nil
  end

  def find_option_by_next_id(tmp_question, target_next_id)
	tmp_question['options'].find { |option| option['next_id'] == target_next_id }
  end

end
