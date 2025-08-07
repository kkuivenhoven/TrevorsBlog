class FraudSimulatorsController < ApplicationController
  before_action :set_fraud_simulator, only: [:show, :edit, :update, :destroy]
  before_action :set_fraud_simulator, only: [:edit, :update, :destroy, :setup_questions_from_json]
  before_action :setup_questions_from_json, only: [:show, :next_question]
  before_action :require_admin, only: [:edit, :update, :create, :new]

  def index
    @fraud_simulators = FraudSimulator.where(is_visible: true)
  end

  def show
	if !@fraud_simulator.is_visible
		redirect_to fraud_simulators_path
	end

    @current_question = find_question_by_id(1)
  end

  def new
    @fraud_simulator = FraudSimulator.new
  end

  def edit
  end

  def create
    @fraud_simulator = FraudSimulator.new(fraud_simulator_params)

    if @fraud_simulator.save
      redirect_to @fraud_simulator, notice: 'Fraud simulator was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @fraud_simulator.update(fraud_simulator_params)
      redirect_to @fraud_simulator, notice: 'Fraud simulator was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fraud_simulator.destroy
    redirect_to fraud_simulators_url, notice: 'Fraud simulator was successfully destroyed.'
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

  def setup_questions_from_json
    @fraud_simulator = FraudSimulator.find(params[:id])
	@questions = JSON.parse(@fraud_simulator.data)
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

  def send_notification_email
	fraud_simulator_id = params[:id]
	User.where(notify_fraud_simulators: true).find_each do |user|
		NotificationMailer.fraud_simulator_notification(user, fraud_simulator_id).deliver_now
	end
	head :ok
  end

  private

	  def set_fraud_simulator
		@fraud_simulator = FraudSimulator.find(params[:id])
	  end

	  def fraud_simulator_params
		params.require(:fraud_simulator).permit(:excerpt, :is_visible, :data, :title)
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

      def require_admin
		unless current_user && current_user.admin?
			redirect_to root_path, alert: "Admins only"
		end 
	  end 


end
