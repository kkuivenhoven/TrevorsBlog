class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:index]
  before_action :set_user, only: [:edit, :update]

  def index
	@users = User.all
  end

  def show
  end

  def edit
  end

  def update
	if @user.update(user_params)
	  flash[:notice] = "Settings successfully updated."
	  redirect_to edit_user_path(@user), notice: "Settings updated!"
    else
	  flash[:alert] = "There was a problem updating your settings."
	  render :edit, status: :unprocessable_entity
    end 
  end

  private

	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:notify_fraud_simulators, :notify_blog_posts)
	end

    def require_admin
		unless current_user && current_user.admin?
			redirect_to root_path, alert: "Admins only"
		end
    end

end
