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
	  redirect_to root_path, notice: "Settings updated!"
    else
	  render :edit
    end
  end

  private

	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		# params.require(:user).permit(:user_name, :notify_on_fraud_simulator, :notify_on_blog_post)
		params.require(:user).permit(:notify_on_fraud_simulator, :notify_on_blog_post)
	end

    def require_admin
		unless current_user && current_user.admin?
			redirect_to root_path, alert: "Admins only"
		end
    end


end
