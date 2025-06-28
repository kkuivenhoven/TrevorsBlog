class DecisionTreeController < ApplicationController
  before_action :setup_questions_from_json, only: [:show, :next_question]
  before_action :redirect_user, only: [:show, :next_question]
  before_action :require_admin, only: [:new_upload, :upload, :edit, :update]

  def index
	session.delete(:choices_log)
	session.delete(:choices)
	@json_files = Dir.glob(Rails.root.join('storage', 'data', '*.json'))
	@json_files.each do |json_file| 
		Dir.glob(Rails.root.join('storage', 'matching_data', '*.json')).each do |file_path|
			target_file_name = File.basename(json_file, ".*" + ".json")
			file_content = File.read(file_path)
			json_data = JSON.parse(file_content)
			if target_file_name == json_data['file_name']
				if json_data['is_visible'] == 0
					@json_files.delete(json_file)
				end
			end
		end
	end
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

  def decision_tree_send_notification_email
	file_name = params[:file_name]
	User.where(notify_fraud_simulators: true).find_each do |user|
		NotificationMailer.fraud_simulator_notification(user, file_name).deliver_now
	end
	head :ok
  end

  def new_upload
	# renders the upload form
  end

  def upload
    uploaded_file = params[:json_file]
    info_uploaded_file = params[:json_file_info]
    unless uploaded_file && uploaded_file.content_type == 'application/json'
        flash[:alert] = 'Please upload a valid JSON file.'
        return redirect_to decision_tree_new_upload_path
    end 
    filename = uploaded_file.original_filename
    target_path = Rails.root.join('storage', 'data', filename)
    info_filename = uploaded_file.original_filename
    info_target_path = Rails.root.join('storage', 'matching_data', filename)
    begin
        File.open(target_path, 'wb') do |file|
            file.write(uploaded_file.read)
        end 
        File.open(info_target_path, 'wb') do |file|
            file.write(info_uploaded_file.read)
        end 
        flash[:notice] = "File uploaded successfully."
        redirect_to decision_tree_index_path, alert: "File not found."
    rescue => e
        flash[:alert] = "Upload failed: #{e.message}"
    end 
  end

  def edit
    @filename = params[:file_name]
    file_path = Rails.root.join('storage', 'data', (@filename + '.json'))
    if File.exist?(file_path)
        @json_content = File.read(file_path)
		search_value = (@filename + '.json')
		folder_path = Rails.root.join('storage', 'matching_data')
		matching_file = nil
		json_files = Dir.glob("#{folder_path}/*.json") 
		json_files.each do |file_path| 
			raw_content = File.read(file_path)
			parsed_json = JSON.parse(raw_content)
			if parsed_json["file_name"] == search_value
				matching_file = file_path
				break
			end
		end
		@meta_content = matching_file ? File.read(matching_file) : nil
    else
        redirect_to decision_tree_index_path, alert: "File not found."
    end
  end

  def update
    @filename = params[:file_name]
    file_path = Rails.root.join('storage', 'data', (@filename + '.json'))
    matching_data_file_path = Rails.root.join('storage', 'matching_data', (@filename + 'info.json'))
    begin 
        File.write(file_path, params[:json_content])
        File.write(matching_data_file_path, params[:json_content_items])
        redirect_to decision_tree_index_path
    rescue => e
        redirect_to edit_decision_tree_path(@filename), alert: "Failed to update file: #{e.message}"
    end 
  end

  private

  # def setup_questions_from_json(file_name)
  def setup_questions_from_json
    file_name = params[:file_name] + '.json'
    file_path = Rails.root.join('storage', 'data', file_name)
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

  def redirect_user
	Dir.glob(Rails.root.join('storage', 'matching_data', '*.json')).each do |file_path|
		target_file_name = params[:file_name] + '.json'
		file_content = File.read(file_path)
		json_data = JSON.parse(file_content)
		if target_file_name == json_data['file_name']
			if json_data['is_visible'] == 0
				redirect_to decision_tree_index_path
			end
		end
	end
  end

  def require_admin
	unless current_user && current_user.admin?
		redirect_to root_path, alert: "Admins only"
	end
  end

end
