class PromptsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_prompt, only: [:show, :edit, :update, :destroy]

  def index
	@prompts = Prompt.all
  end

  def show
  end

  def new
	@prompt = Prompt.new
  end

  def create
	@prompt = Prompt.new(prompt_params)
	if @prompt.save
		redirect_to @prompt, notice: 'Prompt was successfully created.'
	else
		render :new, status: :unprocessable_entity
	end
  end

  def edit
  end

  def update
	if @prompt.update(prompt_params)
		redirect_to @prompt, notice: 'Prompt was successfully updated.'
	else
		render :edit, status: :unprocessable_entity
	end
  end

  def destroy
	@prompt.destroy
	redirect_to prompts_url, notice: 'Prompt was successfully destroyed.'
  end

  private
	
	def set_prompt
		@prompt = Prompt.find(params[:id])
	end

	def prompt_params
		params.require(:prompt).permit(:title, :description, :system_message)
	end

	def authenticate_user!
	  unless current_user
	    redirect_to root_path, alert: 'You must be logged in to access this section.'
	  end
	end

	def require_admin
	  unless current_user&.admin?
	    redirect_to root_path, alert: 'You are not authorized to access this section.'
	  end
	end

end
