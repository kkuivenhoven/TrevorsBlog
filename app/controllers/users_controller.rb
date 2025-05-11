class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
	@users = User.all
  end

  def show
  end

  def edit
  end

  def update
	respond_to do |format|
		if @user.update(user_params)
			format.html { redirect_to @user, notice: 'User was successfully updated.' }
			format.json { render :show, status: :ok, location: @user }
		else
			format.html { render :edit }
			format.json { render json: @user.errors, status: :unprocessable_entity }
		end
	end
  end

  private

	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:role, :user_name)
	end

    def require_admin
		unless current_user && current_user.admin?
			redirect_to root_path, alert: "Admins only"
		end
    end

end
