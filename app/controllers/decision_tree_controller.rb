class DecisionTreeController < ApplicationController
  before_action :setup_questions_from_json, only: [:show, :next_question]

  def index
	session.delete(:choices_log)
	session.delete(:choices)
	
	@json_files = Dir.glob(Rails.root.join('app/assets/data/*.json'))
  end

  def show
    @current_question = find_question_by_id(1)
    @file_name = params[:file_name] + '.json'
  end

  def next_question
    @file_name = params[:file_name] + '.json'
	selected_data = JSON.parse(params[:selected_option])
	current_id = params[:current_id].to_i
	if selected_data['next_id'].to_i != 0 
		selected_next_id = selected_data['next_id'] 
	else
		selected_next_id = selected_data['end_id'] 
	end

	# Check if it's the end of the decision tree
	if !selected_next_id.is_a?(Integer) || selected_next_id.is_a?(Float)
		tmpArray = [current_id, selected_next_id]
		if session[:choices].nil?
		  session[:choices] ||= []
		  session[:choices_log] ||= []
		  @current_question = find_root_node_by_end_id(selected_next_id)
		  session[:choices_log] << { 
			question: @current_question['question'],
			selected_option: @current_question['text'],
			explanation: @current_question['explanation']
		  }
		end
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
			if !choice[1].is_a?(Integer) && !choice[1].is_a?(Float) && choice[1].include?("end")
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
	# render 'index'
	render 'show'
  end

  def end
    render plain: "Scenario Completed!"
  end

  private

  # def setup_questions_from_json(file_name)
  def setup_questions_from_json
    file_name = params[:file_name] + '.json'
    file_path = Rails.root.join('app/assets/data', file_name)
    if File.exist?(file_path)
      file_content = File.read(file_path)
      @questions = JSON.parse(file_content)
    else
      render plain: "File not found", status: :not_found
    end
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

  def find_root_node_by_end_id(end_id)
	node = @questions.find do |node|
		node["options"].any? { |option| option["end_id"] == end_id }
	end
	if node
		node_without_options = node.reject { |key, _| key == "options" }
		node_without_options
	else
		nil
	end
  end

  def decision_tree_send_notification_email
	file_name = params[:file_name]
	User.where(notify_fraud_simulators: true).find_each do |user|
		NotificationMailer.fraud_simulator_notification(user, file_name).deliver_now
	end

	head :ok
  end

end
